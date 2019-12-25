import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/server/server_client.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: ServerClient().getHomePageContent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              return _buildView(data);
            } else {
              return Text("loading...");
            }
          }),
    );
  }

  SingleChildScrollView _buildView(data) {
    List<Map> swiperList = (data['data']['slides'] as List).cast();
    List<Map> navList = (data['data']['category'] as List).cast();
    String imageUrl = data['data']['advertesPicture']['PICTURE_ADDRESS'];
    String leaderImage = data['data']['shopInfo']['leaderImage']; //店长图片
    String leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长电话

    List<Map> recommendList = (data['data']['recommend'] as List).cast();

    String floor1Title =
        data['data']['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
    String floor2Title =
        data['data']['floor2Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
    String floor3Title =
        data['data']['floor3Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
    List<Map> floor1 = (data['data']['floor1'] as List).cast(); //楼层1商品和图片
    List<Map> floor2 = (data['data']['floor2'] as List).cast(); //楼层1商品和图片
    List<Map> floor3 = (data['data']['floor3'] as List).cast(); //楼层1商品和图片

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HomeSwiper(swiperList: swiperList),
          TopNav(navList: navList),
          AdBanner(imageUrl: imageUrl),
          LeaderPhone(image: leaderImage, phone: leaderPhone),
          Recommend(recommendList: recommendList),
          FloorTitle(imageUrl: floor1Title),
          FloorContent(goodsList: floor1),
          FloorTitle(imageUrl: floor2Title),
          FloorContent(goodsList: floor2),
          FloorTitle(imageUrl: floor3Title),
          FloorContent(goodsList: floor3),
          HotPage(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// 首页轮播图
class HomeSwiper extends StatelessWidget {
  final List swiperList;

  HomeSwiper({Key key, this.swiperList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) => Image.network(
          "${swiperList[index]['image']}",
          fit: BoxFit.fill,
        ),
        itemCount: swiperList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 首页导航
class TopNav extends StatelessWidget {
  final List navList;

  TopNav({Key key, this.navList}) : super(key: key);

  Widget _gridViewItem(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navList.length > 10) {
      this.navList.removeRange(10, navList.length);
    }

    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(260),
      padding: EdgeInsets.all(4),
      child: GridView.count(
        children: navList.map((item) => _gridViewItem(context, item)).toList(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4),
      ),
    );
  }
}

class AdBanner extends StatelessWidget {
  final String imageUrl;

  AdBanner({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(imageUrl),
    );
  }
}

//  电话
class LeaderPhone extends StatelessWidget {
  final String image;
  final String phone;

  LeaderPhone({Key key, this.image, this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _callPhone,
      child: Container(
        child: Image.network(this.image),
      ),
    );
  }

  void _callPhone() async {
    String url = 'tel:' + phone;
    print('_callPhone');
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({
    Key key,
    this.recommendList,
  }) : super(key: key);

  Widget _title(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
          itemCount: recommendList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => _item(index)),
    );
  }

  Widget _item(index) {
    return Container(
      height: ScreenUtil().setHeight(330),
      width: ScreenUtil().setWidth(250),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(width: 1, color: Colors.black12))),
      child: Column(
        children: <Widget>[
          Image.network(recommendList[index]['image']),
          Text('￥${recommendList[index]['mallPrice']}'),
          Text(
            '￥${recommendList[index]['price']}',
            style: TextStyle(
                decoration: TextDecoration.lineThrough, color: Colors.grey),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_title(context), _recommendList()],
      ),
    );
  }
}

// 楼层 Title
class FloorTitle extends StatelessWidget {
  final String imageUrl;

  FloorTitle({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(imageUrl),
    );
  }
}

// 楼层内容
class FloorContent extends StatelessWidget {
  final List goodsList;

  FloorContent({Key key, this.goodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_firstFloor(), _secondFloor()],
    );
  }

  Widget _goods(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: Image.network(goods['image']),
    );
  }

  Widget _firstFloor() {
    return Row(
      children: <Widget>[
        _goods(goodsList[0]),
        Column(
          children: <Widget>[
            _goods(goodsList[1]),
            _goods(goodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _secondFloor() {
    return Row(
      children: <Widget>[
        _goods(goodsList[3]),
        _goods(goodsList[4]),
      ],
    );
  }
}

// 火爆专区
class HotPage extends StatefulWidget {
  @override
  _HotPageState createState() => _HotPageState();
}

class _HotPageState extends State<HotPage> {


  @override
  void initState() {
    super.initState();
    ServerClient().getHomeHotContent().then((value){
      print(value);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
