import 'package:flutter/material.dart';
import 'package:flutter_shop/model/detail_bean.dart';
import 'package:flutter_shop/server/server_client.dart';

class DetailProvider with ChangeNotifier {

  DetailsGoodsData detailsBean;
  int index = 0;

  Future getDetailData(String goodsId) async {
    ServerClient().getDetailData(goodsId).then((value) {
      detailsBean = value.data;
      notifyListeners();
    });

    return "";
  }


  changeIndex(int index){
    this.index = index;
    notifyListeners();
  }



}
