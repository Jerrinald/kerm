class Organisateur {
  final int id;
  final int userId;
  final int kermesseId;

  Organisateur({
    required this.id,
    required this.userId,
    required this.kermesseId,
  });

  factory Organisateur.fromJson(Map<String, dynamic> json) {
    return Organisateur(
      id: json['id'],
      userId: json['user_id'],
      kermesseId: json['kermesse_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'kermesseId': kermesseId,
    };
  }
}