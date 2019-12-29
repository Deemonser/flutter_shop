import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/provide/cart_provider.dart';
import 'package:flutter_shop/provide/category_goods_provider.dart';
import 'package:flutter_shop/provide/category_provider.dart';
import 'package:flutter_shop/provide/detail_provider.dart';
import 'package:flutter_shop/routers/routers.dart';
import 'package:provide/provide.dart';

import 'indexs/index_page.dart';

void main() {

  Routers.configureRoutes( Router());

  return runApp(
    ProviderNode(
      child: MyApp(),
      providers: Providers()
        ..provide(Provider.value(CategoryProvider()))
        ..provide(Provider.value(DetailProvider()))
        ..provide(Provider.value(CartProvide()))
        ..provide(Provider.value(CategoryGoodsProvider())),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "shop",
      theme: ThemeData(primaryColor: Colors.pink),
      onGenerateRoute: Routers.router.generator,
      home: IndexPage(),
    );
  }
}
