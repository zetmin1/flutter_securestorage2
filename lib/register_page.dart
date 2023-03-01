import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'login_page.dart';
import 'util.dart';

import 'main_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  late TextEditingController _userNickNameCtrl;
  late TextEditingController _userEmailCtrl;
  late TextEditingController _userPasswordCtrl;

  @override
  void initState() {
    super.initState();
    _userNickNameCtrl = TextEditingController(text: '');
    _userEmailCtrl = TextEditingController(text: '');
    _userPasswordCtrl = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: SizedBox(),
              ),
              _nickNameWidget(),
              SizedBox(
                height: 8,
              ),
              _emailWidget(),
              SizedBox(
                height: 8,
              ),
              _passwordWidget(),
              _joinButton(context),
              _loginButton(context),
              Expanded(
                flex: 3,
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _nickNameWidget() {
    return TextFormField(
      controller: _userNickNameCtrl,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_circle_rounded),
        labelText: "nickName",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _emailWidget() {
    return TextFormField(
      controller: _userEmailCtrl,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
        ),
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

  Widget _joinButton(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () {
          isLoading ? null : _registCheck();
        },
        child: Text(
          isLoading ? 'regist in.....' : 'regist',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _loginButton(context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () => isLoading
            ? null
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(),
                ),
              ),
        child: Text(
          'loginPage',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _registCheck() async {
    final storage = FlutterSecureStorage();
    print(' ');
    print('await storage.readAll() : ');
    print(await storage.readAll());
    print(' ');
    String userNickName = _userNickNameCtrl.text;
    String userEmail = _userEmailCtrl.text;
    String userPassword = _userPasswordCtrl.text;
    if (userNickName != '' && userEmail != '' && userPassword != '') {
      //final storage = FlutterSecureStorage();
      String? emailCheck = await storage.read(key: userEmail);
      if (emailCheck == null) {
        storage.write(key: userEmail, value: userPassword);
        storage.write(key: '${userEmail}_$userPassword', value: userNickName);
        storage.write(key: userNickName, value: STATUS_LOGIN);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainPage(
                      nickName: userNickName,
                    )));
      } else {
        showToast('email이 중복됩니다.');
      }
    } else {
      showToast("입력란을 모두 채워주세요.");
    }
  }
}
