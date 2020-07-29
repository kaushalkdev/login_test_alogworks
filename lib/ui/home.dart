import 'package:flutter/cupertino.dart';
import 'package:flutter_login_test/index.dart';
import 'package:flutter_login_test/model/user_model.dart';
import 'package:flutter_login_test/util/local_database.dart';

class HomePsge extends StatefulWidget {
  @override
  _HomePsgeState createState() => _HomePsgeState();
}

class _HomePsgeState extends State<HomePsge> {
  UserModel _userModel;
  @override
  void initState() {
    super.initState();
    LocalDatabse().getUser().then((value) {
      _userModel = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
      ),
      body: _userModel != null
          ? Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text("Welcome ${_userModel.getUserName()}"),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                      child: Text("Sign out"),
                      onPressed: () async {
                        await LocalDatabse().signOut();
                        Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => LoginPage(),
                            ));
                      })
                ],
              ),
            )
          : Center(
              child: Text("Loading Please wait..."),
            ),
    );
  }
}
