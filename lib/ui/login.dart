import 'package:flutter/cupertino.dart';
import 'package:flutter_login_test/index.dart';
import 'package:flutter_login_test/util/firebase_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login in"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            emailLoginform(context),
            SizedBox(
              height: 30,
            ),
            facebookLoginUp(context),
            googleLoginUp(context),
          ],
        ),
      ),
    );
  }

  emailLoginform(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (email) {
                if (email.isEmpty && !email.contains("@")) {
                  return "Please enter an email";
                } else
                  return null;
              },
              onSaved: (email) {
                this.email = email;
              },
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 5),
            TextFormField(
              onSaved: (password) {
                this.password = password;
              },
              validator: (password) {
                if (password.isEmpty && password.length < 8) {
                  return "Password must be 8 char longer";
                } else
                  return null;
              },
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            loginButton(context: context),
            FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => SignUp()));
                },
                child: Text("Sign up"))
          ],
        ),
      ),
    );
  }

  facebookLoginUp(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        var res = await FirebaseService()
            .handleFaceBookSignin()
            .catchError((onError) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("$onError"),
          ));
        });
        if (res != null && res.contains("Success")) {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePsge(),
              ));
        } else {
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Login Error. Please try again")));
        }
      },
      child: Text("Login with Facebook"),
    );
  }

  googleLoginUp(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        var res =
            await FirebaseService().handleGoogleSignIn().catchError((onError) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("$onError"),
          ));
        });
        if (res != null) {
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePsge(),
              ));
        } else {
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text("Login Error. Please try again")));
        }
      },
      child: Text("Login with Google"),
    );
  }

  loginButton({BuildContext context}) {
    return FlatButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          var res = await loginWithEmail(
            emial: email,
            pass: password,
          ).catchError((onError) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("$onError"),
            ));
          });
          if (res != null) {
            Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePsge(),
                ));
          } else {
            _scaffoldKey.currentState.showSnackBar(
                SnackBar(content: Text("Login Error. Please try again")));
          }
        }
      },
      child: Text("Login"),
    );
  }

  Future loginWithEmail({String emial, String pass}) async {
    return await FirebaseService().signInUser(email: email, password: pass);
  }
}
