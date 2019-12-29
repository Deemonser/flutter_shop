import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category_bean.dart';

class CategoryProvider with ChangeNotifier {
  List<BxMallSubDto> categoryList = [];
  int index=0;

  changeTabList(List<BxMallSubDto> listData) {
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';

    categoryList = [all];
    categoryList.addAll(listData);

    index =0;
    notifyListeners();
  }

  changeTopIndex(int index) {
    this.index = index;
    notifyListeners();
  }
}
