import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/category_bean.dart';
import 'package:flutter_shop/model/category_goods_list_bean.dart';
import 'package:flutter_shop/provide/category_goods_provider.dart';
import 'package:flutter_shop/provide/category_provider.dart';
import 'package:flutter_shop/routers/routers.dart';
import 'package:flutter_shop/server/server_client.dart';
import 'package:provide/provide.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: ServerClient().getCategory(),
          builder: (context, snapshot) => snapshot.hasData
              ? _buildContent(snapshot.data)
              : Text("loading....")),
    );
  }

  Widget _buildContent(CategoryBean data) {
    var mallSubDto = data.data[0].bxMallSubDto;
    Provide.value<CategoryProvider>(context).changeTabList(mallSubDto);
    Provide.value<CategoryGoodsProvider>(context)
        .changeCategoryId(data.data[0].mallCategoryId, '');
    return Row(
      children: <Widget>[
        LeftNav(dataList: data.data),
        Container(
          child: Column(
            children: <Widget>[
              RightTopNav(),
              GoodsList(),
            ],
          ),
        )
      ],
    );
  }
}

/// 左侧导航
class LeftNav extends StatefulWidget {
  List<Data> dataList;

  LeftNav({Key key, this.dataList}) : super(key: key);

  @override
  _LeftNavState createState() => _LeftNavState();
}

class _LeftNavState extends State<LeftNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.black12, width: 0.5))),
      child: ListView.separated(
        itemBuilder: (context, index) =>
            _buildItemWidget(context, index, widget.dataList[index]),
        separatorBuilder: (context, index) => Divider(height: 1),
        itemCount: widget.dataList.length,
      ),
    );
  }

  Widget _buildItemWidget(BuildContext context, int index, Data item) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        Provide.value<CategoryProvider>(context)
            .changeTabList(item.bxMallSubDto);
        Provide.value<CategoryGoodsProvider>(context)
            .changeCategoryId(item.mallCategoryId, '');
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
            color: _currentIndex == index
                ? Color.fromRGBO(236, 236, 236, 1)
                : Colors.white),
        child: Center(child: Text(item.mallCategoryName)),
      ),
    );
  }
}

/// 右侧顶部导航
class RightTopNav extends StatefulWidget {
  @override
  _RightTopNavState createState() => _RightTopNavState();
}

class _RightTopNavState extends State<RightTopNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(570),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 1),
          ),
        ),
        child: Provide<CategoryProvider>(builder: (context, child, category) {
          return ListView(
              scrollDirection: Axis.horizontal,
              children: category.categoryList
                  .asMap()
                  .map((index, item) =>
                      MapEntry(index, _buildTabWidget(index, item)))
                  .values
                  .toList());
        }));
  }

  Widget _buildTabWidget(int index, BxMallSubDto item) {
    bool isCheck = index == Provide.value<CategoryProvider>(context).index;
    return InkWell(
      onTap: () {
        Provide.value<CategoryProvider>(context).changeTopIndex(index);
        Provide.value<CategoryGoodsProvider>(context)
            .changeCategoryId(item.mallCategoryId, item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(item.mallSubName,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: isCheck ? Colors.pink : Colors.black87)),
      ),
    );
  }
}

/// 商品列表
class GoodsList extends StatefulWidget {
  @override
  _GoodsListState createState() => _GoodsListState();
}

class _GoodsListState extends State<GoodsList> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Provide<CategoryGoodsProvider>(
      builder: (context, child, category) {
        if (Provide.value<CategoryGoodsProvider>(context).page <= 2 &&
            controller.positions.isNotEmpty) {
          controller.jumpTo(0);
        }

        return category.list.length == 0
            ? Center(
                child: Text('暂无数据'),
              )
            : Container(
                width: ScreenUtil().setWidth(570),
                child: EasyRefresh(
                  footer: ClassicalFooter(
                      bgColor: Colors.white,
                      textColor: Colors.pink,
                      infoColor: Colors.pink,
                      noMoreText: '',
                      loadReadyText: '上拉加载....'),
                  onLoad: () async {
                    Provide.value<CategoryGoodsProvider>(context).loadMore();
                  },
                  child: ListView.separated(
                      controller: controller,
                      itemBuilder: (context, index) =>
                          _buildItem(category.list[index]),
                      separatorBuilder: (context, index) => Divider(
                            height: 1,
                          ),
                      itemCount: category.list.length),
                ),
              );
      },
    ));
  }

  Widget _buildItem(CategoryListData data) {
    return InkWell(
      onTap: () {
        Routers.router.navigateTo(context, '/detail?id=${data.goodsId}');
      },
      child: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            _image(data.image),
            Column(
              children: <Widget>[
                _goodsName(data.goodsName),
                _goodsPrice(data.presentPrice, data.oriPrice),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(String url) {
    return Center(
      child: Image.network(
        url,
        width: ScreenUtil().setWidth(200),
      ),
    );
  }

  Widget _goodsName(goodsName) {
    return Container(
      width: ScreenUtil().setWidth(370),
      child: Text(
        goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(presentPrice, oriPrice) {
    return Container(
        margin: EdgeInsets.only(top: 20.0),
        width: ScreenUtil().setWidth(370),
        child: Row(children: <Widget>[
          Text(
            '价格:￥${presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ]));
  }
}
