part of 'models.dart';

class User {
  final int? id;
  final String name;
  final bool isMainUser;

  const User({ 
    this.id, 
    required this.name, 
    required this.isMainUser
  });
}