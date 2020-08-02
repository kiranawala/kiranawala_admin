import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';

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

//List<ProductBasicDetails> barCodeSearchResults = new List();
//String barCodeToSearch = '';

//Map<int, ProductBasicDetails> barCodeSearchResultsMap = new Map();
//Map<int, ProductBasicDetails> productMap = new Map();
Map<String, Map<int, ProductBasicDetails>> storeProductMap = new Map<String, Map>();
Map<int, double> productStockInwardTotalQtyMap = Map<int, double>();
Map<String, Map<int, double>> storeProductStockInwardTotalQtyMap = new Map<String, Map>();
Map<int, double> productStockOutwardTotalQtyMap = Map<int, double>();
Map<String, Map<int, double>> storeProductStockOutwardTotalQtyMap = new Map<String, Map<int,double>>();
Map<int, Map<String, double>> terminalProductStockOutwardTotalQtyMap = new Map<int, Map<String,double>>();

Map<String, double> productStockOutwardTotalQtyAtPOSMap = Map<String, double>();
Map<String, List<int>> storeProductCodes = Map<String, List<int>>();

Map<int, double> productStockPositionQtyMap = Map<int, double>();


Map<int, dynamic> productStockInwardMap = Map<int, dynamic>();
List<dynamic> productStockInwardInvoices = List<dynamic>();
Map<int, double> recentProductStockOutwardQtyMap = Map<int, double>();

Map<String, dynamic> productStockOutwardHistoryMap = Map<String, dynamic>();
List<dynamic> productStockOutwardHistory = List<dynamic>();

String storeTerminals = 'POS_7';
int productCount = 0;
List<int> productCodes = List();
int productStockOutwardsProcessed = 0;
int productsRetrieved = 0;
Map<String, int> storeProductsRetrieved = new Map<String, int>();
Map<String, int> storeProductInwardDetailsRetrieved = new Map<String, int>();
Map<String, int> storeProductOutwardDetailsRetrieved = new Map<String, int>();
Map<String, bool> retrievingStoreStockInwardDetails = new Map<String, bool>();
Map<String, bool> retrievingStoreStockOutwardDetails = new Map<String, bool>();
Map<String, bool> retrievingStoreStockBasicDetails = new Map<String, bool>();
Map<String, bool> retrievingStoreProductBasicDetails = new Map<String, bool>();
Map<String, List<String>> terminalsAtStore = new Map<String, List<String>>();

Map<String, int> productCountAtStore = new Map<String, int>();
Map<String, double> unitCountAtStore = new Map<String, double>();
Map<String, double> stockMRPValueAtStore = new Map<String, double>();

//Map<String, double> productStockOutwardQtyAtTerminal = new Map<String, double>();


bool retrievingStockInwardDetails = true;
bool retrievingStockBasicDetails = true;
bool retrievingStockOutwardDetails = true;

List<String> stores = [
  'KIRANAWALA_STORE_2',
  'KIRANAWALA_STORE_3',
  'KIRANAWALA_STORE_4',
  'KIRANAWALA_STORE_5',
  'KIRANAWALA_STORE_6',
  'KIRANAWALA_STORE_7',
  'KIRANAWALA_STORE_8',
];

Map<String, String> storeNameMap = {
  'KIRANAWALA_STORE_2':'S-MART KONDAPUR X-ROADS' ,
  'KIRANAWALA_STORE_3':'S-MART RAJARAJESWARI COLONY',
  'KIRANAWALA_STORE_4':'S-MART RAGHAVENDRA COLONY',
  'KIRANAWALA_STORE_5':'S-MART TRENDSET WINZ',
  'KIRANAWALA_STORE_6':'S-MART INDUSCREST',
  'KIRANAWALA_STORE_7':'S-MART MUPPA GREEN',
  'KIRANAWALA_STORE_8':'S-MART PRASHANTH NAGAR COLONY',
};

Map<int,int> terminalsProcessed = Map<int, int>();

Map<String, int> terminalsProcessedAtStore = Map<String, int>();

Map<String, Map<int, double>> productStockOutwardQtyAtTerminal = new Map<String, Map<int, double>>();

