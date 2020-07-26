import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_test/model/user_model.dart';

class CloudFirestoreService {
  CollectionReference get users => Firestore.instance.collection('users');

  Future<DocumentReference> addUser({
    String userName,
    String userEmail,
    String uuid,
  }) async {
    return await users.add(<String, dynamic>{
      'name': userName,
      'email': userEmail,
      'uuid': uuid,
    });
  }

  Future<UserModel> getUser() async {
    FirebaseUser user =
        await FirebaseAuth.instance.currentUser().catchError((onError) {
      print('user not there error $onError');
    });
    QuerySnapshot querySnapshot = await users
        .where(
          'uuid',
          isEqualTo: user.uid,
        )
        .getDocuments()
        .catchError((onError) {
      print('get user error: $onError');
    });
    if (querySnapshot != null) {
      print(querySnapshot.documents[0].data);
      return UserModel(
          userName: querySnapshot.documents[0].data['name'],
          userEmail: querySnapshot.documents[0].data['email'],
          uuid: querySnapshot.documents[0].data['uuid']);
    } else {
      return null;
    }
  }
}
