import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/online-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-show-all-categories.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-upload-status.dart';

class StockInwardShowCartProducts extends StatefulWidget {
  @override
  _StockInwardShowCartProductsState createState() => _StockInwardShowCartProductsState();
}

class _StockInwardShowCartProductsState extends State<StockInwardShowCartProducts> {

  bool uploadingStockInward = false;
  int invoicedProductsUploaded = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploadingStockInward = false;
    stockInwardUploadSuccessful = false;
  }

  @override
  Widget build(BuildContext context) {
//    if(cartTotal > 0 )
    if (uploadingStockInward) {
      return Scaffold(
        appBar: AppBar(
//          leading: IconButton(
//            tooltip: 'Back to Store',
//            icon: const Icon(Icons.arrow_back),
//            //Don't block the main thread
//            onPressed: () {
//              Navigator.pop(context);
//              //    showSearchPage(context, _searchDelegate);
//            },
//          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push<dynamic>(context,
                  MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                    return StockInwardShowAllCategories();
                  }));
            },
          ),
          title: Center(
            child: Text(
              'STOCK INWARD',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),
            ),
          ),
//          actions: <Widget>[
//            //Adding the search widget in AppBar
//            IconButton(
//              tooltip: 'home',
//              icon: const Icon(Icons.home),
//              //Don't block the main thread
//              onPressed: () {
//                Navigator.push<dynamic>(context,
//                    MaterialPageRoute<dynamic>(builder: (BuildContext context) {
//                  return HomePageListViewSearch();
//                }));
//                //  showSearchPage(context, _searchDelegate);
//              },
//            ),
//          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: LinearProgressIndicator()
              ),
              Center(
                  child: Text(
                      'PLEASE BE PATIENT',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0
                      )
                  )
              ),

            ]
        ),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
//          leading: IconButton(
//            tooltip: 'Back to Store',
//            icon: const Icon(Icons.arrow_back),
//            //Don't block the main thread
//            onPressed: () {
//              Navigator.pop(context);
//              //    showSearchPage(context, _searchDelegate);
//            },
//          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push<dynamic>(context,
                  MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                    return StockInwardShowAllCategories();
                  }));
            },
          ),
          title: Center(
            child: Text(
              'STOCK INWARD',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0),
            ),
          ),
