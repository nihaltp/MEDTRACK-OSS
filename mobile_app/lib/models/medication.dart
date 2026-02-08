class Medication {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final List<bool> frequency;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.frequency,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      time: json['time'] as String,
      frequency: List<bool>.from(json['frequency']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': time,
      'frequency': frequency,
    };
  }
}
