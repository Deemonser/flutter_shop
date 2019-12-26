import "package:dio/dio.dart";
import 'dart:async';



class ServerClient {
  static const server_url = "http://v.jspang.com:8088/baixing";

  static const home_page = server_url + '/wxmini/homePageContent'; // 商家首页信息
  static const home_hot =
      server_url + '/wxmini/homePageBelowConten'; //商城首页热卖商品拉取

  Future request(url, {formData}) async {
    try {
      print('开始获取数据..............url:$url');
      Response response;
      Dio dio = new Dio();
      dio.options.contentType = "application/x-www-form-urlencoded";
      if (formData == null) {
        response = await dio.post(url);
      } else {
        response = await dio.post(url, data: formData);
      }

      if (response.statusCode == 200) {
        return response.data;
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
}