class MultiStoreStockPosition extends StatefulWidget {
  @override
  _MultiStoreStockPositionState createState() => _MultiStoreStockPositionState();
}

class _MultiStoreStockPositionState extends State<MultiStoreStockPosition> {
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
  String storeProductNode = 'KIRANAWALA_MASTER';

  void getProductRecentStockInwardDetails(String store, int productCode){
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(store)
        .child('products')
        .child(productCode.toString())
        .child('stockInwards')
        .once()
        .then((snapshot){
      if(snapshot != null && snapshot.value != null && snapshot.value['invoices'] != null) {
        if(storeProductStockInwardTotalQtyMap.containsKey(store)){
          storeProductStockInwardTotalQtyMap[store][int.parse(productCode.toString())] =
          (snapshot.value['stockInwardTillDate'] != null)
              ? double.parse(
              snapshot.value['stockInwardTillDate'].toString())
              : 0;
        }
        else
          {
            storeProductStockInwardTotalQtyMap[store] = {int.parse(productCode.toString()):
            (snapshot.value['stockInwardTillDate'] != null)
                ? double.parse(
                snapshot.value['stockInwardTillDate'].toString())
                : 0};
          }
      }
      storeProductInwardDetailsRetrieved[store] = (storeProductInwardDetailsRetrieved[store]!=null?storeProductInwardDetailsRetrieved[store]:0) + 1;

      if(storeProductInwardDetailsRetrieved[store] == storeProductCodes[store].length){
//        print(store + ':getProductRecentStockInwardDetails:FINISHED');
//        print(store + ':Stock Inward Retrieved:' + storeProductInwardDetailsRetrieved[store].toString());
//        print(store + ':productStockInwardTotalQtyMap:' + storeProductStockInwardTotalQtyMap[store].length.toString());

//        storeProductStockInwardTotalQtyMap[store].forEach((key, value) {
//          print('Store:' + store + '.Product Code:' + key.toString() + '.Inward Qty Till Date:' + value.toString());
//        });

        retrievingStoreStockInwardDetails[store] = false;
        stores.forEach((element) {
          retrievingStockInwardDetails = retrievingStoreStockInwardDetails[element];
        });
        print('Retrieving Stock Inward Details:' + retrievingStockInwardDetails.toString());

      }
    });
  }

  void getStockInwardsAtStore(String store){
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(store)
        .child('products')
        .once()
        .then((snapshot){
      Map<int, double> productStockInwardTotalQtyMap = {};
      if(snapshot != null && snapshot.value != null) {
        snapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
          if (productSnapshot['stockInwards'] != null && productSnapshot['stockInwards']['stockInwardTillDate'] != null) {
                productStockInwardTotalQtyMap[int.parse(productCode.toString())] =  double.parse(productSnapshot['stockInwards']['stockInwardTillDate'].toString());
          }
        });
      }
      print('# of Products with Stock Inwards:' + store + ':' + productStockInwardTotalQtyMap.length.toString());
      storeProductStockInwardTotalQtyMap[store] = productStockInwardTotalQtyMap;
      retrievingStoreStockInwardDetails[store] = false;
      stores.forEach((element) {
        retrievingStockInwardDetails = retrievingStoreStockInwardDetails[element];
      });
      setState(() {

      });
//      print(storeProductStockInwardTotalQtyMap['KIRANAWALA_STORE_7'][272790025683]);
    });
  }

  void getStockOutwardsAtStore(String store){
//    print('Retrieving Stock Outward Details:' + productCode.toString());
//    int stockOutwardTerminalsProcessed = 0;
      FirebaseDatabase.instance
          .reference()
          .child('stores')
          .child(store)
          .child('products')
          .once()
          .then((snapshot){
        if(snapshot != null && snapshot.value != null) {
          snapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
            if (productSnapshot['stockOutwards'] != null) {
              double stockOutwardQtyTillDate = 0;
              terminalsAtStore[store].forEach((String posTerminal) {
                if(productSnapshot['stockOutwards'][posTerminal] != null && productSnapshot['stockOutwards'][posTerminal]['stockOutwardTillDate'] != null)
                {
//                  print('Stock Outward Till Date For:' +
//                      productCode.toString() + '@' + posTerminal +':' + productSnapshot['stockOutwards'][posTerminal]['stockOutwardTillDate'].toString());
                  stockOutwardQtyTillDate = stockOutwardQtyTillDate + double.parse(productSnapshot['stockOutwards'][posTerminal]['stockOutwardTillDate'].toString());
                }
              });
              productStockOutwardTotalQtyMap[int.parse(productCode.toString())] = stockOutwardQtyTillDate;
            }
          });
        }
        print('# of Products with Stock Outwards:' + store + ':' + productStockOutwardTotalQtyMap.length.toString());
        storeProductStockOutwardTotalQtyMap[store] = productStockOutwardTotalQtyMap;
        retrievingStoreStockOutwardDetails[store] = false;
//        print(storeProductStockOutwardTotalQtyMap['KIRANAWALA_STORE_7'][272790025683]);
        stores.forEach((element) {
          retrievingStockOutwardDetails = retrievingStoreStockOutwardDetails[element];
        });
        setState(() {

        });
      });

