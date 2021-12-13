import 'dart:convert';

class UserModel {

  final String id;
  final String? name;
  final String? lastName;

  UserModel(this.id, {
    this.name,
    this.lastName
  });

  UserModel copyWith(Map<String, dynamic> json) {
    final thisUser = toJSON();
    thisUser.updateAll((key, value) {
      if(json.keys.contains(key)) {
        return json[key];
      }

      return value;
    });

    return UserModel.fromJSON(thisUser);
  }

  UserModel.fromJSON(Map<String, dynamic> json):
    id = json['__id'],
    name = json['name'] ?? 'No name',
    lastName = json['last_name'] ?? 'No last name'
    ;

  Map<String, dynamic> toJSON() => {
    '__id': id,
    'name': name,
    'last_name': lastName,
  };

  String toJSONString() {
    // Parsing into a string
    final jsonString = json.encode(toJSON());

    return jsonString;
  }

}