import 'dart:convert';

import "package:dio/dio.dart";
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop/model/category_bean.dart';
import 'package:flutter_shop/model/category_goods_list_bean.dart';
import 'package:flutter_shop/model/detail_bean.dart';

class ServerClient {
  static const server_url = "http://v.jspang.com:8088/baixing";

  static const home_page = server_url + '/wxmini/homePageContent'; // 商家首页信息
  static const home_hot =
      server_url + '/wxmini/homePageBelowConten'; //商城首页热卖商品拉取
  static const category = server_url + '/wxmini/getCategory'; //分类
  static const mallGoods = server_url + '/wxmini/getMallGoods'; //分类商品列表
  static const goodsDetail = server_url + '/wxmini/getGoodDetailById'; //分类商品列表

  Future request(url, {formData}) async {
    try {
      Response response;
      Dio dio = new Dio();
      dio.interceptors.add(LogInterceptor(responseBody: true));
      dio.options.contentType = Headers.formUrlEncodedContentType;
      if (formData == null) {
        response = await dio.post(url);
      } else {
        response = await dio.post(url, data: formData);
      }

      if (response.statusCode == 200) {
        var result = response.data;
        return result;
      } else {
        throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
      }
    } catch (e) {
      return print('ERROR:======>${e}');
    }
  }

  Future getHomePageContent() async {
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    return request(home_page, formData: formData);
  }

  Future getHomeHotContent(int page) async {
    var formPage = {'page': page};
    return request(home_hot, formData: formPage);
  }

  Future<CategoryBean> getCategory() async {
    var response = await request(category);
    var data = json.decode(response.toString());
    return CategoryBean.fromJson(data);
  }

  Future<CategoryGoodsListBean> getCategoryGoodsList(
      String categoryId, String categorySubId, int page) async {
    var formData = {
      'categoryId': '$categoryId',
      'categorySubId': "$categorySubId",
      'page': page
    };

    var response = await request(mallGoods, formData: formData);
    var data = json.decode(response.toString());
    return CategoryGoodsListBean.fromJson(data);
  }

    Future<DetailsBean> getDetailData(
      String goodsId) async {
    var formData = {
      'goodId': '$goodsId',
    };

    var response = await request(goodsDetail, formData: formData);
    var data = json.decode(response.toString());
    return DetailsBean.fromJson(data);
  }




}
