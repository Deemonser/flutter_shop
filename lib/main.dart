import 'package:flutter/material.dart';

import 'indexs/index_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "shop",
      theme: ThemeData(primaryColor: Colors.pink),
      home: IndexPage(),
    );
  }
}
