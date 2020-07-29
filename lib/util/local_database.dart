import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_login_test/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';

class LocalDatabse {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final key = Key.fromUtf8('my 32 length key................');
  final iv = IV.fromLength(16);
  Encrypter encrypter;
  LocalDatabse() {
    encrypter = Encrypter(AES(key));
  }

  Future<UserModel> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserModel(
        userEmail: prefs.getString("email"),
        userName: prefs.getString("name"),
        isLogin: prefs.getBool("login"));
  }

  Future<bool> logIn({String email, String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encrypted = encrypter.encrypt(password, iv: iv);
    if (prefs.getString("email") == email &&
        prefs.getString("password") == encrypted.base64) {
      await prefs.setBool("login", true);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUp({String name, String email, String password}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final encrypted = encrypter.encrypt(password, iv: iv);
    if ((await prefs.setString("name", name)) &&
        (await prefs.setString("email", email)) &&
        (await prefs.setBool("login", true)) &&
        (await prefs.setString("password", encrypted.base64))) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool("login", false);
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

    await LocalDatabse().signUp(
      email: user.email,
      name: user.displayName,
      password: googleAuth.idToken,
    );
    return await LocalDatabse().getUser();
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
        final FirebaseUser user =
            (await _auth.signInWithCredential(authCredential)).user;

        await LocalDatabse().signUp(
          email: user.email,
          name: user.displayName,
          password: facebookLoginResult.accessToken.token,
        );
        break;
    }

    return resultString;
  }
}
