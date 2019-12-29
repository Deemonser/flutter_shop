import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_goods_list_bean.dart';
import 'package:flutter_shop/server/server_client.dart';

class CategoryGoodsProvider with ChangeNotifier {
  List<CategoryListData> list = [];

  int page = 1;
  String categoryId;
  String categorySubId;

  changeCategoryId(String categoryId, String categorySubId) {
    this.categoryId = categoryId;
    this.categorySubId = categorySubId;
    print('$categoryId,$categorySubId');
    page = 1;

    ServerClient()
        .getCategoryGoodsList(categoryId, categorySubId, page)
        .then((value) {
      print(value.data);
      if (value.data != null) {
        list = value.data;
      } else {
        list = [];
      }
      page++;
      notifyListeners();
    });
  }

  loadMore() {
    ServerClient()
        .getCategoryGoodsList(categoryId, categorySubId, page)
        .then((value) {
      if (value.data != null) {
        list.addAll(value.data);
        page++;
      }
      notifyListeners();
    });
  }
}
