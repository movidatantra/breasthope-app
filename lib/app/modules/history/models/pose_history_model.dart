class PoseHistoryModel {
  final String label;
  final String mode;
  final double? akurasi;
  final int? repetisi;
  final DateTime timestamp;

  PoseHistoryModel({
    required this.label,
    required this.mode,
    this.akurasi,
    this.repetisi,
    required this.timestamp,
  });

  factory PoseHistoryModel.fromJson(Map<String, dynamic> json) {
    return PoseHistoryModel(
      label: json['label'] ?? '',
      mode: json['mode'] ?? '',
      akurasi: (json['akurasi'] != null)
          ? (json['akurasi'] as num).toDouble()
          : null,
      repetisi:
          (json['repetisi'] != null) ? (json['repetisi'] as num).toInt() : null,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
