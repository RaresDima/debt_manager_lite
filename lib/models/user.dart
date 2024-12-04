part of 'models.dart';

class User {
  final int? id;
  final String name;

  Future<bool> get isMainUser async {
    return id == (await DatabaseService().mainUser).id;
  }

  const User({ 
    this.id, 
    required this.name
  });
}