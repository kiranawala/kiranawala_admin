import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

//class ProductBasicDetails {
//  String productName;
//  int productID;
//  String productBarCode;
//  num productPrice;
//  String productImageURL;
//  String productCategory;
//  String productBrand;
//
//  ProductBasicDetails(
//      String productName,
//      num productPrice,
//      int productID,
//      String productBarCode,
//      String productImageURL,
//      String productCategory,
//      String productBrand,
//      ) {
//    this.productName = productName;
//    this.productPrice = productPrice;
//    this.productID = productID;
//    this.productBarCode = productBarCode;
//    this.productImageURL = productImageURL;
//    this.productCategory = productCategory;
//    this.productBrand = productBrand;
//  }
//}

class ProductRecentStockInwardDetails {
  int productID;
  String recentStockInwardDate;
  String recentStockInwardTime;
  double recentStockInwardQty;
  double stockInwardQtyTillDate;

  ProductRecentStockInwardDetails(
      int productID,
      String recentStockInwardDate,
      String recentStockInwardTime,
      double recentStockInwardQty,
      double stockInwardQtyTillDate)
  {
    this.productID = productID;
    this.recentStockInwardDate = recentStockInwardDate;
    this.recentStockInwardTime = recentStockInwardTime;
    this.recentStockInwardQty = recentStockInwardQty;
    this.stockInwardQtyTillDate = stockInwardQtyTillDate;
  }
}

class ProductRecentStockOutwardDetails {
  int productID;
  String recentStockOutwardDate;
  String recentStockOutwardTime;
  double recentStockOutwardQty;
  double stockOutwardQtyTillDate;

  ProductRecentStockOutwardDetails(
      int productID,
      String recentStockOutwardDate,
      String recentStockOutwardTime,
      double recentStockOutwardQty,
      double stockOutwardQtyTillDate)
  {
    this.productID = productID;
    this.recentStockOutwardDate = recentStockOutwardDate;
    this.recentStockOutwardTime = recentStockOutwardTime;
    this.recentStockOutwardQty = recentStockOutwardQty;
    this.stockOutwardQtyTillDate = stockOutwardQtyTillDate;
  }
}

class ProductStockInwardDetails {
  int productID;
  String recentStockInwardDate;
  String recentStockInwardTime;
  double recentStockInwardQty;

  ProductStockInwardDetails(
      int productID,
      String recentStockInwardDate,
      String recentStockInwardTime,
      double recentStockInwardQty)
  {
    this.productID = productID;
    this.recentStockInwardDate = recentStockInwardDate;
    this.recentStockInwardTime = recentStockInwardTime;
    this.recentStockInwardQty = recentStockInwardQty;
  }
}

class ProductStockOutwardDetails {
  int productID;
  String recentStockOutwardDate;
  String recentStockOutwardTime;
  double recentStockOutwardQty;

  ProductStockOutwardDetails(
      int productID,
      String recentStockOutwardDate,
      String recentStockOutwardTime,
      double recentStockOutwardQty)
  {
    this.productID = productID;
    this.recentStockOutwardDate = recentStockOutwardDate;
    this.recentStockOutwardTime = recentStockOutwardTime;
    this.recentStockOutwardQty = recentStockOutwardQty;
  }
}


ProductBasicDetails stockInProductToUpdate;
ProductStockInwardDetails stockInwardDetailsProductToUpdate;

Map<int, ProductStockInwardDetails> stockInwardDetailsMap = new Map();
List<ProductStockInwardDetails> stockInwardDetailsList = new List();
List<ProductBasicDetails> barCodeSearchResults = new List();
String barCodeToSearch = '';

//Map<int, ProductBasicDetails> barCodeSearchResultsMap = new Map();
Map<int, ProductBasicDetails> productMap = new Map();
Map<int, double> productStockInwardTotalQtyMap = Map<int, double>();
Map<int, double> productStockOutwardTotalQtyMap = Map<int, double>();
Map<String, double> productStockOutwardTotalQtyAtPOSMap = Map<String, double>();

Map<int, double> productStockPositionQtyMap = Map<int, double>();


Map<int, dynamic> productStockInwardMap = Map<int, dynamic>();
List<dynamic> productStockInwardInvoices = List<dynamic>();
Map<int, double> recentProductStockOutwardQtyMap = Map<int, double>();

Map<String, dynamic> productStockOutwardHistoryMap = Map<String, dynamic>();
List<dynamic> productStockOutwardHistory = List<dynamic>();

String storeTerminals = 'POS_7,POS_8';
int productCount = 0;
List<int> productCodes = List();
int productStockOutwardsProcessed = 0;
int productsRetrieved = 0;

