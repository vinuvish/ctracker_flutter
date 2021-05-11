import 'package:flutter/material.dart';

class AccountDisabledPage extends StatefulWidget {
  AccountDisabledPage({Key key}) : super(key: key);

  @override
  _AccountDisabledPageState createState() => _AccountDisabledPageState();
}

class _AccountDisabledPageState extends State<AccountDisabledPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.asset('assets/images/acc_disabled.png'),
          ),
          Text('Account not activated ', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
          SizedBox(height: 20),
          Text(
            'You account has been disbaled',
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(letterSpacing: 1, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
