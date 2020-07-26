import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_test/index.dart';
import 'package:flutter_login_test/model/user_model.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_login_test/util/custom_web_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  CloudFirestoreService cloudFirestoreService = CloudFirestoreService();

  // static const app_id = '616400409286566';

  // static const redirect_url =
  //     'https://testproject-a5bc9.firebaseapp.com/__/auth/handler';

  Future<FirebaseUser> getCurrentUser() async {
    if (_auth != null)
      return await _auth.currentUser();
    else
      return null;
  }

  Future<UserModel> signInUser({
    String email,
    String password,
  }) async {
    final FirebaseUser user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      UserModel userModel =
          await cloudFirestoreService.getUser().catchError((onError) {
        print('Error Sign in $onError');
      });

      return userModel;
    } else
      return null;
  }

  Future<UserModel> handleGoogleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    UserModel userModel =
        await cloudFirestoreService.getUser().catchError((onError) {
      print('User error $onError');
    });

    if (userModel == null) {
      DocumentReference docRef = await cloudFirestoreService.addUser(
        userEmail: user.email,
        userName: user.displayName,
        uuid: user.uid,
      );

      if (docRef != null) {
        return UserModel(
          userEmail: user.email,
          userName: user.displayName,
          uuid: user.uid,
        );
      } else
        return null;
    } else {
      return userModel;
    }
  }

  Future<UserModel> registerUser({
    String name,
    String email,
    String password,
  }) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;

    try {
      await user.sendEmailVerification();
    } catch (e) {
      print("An error occured while trying to send email verification");
      print(e.message);
    }
    DocumentReference docRef = await cloudFirestoreService.addUser(
      userEmail: email,
      userName: name,
      uuid: user.uid,
    );

    if (docRef != null) {
      return UserModel(
        userEmail: email,
        userName: user.displayName,
        uuid: user.uid,
      );
    } else
      return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> handleFaceBookSignin() async {
    var facebookLogin = FacebookLogin();
    String resultString = 'Success';
    var facebookLoginResult = await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        resultString = '${facebookLoginResult.errorMessage} error';

        break;
      case FacebookLoginStatus.cancelledByUser:
        resultString = "Cancelled By User error";

        break;
      case FacebookLoginStatus.loggedIn:
        AuthCredential authCredential = FacebookAuthProvider.getCredential(
            accessToken: facebookLoginResult.accessToken.token);
        AuthResult authResult =
            await _auth.signInWithCredential(authCredential);
        UserModel userModel =
            await cloudFirestoreService.getUser().catchError((onError) {
          print('error $onError');
        });

        if (userModel == null) {
          DocumentReference docRef = await cloudFirestoreService.addUser(
            userEmail: authResult.user.email,
            userName: authResult.user.displayName,
            uuid: authResult.user.uid,
          );

          if (docRef != null) {
            resultString = 'Success';
          } else {
            resultString = 'database error';
          }
        }
        break;
    }

    return resultString;
  }
  // Future<String> handleFacebookLogin({BuildContext context}) async {
  //   String resultString = 'Success';
  //   String result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => CustomWebView(
  //               selectedUrl:
  //                   'https://www.facebook.com/dialog/oauth?client_id=$app_id&redirect_uri=$redirect_url&response_type=token&scope=email,public_profile,',
  //             ),
  //         maintainState: true),
  //   );
  //   if (result != null) {
  //     try {
  //       final facebookAuthCred =
  //           FacebookAuthProvider.getCredential(accessToken: result);
  //       var user =
  //           (await FirebaseAuth.instance.signInWithCredential(facebookAuthCred))
  //               .user;

  //       UserModel userModel =
  //           await cloudFirestoreService.getUser().catchError((onError) {
  //         print('error $onError');
  //       });

  //       if (userModel == null) {
  //         DocumentReference docRef = await cloudFirestoreService.addUser(
  //           userEmail: user.email,
  //           userName: user.displayName,
  //           uuid: user.uid,
  //         );

  //         if (docRef == null) {
  //           resultString = 'database error';
  //         }
  //       }
  //     } catch (e) {
  //       resultString = e.toString();
  //       print('Error $e');
  //     }
  //   }
  //   return resultString;
  // }
}
