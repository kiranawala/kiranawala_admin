import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

class ProductBasicDetails {
  String productName;
  int productID;
  String productBarCode;
  num productPrice;
  String productImageURL;
  String productCategory;
  String productBrand;

  ProductBasicDetails(
      String productName,
      num productPrice,
      int productID,
      String productBarCode,
      String productImageURL,
      String productCategory,
      String productBrand,
      ) {
    this.productName = productName;
    this.productPrice = productPrice;
    this.productID = productID;
    this.productBarCode = productBarCode;
    this.productImageURL = productImageURL;
    this.productCategory = productCategory;
    this.productBrand = productBrand;
  }
}

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

Map<int, ProductBasicDetails> barCodeSearchResultsMap = new Map();
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

String storeTerminals = 'POS_7';
String inventoryNode = 'KIRANAWALA_STORE7';
String productNode = 'KIRANAWALA_STORE_7';
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
  String storeInventoryNode = 'KIRANAWALA_STORE_2';
  String storeProductNode = 'KIRANAWALA_STORE_2';

  void getProductRecentStockInwardDetails(int productCode){
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(storeInventoryNode)
        .child('products')
        .child(productCode.toString())
        .child('stockInwards')
        .once()
        .then((snapshot){
      if(snapshot != null && snapshot.value != null && snapshot.value['invoices'] != null) {
        productStockInwardTotalQtyMap[int.parse(productCode.toString())] =
        (snapshot.value['stockInwardTillDate'] != null)
            ? double.parse(
            snapshot.value['stockInwardTillDate'].toString())
            : 0;
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
          .child('stockOutwards')
          .child(posTerminal)
          .once()
          .then((snapshot){
        if(snapshot != null && snapshot.value != null) {
          productStockOutwardTotalQtyAtPOSMap[posTerminal] =
          (snapshot.value['stockOutwardTillDate'] != null)
              ? double.parse(
              snapshot.value['stockOutwardTillDate'].toString())
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
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(productNode)
        .child('products')
        .once()
        .then((productsSnapshot) {
      if(productsSnapshot != null && productsSnapshot.value != null) {
        productsSnapshot.value.forEach((dynamic productCode,
            dynamic productSnapshot) {
//          print(productCode);
          if (productSnapshot['title'] != null &&
              productSnapshot['title'] != '' && productCode != null &&
              productCode != '') {
            productMap[int.parse(productCode.toString())] = ProductBasicDetails(
                productSnapshot['title'],
                double.parse(productSnapshot['price'].toString()),
                int.parse(productCode.toString()),
                productSnapshot['barcode'].toString(),
                (productSnapshot['imageurl'] != null)
                    ? productSnapshot['imageurl']
                    : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
                productSnapshot['category'],
                productSnapshot['brand'],
            );
          }
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
            if (productSnapshotValue['stockInwards'] != null && productSnapshotValue['stockInwards']['invoices'] != null) {
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

      productMap.forEach((int element, ProductBasicDetails value) {
          stockQty = stockQty + (productStockInwardTotalQtyMap[element] - productStockOutwardTotalQtyMap[element]);
          stockMRPValue = stockMRPValue +
              ((productStockInwardTotalQtyMap[element] - productStockOutwardTotalQtyMap[element])
                  * double.parse(productMap[element].productPrice.toString()));
      });
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
                      ListView.builder(itemBuilder: (BuildContext context, int index){
                        return Container(
                            child:Row(
                                children:<Widget>[
                                  Expanded(flex:8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            productMap[productCodes[index]].productName.toString().toUpperCase(),
                                            style:TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                            )),
                                      )),
                                  Expanded(flex:2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            (productMap[productCodes[index]] != null)?
                                            productMap[productCodes[index]].productPrice.toStringAsFixed(0):0,
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
                                      flex:1,
                                      child:Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            (productStockInwardTotalQtyMap[productCodes[index]] - productStockOutwardTotalQtyMap[productCodes[index]]).toStringAsFixed(0),
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
                        );
                      },
                          itemCount:productCodes.length),
                    ),
                  ],

                ),
            ));
      }

    }
  }
}
