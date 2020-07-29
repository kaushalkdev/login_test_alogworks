import 'package:flutter/cupertino.dart';
import 'package:flutter_login_test/util/local_database.dart';
import '../index.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    fetchData().then((islogin) {
      Future.delayed(Duration(seconds: 2))
          .then((value) => Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => islogin ? HomePsge() : LoginPage(),
              )))
          .catchError((onError) {
        print("Error $onError");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Text("Splash Screen waiting...."),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> fetchData() async {
    var user = await LocalDatabse().getUser().catchError((onError) {
      print("getting user eroor");
    });
    print(user.getUserName());
    if (user.getisLogin() != null) {
      return user.getisLogin();
    } else {
      return false;
    }
  }
}
