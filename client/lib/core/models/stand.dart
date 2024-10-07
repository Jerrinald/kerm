class Stand {
  final int id;
  final int actorId;
  final int kermesseId;
  final String name;
  final String type;
  final int maxPoint;

  Stand({
    required this.id,
    required this.actorId,
    required this.kermesseId,
    required this.type,
    required this.name,
    required this.maxPoint,
  });

  factory Stand.fromJson(Map<String, dynamic> json) {
    return Stand(
      id: json['id'],
      actorId: json['actor_id'],
      kermesseId: json['kermesse_id'],
      name: json['name'],
      type: json['type'],
      maxPoint: json['max_point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'actor_id': actorId,
      'kermesse_id': kermesseId,
      'name': name,
      'type': type,
      'max_point': maxPoint,
    };
  }
}