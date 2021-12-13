import 'package:cloud_firestore/cloud_firestore.dart';

class AreaModel {

  final String? id;
  final String name;
  final String description;
  final double capital;
  late final Timestamp creation;
  final List<Map<String, dynamic>> balance;

  AreaModel({
    required this.name,
    required this.description,
    this.capital = 0.0,
    this.balance = const [],
    this.id,
  }) {
    creation = Timestamp.now();
  }
  
  AreaModel copyWith(Map<String, dynamic> json) {
    final thisUser = toJSON();
    thisUser.updateAll((key, value) {
      if(json.keys.contains(key)) {
        return json[key];
      }

      return value;
    });

    return AreaModel.fromJSON(thisUser);
  }

  AreaModel.fromJSON(Map<String, dynamic> json):
    id = json['__id'],
    name = json['name'] ?? 'No name',
    description = json['description'] ?? 'No description',
    capital = json['capital'] ?? 0.0,
    balance = List<Map<String, dynamic>>.from(json['balance'] ?? const []),
    creation = json['creation']
    ;

  Map<String, dynamic> toJSON() => {
    'name': name,
    'description': description,
    'capital': capital,
    'balance': balance,
    'creation': creation
  };
}