//          actions: <Widget>[
//            //Adding the search widget in AppBar
//            IconButton(
//              tooltip: 'home',
//              icon: const Icon(Icons.home),
//              //Don't block the main thread
//              onPressed: () {
//                Navigator.push<dynamic>(context,
//                    MaterialPageRoute<dynamic>(builder: (BuildContext context) {
//                  return HomePageListViewSearch();
//                }));
//                //  showSearchPage(context, _searchDelegate);
//              },
//            ),
//          ],
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: GridView.builder(
                    itemCount: cartProducts.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery
                          .of(context)
                          .size
                          .width /
                          (MediaQuery
                              .of(context)
                              .size
                              .height),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      int qtyInCart = cartProducts[index].qtyInCart;
                      return Container(
                        child: Card(
                          child: InkWell(
                            onTap: () {},
                            child: Material(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: new Text(
                                      cartProducts[index].productName,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: new Text(
                                      "\u20B9" +
                                          cartProducts[index]
                                              .productPrice
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: new Stack(
                                      children: <Widget>[
                                        new Container(
                                          //margin: new EdgeInsets.only(left: 46.0),
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: new Color(0xFFFFFFFF),
                                            borderRadius:
                                            new BorderRadius.circular(8.0),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  cartProducts[index]
                                                      .productImageURL),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: new Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: new RaisedButton(
                                              child: new IconButton(
                                                  icon: Icon(Icons.remove),
                                                  onPressed: () {
                                                    CartProduct cartProduct =
                                                    cartProducts[index];
                                                    cartProduct.qtyInCart =
                                                        cartProduct.qtyInCart -
                                                            1;
                                                    itemCount = itemCount - 1;
                                                    cartTotal = cartTotal -
                                                        cartProduct
                                                            .productPrice;
                                                    if (cartProduct.qtyInCart ==
                                                        0) {
                                                      productCount =
                                                          productCount - 1;
                                                      cartProductMap.remove(
                                                          cartProduct.productID
                                                              .toString());
                                                    } else {
                                                      cartProductMap[cartProduct
                                                          .productID
                                                          .toString()] =
                                                          cartProduct;
                                                    }
                                                    setState(() {
                                                      qtyInCart =
                                                          cartProduct
                                                              .qtyInCart - 1;
                                                    });
                                                    cartProducts.clear();
                                                    for (int i = 0;
                                                    i < cartProductMap.length;
                                                    i++) {
                                                      cartProducts.add(
                                                          cartProductMap.values
                                                              .elementAt(i));
                                                    }
                                                  }),
                                              textColor: Colors.white,
                                              color: Colors.blue,
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,

                                            child: Center(
                                                child: new Text(
                                                  qtyInCart.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: "Montserrat",
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 20.0),
                                                )
                                            )),
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: new RaisedButton(
                                              child: new IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () {
                                                    print(
                                                        'add button pressed!!');
                                                    CartProduct cartProduct =
                                                    cartProducts[index];
                                                    cartProduct.qtyInCart =
                                                        cartProduct.qtyInCart +
                                                            1;
                                                    itemCount = itemCount + 1;
                                                    cartTotal = cartTotal +
                                                        cartProduct
                                                            .productPrice;
                                                    cartProductMap[
                                                    cartProducts[index]
                                                        .productID] =
                                                        cartProduct;
                                                    setState(() {
                                                      qtyInCart =
                                                          cartProduct
                                                              .qtyInCart + 1;
                                                    });
                                                    cartProducts.clear();
                                                    for (int i = 0;
                                                    i < cartProductMap.length;
                                                    i++) {
                                                      cartProducts.add(
                                                          cartProductMap.values
                                                              .elementAt(i));
                                                    }
                                                  }),
                                              textColor: Colors.white,
                                              color: Colors.blue,
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: new Text(
                                      "\u20B9" +
                                          (cartProducts[index].productPrice *
                                              qtyInCart)
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: new RaisedButton(
                    child: new Text('PROCEED TO UPDATE',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )),
                    onPressed: () {
                      uploadStockInward(cartProducts);

                      setState(() {
                        invoicedProductsUploaded = 0;
                        uploadingStockInward = true;
                      });
                      cartProducts.forEach((element) {
                        print(element);
                        uploadStockInwardForProduct(element);
                      });

                    },
                    color: Colors.blue,
                  ),
                ),
              ),
            ]
        ),
      );
    }
  }

  void uploadStockInward(List<CartProduct> cartProducts) {
    var l_stockInwardInvoiceId = DateFormat('yyyyMMddHHmmss').format(
        DateTime.now()).toString();
    var l_stockInwardTime = DateFormat('HH:mm:ss').format(
        DateTime.now()).toString();
    var l_stockInwardDate = DateFormat('yyyy-MM-dd').format(
        DateTime.now()).toString();
    List<dynamic> l_invoicedProducts = List<dynamic>();
    cartProducts.forEach((element) {
      print(element);
      l_invoicedProducts.add(<String, dynamic>{
        'sku': element.productID,
        'barcode': element.productBarCode,
        'price': element.productPrice,
        'name': element.productName,
        'imageurl': element.productImageURL,
        'qty': element.qtyInCart
      });
    });
    print(l_invoicedProducts);
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('stockInwards')
        .child(l_stockInwardInvoiceId)
        .set({
      'invoiceId':l_stockInwardInvoiceId,
      'date':l_stockInwardDate,
      'time':l_stockInwardTime,
      'supplier':'KIRANAWALA',
      'productCount':productCount,
      'itemCount':itemCount,
      'invoiceAmount':cartTotal,
      'invoicedProducts':l_invoicedProducts
    }).then((value) {
          print('Invoice loaded successfully.');
    });
  }

  void uploadStockInwardForProduct(CartProduct cartProduct){
    var l_stockInwardTime = DateFormat('HH:mm:ss').format(
    DateTime.now()).toString();
    var l_stockInwardDate = DateFormat('yyyy-MM-dd').format(
    DateTime.now()).toString();
    var l_stockInwardInvoiceId = DateFormat('yyyyMMddHHmmss').format(
        DateTime.now()).toString();
    var l_stockInwardQty = double.parse(cartProduct.qtyInCart
        .toString());
    var l_stockInwardTillDate = 0.0;

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(cartProduct.productID.toString())
        .child('stockInwards')
        .child('stockInwardTillDate')
        .once()
        .then((stockInwardTillDateSnapshot) {
    if (stockInwardTillDateSnapshot != null &&
    stockInwardTillDateSnapshot.value !=
    null) {
    print(stockInwardTillDateSnapshot.value);
    l_stockInwardTillDate =
    double.parse(stockInwardTillDateSnapshot.value
        .toString());
    print(l_stockInwardTillDate);
    }
    l_stockInwardTillDate = l_stockInwardTillDate +
    l_stockInwardQty;

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(cartProduct.productID.toString())
        .child('stockInwards')
        .child('invoices')
        .child(
    l_stockInwardInvoiceId)
        .update(<String, dynamic>
    {
    'qty': l_stockInwardQty,
    'mode': 'Manual',
    'invoiceId': l_stockInwardInvoiceId,
    'date': l_stockInwardDate,
    'time': l_stockInwardTime,
    'timeStamp': DateTime.now().toString()
    }).then((value) {
    print(
    'Stock Inward Updated Successfully.');
    });

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(cartProduct.productID.toString())
        .child('stockInwards')
        .child(DateFormat('yyyy').format(
    DateTime.now()).toString())
        .child(DateFormat('MM')
        .format(DateTime.now())
        .toString())
        .child(DateFormat('dd')
        .format(DateTime.now())
        .toString())
        .set(<String, dynamic>
    {
    'invoiceId': l_stockInwardInvoiceId,
    'qty': l_stockInwardQty,
    }).then((value) {
    print(
    'Stock Inward Updated Successfully.');
    });
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(cartProduct.productID.toString())
        .child('stockInwards')
        .update(<String, dynamic>
    {
    'recentStockInwardTime': l_stockInwardTime,
    'recentStockInwardDate': l_stockInwardDate,
    'recentStockInwardInvoiceId': l_stockInwardInvoiceId,
    'recentStockInwardQty': l_stockInwardQty,
    'stockInwardTillDate': l_stockInwardTillDate
    }).then((value) {
    print(
    'Stock Inward Updated Successfully.');
    invoicedProductsUploaded = invoicedProductsUploaded + 1;
    if(invoicedProductsUploaded == productCount)
      {
        print('invoicedProductsUploaded:' + invoicedProductsUploaded.toString());
        print('productCount:' + productCount.toString());
        print('Stock Inward for all products uploaded successfully');
        setState(() {
          uploadingStockInward = false;
          stockInwardUploadSuccessful = true;
          cartProducts.clear();
          cartTotal = 0.0;
          productCount = 0.0;
          itemCount = 0.0;
        });
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return StockInwardUploadStatus();
            }
          )
        );
      }

    }).catchError((dynamic error) {
    productUpdateStatus = 'FAILURE';
    print('STOCK INWARD UPDATE FAILED:' +
    cartProduct.productID.toString());
    stockInwardUploadSuccessful = false;
    });
    });
  }
}




