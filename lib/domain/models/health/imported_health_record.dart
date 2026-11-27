class ImportedHealthRecord {
  const ImportedHealthRecord({
    required this.id,
    required this.dataType,
    required this.value,
    required this.unit,
    required this.startAt,
    required this.endAt,
    required this.sourcePlatform,
    required this.sourceId,
    required this.sourceName,
    required this.importedAt,
  });

  final String id;
  final String dataType;
  final String value;
  final String unit;
  final DateTime startAt;
  final DateTime endAt;
  final String sourcePlatform;
  final String sourceId;
  final String sourceName;
  final DateTime importedAt;
}
