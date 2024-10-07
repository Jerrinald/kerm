class Tombola {
  final int id;
  final int actorId;
  final int kermesseId;
  final int nbTicket;

  Tombola({
    required this.id,
    required this.actorId,
    required this.kermesseId,
    required this.nbTicket,
  });

  factory Tombola.fromJson(Map<String, dynamic> json) {
    return Tombola(
      id: json['id'],
      actorId: json['actor_id'],
      kermesseId: json['kermesse_id'],
      nbTicket: json['nb_ticket'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actor_id': actorId,
      'kermesse_id': kermesseId,
      'nb_ticket': nbTicket,
    };
  }
}