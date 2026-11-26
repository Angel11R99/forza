import { readFileSync } from 'node:fs';
import { test, before, after } from 'node:test';
import assert from 'node:assert/strict';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  collection,
  doc,
  getDoc,
  getDocs,
  serverTimestamp,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

const rules = readFileSync(new URL('../../firestore.rules', import.meta.url), 'utf8');
let environment;

before(async () => {
  environment = await initializeTestEnvironment({
    projectId: 'demo-forza-firestore-rules',
    firestore: { host: '127.0.0.1', port: 8080, rules },
  });
});

after(async () => {
  await environment.cleanup();
});

test('Firestore data is private to its owner and rejects invalid writes', async () => {
  const alice = environment.authenticatedContext('alice').firestore();
  const bob = environment.authenticatedContext('bob').firestore();
  const anonymous = environment.unauthenticatedContext().firestore();
  const aliceProfile = doc(alice, 'users/alice');
  const aliceManifest = doc(alice, 'users/alice/sync/current');
  const aliceChunk = doc(
    alice,
    'users/alice/sync/current/snapshots/snapshot_1/chunks/chunk_000',
  );

  await assertFails(getDoc(doc(anonymous, 'users/alice')));
  await assertFails(getDocs(collection(anonymous, 'users')));
  await assertFails(
    setDoc(doc(anonymous, 'users/anonymous'), {
      uid: 'anonymous',
      email: 'anon@example.com',
      displayName: null,
      photoURL: null,
      provider: 'google.com',
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );

  await assertSucceeds(
    setDoc(aliceProfile, {
      uid: 'alice',
      email: 'alice@example.com',
      displayName: 'Alice',
      photoURL: null,
      provider: 'google.com',
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    }),
  );
  await assertSucceeds(getDoc(aliceProfile));
  await assertFails(getDoc(doc(bob, 'users/alice')));
  await assertFails(getDocs(collection(bob, 'users')));
  await assertFails(updateDoc(aliceProfile, { uid: 'bob' }));

  await assertSucceeds(
    setDoc(aliceManifest, {
      format: 'FORZA_BACKUP',
      version: 1,
      chunkCount: 1,
      snapshotId: 'snapshot_1',
      writer: 'rules-test',
      updatedAt: serverTimestamp(),
    }),
  );
  await assertSucceeds(getDoc(aliceManifest));
  await assertFails(getDoc(doc(bob, 'users/alice/sync/current')));
  await assertFails(getDoc(doc(anonymous, 'users/alice/sync/current')));

  await assertSucceeds(
    setDoc(aliceChunk, {
      snapshotId: 'snapshot_1',
      index: 0,
      content: '{"format":"FORZA_BACKUP"}',
    }),
  );
  await assertFails(
    setDoc(
      doc(bob, 'users/alice/sync/current/snapshots/snapshot_1/chunks/chunk_000'),
      { snapshotId: 'snapshot_1', index: 0, content: 'stolen' },
    ),
  );
  await assertFails(
    setDoc(
      doc(alice, 'users/alice/sync/current/snapshots/snapshot_1/chunks/chunk_001'),
      { snapshotId: 'snapshot_1', index: 1, content: 'x'.repeat(650001) },
    ),
  );
  await assertFails(updateDoc(aliceManifest, { extraField: true }));
  await assertSucceeds(updateDoc(aliceManifest, { updatedAt: serverTimestamp() }));
});