class StoreStockPosition extends StatefulWidget {
  @override
  _StoreStockPositionState createState() => _StoreStockPositionState();
}

class _StoreStockPositionState extends State<StoreStockPosition> {
  bool retrievingProductDetails = false;
  bool retrievingProductStockInwardDetails = false;
  int stockInwardDetailsRetrieved = 0;

  bool retrievingProductStockOutwardDetails = false;


  Map<int, double> recentProductStockOutwardDailyAverageMap = Map<int, double>();

  Map<String, double> recentProductStockOutwardQtyAtPOSMap = Map<String, double>();
  Map<String, double> recentProductStockOutwardDailyAverageAtPOSMap = Map<String, double>();


  Map<int, ProductRecentStockInwardDetails> recentProductStockInwardDetailsMap = Map<int, ProductRecentStockInwardDetails>();
  int stockPosition = 0;
  double productStockPosition = 0;
  int productId = 0;
  bool retrievingProductsNode = false;
  String storeInventoryNode = 'KIRANAWALA_STORE_7';
  String storeProductNode = 'KIRANAWALA_STORE_7';

  void getProductRecentStockInwardDetails(int productCode){
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(storeInventoryNode)
        .child('products')
        .child(productCode.toString())
        .child('stockInwardTillDate')
        .once()
        .then((snapshot){
      if(snapshot != null && snapshot.value != null) {
//        print(productCode.toString());
        productStockInwardTotalQtyMap[int.parse(productCode.toString())] =
        (snapshot.value != null)
            ? double.parse(
            snapshot.value.toString())
            : 0;
        print('getProductRecentStockInwardDetails:' + productCode.toString() + ':' + productStockInwardTotalQtyMap[int.parse(productCode.toString())].toString());
      }
      stockInwardDetailsRetrieved = stockInwardDetailsRetrieved + 1;

      if(stockInwardDetailsRetrieved == productCodes.length){
        print('getProductRecentStockInwardDetails:FINISHED');
        print('Stock Inward Retrieved:' + stockInwardDetailsRetrieved.toString());
        print('productStockInwardTotalQtyMap:' + productStockInwardTotalQtyMap.length.toString());
        setState(() {
          retrievingProductStockInwardDetails = false;
        });
      }
    });
  }

  void getProductRecentStockOutwardDetails(int productCode){
//    print('Retrieving Stock Outward Details:' + productCode.toString());
    List<String> terminalsAtStore = storeTerminals.split(',');
    int stockOutwardTerminalsProcessed = 0;
    terminalsAtStore.forEach((String posTerminal) {
      FirebaseDatabase.instance
          .reference()
          .child('stores')
          .child(storeInventoryNode)
          .child('products')
          .child(productCode.toString())
          .child('stockOutwardTillDate')
          .child(posTerminal)
          .once()
          .then((snapshot){
        if(snapshot != null && snapshot.value != null) {
          productStockOutwardTotalQtyAtPOSMap[posTerminal] =
          (snapshot.value != null)
              ? double.parse(
              snapshot.value.toString())
              : 0;
        }
        else
        {
          productStockOutwardTotalQtyAtPOSMap[posTerminal] = 0;
          recentProductStockOutwardDailyAverageAtPOSMap[posTerminal] = 0;
        }
        stockOutwardTerminalsProcessed = stockOutwardTerminalsProcessed + 1;
        if(stockOutwardTerminalsProcessed == terminalsAtStore.length) {
          double totalStockOutwardQty = 0;
          productStockOutwardTotalQtyAtPOSMap.forEach((String key,
              double value) {
            totalStockOutwardQty = totalStockOutwardQty + value;
          });

          productStockOutwardTotalQtyMap[productCode] = totalStockOutwardQty;
          productStockOutwardsProcessed = productStockOutwardsProcessed + 1;
          if(productStockOutwardsProcessed == productCodes.length)
            {
              print('getProductRecentStockOutwardDetails:FINISHED');
              print('Stock Outward Retrieved:' + productStockOutwardsProcessed.toString());
              print('productStockOutwardTotalQtyMap:' + productStockOutwardTotalQtyMap.length.toString());
              setState(() {
                retrievingProductStockOutwardDetails = false;
              });
            }
          }
      });
    });
  }

