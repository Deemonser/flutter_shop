import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/widget/BottomNavigationIcon.dart';

import 'cart_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationIcon> _bottomItems = [
    BottomNavigationIcon("首页", CupertinoIcons.home),
    BottomNavigationIcon("分类", CupertinoIcons.search),
    BottomNavigationIcon("购物车", CupertinoIcons.shopping_cart),
    BottomNavigationIcon("会员中心", CupertinoIcons.profile_circled)
  ];

  final List<Widget> _page = [
    HomePage(),
    SearchPage(),
    CartPage(),
    ProfilePage()
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("百姓生活+"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _page,
      ),
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _bottomItems.map((item) => item.item).toList(),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
