import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/cart_info_bean.dart';
import 'package:flutter_shop/provide/cart_provider.dart';
import 'package:provide/provide.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCartInfo(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _buildContent();
        } else {
          return Text('正在加载');
        }
      },
    );
  }

  Widget _buildContent() {
    return Container(
      child: Provide<CartProvider>(
        builder: (context, child, val) {
          return Column(
            children: <Widget>[
              _buildGoodsList(val.cartList),
              CartBottom(),
            ],
          );
        },
      ),
    );
  }

  _buildGoodsList(List<CartInfoBean> cartList) {
    return Expanded(
        child: ListView.separated(
            itemBuilder: (context, index) => CartItem(cartList[index]),
            separatorBuilder: (context, index) => Divider(height: 1),
            itemCount: cartList.length));
  }

  _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvider>(context).initListBySp();
    return "";
  }
}

class CartItem extends StatelessWidget {
  CartInfoBean item;

  CartItem(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
      padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Row(
        children: <Widget>[
          _cartCheckBt(context, this.item),
          _cartImage(item),
          _cartGoodsName(item),
          _cartPrice(item)
        ],
      ),
    );
  }

  //多选按钮
  Widget _cartCheckBt(context, CartInfoBean item) {
    return Container(
      child: Checkbox(
        value: true,
        activeColor: Colors.pink,
        onChanged: (bool val) async {
          await CartProvider.getInstant(context)
              .changeCheck(val, goodsId: item.goodsId);
        },
      ),
    );
  }

  //商品图片
  Widget _cartImage(item) {
    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Image.network(item.images),
    );
  }

  //商品名称
  Widget _cartGoodsName(item) {
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(item.goodsName),
          CartCount(),
        ],
      ),
    );
  }

  //商品价格
  Widget _cartPrice(item) {
    return Container(
      width: ScreenUtil().setWidth(150),
      alignment: Alignment.centerRight,
      child: Column(
        children: <Widget>[
          Text('￥${item.price}'),
          Container(
            child: InkWell(
              onTap: () {},
              child: Icon(
                Icons.delete_forever,
                color: Colors.black26,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      color: Colors.white,
      width: ScreenUtil().setWidth(740),
      child: Row(
        children: <Widget>[selectAllBtn(context), allPriceArea(), goButton()],
      ),
    );
  }

  //全选按钮
  Widget selectAllBtn(context) {
    return Container(
      child: Row(
        children: <Widget>[
          Checkbox(
            value: CartProvider.getInstant(context).isAllCheck,
            activeColor: Colors.pink,
            onChanged: (bool val) async {
              await CartProvider.getInstant(context).changeCheck(val);
            },
          ),
          Text('全选')
        ],
      ),
    );
  }

  // 合计区域
  Widget allPriceArea() {
    return Expanded(
      child: Container(
        alignment: Alignment.centerRight,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  width: ScreenUtil().setWidth(280),
                  child: Text('合计:',
                      style: TextStyle(fontSize: ScreenUtil().setSp(36))),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('￥1922',
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(36),
                          color: Colors.red,
                        )),
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                '满10元免配送费，预购免配送费',
                style: TextStyle(
                    color: Colors.black38, fontSize: ScreenUtil().setSp(22)),
              ),
            )
          ],
        ),
      ),
    );
  }

  //结算按钮
  Widget goButton() {
    return Container(
      width: ScreenUtil().setWidth(160),
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(3.0)),
          child: Text(
            '结算(6)',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class CartCount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(165),
      margin: EdgeInsets.only(top: 5.0),
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Row(
        children: <Widget>[
          _reduceBtn(),
          _countArea(),
          _addBtn(),
        ],
      ),
    );
  }

  //添加按钮
  Widget _addBtn() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(left: BorderSide(width: 1, color: Colors.black12))),
        child: Text('+'),
      ),
    );
  }

  // 减少按钮
  Widget _reduceBtn() {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(width: 1, color: Colors.black12))),
        child: Text('-'),
      ),
    );
  }

  //中间数量显示区域
  Widget _countArea() {
    return Container(
      width: ScreenUtil().setWidth(70),
      height: ScreenUtil().setHeight(45),
      alignment: Alignment.center,
      color: Colors.white,
      child: Text('1'),
    );
  }
}
