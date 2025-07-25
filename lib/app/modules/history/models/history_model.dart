class HistoryItem {
  final String note;
  final DateTime timestamp;

  HistoryItem({
    required this.note,
    required this.timestamp,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      note: json['note'] ?? '', // cegah null
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'note': note,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
