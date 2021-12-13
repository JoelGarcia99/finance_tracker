class UserModel {

  late Map<String, dynamic> balance;
  final String id;
  final String? name;
  final String? lastName;

  UserModel(this.id, {
    this.name,
    this.lastName
  }) {
    balance = {
      'date': DateTime.now(),
      'type': 'incoming',
      'value': 12.50,
      'area': {
        '__id': DateTime.now().millisecond,
        'name': 'videogames'
      }
    };
  }

  Map<String, dynamic> toJSON() => {
    '__id': id,
    'name': name,
    'last_name': lastName,
    'balance': balance
  };

}