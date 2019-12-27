import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/category_provider.dart';
import 'package:provide/provide.dart';

import 'indexs/index_page.dart';

void main() => runApp(
      ProviderNode(
        child: MyApp(),
        providers: Providers()..provide(Provider.value(CategoryProvider())),
      ),
    );

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
