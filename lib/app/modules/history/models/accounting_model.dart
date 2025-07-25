class AccountingLog {
  final String action;
  final String detail;
  final DateTime timestamp;

  AccountingLog({
    required this.action,
    required this.detail,
    required this.timestamp,
  });

  factory AccountingLog.fromJson(Map<String, dynamic> json) {
    return AccountingLog(
      action: json['action'] ?? '',
      detail: json['detail'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
