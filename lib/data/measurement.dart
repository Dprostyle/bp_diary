class Measurement {
  const Measurement({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    required this.recordedAt,
  });

  final String id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final DateTime recordedAt;

  Map<String, Object> toJson() {
    return {
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'] as String,
      systolic: _asInt(json['systolic']),
      diastolic: _asInt(json['diastolic']),
      pulse: _asInt(json['pulse']),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }
}

int _asInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.round();
  }
  throw const FormatException('measurement field');
}

abstract final class MeasurementBounds {
  static const systolicMin = 70;
  static const systolicMax = 250;
  static const diastolicMin = 40;
  static const diastolicMax = 150;
  static const pulseMin = 30;
  static const pulseMax = 220;
  static const defaultSystolic = 120;
  static const defaultDiastolic = 80;
  static const defaultPulse = 70;
}
