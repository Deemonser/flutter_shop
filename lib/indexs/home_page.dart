import 'package:flutter/material.dart';
import 'package:flutter_shop/server/server_client.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _showText = "还没数据";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                ServerClient().getHomePageContent().then((value) {
                  setState(() {
                    _showText = value.toString();
                  });
                });
              },
              child: Text('点击获取数据'),
            ),
            Text(_showText)
          ],
        ),
      ),
    );
  }
}
