import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-category-brand.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-request-price.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-status.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-lookup-image.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-request-name.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-update-discount.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-show-selected-category-products.dart';

class StockInwardCartOptions extends StatefulWidget {
  StockInwardCartOptions({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _StockInwardCartOptionsState createState() => _StockInwardCartOptionsState();
}

class _StockInwardCartOptionsState extends State<StockInwardCartOptions> {
  int qtyInCart;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(skuToUpdate);
    print(barCodeSearchResultsMap);
    print(barCodeSearchResultsMap[skuToUpdate].productName);
    print(barCodeSearchResultsMap[skuToUpdate].productPrice);

    qtyInCart = (cartProductMap.containsKey(
        skuToUpdate.toString()))
        ? cartProductMap[skuToUpdate.toString()].qtyInCart
        : 0;
    print(qtyInCart);
  }
  @override
  Widget build(BuildContext context) {
    int qtyInCart = (cartProductMap.containsKey(
        skuToUpdate.toString()))
        ? cartProductMap[skuToUpdate.toString()].qtyInCart
        : 0;
    print(qtyInCart);
    return
      Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        height: MediaQuery.of(context).size.height,
        child: Column(children: <Widget>[
          Expanded(
            flex:4,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Stack(
                  children:<Widget>[
                    Positioned(
                      child:
                      Center(
                        child: Text(
                          barCodeSearchResultsMap[skuToUpdate].productName.toUpperCase(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat"),
                        ),
                      ),
                    ),
                    Positioned(
                      right:0.0,
                      child:
                      Container(
                        child: IconButton(
                          icon:Icon(Icons.check_circle,color:Colors.green, size: 40.0,),
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    )

                  ]
              ),
            ),
          ),
          Expanded(
            flex:2,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex:2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:2,
                        child: Text(
                          "\u20B9" +
                              barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat"),
                        ),
                      ),
                      Expanded(flex:1,
                          child:Icon(Icons.shopping_cart, color:Colors.black38)
                      ),
                      Expanded(
                        flex:2,
                        child:Text(
                          qtyInCart.toString(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat"),
                        ),
                      ),
                      Expanded(flex:2,
                        child: Text(
                          "\u20B9" + (barCodeSearchResultsMap[skuToUpdate].productPrice * qtyInCart).toString(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex:10,
              child:
              Row(
                children: <Widget>[
                  Expanded(
                    flex:8,
                    child: Center(
                        child: Image.network(barCodeSearchResultsMap[skuToUpdate].productImageURL,
                        )
                    ),
                  ),
                  Expanded(
                    flex:2,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      child: Column(children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12, width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: RaisedButton(
                              color: Colors.white,
                              child: Center(child: Icon(Icons.shopping_cart, color: Colors.green,size:40.0)),
                              onPressed: () {
                                if(cartTotal > 0)
                                {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push<dynamic>(
                                      MaterialPageRoute<dynamic>(
                                          builder:(BuildContext context) {
                                            return null;
                                          }
                                      )
                                  );
                                }

                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12, width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: RaisedButton(
                              color: Colors.white,
                              child: Icon(Icons.exposure_plus_1, color: Colors.green,size:40.0),
                              onPressed: () {
                                CartProduct cartProduct;
                                if (cartProductMap.containsKey(
                                    skuToUpdate.toString())) {
                                  cartProduct =
                                  cartProductMap[skuToUpdate.toString()];
                                  cartProduct.qtyInCart = cartProduct.qtyInCart + 1;
                                  itemCount = itemCount + 1;
                                  cartTotal = cartTotal + cartProduct.productPrice;
                                  cartProductMap[skuToUpdate.toString()] =
                                      cartProduct;
                                  setState(() {
                                    qtyInCart = cartProduct.qtyInCart;
                                  });
                                } else {
                                  setState(() {
                                    qtyInCart = 1;
                                  });
                                  productCount = productCount + 1;
                                  itemCount = itemCount + 1;
                                  cartProduct = CartProduct(
                                      barCodeSearchResultsMap[skuToUpdate].productName.toString(),
                                      barCodeSearchResultsMap[skuToUpdate].productID.toString(),
                                      barCodeSearchResultsMap[skuToUpdate].productBarCode.toString(),
                                      barCodeSearchResultsMap[skuToUpdate].productPrice,
                                      barCodeSearchResultsMap[skuToUpdate].productImageURL,
                                      1);
                                  cartTotal = cartTotal + cartProduct.productPrice;
                                  cartProductMap[skuToUpdate
                                      .toString()] = cartProduct;
                                }
                                cartProducts.clear();
                                for (int i = 0; i < cartProductMap.length; i++) {
                                  cartProducts.add(cartProductMap.values.elementAt(i));
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12, width: 2.0),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                child: RaisedButton(
                                  color: Colors.white,
                                  child: Icon(Icons.delete, color: Colors.deepOrange,size:40.0),
                                  onPressed: (){
                                    CartProduct cartProduct;
                                    if (cartProductMap.containsKey(
                                       skuToUpdate.toString())) {
                                      cartProduct =
                                      cartProductMap[skuToUpdate.toString()];
                                      itemCount = itemCount - cartProduct.qtyInCart;
                                      cartTotal = cartTotal - cartProduct.productPrice * cartProduct.qtyInCart;
                                      cartProduct.qtyInCart = 0;
                                      productCount = productCount - 1;
                                      cartProductMap.remove(
                                          skuToUpdate.toString());
                                      setState(() {
                                        qtyInCart = cartProduct.qtyInCart;
                                      });
                                    }

                                    cartProducts.clear();
                                    for (int i = 0; i < cartProductMap.length; i++) {
                                      cartProducts.add(cartProductMap.values.elementAt(i));
                                    }

                                  },
                                )
                            )
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12, width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: RaisedButton(
                              color: Colors.white,
                              child: Center(child: Icon(Icons.exposure_neg_1, color: Colors.green,size:40.0)),
                              onPressed: () {
                                CartProduct cartProduct;
                                if (cartProductMap.containsKey(
                                    skuToUpdate.toString())) {
                                  cartProduct =
                                  cartProductMap[skuToUpdate.toString()];
                                  cartProduct.qtyInCart = cartProduct.qtyInCart - 1;
                                  itemCount = itemCount - 1;
                                  cartTotal = cartTotal - cartProduct.productPrice;
                                  if (cartProduct.qtyInCart == 0) {
                                    productCount = productCount - 1;
                                    cartProductMap.remove(
                                        skuToUpdate.toString());
                                  } else {
                                    cartProductMap[skuToUpdate.toString()] =
                                        cartProduct;
                                  }
                                  setState(() {
                                    qtyInCart = cartProduct.qtyInCart;
                                  });
                                }
                                cartProducts.clear();
                                for (int i = 0; i < cartProductMap.length; i++) {
                                  cartProducts.add(cartProductMap.values.elementAt(i));
                                }
                              },
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              )
          ),
        ]),
      );
  }
}