//          if(terminalProductStockOutwardTotalQtyMap.containsKey(int.parse(productCode.toString()))){
//            terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())][posTerminal] =
//            (snapshot.value['stockOutwardTillDate'] != null)
//                ? double.parse(
//                snapshot.value['stockOutwardTillDate'].toString())
//                : 0;
//          }
//          else
//          {
//            terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())] = {posTerminal:
//            (snapshot.value['stockOutwardTillDate'] != null)
//                ? double.parse(
//                snapshot.value['stockOutwardTillDate'].toString())
//                : 0};
//          }
////          print(storeProductStockOutwardTotalQtyMap);
//        }
//        else
//        {
//          if(terminalProductStockOutwardTotalQtyMap.containsKey(int.parse(productCode.toString()))){
//            terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())][posTerminal] = 0;
//          }
//          else
//          {
//            terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())] = {posTerminal: 0};
//          }
//        }
//        terminalsProcessed[int.parse(productCode.toString())] = (terminalsProcessed.containsKey(int.parse(productCode.toString()))?terminalsProcessed[int.parse(productCode.toString())]:0) + 1;
//        if(terminalsProcessed[int.parse(productCode.toString())] == terminalsAtStore[store].length)
//        {
//          double totalStockOutwardQty = 0;
//          terminalsAtStore[store].forEach((element) {
//            totalStockOutwardQty = totalStockOutwardQty + terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())][posTerminal];
//          });
//
//          if(storeProductStockOutwardTotalQtyMap.containsKey(store))
//          {
//            storeProductStockOutwardTotalQtyMap[store][int.parse(productCode.toString())] = totalStockOutwardQty;
//          }
//          else
//          {
//            storeProductStockOutwardTotalQtyMap[store] = {int.parse(productCode.toString()): totalStockOutwardQty};
//          }
//
//          storeProductOutwardDetailsRetrieved[store] = (storeProductOutwardDetailsRetrieved[store]!=null?storeProductOutwardDetailsRetrieved[store]:0) + 1;
//          print(productCode.toString());
//          print(storeProductStockOutwardTotalQtyMap[store][int.parse(productCode.toString())]);
//          print(storeProductOutwardDetailsRetrieved[store]);
//          print(storeProductCodes[store].length);
//
//          if(storeProductOutwardDetailsRetrieved[store] == storeProductCodes[store].length){
//            print(store + ':getProductRecentStockOutwardDetails:FINISHED');
//            print(store + ':Stock Outward Retrieved:' + storeProductOutwardDetailsRetrieved[store].toString());
//            print(store + ':productStockInwardTotalQtyMap:' + storeProductStockOutwardTotalQtyMap[store].length.toString());
//
//            retrievingStoreStockOutwardDetails[store] = false;
//            stores.forEach((element) {
//              retrievingStockOutwardDetails = retrievingStoreStockOutwardDetails[element];
//            });
//            print('Retrieving Stock Outward Details:' + retrievingStockOutwardDetails.toString());
//
//          }
//        }
//      });
//    });
  }


