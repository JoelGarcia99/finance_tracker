import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/assembler/assembler.dart';
import 'package:finance_tracker/auth/models/model.user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthAPI {

  final _dbInstance = FirebaseFirestore.instance;

  Future<void> signUp(String email, String password) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );

    if(FirebaseAuth.instance.currentUser == null) return;

    await _dbInstance.collection('Usuario').add({
      '__id': FirebaseAuth.instance.currentUser!.uid
    });
  }

  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    final user = FirebaseAuth.instance.currentUser;

    if(user != null) {

      final userData = (await _dbInstance.collection('Usuario').where(
        '__id',
        isEqualTo: user.uid
      ).get()).docs[0];
      
      Wrapper().currentUserSink = UserModel(
        user.uid,
        name: userData.data()['name'] ?? 'Joel',
        lastName: userData.data()['last_name'] ?? 'García'
      );
    }
  }

  Future<void> insertEntry() async {

    final user = FirebaseAuth.instance.currentUser!.uid;

    await _dbInstance.collection('Usuario').add(
      UserModel(user).toJSON()  
    );
  }

}