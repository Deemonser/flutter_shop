import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/category_bean.dart';
import 'package:flutter_shop/provide/category_provider.dart';
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
    return Row(
      children: <Widget>[LeftNav(dataList: data.data), RightContent()],
    );
  }
}

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
    print(widget.dataList.length);
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.black12, width: 1))),
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
          Provide.value<CategoryProvider>(context).changeTabIndex(index);
          _currentIndex = index;
        });
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.black12 : Colors.white),
        child: Center(child: Text(item.mallCategoryName)),
      ),
    );
  }
}

class RightContent extends StatefulWidget {
  @override
  _RightContentState createState() => _RightContentState();
}

class _RightContentState extends State<RightContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provide<CategoryProvider>(
        builder: (context, child, category) {
          return Text('${category.tab_index}');
        },
      ),
    );
  }
}
