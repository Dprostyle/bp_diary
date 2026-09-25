class Measurement {
  const Measurement({
    required this.id,
    required this.recordedAt,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
  });

  final String id;
  final DateTime recordedAt;
  final int systolic;
  final int diastolic;
  final int pulse;

  Measurement copyWith({
    int? systolic,
    int? diastolic,
    int? pulse,
  }) {
    return Measurement(
      id: id,
      recordedAt: recordedAt,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      pulse: pulse ?? this.pulse,
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'recordedAt': recordedAt.toIso8601String(),
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
    };
  }

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'] as String,
      recordedAt: DateTime.parse(json['recordedAt'] as String),
      systolic: json['systolic'] as int,
      diastolic: json['diastolic'] as int,
      pulse: json['pulse'] as int,
    );
  }
}

class DayReading {
  const DayReading({
    required this.day,
    required this.systolic,
    required this.diastolic,
  });

  final DateTime day;
  final int systolic;
  final int diastolic;
}
