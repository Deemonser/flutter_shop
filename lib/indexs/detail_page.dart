import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provide/cart_provider.dart';
import 'package:flutter_shop/provide/detail_provider.dart';
import 'package:provide/provide.dart';

class DetailPage extends StatelessWidget {
  String goodsId;

  DetailPage(this.goodsId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品详情 $goodsId'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: Provide.value<DetailProvider>(context).getDetailData(goodsId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: <Widget>[
              Expanded(
                child: Container(
//                margin: EdgeInsets.only(bottom: 100),
                  child: ListView(
                    children: <Widget>[
                      DetailTopArea(),
                      DetailsExplain(),
                      DetailTabBar(),
                      DetailWeb(),
                    ],
                  ),
                ),
              ),
              DetailsBottom(),
            ]);
          } else {
            return Text("loading......");
          }
        },
      ),
    );
  }
}

class DetailTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailProvider>(builder: (context, child, val) {
      var goodsInfo =
          Provide.value<DetailProvider>(context).detailsBean?.goodInfo;

      if (goodsInfo != null) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(2.0),
          child: Column(
            children: <Widget>[
              _goodsImage(goodsInfo.image1),
              _goodsName(goodsInfo.goodsName),
              _goodsNum(goodsInfo.goodsSerialNumber),
              _goodsPrice(goodsInfo.presentPrice, goodsInfo.oriPrice)
            ],
          ),
        );
      } else {
        return Text('正在加载中......');
      }
    });
  }

  //商品图片
  Widget _goodsImage(url) {
    return Image.network(url, width: ScreenUtil().setWidth(740));
  }

  //商品名称
  Widget _goodsName(name) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      child: Text(
        name,
        maxLines: 1,
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
      ),
    );
  }

  Widget _goodsNum(num) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Text(
        '编号:${num}',
        style: TextStyle(color: Colors.black26),
      ),
    );
  }

  //商品价格方法
  Widget _goodsPrice(presentPrice, oriPrice) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            '￥${presentPrice}',
            style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: ScreenUtil().setSp(40),
            ),
          ),
          Text(
            '市场价:￥${oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }
}

class DetailsExplain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        width: ScreenUtil().setWidth(750),
        padding: EdgeInsets.all(10.0),
        child: Text(
          '说明：> 急速送达 > 正品保证',
          style: TextStyle(color: Colors.red, fontSize: ScreenUtil().setSp(30)),
        ));
  }
}

class DetailTabBar extends StatefulWidget {
  @override
  _DetailTabBarState createState() => _DetailTabBarState();
}

class _DetailTabBarState extends State<DetailTabBar>
    with SingleTickerProviderStateMixin {
  var tabs = [
    Tab(child: Text("详细")),
    Tab(child: Text("评论")),
  ];

  TabController _controller;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: tabs.length);

    _controller.addListener(() {
      if (_controller.indexIsChanging) {
        Provide.value<DetailProvider>(context).changeIndex(_controller.index);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: TabBar(
        tabs: tabs,
        controller: _controller,
        indicatorColor: Colors.pink,
        labelColor: Colors.pink,
        unselectedLabelColor: Colors.black87,
      ),
    );
  }
}

class DetailWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provide.value<DetailProvider>(context);
    var goodsDetail = provider.detailsBean?.goodInfo?.goodsDetail;

    return Container(
      child: Provide<DetailProvider>(
        builder: (context, child, value) {
          if (value.index == 0) {
            return Html(
              data: goodsDetail == null ? "" : goodsDetail,
            );
          } else {
            return Center(
              child: Text("暂时没有评论"),
            );
          }
        },
      ),
    );
  }
}

class DetailsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      color: Colors.white,
      height: ScreenUtil().setHeight(100),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
              width: ScreenUtil().setWidth(110),
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart,
                size: 28,
                color: Colors.red,
              ),
            ),
          ),
          InkWell(
            onTap: ()async {
              var info = Provide.value<DetailProvider>(context).detailsBean.goodInfo;
              await Provide.value<CartProvide>(context).save(info.goodsId, info.goodsName, 1, info.presentPrice, info.image1);
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              color: Colors.green,
              child: Text(
                '加入购物车',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          ),
          InkWell(
            onTap: ()async {
              await Provide.value<CartProvide>(context).clear();
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              color: Colors.red,
              child: Text(
                '马上购买',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
