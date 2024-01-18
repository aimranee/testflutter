import 'dart:convert';

class EventModel {
  EventModel({
    required this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.location,
    required this.description,
    required this.prix,
  });

  String? id;
  String? title;
  String? image;
  String? date;
  String? location;
  String? description;
  String? prix;

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json["id"],
      title: json["title"],
      image: json["image"],
      date: json["date"],
      location: json["location"],
      description: json["description"],
      prix: json["prix"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "date": date,
        "location": location,
        "description": description,
        "prix": prix,
      };
}
