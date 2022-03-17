import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
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


ProductStockInwardDetails l_productStockInwardDetails = null;
ProductStockOutwardDetails l_productStockOutwardDetails = null;

Map<int, ProductStockInwardDetails> stockInwardDetailsMap = new Map();
List<ProductStockInwardDetails> stockInwardDetailsList = new List();
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

String storeTerminals = 'POS_2';
int productCount = 0;
List<int> productCodes = List();
int productStockOutwardsProcessed = 0;
int productsRetrieved = 0;
int productCode = 0;

class InventoryManagerProductStockPosition extends StatefulWidget {
  @override
  _InventoryManagerProductStockPositionState createState() => _InventoryManagerProductStockPositionState();
}

class _InventoryManagerProductStockPositionState extends State<InventoryManagerProductStockPosition> {
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
  String storeProductNode = 'KIRANAWALA_MASTER';

  String selectedStockPositionDate;
  String selectedStockPositionDay;
  String selectedStockPositionMonth;
  String selectedStockPositionYear;

  double l_productStockInwardQtyForDate = 0;
  double l_productStockOutwardQtyForDate = 0;

  void getProductStockInwardDetailsForDate(int productCode){
    print(selectedStockPositionDay);
    print(selectedStockPositionMonth);
    print(selectedStockPositionYear);
    print(storeInventoryNode);
    print(productCode.toString());
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(storeInventoryNode)
        .child('products')
        .child(productCode.toString())
        .child('stockInwards')
        .child(selectedStockPositionYear)
        .child(selectedStockPositionMonth)
        .child(selectedStockPositionDay)
        .child('stockInwardTillDate')
        .once()
        .then((snapshot){
      if(snapshot != null && snapshot.value != null) {
        l_productStockInwardQtyForDate = double.parse(snapshot.value['stockInwardTillDate'].toString());
      }
      setState(() {
        retrievingProductStockInwardDetails = false;
      });
    });
  }


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
      if(snapshot != null && snapshot.value != null) {
//        print(productCode.toString());
        productStockInwardTotalQtyMap[int.parse(productCode.toString())] = double.parse(snapshot.value['stockInwardTillDate'].toString());
        print('getProductRecentStockInwardDetails:' + productCode.toString() + ':' + productStockInwardTotalQtyMap[int.parse(productCode.toString())].toString());
        l_productStockInwardDetails = new ProductStockInwardDetails(productCode, snapshot.value['recentStockInwardDate'], snapshot.value['recentStockInwardTime'], double.parse(snapshot.value['recentStockInwardQty'].toString()));
      }
      else
        {
          productStockInwardTotalQtyMap[int.parse(productCode.toString())] = 0;
        }
      setState(() {
        retrievingProductStockInwardDetails = false;
      });
    });
  }

  void getProductStockOutwardDetailsForDate(int productCode){
    productStockOutwardTotalQtyMap[productCode] = 0;
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
          .child(selectedStockPositionYear)
          .child(selectedStockPositionMonth)
          .child(selectedStockPositionDay)
          .child('stockOutwardTillDate')
          .once()
          .then((snapshot){
        if(snapshot != null && snapshot.value != null) {
          print(snapshot.value.toString());
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
          productStockOutwardTotalQtyAtPOSMap.forEach((String key, double value) {
            l_productStockOutwardQtyForDate = l_productStockOutwardQtyForDate + value;
          });

          setState(() {
            retrievingProductStockOutwardDetails = false;
          });
        }
      });
    });
  }

  void getProductRecentStockOutwardDetails(int productCode){
//    print('Retrieving Stock Outward Details:' + productCode.toString());
    productStockOutwardTotalQtyMap[productCode] = 0;
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
          .child('stockOutwardTillDate')
          .once()
          .then((snapshot){
        if(snapshot != null && snapshot.value != null) {
          print(snapshot.value.toString());
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

          setState(() {
            retrievingProductStockOutwardDetails = false;
          });
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
        .child(storeProductNode)
        .child('products')
        .child(productCode)
        .once()
        .then((productsSnapshot) {
      if(productsSnapshot != null && productsSnapshot.value != null) {
          print(productCode);
          print(productsSnapshot.value);
          productMap[int.parse(productCode.toString())] = ProductBasicDetails(
              productsSnapshot.value['title'],
              double.parse(productsSnapshot.value['price'].toString()),
              int.parse(productCode.toString()),
              productsSnapshot.value['barcode'].toString(),
              (productsSnapshot.value['imageUrl'] != null)
                  ? productsSnapshot.value['imageUrl']
                  : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
              productsSnapshot.value['category'],
              productsSnapshot.value['brand'],
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

      setState(() {
        retrievingProductDetails = false;
      });
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

    selectedStockPositionDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    selectedStockPositionDay = selectedStockPositionDate.substring(0,2);
    selectedStockPositionMonth = selectedStockPositionDate.substring(3,5);
    selectedStockPositionYear  = selectedStockPositionDate.substring(6,10);

    print(selectedStockPositionDate);
    print(selectedStockPositionDay);
    print(selectedStockPositionMonth);
    print(selectedStockPositionYear);


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
        
//        productCodes = [];
//        productCodes.add(2128092020145810);
        productCode = skuToUpdate;
//        productCode = 11120190819;
        getProductBasicDetails(productCode.toString());
        getProductStockInwardDetailsForDate(productCode);
        getProductStockOutwardDetailsForDate(productCode);

//        productCodes.forEach((int productCode) {
//              getProductBasicDetails(productCode.toString());
//              getProductRecentStockInwardDetails(productCode);
//              getProductRecentStockOutwardDetails(productCode);
//        });
    });
  }
  @override
  Widget build(BuildContext context) {
    {

      if(retrievingProductDetails || retrievingProductStockInwardDetails || retrievingProductStockOutwardDetails){
        print(productStockOutwardTotalQtyMap);
        print(productStockInwardTotalQtyMap);
        print(productMap);
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
                    title:Text('PRODUCT STOCK POSITION'),
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
//      double stockQty = 0;

//      productCodes = [];
//      productStockInwardTotalQtyMap.forEach((key, value) {
//        productCodes.add(key);
//      });
//
//      productCodes.forEach((element) {
//        if(productMap.containsKey(element) && productStockInwardTotalQtyMap.containsKey(element) )
//          {
//            if(productStockOutwardTotalQtyMap.containsKey(element)) {
//              stockQty = stockQty + (productStockInwardTotalQtyMap[element] -
//                  productStockOutwardTotalQtyMap[element]);
//
//              stockMRPValue = stockMRPValue +
//                  ((productStockInwardTotalQtyMap[element] - productStockOutwardTotalQtyMap[element])
//                      * double.parse(productMap[element].productPrice.toString()));
//            }
//            else {
//              stockQty = stockQty + productStockInwardTotalQtyMap[element];
//              stockMRPValue = stockMRPValue +
//                  ((productStockInwardTotalQtyMap[element])
//                      * double.parse(productMap[element].productPrice.toString()));
//            }
//          }
//      });

//      productMap.forEach((int element, ProductBasicDetails value) {
//          stockQty = stockQty + (productStockInwardTotalQtyMap[element] - productStockOutwardTotalQtyMap[element]);
//          stockMRPValue = stockMRPValue +
//              ((productStockInwardTotalQtyMap[element] - productStockOutwardTotalQtyMap[element])
//                  * double.parse(productMap[element].productPrice.toString()));
//      });
      print('Total Stock Value:' + stockMRPValue.toString());

        String l_productName = (productMap[productCode] != null)?
        productMap[productCode].productName.toString().toUpperCase():'';

        String l_productPrice = (productMap[productCode] != null)?
        productMap[productCode].productPrice.toStringAsFixed(0):'0';

        double l_productStockPosition = 0.0;

        if(productStockInwardTotalQtyMap[productCode] != null)
        {
          if(productStockOutwardTotalQtyMap[productCode] != null)
          {
            l_productStockPosition = productStockInwardTotalQtyMap[productCode] - productStockOutwardTotalQtyMap[productCode];
          }
          else
          {
            l_productStockPosition = productStockInwardTotalQtyMap[productCode];
          }
        }


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
                    'PRODUCT STOCK POSITION',
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color:Colors.white), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                        child:FlatButton(
                          color:Colors.blueGrey,
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2019, 11, 01),
                                maxTime: DateTime.now(),
                                onChanged: (date) {
                                  // print('change $date');
                                },
                                onConfirm: (date) {
                                  selectedOnlineSalePositionDate = DateFormat('dd-MMM-yyyy').format(date);
                                  selectedOnlineSalePositionDateAsddMMyyyy = DateFormat('ddMMyyyy').format(date);
                                  selectedOnlineSalePositionDay = selectedOnlineSalePositionDateAsddMMyyyy.substring(0,2);
                                  selectedOnlineSalePositionMonth = selectedOnlineSalePositionDateAsddMMyyyy.substring(2,4);
                                  selectedOnlineSalePositionYear = selectedOnlineSalePositionDateAsddMMyyyy.substring(4,8);
                                  print(date);
                                  print(selectedOnlineSalePositionDate);
                                  print(selectedOnlineSalePositionYear);
                                  print(selectedOnlineSalePositionMonth);
                                  print(selectedOnlineSalePositionDay);
//                                    retrieveOnlineSalePositionForSelectedDate();
                                  setState(() {

                                  });
                                },
                                currentTime: DateTime.now(), locale: LocaleType.en);
                          },
                          child: Text(
                            selectedOnlineSalePositionDate.toUpperCase(),
                            style: TextStyle(color: Colors.amberAccent,
                                fontSize: 20.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(l_productName,
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(l_productPrice.toString(),
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(productCode.toString(),
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(productMap[productCode].productBarCode,
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Total Inward:',
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,),
                          ),
                          Expanded(
                            child: Text(productStockInwardTotalQtyMap[productCode].toString(),
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Total Outward:',
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,),
                          ),
                          Expanded(
                            child: Text(productStockOutwardTotalQtyMap[productCode].toString(),
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('In-Stock:',
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,),
                          ),
                          Expanded(
                            child: Text((productStockInwardTotalQtyMap[productCode] - productStockOutwardTotalQtyMap[productCode]).toString(),
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Recent Date:',
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,),
                          ),
                          Expanded(
                            child: Text(l_productStockInwardDetails.recentStockInwardDate.toString(),
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Recent Time:',
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,),
                          ),
                          Expanded(
                            child: Text(l_productStockInwardDetails.recentStockInwardTime.toString(),
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('Recent Qty:',
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,),
                          ),
                          Expanded(
                            child: Text(l_productStockInwardDetails.recentStockInwardQty.toString(),
                              style:TextStyle(
                                fontSize: 24.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left,),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
            ));
      }

    }
  }
}
