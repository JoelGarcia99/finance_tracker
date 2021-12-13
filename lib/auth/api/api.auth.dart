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

    await _dbInstance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid)
      .set({
        '__id': FirebaseAuth.instance.currentUser!.uid
      });

    final user = FirebaseAuth.instance.currentUser!;
    
    // default user data
    Wrapper().currentUserSink = UserModel(
      user.uid,
      name: 'Joel',
      lastName: 'García'
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Wrapper().currentUserSink = null;
  }

  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    final user = FirebaseAuth.instance.currentUser;

    if(user != null) {

      final userData = (await _dbInstance.collection('Users').doc(user.uid).get());
      
      Wrapper().currentUserSink = UserModel(
        user.uid,
        name: userData.data()?['name'] ?? 'No name',
        lastName: userData.data()?['last_name'] ?? 'No surname'
      );
    }
  }

  Future<void> insertEntry() async {

    final user = FirebaseAuth.instance.currentUser!.uid;

    await _dbInstance.collection('Users').add(
      UserModel(user).toJSON()  
    );
  }

  Future<void> updateUser(Map<String, dynamic> updateFields) async {
    if(updateFields.containsKey('__id')) updateFields.remove('__id');

    /// Cannot update if there is no user in session
    /// If this raise an error it means you did something wrond.
    await _dbInstance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid,).
      update(updateFields);

    Wrapper().currentUserSink = Wrapper().currentUser!.copyWith(updateFields);
  }

}