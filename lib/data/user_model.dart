import 'dart:developer';

class UserModel {
  int? id;
  String? nom;
  String? prenom;
  String? email;

  UserModel({this.id, this.nom, this.prenom, this.email});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    log("ffff");
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['email'] = email;
    return data;
  }
}
