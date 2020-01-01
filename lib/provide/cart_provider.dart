import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop/model/cart_info_bean.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  List<CartInfoBean> cartList;
  SharedPreferences _sp;
  bool isAllCheck = false;

  static CartProvider getInstant(BuildContext context) {
    return Provide.value<CartProvider>(context);
  }

  initListBySp() async {
    if (_sp != null && cartList != null) return;

    //初始化SharedPreferences
    _sp = await SharedPreferences.getInstance();
    String cartString = _sp.getString('cartInfo'); //获取持久化存储的值
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    //把获得值转变成List
    cartList = (temp as List)
        .cast()
        .map((json) => CartInfoBean.fromJson(json))
        .toList();

    _refreshAllCheck();
  }

  _refreshAllCheck() {
    isAllCheck =
        cartList.map((item) => item.isCheck).reduce((t1, t2) => t1 && t2);
  }

  _save() {
    //把字符串进行encode操作，
    String cartString =
        json.encode(cartList.map((item) => item.toJson()).toList()).toString();
    print(cartString);
    _sp.setString('cartInfo', cartString); //进行持久化
  }

  save(goodsId, goodsName, count, price, images) async {
    initListBySp();

    bool isContains = cartList.map((item) => item.goodsId).contains(goodsId);

    if (isContains) {
      cartList.forEach((item) {
        if (item.goodsId == goodsId) item.count++;
      });
    } else {
      cartList.add(new CartInfoBean(
          goodsId: goodsId,
          goodsName: goodsName,
          count: count,
          price: price,
          images: images,
          isCheck: true));
    }

    _save();

    notifyListeners();
  }

  clear() async {
    initListBySp();

    cartList.clear();

    _sp.clear();
    notifyListeners();
  }

  add(goodsId) {
    initListBySp();
    cartList.firstWhere((item) => item.goodsId == goodsId)?.count++;
    _save();
    notifyListeners();
  }

  reduce(goodsId) {
    initListBySp();
    var infoBean = cartList.firstWhere((item) => item.goodsId == goodsId);
    if (infoBean != null && infoBean.count >= 2) infoBean.count--;
    _save();
    notifyListeners();
  }

  changeCheck(bool isCheck, {String goodsId}) {
    initListBySp();

    if (goodsId == null) {
      cartList.forEach((item) {
        item.isCheck = isCheck;
      });
    } else {
      cartList.firstWhere((item) => item.goodsId == goodsId)?.isCheck = isCheck;
    }

    _refreshAllCheck();

    _save();
    notifyListeners();
  }

  remove(String goodsId) async {
    initListBySp();

    cartList.removeWhere((item) => item.goodsId == goodsId);

    _save();
    notifyListeners();
  }
}
