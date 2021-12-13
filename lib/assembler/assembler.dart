import 'dart:async';

import 'package:finance_tracker/auth/models/model.user.dart';

/// This class is used to update all the interfaces in real time,
/// so every time you update something in runtime, you should update
/// this class in order to notify all the other classes

class Wrapper {

  /// Singleton pattern
  static Wrapper? _instance;

  factory Wrapper() {
    _instance ??= Wrapper._();

    return _instance!;
  }

  Wrapper._();

  UserModel? _currentUser;

  /// All the data in home
  final StreamController<Map<String, dynamic>> _homeData = StreamController.broadcast();
  final StreamController<Map<String, dynamic>> _currentPageData = StreamController.broadcast();
  final StreamController<UserModel> _userData = StreamController.broadcast();

  Stream<Map<String, dynamic>> get homeDataStream => _homeData.stream;
  Function(Map<String, dynamic>) get homeDataSink => _homeData.sink.add;

  Stream<Map<String, dynamic>> get currentPageDataStream => _currentPageData.stream;
  Function(Map<String, dynamic>) get currentPageDataSink => _currentPageData.sink.add;

  Stream<UserModel> get currentUserStream => _userData.stream;
  
  set currentUserSink(UserModel user) {
    _currentUser = user;
    _userData.sink.add(user);
  }
  UserModel? get currentUser => _currentUser;


}