//class ShowMinimumOrderValueMessage extends StatefulWidget {
//  @override
//  _ShowMinimumOrderValueMessageState createState() => _ShowMinimumOrderValueMessageState();
//}
//
//class _ShowMinimumOrderValueMessageState extends State<ShowMinimumOrderValueMessage> {
//  int qtyInCart;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Wrap(
//        children: <Widget>[
//          Container(
//            decoration: BoxDecoration(
//                border: Border.all(color: Colors.grey, width: 2.0),
//                borderRadius: BorderRadius.all(Radius.circular(5.0))),
//            height: MediaQuery.of(context).size.height/2,
//            child: Column(children: <Widget>[
//              Expanded(
//                flex:2,
//                child: Text(
//                  'MINIMUM ORDER VALUE : \u20B9' + selectedStoreDetails.storeMinimumOrderValue.toString(),
//                  maxLines: 2,
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 16.0,
//                      fontWeight: FontWeight.bold,
//                      fontFamily: "Montserrat"),
//                ),
//              ),
//              Expanded(
//                flex:2,
//                child:
//                Container(
//                  decoration: BoxDecoration(
//                      border: Border.all(color: Colors.white, width: 2.0),
//                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                  child: RaisedButton(
//                    color:Colors.blue,
//                    child:Center(
//                      child:Text('DONE',
//                          style:TextStyle(
//                            fontSize:20.0,
//                            fontFamily:'Montserrat',
//                            fontWeight: FontWeight.bold,
//                          )),
//                    ),
//                    onPressed: () => {
//                      Navigator.of(context).pop()
//                    },
//                  ),
//                ),
//              )
//
//            ]),
//          ),
//        ],
//      ),
//    );
//  }
//}
