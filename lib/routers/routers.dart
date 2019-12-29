import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_shop/indexs/detail_page.dart';

class Routers{
  static String root='/';
  static String detailsPage = '/detail';
  static Router router;

  static void configureRoutes(Router _router){
    router = _router;

    _router.notFoundHandler= new Handler(
        handlerFunc: (BuildContext context,Map<String,List<String>> params){
          print('ERROR====>ROUTE WAS NOT FONUND!!!');
        }
    );

    _router.define(detailsPage,handler:detailHandler);
  }



}





Handler detailHandler = Handler(handlerFunc: (context,Map<String,List<String>> params){

  var goodsId = params['id'].first;

  return DetailPage(goodsId);

});
