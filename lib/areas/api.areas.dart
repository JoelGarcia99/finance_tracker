import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/areas/model.area.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AreasAPI {

  static AreasAPI? _instance;

  factory AreasAPI() {
    _instance ??= AreasAPI._();

    return _instance!;
  }

  AreasAPI._();

  final _dbInstance = FirebaseFirestore.instance;

  Future<AreaModel> createArea(AreaModel area) async {
    final jsonData = area.toJSON();
    jsonData.addAll({'user_id': FirebaseAuth.instance.currentUser!.uid});

    final dbArea = await _dbInstance.collection('Areas').add(jsonData);

    return area.copyWith({
      '__id': dbArea.id
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _queryAreas() {
    return _dbInstance.collection('Areas').where(
      'user_id',
      isEqualTo: FirebaseAuth.instance.currentUser!.uid
    ).orderBy(
      'creation',
      descending: true
    ).limit(10).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? _areasStream;

  Stream<QuerySnapshot<Map<String, dynamic>>> get queryAreasStream {
    _areasStream ??= _queryAreas();
    return _areasStream!;
  }

}