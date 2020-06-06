import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nomoni_app/utils/api.dart' as api;
import 'package:nomoni_app/utils/helpers.dart' as helpers;

class Login extends StatefulWidget {
  final String title;

  Login({Key key, this.title}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {    
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<http.Response> logIn() async {
    dynamic body = <String, String> {
      'email': emailCtrl.text,
      'password': passwordCtrl.text
    };
    return await api.post('auth/login', body);
    
    // _createAndPrintSpendData(amountController.text, nameController.text);
    // Navigator.pushNamed(context, '/expenses');
    // Navigator.pushReplacementNamed(context, '/expenses');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'User: ',
                    icon: Icon(Icons.account_box)
                  ),
                  maxLength: 50,
                ),
                TextField(
                  controller: passwordCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'Password: ',
                    icon: Icon(Icons.security)
                  ),
                  maxLength: 20,
                  obscureText: true
                ),
                RaisedButton(
                  onPressed: () {
                    dynamic body = <String, String> {
                      'email': emailCtrl.text,
                      'password': passwordCtrl.text
                    };
                    api.post('auth/login', body).then((response) {
                      if (response.statusCode == 200) {
                        Map resp = json.decode(response.body);
                        helpers.showMessage(context, resp);
                      }
                    });
                  },
                  child: Text('Sign In'),
                ),
              ],
            ),
          )
        )
      )
    );
  }

    
}