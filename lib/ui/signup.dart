import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_test/index.dart';
import 'package:flutter_login_test/model/user_model.dart';
import 'package:flutter_login_test/util/firebase_service.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password, name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            emailSignUpform(context),
            SizedBox(
              height: 30,
            ),
            facebookSignUp(context),
            googleSignUp(context),
          ],
        ),
      ),
    );
  }

  emailSignUpform(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            //name
            TextFormField(
              validator: (name) {
                if (name.isEmpty || name.contains("@")) {
                  return "Please enter a valid name";
                } else
                  return null;
              },
              onSaved: (name) {
                this.name = name;
              },
              decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 5),
            //email
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
            //password
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
            signUpButton(context: context),
            FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("Login"))
          ],
        ),
      ),
    );
  }

  facebookSignUp(BuildContext context) {
    return Container(
      child: FlatButton(
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
        child: Text("Sign up with Facebook"),
      ),
    );
  }

  googleSignUp(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () async {
          var res = await FirebaseService()
              .handleGoogleSignIn()
              .catchError((onError) {
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
                SnackBar(content: Text("Sign up Error. Please try again")));
          }
        },
        child: Text("Sign up with Google"),
      ),
    );
  }

  signUpButton({BuildContext context}) {
    return FlatButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          var usermodel = await signUpWithEmail(
            name: name,
            emial: email,
            pass: password,
          ).catchError((onError) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("$onError"),
            ));
          });
          if (usermodel != null) {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (context) => HomePsge()),
            );
          }
        }
      },
      child: Text("Sign Up"),
    );
  }

  Future<UserModel> signUpWithEmail(
      {String emial, String pass, String name}) async {
    return await FirebaseService().registerUser(
      email: emial,
      name: name,
      password: pass,
    );
  }
}
