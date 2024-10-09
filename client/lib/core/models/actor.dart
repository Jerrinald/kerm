class Actor {
  final int id;
  final int userId;
  final int kermesseId;
  final int nbJeton;
  final bool response;
  final bool active;

  Actor({
    required this.id,
    required this.userId,
    required this.kermesseId,
    required this.nbJeton,
    required this.response,
    required this.active,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      userId: json['user_id'],
      kermesseId: json['kermesse_id'],
      nbJeton: json['nb_jeton'],
      response: json['response'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'kermesseId': kermesseId,
      'nb_jeton': nbJeton,
      'response': response,
      'active': active,
    };
  }
}

class ActorUser {
  final int id;
  final int userId;
  final int kermesseId;
  final int nbJeton;
  final bool response;
  final bool active;
  final String email;
  final String firstname;
  final String lastname;

  ActorUser({
    required this.id,
    required this.userId,
    required this.kermesseId,
    required this.nbJeton,
    required this.response,
    required this.active,
    required this.email,
    required this.firstname,
    required this.lastname,
  });

  factory ActorUser.fromJson(Map<String, dynamic> json) {
    return ActorUser(
      id: json['id'],
      userId: json['user_id'],
      kermesseId: json['kermesse_id'],
      nbJeton: json['nb_jeton'],
      response: json['response'],
      active: json['active'],
      email: json['email'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'kermesse_id': kermesseId,
      'nb_jeton': nbJeton,
      'response': response,
      'active': active,
      'email': email,
      'firstname': firstname,
      'lastname': lastname,
    };
  }
}