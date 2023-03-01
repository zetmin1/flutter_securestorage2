import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'register_page.dart';
import 'util.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  late TextEditingController _userEmailCtrl;
  late TextEditingController _userPasswordCtrl;

  @override
  void initState() {
    super.initState();
    _userEmailCtrl = TextEditingController(text: '');
    _userPasswordCtrl = TextEditingController(text: '');
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('login page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(flex: 3, child: SizedBox()),
              _emailWidget(),
              SizedBox(
                height: 8,
              ),
              _passwordWidget(),
              _loginButton(context),
              Expanded(
                flex: 3,
                child: SizedBox(),
              ),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailWidget() {
    return TextFormField(
      controller: _userEmailCtrl,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        labelText: "Email",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _passwordWidget() {
    return TextFormField(
      controller: _userPasswordCtrl,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key_rounded),
        labelText: "Password",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _loginButton(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () => isLoading ? null : _loginCheck(),
        child: Text(
          isLoading ? 'loggin in ....' : 'login',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Don\'t have an account?'),
        SizedBox(
          width: 20,
        ),
        InkWell(
          onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => RegisterPage())),
          child: Text('register'),
        ),
      ],
    );
  }

  void _loginCheck() async {
    print('_userEmailctrl.text : ${_userEmailCtrl.text}');
    print('_userPasswordCtrl.text : ${_userPasswordCtrl.text}');

    final storage = FlutterSecureStorage();
    String? storagePass = await storage.read(key: '${_userEmailCtrl.text}');
    if (storagePass != null &&
        storagePass != '' &&
        storagePass == _userPasswordCtrl.text) {
      print('storagePass : $storagePass');
      String? userNickName =
          await storage.read(key: '${_userEmailCtrl.text}_$storagePass');
      storage.write(key: userNickName!, value: STATUS_LOGIN);
      print('로그인 성공');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  MainPage(nickName: userNickName)));
    }
  }
}