//  void getProductRecentStockOutwardDetails(String store){
////    print('Retrieving Stock Outward Details:' + productCode.toString());
////    int stockOutwardTerminalsProcessed = 0;
//    terminalsAtStore[store].forEach((String posTerminal) {
//      FirebaseDatabase.instance
//          .reference()
//          .child('stores')
//          .child(store)
//          .child('products')
//          .child(productCode.toString())
//          .child('stockOutwards')
//          .child(posTerminal)
//          .once()
//          .then((snapshot){
//        if(snapshot != null && snapshot.value != null) {
//
//          if(terminalProductStockOutwardTotalQtyMap.containsKey(int.parse(productCode.toString()))){
//            terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())][posTerminal] =
//            (snapshot.value['stockOutwardTillDate'] != null)
//                ? double.parse(
//                snapshot.value['stockOutwardTillDate'].toString())
//                : 0;
//          }
//          else
//          {
//            terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())] = {posTerminal:
//            (snapshot.value['stockOutwardTillDate'] != null)
//                ? double.parse(
//                snapshot.value['stockOutwardTillDate'].toString())
//                : 0};
//          }
////          print(storeProductStockOutwardTotalQtyMap);
//        }
//        else
//          {
//            if(terminalProductStockOutwardTotalQtyMap.containsKey(int.parse(productCode.toString()))){
//              terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())][posTerminal] = 0;
//            }
//            else
//            {
//              terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())] = {posTerminal: 0};
//            }
//          }
//        terminalsProcessed[int.parse(productCode.toString())] = (terminalsProcessed.containsKey(int.parse(productCode.toString()))?terminalsProcessed[int.parse(productCode.toString())]:0) + 1;
////        print(terminalsProcessed[int.parse(productCode.toString())]);
//        if(terminalsProcessed[int.parse(productCode.toString())] == terminalsAtStore[store].length)
//          {
//            double totalStockOutwardQty = 0;
//          terminalsAtStore[store].forEach((element) {
//            totalStockOutwardQty = totalStockOutwardQty + terminalProductStockOutwardTotalQtyMap[int.parse(productCode.toString())][posTerminal];
////                productStockOutwardQtyAtTerminal[element][productCode];
//          });
//
//            if(storeProductStockOutwardTotalQtyMap.containsKey(store))
//            {
//              storeProductStockOutwardTotalQtyMap[store][int.parse(productCode.toString())] = totalStockOutwardQty;
//            }
//            else
//            {
//              storeProductStockOutwardTotalQtyMap[store] = {int.parse(productCode.toString()): totalStockOutwardQty};
//            }
//
//            storeProductOutwardDetailsRetrieved[store] = (storeProductOutwardDetailsRetrieved[store]!=null?storeProductOutwardDetailsRetrieved[store]:0) + 1;
//            print(productCode.toString());
//            print(storeProductStockOutwardTotalQtyMap[store][int.parse(productCode.toString())]);
//            print(storeProductOutwardDetailsRetrieved[store]);
//            print(storeProductCodes[store].length);
//
//            if(storeProductOutwardDetailsRetrieved[store] == storeProductCodes[store].length){
//        print(store + ':getProductRecentStockOutwardDetails:FINISHED');
//        print(store + ':Stock Outward Retrieved:' + storeProductOutwardDetailsRetrieved[store].toString());
//        print(store + ':productStockInwardTotalQtyMap:' + storeProductStockOutwardTotalQtyMap[store].length.toString());
//
////        storeProductStockInwardTotalQtyMap[store].forEach((key, value) {
////          print('Store:' + store + '.Product Code:' + key.toString() + '.Inward Qty Till Date:' + value.toString());
////        });
//
//              retrievingStoreStockOutwardDetails[store] = false;
//              stores.forEach((element) {
//                retrievingStockOutwardDetails = retrievingStoreStockOutwardDetails[element];
//              });
//              print('Retrieving Stock Outward Details:' + retrievingStockOutwardDetails.toString());
//
//            }
////          print('Store:' + store + '.Product Code:' + productCode.toString() + '.Outward Qty:' + totalStockOutwardQty.toString());
//          }
////                }
//        //        terminalsProcessedAtStore[store] = ((terminalsProcessedAtStore[store] != null)?terminalsProcessedAtStore[store]:0) + 1;
////        stockOutwardTerminalsProcessed = stockOutwardTerminalsProcessed + 1;
////        print(terminalsProcessedAtStore[store]);
////        if(terminalsProcessedAtStore[store] == terminalsAtStore[store].length) {
////          double totalStockOutwardQty = 0;
////          terminalsAtStore[store].forEach((element) {
////            totalStockOutwardQty = totalStockOutwardQty +
////                productStockOutwardQtyAtTerminal[element][productCode];
////          });
////          print(totalStockOutwardQty);
////        }
////
////          if(storeProductStockOutwardTotalQtyMap.containsKey(store)){
////            storeProductStockOutwardTotalQtyMap[store][int.parse(productCode.toString())] =
////                totalStockOutwardQty;
////          }
////          else
////          {
////            storeProductStockOutwardTotalQtyMap[store] = {int.parse(productCode.toString()):
////            totalStockOutwardQty};
////          }
////          }
//      });
//    });
//  }


  void getProductBasicDetailsFromMaster(String store)
  {

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_MASTER')
        .child('products')
        .once()
        .then((DataSnapshot snapshot) {
      Map<int, ProductBasicDetails> productMap = Map();
      if (snapshot != null && snapshot.value != null) {
        snapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
            productMap[int.parse(productSnapshot['productcode'].toString())] =
                ProductBasicDetails(
                  productSnapshot['title'],
                  double.parse(productSnapshot['price'].toString()),
                  int.parse(productSnapshot['productcode'].toString()),
                  productSnapshot['barcode'].toString(),
                  (productSnapshot['imageURL'] != null)
                      ? productSnapshot['imageURL']
                      : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
                  productSnapshot['category'],
                  productSnapshot['brand'],
                );
        });
      }

      print('# of Products with Basic Details:' + productMap.length.toString());
      storeProductMap[store] = productMap;
      retrievingStoreStockBasicDetails[store] = false;
      stores.forEach((element) {
        retrievingStockBasicDetails = retrievingStoreStockBasicDetails[element];
      });
      setState(() {

      });
//          print(storeProductStockOutwardTotalQtyMap['KIRANAWALA_STORE_7'][272790025683]);
//          retrievingProductBasicDetails = retrievingStoreProductBasicDetails[element];
//          storeProductsRetrieved[store] = (storeProductsRetrieved[store]!=null?storeProductsRetrieved[store]:0) + 1;
//      if(storeProductsRetrieved[store] == storeProductCodes[store].length) {
////        print(store + ':getProductDetails:FINISHED');
////        print(store + ':Product Details Retrieved:' + storeProductsRetrieved[store].toString());
////        print(store + ':productMap:' + storeProductMap[store].length.toString());
////        storeProductMap[store].forEach((key, value) {
////          print('Store:' + store + '.Product Code:' + key.toString() + '.' + 'Product Name:' + value.productName);
////        });
//        retrievingStoreProductBasicDetails[store] = false;
//        stores.forEach((element) {
//          retrievingStockBasicDetails = retrievingStoreProductBasicDetails[element];
//        });
//        print('Retrieving Basic Details:' + retrievingStockBasicDetails.toString());
//      }

    });
  }
  void getProductBasicDetailsAtStore(String store)
  {

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_MASTER')
        .child('products')
        .once()
        .then((DataSnapshot snapshot) {
          Map<int, ProductBasicDetails> productMap = Map();
      if (snapshot != null && snapshot.value != null) {
        snapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
          if (productSnapshot['basicDetails'] != null) {
            productMap[int.parse(productSnapshot['basicDetails']['productCode'].toString())] =
                ProductBasicDetails(
                  productSnapshot['basicDetails']['productName'],
                  double.parse(productSnapshot['basicDetails']['productPrice'].toString()),
                  int.parse(productSnapshot['basicDetails']['productCode'].toString()),
                  productSnapshot['basicDetails']['productBarcode'].toString(),
                  (productSnapshot['basicDetails']['productImageURL'] != null)
                      ? productSnapshot['productImageURL']
                      : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
                  productSnapshot['basicDetails']['productCategory'],
                  productSnapshot['basicDetails']['productBrand'],
                );
          }
        });
      }

      print('# of Products with Basic Details:' + store + ':' + productMap.length.toString());
      storeProductMap[store] = productMap;
      retrievingStoreStockBasicDetails[store] = false;
      stores.forEach((element) {
        retrievingStockBasicDetails = retrievingStoreStockBasicDetails[element];
      });
      setState(() {

      });
//          print(storeProductStockOutwardTotalQtyMap['KIRANAWALA_STORE_7'][272790025683]);
//          retrievingProductBasicDetails = retrievingStoreProductBasicDetails[element];
//          storeProductsRetrieved[store] = (storeProductsRetrieved[store]!=null?storeProductsRetrieved[store]:0) + 1;
//      if(storeProductsRetrieved[store] == storeProductCodes[store].length) {
////        print(store + ':getProductDetails:FINISHED');
////        print(store + ':Product Details Retrieved:' + storeProductsRetrieved[store].toString());
////        print(store + ':productMap:' + storeProductMap[store].length.toString());
////        storeProductMap[store].forEach((key, value) {
////          print('Store:' + store + '.Product Code:' + key.toString() + '.' + 'Product Name:' + value.productName);
////        });
//        retrievingStoreProductBasicDetails[store] = false;
//        stores.forEach((element) {
//          retrievingStockBasicDetails = retrievingStoreProductBasicDetails[element];
//        });
//        print('Retrieving Basic Details:' + retrievingStockBasicDetails.toString());
//      }

    });
  }

  void getProductBasicDetails(String store, String productCode)
  {

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(store)
        .child('products')
        .child(productCode)
        .child('basicDetails')
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot != null && snapshot.value != null) {
        if(storeProductMap.containsKey(store))
            storeProductMap[store][int.parse(snapshot.value['productCode'].toString())] =
                ProductBasicDetails(
              snapshot.value['productName'],
              double.parse(snapshot.value['productPrice'].toString()),
              int.parse(snapshot.value['productCode'].toString()),
              snapshot.value['productBarcode'].toString(),
              (snapshot.value['productImageURL'] != null)
                  ? snapshot.value['productImageURL']
                  : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
              snapshot.value['productCategory'],
              snapshot.value['productBrand'],
            );
        else
          storeProductMap[store] = {int.parse(snapshot.value['productCode'].toString()):
              ProductBasicDetails(
                snapshot.value['productName'],
                double.parse(snapshot.value['productPrice'].toString()),
                int.parse(snapshot.value['productCode'].toString()),
                snapshot.value['productBarcode'].toString(),
                (snapshot.value['productImageURL'] != null)
                    ? snapshot.value['productImageURL']
                    : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
                snapshot.value['productCategory'],
                snapshot.value['productBrand'],
              )};
      }
      else
        {
          print('Product Not Found:'+ productCode);
        }
      storeProductsRetrieved[store] = (storeProductsRetrieved[store]!=null?storeProductsRetrieved[store]:0) + 1;
      if(storeProductsRetrieved[store] == storeProductCodes[store].length) {
//        print(store + ':getProductDetails:FINISHED');
//        print(store + ':Product Details Retrieved:' + storeProductsRetrieved[store].toString());
//        print(store + ':productMap:' + storeProductMap[store].length.toString());
//        storeProductMap[store].forEach((key, value) {
//          print('Store:' + store + '.Product Code:' + key.toString() + '.' + 'Product Name:' + value.productName);
//        });
          retrievingStoreProductBasicDetails[store] = false;
          stores.forEach((element) {
            retrievingStockBasicDetails = retrievingStoreProductBasicDetails[element];
          });
          print('Retrieving Basic Details:' + retrievingStockBasicDetails.toString());
      }

    });
  }

  void getStoreStockPosition(String store){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child(store)
        .child('products')
        .once()
        .then((productSnapshot){
      List<int> codes = [];

      if(productSnapshot != null && productSnapshot.value != null ) {
        productSnapshot.value.forEach((dynamic productSnapshotKey,
            dynamic productSnapshotValue) {
          if (productSnapshotValue['stockInwards'] != null && productSnapshotValue['stockInwards']['invoices'] != null) {
            codes.add(int.parse(productSnapshotKey.toString()));
          }
        });
      }

      storeProductCodes[store] = codes;
      print(storeProductCodes[store].length.toString());



//      print('Product Count to be processed:' + storeProductCodes[store].length.toString());
      storeProductCodes[store].forEach((int productCode) {
//        getProductBasicDetails(store, productCode.toString());
//        getProductRecentStockInwardDetails(store,productCode);
//        getProductRecentStockOutwardDetails(store, productCode);
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
    storeProductMap = Map();
    storeProductStockInwardTotalQtyMap = Map();
    storeProductInwardDetailsRetrieved = Map();

    stores.forEach((element) {
      retrievingStoreStockInwardDetails[element] = true;
      retrievingStoreStockBasicDetails[element] = true;
      retrievingStoreStockOutwardDetails[element] = true;
    });

    terminalsAtStore = {
      'KIRANAWALA_STORE_1':['POS_1'],
      'KIRANAWALA_STORE_2':['POS_2'],
      'KIRANAWALA_STORE_3':['POS_3'],
      'KIRANAWALA_STORE_4':['POS_4'],
      'KIRANAWALA_STORE_5':['POS_5'],
      'KIRANAWALA_STORE_6':['POS_6'],
      'KIRANAWALA_STORE_7':['POS_7'],
      'KIRANAWALA_STORE_8':['POS_8'],

    };

    retrievingProductDetails = true;
    retrievingProductStockInwardDetails = true;
    retrievingProductStockOutwardDetails = true;

    retrievingStockInwardDetails = true;
    retrievingStockOutwardDetails = true;
    retrievingStockBasicDetails = true;

    storeProductCodes = {};

//    getStoreStockPosition('KIRANAWALA_STORE_7');
//    getStoreStockPosition('KIRANAWALA_STORE_8');
    productStockOutwardTotalQtyMap = {};
    storeProductStockOutwardTotalQtyMap = {};
//    retrievingStoreStockOutwardDetails['KIRANAWALA_STORE_4'] = true;
//    getStockOutwardsAtStore('KIRANAWALA_STORE_4');
//    retrievingStoreStockOutwardDetails['KIRANAWALA_STORE_7'] = true;
//    getStockOutwardsAtStore('KIRANAWALA_STORE_7');

    productStockInwardTotalQtyMap = {};
//    storeProductStockOutwardTotalQtyMap = {};
//    retrievingStoreStockInwardDetails['KIRANAWALA_STORE_4'] = true;
//    getStockInwardsAtStore('KIRANAWALA_STORE_4');
//    retrievingStoreStockInwardDetails['KIRANAWALA_STORE_7'] = true;
//    getStockInwardsAtStore('KIRANAWALA_STORE_7');

//    retrievingStoreStockBasicDetails['KIRANAWALA_STORE_4'] = true;
//    getProductBasicDetailsAtStore('KIRANAWALA_STORE_4');
//    retrievingStoreStockBasicDetails['KIRANAWALA_STORE_7'] = true;
//    getProductBasicDetailsAtStore('KIRANAWALA_STORE_7');

    retrievingStoreStockOutwardDetails = {};
    retrievingStoreStockInwardDetails = {};
    retrievingStoreStockBasicDetails = {};

    retrievingStockOutwardDetails = true;
    retrievingStockInwardDetails = true;
    retrievingStockBasicDetails = true;

    storeProductMap = {};
    storeProductStockOutwardTotalQtyMap = {};
    storeProductStockInwardTotalQtyMap = {};

    stores.forEach((storesElement) {
      retrievingStoreStockOutwardDetails[storesElement] = true;
      getStockOutwardsAtStore(storesElement);
      retrievingStoreStockInwardDetails[storesElement] = true;
      getStockInwardsAtStore(storesElement);
      retrievingStoreStockBasicDetails[storesElement] = true;
      getProductBasicDetailsFromMaster(storesElement);
    });
  }
  @override
  Widget build(BuildContext context) {
    {

      if(retrievingStockBasicDetails || retrievingStockInwardDetails || retrievingStockOutwardDetails){
        return
          WillPopScope(
              onWillPop:(){
                setState(() {
                  retrievingProductDetails = false;
                  retrievingProductStockInwardDetails = false;
                  retrievingProductStockOutwardDetails = false;
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ShowHomePage();
                      }));
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
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                            return ShowHomePage();
                          }));
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



        stores.forEach((storesElement) {
          int count = 0;
          double units = 0;
          double stockMRPValue = 0;
          print('STORE:' + storesElement);
          if(storeProductMap[storesElement] != null)
          storeProductMap[storesElement].forEach((key, value) {
//            print(key);
            if(storeProductStockInwardTotalQtyMap[storesElement][key] != null)
            {
              double inwardQty = storeProductStockInwardTotalQtyMap[storesElement][key];
              double outwardQty = ((storeProductStockOutwardTotalQtyMap[storesElement][key] != null)?storeProductStockOutwardTotalQtyMap[storesElement][key]:0);
              double stockPosition = inwardQty - outwardQty;
              if(stockPosition >= 0)
                {
                  count = count + 1;
                  units = units + stockPosition;
                  stockMRPValue = stockMRPValue + (stockPosition * storeProductMap[storesElement][key].productPrice);

//                  print('STORE:'
//                      + storesElement
//                      + '.PRODUCT CODE:'
//                      + key.toString()
//                      + '.STOCK INWARD TILL DATE:'
//                      + storeProductStockInwardTotalQtyMap[storesElement][key].toString()
//                      + '.STOCK OUTWARD TILL DATE:'
//                      + storeProductStockOutwardTotalQtyMap[storesElement][key].toString()
//                  );
                }

            }
          });
          productCountAtStore[storesElement] = count;
          unitCountAtStore[storesElement] = units;
          stockMRPValueAtStore[storesElement] = stockMRPValue;

          print('STORE:'
              + storesElement
              + '.SKU COUNT:'
              + count.toString()
          );
          print('STORE:'
              + storesElement
              + '.SKU UNITS:'
              + units.toString()
          );
        });
      print('Stock Inwards:' + productStockInwardTotalQtyMap.length.toString());
      print('Stock Outwards:' + productStockOutwardTotalQtyMap.length.toString());
      print('Product Details:' + productMap.length.toString());

      double stockMRPValue = 0;
      double stockQty = 0;

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
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return ShowHomePage();
                    }));
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
                        Navigator.of(context).pop();
                        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return ShowHomePage();
                            }));
                      }),

                ),
                body:ListView.builder(
                  itemBuilder: (BuildContext context, int index){
                    return
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                          children: <Widget>[
                            Expanded(
                          child:Text(storeNameMap[stores[index]],
                          textAlign: TextAlign.center,)
                      )
                        ],
                      ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child:Text('SKUs')
                              ),
                              Expanded(
                                  child:Text(productCountAtStore[stores[index]].toString())
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child:Text('UNITS')
                              ),
                              Expanded(
                                  child:Text(unitCountAtStore[stores[index]].toString())
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child:Text('TERMINALS')
                              ),
                              Expanded(
                                  child:Text(terminalsAtStore[stores[index]].length.toString())
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child:Text('STOCK VALUE(MRP)')
                              ),
                              Expanded(
                                  child:Text(stockMRPValueAtStore[stores[index]].toString())
                              )
                            ],
                          ),
//                    Expanded(child: Text(productCountAtStore[stores[index]].toString())),
//                    Text(unitCountAtStore[stores[index]].toString()),
//                    Text(terminalsAtStore[stores[index]].length.toString()),
//                    Text(stockMRPValueAtStore[stores[index]].toString())
                      ],
                      ),
                    );
                  },
                    itemCount: stores.length,
                ),
            ));
      }

    }
  }
}
