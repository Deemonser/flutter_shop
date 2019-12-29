import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop/model/cart_info_bean.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvide with ChangeNotifier {
  List<CartInfoBean> cartList = [];

  save(goodsId, goodsName, count, price, images) async {
    //初始化SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cartString = prefs.getString('cartInfo'); //获取持久化存储的值
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    //把获得值转变成List
    List<CartInfoBean> tempList = (temp as List)
        .cast()
        .map((json) => CartInfoBean.fromJson(json))
        .map((item) {
      if (item.goodsId == goodsId) item.count++;
      return item;
    }).toList();

    if (tempList.length == 0) {
      tempList.add(new CartInfoBean(
          goodsId: goodsId,
          goodsName: goodsName,
          count: count,
          price: price,
          images: images));
    }

    cartList = tempList;

    //把字符串进行encode操作，
    cartString = json.encode(tempList.map((item)=>item.toJson()).toList()).toString();
    print(cartString);
    prefs.setString('cartInfo', cartString); //进行持久化
    notifyListeners();
  }


  clear() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  remove(String goodsId) async{


  }

}
