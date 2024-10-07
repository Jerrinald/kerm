class StatStand {
  final int id;
  final int actorId;
  final int standId;
  final int nbJeton;
  final int nbPoint;

  StatStand({
    required this.id,
    required this.actorId,
    required this.standId,
    required this.nbJeton,
    required this.nbPoint,
  });

  factory StatStand.fromJson(Map<String, dynamic> json) {
    return StatStand(
      id: json['id'],
      actorId: json['actor_id'],
      standId: json['standId'],
      nbJeton: json['nb_jeton'],
      nbPoint: json['nb_point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actor_id': actorId,
      'stand_id': standId,
      'nb_jeton': nbJeton,
      'nb_point': nbPoint,
    };
  }
}