  void getProductBasicDetails(String productCode)
  {
//    print('retrieving product basic details for :' + productCode);
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(storeInventoryNode)
        .child('products')
        .child(productCode)
        .child('basicDetails')
        .once()
        .then((productsSnapshot) {
      if(productsSnapshot != null && productsSnapshot.value != null) {
//          print(productCode);
          productMap[int.parse(productCode.toString())] = ProductBasicDetails(
              productsSnapshot.value['productName'],
              double.parse(productsSnapshot.value['productPrice'].toString()),
              int.parse(productCode.toString()),
              productsSnapshot.value['productBarCode'].toString(),
              (productsSnapshot.value['productImageURL'] != null)
                  ? productsSnapshot.value['productImageURL']
                  : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
              productsSnapshot.value['productCategory'],
              productsSnapshot.value['productBrand'],
              (productsSnapshot.value['productStatus'] != null)
                  ? productsSnapshot.value['productStatus']
                  : 'INACTIVE',
              (productsSnapshot.value['productParent'] != null)
                  ? productsSnapshot.value['productParent']
                  : 'N/A',
              (productsSnapshot.value['productCreationTimeStamp'] != null)
                  ? productsSnapshot.value['productCreationTimeStamp']
                  : 'N/A'
          );
      }
      productsRetrieved = productsRetrieved + 1;
      if (productsRetrieved == productCodes.length) {
        print('getProductDetails:FINISHED');
        print(
            'Product Details Retrieved:' + productsRetrieved.toString());
        print('productMap:' + productMap.length.toString());

        setState(() {
          retrievingProductDetails = false;
        });
      }

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stockInwardDetailsRetrieved = 0;
    productStockOutwardsProcessed = 0;
    productStockInwardTotalQtyMap = {};
    productMap = Map();
    productsRetrieved = 0;

    retrievingProductDetails = true;
    retrievingProductStockInwardDetails = true;
    retrievingProductStockOutwardDetails = true;

    print(storeInventoryNode);

    FirebaseDatabase
      .instance
      .reference()
      .child('stores')
      .child(storeInventoryNode)
      .child('products')
      .once()
      .then((productSnapshot){
        if(productSnapshot != null && productSnapshot.value != null ) {
          productSnapshot.value.forEach((dynamic productSnapshotKey,
              dynamic productSnapshotValue) {
            if (productSnapshotValue['basicDetails'] != null && productSnapshotValue['stockInwards'] != null && productSnapshotValue['stockInwards']['invoices'] != null) {
              productCodes.add(int.parse(productSnapshotKey.toString()));
            }
          });
        }

        print('Product Count to be processed:' + productCodes.length.toString());
        productCodes.forEach((int productCode) {
              getProductBasicDetails(productCode.toString());
              getProductRecentStockInwardDetails(productCode);
              getProductRecentStockOutwardDetails(productCode);
        });
    });
  }
  @override
  Widget build(BuildContext context) {
    {

      if(retrievingProductDetails || retrievingProductStockInwardDetails || retrievingProductStockOutwardDetails){
        return
          WillPopScope(
              onWillPop:(){
                setState(() {
                  retrievingProductDetails = false;
                  retrievingProductStockInwardDetails = false;
                  retrievingProductStockOutwardDetails = false;
//                  Navigator.of(context).pop();
//                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                      builder:(BuildContext context){
//                        return CheckIfAdmin();
//                      }));
                });

                return;
              },
              child:Scaffold(
                  appBar: AppBar(
                    centerTitle:  true,
                    automaticallyImplyLeading: false,
                    title:Text('PRODUCT MANAGER'),
                    leading: IconButton(icon:Icon(Icons.keyboard_backspace),
                        onPressed: (){
//                          Navigator.of(context).pop();
//                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                            return CheckIfAdmin();
//                          }));
                        }),
                  ),
                  body:
                  Container(
                    color: Colors.white,
                    child: Dialog(
                      child: new Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(flex: 2, child: new CircularProgressIndicator()),
                          SizedBox(width: 10.0),
                          Expanded(
                              flex: 12,
                              child: Text("LOADING STOCK POSITION")),
                        ],
                      ),
                    ),
                  )
              ));
      }
      else
      {
      print('Stock Inwards:' + productStockInwardTotalQtyMap.length.toString());
      print('Stock Outwards:' + productStockOutwardTotalQtyMap.length.toString());
      print('Product Details:' + productMap.length.toString());

      double stockMRPValue = 0;
      double stockQty = 0;

      productCodes = [];
      productStockInwardTotalQtyMap.forEach((key, value) {
        productCodes.add(key);
      });

      productCodes.forEach((element) {
        if(productMap.containsKey(element) && productStockInwardTotalQtyMap.containsKey(element) )
          {
            if(productStockOutwardTotalQtyMap.containsKey(element)) {
              stockQty = stockQty + (productStockInwardTotalQtyMap[element] -
                  productStockOutwardTotalQtyMap[element]);

              stockMRPValue = stockMRPValue +
                  ((productStockInwardTotalQtyMap[element] - productStockOutwardTotalQtyMap[element])
                      * double.parse(productMap[element].productPrice.toString()));
            }
            else {
              stockQty = stockQty + productStockInwardTotalQtyMap[element];
              stockMRPValue = stockMRPValue +
                  ((productStockInwardTotalQtyMap[element])
                      * double.parse(productMap[element].productPrice.toString()));
            }
          }
      });

//      productMap.forEach((int element, ProductBasicDetails value) {
//          stockQty = stockQty + (productStockInwardTotalQtyMap[element] - productStockOutwardTotalQtyMap[element]);
//          stockMRPValue = stockMRPValue +
//              ((productStockInwardTotalQtyMap[element] - productStockOutwardTotalQtyMap[element])
//                  * double.parse(productMap[element].productPrice.toString()));
//      });
      print('Total Stock Value:' + stockMRPValue.toString());

        return WillPopScope(
            onWillPop:(){
              setState(() {
                retrievingProductDetails = false;
                retrievingProductStockInwardDetails = false;
                retrievingProductStockOutwardDetails = false;
//                Navigator.of(context).pop();
//                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                    builder:(BuildContext context){
//                      return CheckIfAdmin();
//                    }));
              });
              return;
            },
            child:Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'PRODUCT MANAGER',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        fontFamily: 'Montserrat'),
                  ),
                  leading: IconButton(icon:Icon(Icons.keyboard_backspace),
                      onPressed: (){
//                        Navigator.of(context).pop();
//                        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                          return CheckIfAdmin();
//                        }));
                      }),

                ),
                body:Column(
                  children: <Widget>[
                    Expanded(
                      flex:3,
                      child:Container(
                        child:Column(
                          children: <Widget>[
                            Row(
                                children:<Widget>[

                                  Expanded(
                                    flex:6,
                                    child: Text('No. Of. SKUs:',
                                        style:TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Expanded(
                                    flex:4,
                                    child: Text(productMap.length.toStringAsFixed(0),
                                        style:TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                        )),
                                  )
                                ]
                            ),
                            Row(
                                children:<Widget>[
                                  Expanded(
                                    flex:6,
                                    child: Text('No. Of. Units:',
                                        style:TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Expanded(
                                    flex:4,
                                    child: Text(stockQty.toStringAsFixed(0),
                                        style:TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                        )),
                                  )
                                ]
                            ),
                            Row(
                                children:<Widget>[
                                  Expanded(
                                    flex:6,
                                    child: Text('Total MRP Value:',
                                        style:TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  Expanded(
                                    flex:4,
                                    child: Text(stockMRPValue.toStringAsFixed(0),
                                        style:TextStyle(
                                          fontSize: 20.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                        )),
                                  )
                                ]
                            )
                          ],
                        )

                        )
                      ),
                    Expanded(
                      flex:16,
                      child:
                      ListView.builder(
                        itemCount:productStockInwardTotalQtyMap.length,
                        itemBuilder: (BuildContext context, int index){
                          String l_productName = (productMap[productCodes[index]] != null)?
                          productMap[productCodes[index]].productName.toString().toUpperCase():'';

                          String l_productPrice = (productMap[productCodes[index]] != null)?
                          productMap[productCodes[index]].productPrice.toStringAsFixed(0):'0';

                          double l_productStockPosition = 0.0;

                          if(productStockInwardTotalQtyMap[productCodes[index]] != null)
                            {
                              if(productStockOutwardTotalQtyMap[productCodes[index]] != null)
                              {
                                l_productStockPosition = productStockInwardTotalQtyMap[productCodes[index]] - productStockOutwardTotalQtyMap[productCodes[index]];
                              }
                              else
                              {
                                l_productStockPosition = productStockInwardTotalQtyMap[productCodes[index]];
                              }
                            }



//                          ().toStringAsFixed(0),


                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              color:Colors.black12,
                              child:Row(
                                  children:<Widget>[
                                    Expanded(flex:8,
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                                l_productName,
                                                style:TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              textAlign: TextAlign.left,
                                            ),
                                            Text(
                                                productCodes[index].toString(),
                                                style:TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ],
                                        )),
                                    Expanded(flex:2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              l_productPrice.toString(),
                                              style:TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                              ),
                                          textAlign: TextAlign.right,),
                                        )),
//                                  Expanded(flex:2,child:Text(productStockInwardTotalQtyMap[productCodes[index]].toString())),
//                                  Expanded(flex:2,child:Text(productStockOutwardTotalQtyMap[productCodes[index]].toString())),
                                    Expanded(
                                        flex:2,
                                        child:Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              l_productStockPosition.toString(),
                                              style:TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ))

                                  ]
                              )
                        ),
                          );
                      },
                          ),
                    ),
                  ],

                ),
            ));
      }

    }
  }
}
