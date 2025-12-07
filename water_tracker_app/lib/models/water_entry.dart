class WaterEntry {
  final int? id;
  final int amount;
  final DateTime time;
  final String note;

  WaterEntry({
    this.id,
    required this.amount,
    required this.time,
    this.note = '',
  });

  String get formattedTime {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDate {
    return '${time.day.toString().padLeft(2, '0')}.${time.month.toString().padLeft(2, '0')}.${time.year}';
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'amount': amount,
      'time': time.toIso8601String(),
      'note': note,
    };
  }

  factory WaterEntry.fromMap(Map<String, dynamic> map) {
    return WaterEntry(
      id: map['id'],
      amount: map['amount'],
      time: DateTime.parse(map['time']),
      note: map['note'] ?? '',
    );
  }
}