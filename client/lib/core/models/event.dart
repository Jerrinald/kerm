class Event {
  final int id;
  final String name;
  final String description;
  final String place;
  final String dateStart;
  final String dateEnd;
  final bool transportActive;
  final String transportStart;
  final double cagnotte; // New field

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.place,
    required this.dateStart,
    required this.dateEnd,
    required this.transportActive,
    required this.transportStart,
    required this.cagnotte, // Initialize new field
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      place: json['place'] ?? '',
      dateStart: json['date_start'] ?? '',
      dateEnd: json['date_end'] ?? '',
      transportActive: json['transport_active'] ?? false,
      transportStart: json['transport_start'] ?? 'Indefini',
      cagnotte: (json['cagnotte'] as num).toDouble(), // Ensure it's a double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'place': place,
      'date_start': dateStart,
      'date_end': dateEnd,
      'transport_active': transportActive,
      'transport_start': transportStart,
      'cagnotte': cagnotte, // Add new field
    };
  }
}
