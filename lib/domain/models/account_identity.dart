class AccountIdentity {
  const AccountIdentity({
    required this.providerUserId,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String providerUserId;
  final String email;
  final String? displayName;
  final String? photoUrl;
}
