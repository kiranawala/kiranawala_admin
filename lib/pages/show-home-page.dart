import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/ShowTerminalWiseSalePositionStreamBuilder.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/online-product-lookup.dart';
import 'package:kiranawala_admin/pages/product-lookup.dart';
import 'package:kiranawala_admin/pages/reset-store.dart';
import 'package:kiranawala_admin/pages/search-barcode.dart';
import 'package:kiranawala_admin/pages/select-store.dart';
import 'package:kiranawala_admin/pages/show-sale-position-home.dart';
import 'package:kiranawala_admin/pages/stock-in-manager-online.dart';
import 'package:kiranawala_admin/pages/stock-inward-history.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-home-page.dart';
//import 'package:kiranawala_admin/stock-position/ShowTerminalWiseSalePositionStreamBuilder.dart';
//import 'package:kiranawala_admin/stock-position/check-if-admin.dart';
//import 'package:kiranawala_admin/stock-position/stock-inward-history.dart';

import 'show-sinima-home-page.dart';

bool storeLoading = true;
bool storeLoaded = false;
bool storeLoadingSuccessful = false;

bool fullProductBasicDetailsMapAvailable = false;
//bool productDiscountDetailsAtAllStoresAvailable = false;
//bool productStockPositionAtAllStoresAvailable = false;
//bool fullProductSalePositionMapAvailable = false;
//bool fullProductStockPositionMapAvailable = false;
//bool productSalePositionAtAllTerminalsAvailable = false;

//class ProductDiscountDetails {
//  num discount;
//  String discountStartDate;
//  String discountEndDate;
//  String discountStatusChangeTimeStamp;
//  bool isDiscountActive;
//  String discountType;
//  int productCode;
//
//
//  ProductDiscountDetails(
//      num discount,
//      String discountStartDate,
//      String discountEndDate,
//      String discountStatusChangeTimeStamp,
//      bool isDiscountActive,
//      String discountType,
//      int productCode
//      ) {
//    this.discount = discount;
//    this.discountStartDate = discountStartDate;
//    this.discountEndDate = discountEndDate;
//    this.discountStatusChangeTimeStamp = discountStatusChangeTimeStamp;
//    this.isDiscountActive = isDiscountActive;
//    this.discountType = discountType;
//    this.productCode = productCode;
//  }
//}
//
//
//class ProductBasicDetails {
//  String productName;
//  int productID;
//  String productBarCode;
//  num productPrice;
//  String productImageURL;
//  String productCategory;
//  String productBrand;
//  String productStatus;
//  String productParentStore;
//  String productCreationTimeStamp;
//
//
//  ProductBasicDetails(
//      String productName,
//      num productPrice,
//      int productID,
//      String productBarCode,
//      String productImageURL,
//      String productCategory,
//      String productBrand,
//      String productStatus,
//    String productParentStore,
//    String productCreationTimeStamp
//      ) {
//    this.productName = productName;
//    this.productPrice = productPrice;
//    this.productID = productID;
//    this.productBarCode = productBarCode;
//    this.productImageURL = productImageURL;
//    this.productCategory = productCategory;
//    this.productBrand = productBrand;
//    this.productStatus = productStatus;
//    this.productParentStore = productParentStore;
//    this.productCreationTimeStamp = productCreationTimeStamp;
//  }
//}

//List<ProductBasicDetails> barCodeSearchResults = new List<ProductBasicDetails>();
//String barCodeToSearch = '';

//Map<int, ProductBasicDetails> barCodeSearchResultsMap = new Map();
//Map<int, ProductBasicDetails> productMap = new Map();


//Map<int, ProductBasicDetails> fullProductBasicDetailsMap = new Map();
//List<ProductBasicDetails> fullProductBasicDetailsList = new List();

//Map<int, ProductDiscountDetails> fullProductDiscountMap = new Map();
//List<ProductDiscountDetails> fullProductDiscountList = new List();

//Map<int, double> fullProductSalePositionMap = new Map();
//Map<int, double> fullProductStockPositionMap = new Map();

//Map<String, Map<int, ProductBasicDetails>> fullProductBasicDetailsAtStore = new Map();
//Map<String, Map<int, ProductDiscountDetails>> fullProductDiscountDetailsAtStore = new Map();
//Map<String, Map<int, double>> fullProductStockPositionAtStore = new Map();
//Map<String, Map<int, double>> fullProductSalePositionAtStore = new Map();
//Map<String, Map<int, double>> fullProductSalePositionAtTerminal = new Map();


//Map<String, bool> salePositionForTerminalAvailable = new Map();
//Map<String, bool> salePositionForTerminalProcessed = new Map();
//Map<String, bool> storeStockPositionAvailable = new Map();


int discountsProcessed = 0;
int stockPositionProcessed = 0;
int salePositionProcessed = 0;

class ShowHomePage extends StatefulWidget {
  @override
  _ShowHomePageState createState() => _ShowHomePageState();
}

class _ShowHomePageState extends State<ShowHomePage> {

  void getProductSalePostionAtStore(String storeId){
//    print(storeId);
//    print(storeIdTerminalMap[storeId]);
    storeIdTerminalMap[storeId].forEach((posTerminal) {
//      print(posTerminal);
      getProductSalePositionAtTerminal(posTerminal);
    });
  }

  void getProductSalePositionAtTerminal(String posTerminal){
//    print('getProductSalePositionAtTerminal:');
//    print(posTerminal);

    FirebaseDatabase.instance
        .reference()
        .child('storeTerminals')
        .child(posTerminal)
        .child('sales')
        .child('productSalePosition')
        .once()
        .then((productSalePositionSnapshot) {
//        print(productSalePositionSnapshot);
        if(productSalePositionSnapshot != null && productSalePositionSnapshot.value != null) {
          Map<int,double> salePositionMap = <int, double>{};
          productSalePositionSnapshot.value.forEach((dynamic productCode,
              dynamic productSnapshot) {
            salePositionMap[int.parse(productCode.toString())]
            = double.parse(productSnapshot['salePosition'].toString());
          });
          fullProductSalePositionAtTerminal[posTerminal] =
              salePositionMap;
          salePositionForTerminalAvailable[posTerminal] = true;
        }
      salePositionForTerminalProcessed[posTerminal] = true;
        salePositionProcessed = salePositionProcessed + 1;
        if(salePositionProcessed == allTerminals.length)
        {
          if (this.mounted) {
            setState(() {
              productSalePositionAtAllTerminalsAvailable = true;
              print('All Terminals Processed For Sale Position');
            });
          }

        }
    });
  }

//  void getProductSalePositionAtTerminal(String posTerminal){
//    print('getProductSalePositionAtTerminal:');
//    print(posTerminal);
//    fullProductSalePositionMap = new Map();
//    FirebaseDatabase.instance
//        .reference()
//        .child('storeTerminals')
//        .child(posTerminal)
//        .child('sales')
//        .child('productSalePosition')
//        .onValue
//        .listen((event) {
//      print(event);
//      if(event != null)
//      {
//        if(event.snapshot != null && event.snapshot.value != null) {
////          if(event.snapshot.value[posTerminal] != null
////              && event.snapshot.value[posTerminal]['sales'] != null
////              && event.snapshot.value[posTerminal]['sales']['salePosition'] != null)
////            {
////              event.snapshot.value[posTerminal]['sales']['salePosition'].forEach((dynamic productCode, dynamic productSnapshot)
////              {
//          event.snapshot.value.forEach((dynamic productCode, dynamic productSnapshot)
//          {
////                print(productCode);
////                print(productSnapshot['salePosition']);
//            fullProductSalePositionMap[int.parse(productCode.toString())]
//            = double.parse(productSnapshot['salePosition'].toString());
//          });
//          fullProductSalePositionAtTerminal[posTerminal] = fullProductSalePositionMap;
//          print(fullProductSalePositionAtTerminal[posTerminal]);
//          salePositionForTerminalAvailable[posTerminal] = true;
//        }
//      }
////        event.snapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
//////          print(productCode);
//////          print(productSnapshot['salePosition']);
////          fullProductSalePositionMap[int.parse(productCode.toString())]
////          = double.parse(productSnapshot['salePosition'].toString());
////        });
//
//
////        fullProductSalePositionMapAvailable = true;
//
////        print('Full Sale Position Map :' +
////            fullProductSalePositionMap.length.toString());
//
//
////        if (this.mounted) {
////          setState(() {
////            storeLoading = false;
////            storeLoaded = true;
////            storeLoadingSuccessful = true;
////          });
////        }
////      }
//    });
//  }

  void getProductStockPositionAtStore(String storeId)
  {
    print('getProductStockPositionAtStore:' + storeId.toString());
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(storeId)
        .child('products')
        .once()
        .then((productsSnapshot) {
          print(productsSnapshot);
      if(productsSnapshot != null && productsSnapshot.value != null) {
        Map<int, double> stockPositionMap = new Map();
        productsSnapshot.value.forEach((dynamic productCode,
            dynamic productSnapshot) {
          if (productSnapshot['stockInwards'] != null &&
              productSnapshot['stockInwards']['stockInwardTillDate'] != null) {
//              print(productCode);
//              print(productSnapshot['stockInwards']['stockInwardTillDate'].toString());
            stockPositionMap[int.parse(productCode.toString())]
            = double.parse(
                productSnapshot['stockInwards']['stockInwardTillDate']
                    .toString());
          }
        });
        fullProductStockPositionAtStore[storeId] = stockPositionMap;
        storeStockPositionAvailable[storeId] = true;

        print('Full Stock Position Map Of Store:' + storeId.toString() + ':' +
            fullProductStockPositionAtStore[storeId].length.toString());
      }
      stockPositionProcessed = stockPositionProcessed + 1;
      if(stockPositionProcessed == storeIdMap.length)
        {
          if (this.mounted) {
            setState(() {
              productStockPositionAtAllStoresAvailable = true;
              print('All Stores Processed For Stock Position.');
            });
          }
        }
    });
  }

  void getProductDiscountDetailsAtStore(String storeId)
  {
    print(storeId);
    fullProductDiscountMap = new Map();
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(storeId)
        .child('discounts')
        .once()
        .then((discountsSnapshot) {

          if(discountsSnapshot != null && discountsSnapshot.value != null) {
//            print(event.snapshot.value['discounts']);
            discountsSnapshot.value.forEach((dynamic productCode,
                dynamic discountSnapshot) {
              ProductDiscountDetails productDiscountDetails;
              productDiscountDetails =
              new ProductDiscountDetails(
                  discountSnapshot['discount'],
                  discountSnapshot['discountStartDate'],
                  discountSnapshot['discountEndDate'],
                  discountSnapshot['statusChangeTimeStamp'],
                  discountSnapshot['isDiscountActive'],
                  discountSnapshot['discountType'],
                  discountSnapshot['productCode']);
              fullProductDiscountMap[int.parse(productCode.toString())] = productDiscountDetails;
            });
            fullProductDiscountDetailsAtStore[storeId] = fullProductDiscountMap;
          }
          discountsProcessed = discountsProcessed + 1;
//          print(discountsProcessed);
//          print(storeIdMap.length);
          if(discountsProcessed == storeIdMap.length)
          {
            if (this.mounted) {
              setState(() {
                productDiscountDetailsAtAllStoresAvailable = true;
                print('All Stores Processed for Discount Details.');
              });
            }

//            print(fullProductDiscountDetailsAtStore);
//            print(fullProductDiscountDetailsAtStore.length);
//            fullProductDiscountDetailsAtStore.forEach((key, value) {
//              print(key);
//            });
          }
    });
  }


  void loadAllStores()
  {
    storeIdMap.forEach((key, value) {
      storeIdTerminalMap[value].forEach((terminal){
        salePositionForTerminalAvailable[terminal] = false;
      });
    });

    fullProductStockPositionAtStore = new Map();
    storeStockPositionAvailable = new Map();

    discountsProcessed = 0;
    productDiscountDetailsAtAllStoresAvailable = false;

    allTerminals = List<String>();
    storeIdMap.forEach((String store, String storeId){
      storeIdTerminalMap[storeId].forEach((String terminal){
        print(terminal);
        allTerminals.add(terminal);
      });
    });
    print(allTerminals);
    print(allTerminals.length.toString());

    salePositionProcessed = 0;
    allTerminals.forEach((String terminal){
      print(terminal);
      getProductSalePositionAtTerminal(terminal);
    });


    storeIdMap.forEach((String store, String storeId){
      print(storeId);
      getProductDiscountDetailsAtStore(storeId);
      getProductSalePostionAtStore(storeId);
      getProductStockPositionAtStore(storeId);
    });

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_MASTER')
        .child('products')
        .onValue
        .listen((event) {
      if(event != null && event.snapshot != null && event.snapshot.value != null) {
        event.snapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
          if(productSnapshot['title'] != null && productSnapshot['title'] != ''){

            ProductBasicDetails product = ProductBasicDetails(
                productSnapshot['title'],
                double.parse(productSnapshot['price'].toString()),
                int.parse(productCode.toString()),
                productSnapshot['barcode'].toString(),
                (productSnapshot['imageurl'] != null)
                    ? productSnapshot['imageurl']
                    : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
                productSnapshot['category'],
                productSnapshot['brand'],
                (productSnapshot['productStatus'] != null)
                    ? productSnapshot['productStatus']
                    : 'INACTIVE',
                (productSnapshot['productParent'] != null)
                    ? productSnapshot['productParent']
                    : 'N/A',
                (productSnapshot['productCreationTimeStamp'] != null)
                    ? productSnapshot['productCreationTimeStamp']
                    : 'N/A'
            );
            fullProductBasicDetailsMap[int.parse(productCode.toString())]= product;
            fullProductBasicDetailsList.add(product);
          }
        });

        fullProductBasicDetailsMapAvailable = true;

        print('Full Product Map :' +
            fullProductBasicDetailsMap.length.toString());


        if (this.mounted) {
          setState(() {
            storeLoading = false;
            storeLoaded = true;
            storeLoadingSuccessful = true;
          });
        }
      }
    });

  }
  void initState()
  {
    super.initState();
    print('ShowHomePage');

//    if(!fullProductBasicDetailsMapAvailable
//        || !productDiscountDetailsAtAllStoresAvailable
//        || !productStockPositionAtAllStoresAvailable
//        || !productSalePositionAtAllTerminalsAvailable
//      )
//     {
//      loadAllStores();
//     }

//    void checkIfAdmin() {
//      checkingIfAdmin = true;
//      FirebaseDatabase.instance
//          .reference()
//          .child('storeAdmins')
//          .onValue
//          .listen((event) {
//        if (event.snapshot != null && event.snapshot.value != null) {
//          if (event.snapshot.value[mobileNumber] != null &&
//              event.snapshot.value[mobileNumber]['productNode'] != null &&
//              event.snapshot.value[mobileNumber]['inventoryNode'] != null) {
//            productNode =
//                event.snapshot.value[mobileNumber]['productNode'].toString();
//            inventoryNode =
//                event.snapshot.value[mobileNumber]['inventoryNode'].toString();
//            storeName =
//                event.snapshot.value[mobileNumber]['storeName'].toString();
//            storeLocation =
//                event.snapshot.value[mobileNumber]['storeLocation'].toString();
//            storeTerminals =
//                event.snapshot.value[mobileNumber]['storeTerminals'].toString();
//            storeTerminals_List = storeTerminals.split(',');
//            storeTerminals_List.forEach((storeTerminalElement) {
//              FirebaseDatabase
//                  .instance
//                  .reference()
//                  .child('storeTerminals')
//                  .child(storeTerminalElement)
//                  .child('storeName')
//                  .once()
//                  .then((storeNameSnapshot){
//                print(storeTerminalElement + ':' + storeNameSnapshot.value);
//                posTerminalToStoreName[storeTerminalElement] = storeNameSnapshot.value;
//              });
//            });
////            setState(() {
////              isAdmin = true;
////            });
//          }
//        }
////        setState(() {
////          checkingIfAdmin = false;
////        });
//      });
    DateTime now = DateTime.now();
    String dateString  = DateFormat('dd-MM-yyyy').format(now);

    saleAnalysisDay = dateString.substring(0,2);
    saleAnalysisMonth = dateString.substring(3,5);
    saleAnalysisYear  = dateString.substring(6,10);

    print('ShowTerminalWiseSalePosition:initState:year:' + saleAnalysisYear );
    print('ShowTerminalWiseSalePosition:initState:month:' + saleAnalysisMonth );
    print('ShowTerminalWiseSalePosition:initState:day:' + saleAnalysisDay );
    print('ShowTerminalWiseSalePosition:initState:storeName:' + storeName );

    saleAnalysisDate = DateFormat('dd-MM-yyyy').format(now);

  }




//    FirebaseDatabase.instance
//        .reference()
//        .child('storeTerminals')
//        .child('POS_8')
//        .child('sales')
//        .child('productSalePosition')
//        .onValue
//        .listen((event) {
//      if(event != null && event.snapshot != null && event.snapshot.value != null) {
//        event.snapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
//
//          fullProductSalePositionMap[int.parse(productCode.toString())]
//                                          = double.parse(productSnapshot['salePosition'].toString());
//        });
//
//        fullProductSalePositionMapAvailable = true;
//
//        print('Full Sale Position Map :' +
//            fullProductSalePositionMap.length.toString());
//
//
//        if (this.mounted) {
//          setState(() {
//            storeLoading = false;
//            storeLoaded = true;
//            storeLoadingSuccessful = true;
//          });
//        }
//      }
//    });

//    FirebaseDatabase.instance
//        .reference()
//        .child('stores')
//        .child('KIRANAWALA_STORE_8')
//        .child('products')
//        .onValue
//        .listen((event) {
//      if(event != null && event.snapshot != null && event.snapshot.value != null) {
//        event.snapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
//          if(productSnapshot['stockInwards'] != null && productSnapshot['stockInwards']['stockInwardTillDate'] != null)
//            {
////              print(productCode);
////              print(productSnapshot['stockInwards']['stockInwardTillDate'].toString());
//              fullProductStockPositionMap[int.parse(productCode.toString())]
//              = double.parse(productSnapshot['stockInwards']['stockInwardTillDate'].toString());
//            }
//        });
//
//        fullProductStockPositionMapAvailable = true;
//
//        print('Full Stock Position Map :' +
//            fullProductStockPositionMap.length.toString());
//
//
//        if (this.mounted) {
//          setState(() {
//            storeLoading = false;
//            storeLoaded = true;
//            storeLoadingSuccessful = true;
//          });
//        }
//      }
//    });



//    FirebaseDatabase
//        .instance
//        .reference()
//        .child('stores')
//        .child('KIRANAWALA_MASTER')
//        .child('products')
//        .once()
//        .then((productSnapshot){
//      if(productSnapshot != null && productSnapshot.value != null ) {
//        productSnapshot.value.forEach((dynamic productSnapshotKey,
//            dynamic productSnapshotValue) {
//          if (productSnapshotValue['stockInwards'] != null && productSnapshotValue['stockInwards']['invoices'] != null) {
//            productCodes.add(int.parse(productSnapshotKey.toString()));
//          }
//        });
//      }
//
//      productCodes.forEach((int productCode) {
//        FirebaseDatabase
//            .instance
//            .reference()
//            .child('stores')
//            .child('KIRANAWALA_MASTER')
//            .child('products')
//            .child(productCode.toString())
//            .once()
//            .then((productCodeSnapshot){
//              if(productCodeSnapshot != null && productCodeSnapshot.value != null)
//                {
//                  FirebaseDatabase
//                    .instance
//                      .reference()
//                      .child('stores')
//                      .child('KIRANAWALA_STORE_8')
//                      .child('products')
//                      .child(productCode.toString())
//                      .child('basicDetails')
//                      .update(<String, dynamic>{
//                        'productName':productCodeSnapshot.value['title'].toString(),
//                        'productPrice':double.parse(productCodeSnapshot.value['price'].toString()),
//                        'productCode':int.parse(productCodeSnapshot.value['productcode'].toString()),
//                        'productBarcode':productCodeSnapshot.value['barcode'].toString(),
//                        'productImageURL':productCodeSnapshot.value['imageurl'].toString(),
//                        'productCategory':productCodeSnapshot.value['category'].toString(),
//                        'productBrand':productCodeSnapshot.value['brand'].toString(),
//                  });
//
//                }
//        });
//      });
//      print('Product Count to be processed:' + productCodes.length.toString());
//      productCodes.forEach((int productCode) {
//        getProductBasicDetails(productCode.toString());
//        getProductRecentStockInwardDetails(productCode);
//        getProductRecentStockOutwardDetails(productCode);
//      });
//    });

  @override
  Widget build(BuildContext context) {
//    if(fullProductBasicDetailsMapAvailable
//        && productDiscountDetailsAtAllStoresAvailable
//        && productStockPositionAtAllStoresAvailable
//        && productSalePositionAtAllTerminalsAvailable
//      )
//      {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: getTextWidget('ADMIN OPTIONS', 20.0, Colors.black))),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return SelectStore();
                      })).then((dynamic selectedStore){
                        if(selectedStore != null){
                          print(selectedStore.toString());
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                              builder:(BuildContext context){
                                return ResetStore();
                              }
                          ));
                        }
                        else
                        {
                          print('GO BACK');
                        }
                      });
                    },
                    child:Center(child: getTextWidget('RESET STORE', 20.0, Colors.white))
                ),
              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: RaisedButton(
//                    color:Colors.blue,
//                    onPressed: (){
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return SinimaHomePage();
//                      }));
//                    },
//                    child:Center(child: getTextWidget('SINIMA', 20.0, Colors.white))
//                ),
//              ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: RaisedButton(
//                color:Colors.blue,
//                onPressed: (){
//                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                    return StoreStockPosition();
//                  }));
//                },
//                child:Center(child: getTextWidget('STOCK POSITION', 20.0, Colors.white))
//            ),
//          ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: RaisedButton(
//                    color:Colors.blue,
//                    onPressed: (){
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return MultiStoreStockPosition();
//                      }));
//                    },
//                    child:Center(child: getTextWidget('GROUP STOCK POSITION', 20.0, Colors.white))
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: RaisedButton(
//                    color:Colors.blue,
//                    onPressed: (){
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return SearchBarCode();
//                      }));
//                    },
//                    child:Center(child: getTextWidget('SEARCH BARCODE', 20.0, Colors.white))
//                ),
//              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return ShowSalePositionHomePage();
                      }));
                    },
                    child:Center(child: getTextWidget('SALE HISTORY', 20.0, Colors.white))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return StockInwardSummary();
                      }));
                    },
                    child:Center(child: getTextWidget('STOCK INWARD SUMMARY', 20.0, Colors.white))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return ShowTerminalWiseSalePosition();
                      }));
                    },
                    child:Center(child: getTextWidget('STORE SALE POSITION', 20.0, Colors.white))
                ),
              ),
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return OnlineProductLookUp();
                      }));
                    },
                    child:Center(child: getTextWidget('PRODUCT LOOKUP', 20.0, Colors.white))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return InventoryManagerHomePage();
                      }));
                    },
                    child:Center(child: getTextWidget('INVENTORY MANAGER', 20.0, Colors.white))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return StockInwardHomePage();
                      }));
                    },
                    child:Center(child: getTextWidget('STOCK INWARD', 20.0, Colors.white))
                ),
              ),
            ],
          ),
        );
//      }
//    else
//      {
//        return Container(
//          color: Colors.white,
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Container(
//                    width: MediaQuery.of(context).size.width,
//                    child: Center(child: getTextWidget('ADMIN OPTIONS', 20.0, Colors.black))),
//              ),
////              Padding(
////                padding: const EdgeInsets.all(8.0),
////                child: RaisedButton(
////                    color:Colors.blue,
////                    onPressed: (){
////                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
////                        return SelectStore();
////                      })).then((dynamic selectedStore){
////                        if(selectedStore != null){
////                          print(selectedStore.toString());
////                          Navigator.of(context).pop();
////                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
////                              builder:(BuildContext context){
////                                return ResetStore();
////                              }
////                          ));
////                        }
////                        else
////                        {
////                          print('GO BACK');
////                        }
////                      });
////                    },
////                    child:Center(child: getTextWidget('RESET STORE', 20.0, Colors.white))
////                ),
////              ),
////              Padding(
////                padding: const EdgeInsets.all(8.0),
////                child: RaisedButton(
////                    color:Colors.blue,
////                    onPressed: (){
////                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
////                        return SinimaHomePage();
////                      }));
////                    },
////                    child:Center(child: getTextWidget('SINIMA', 20.0, Colors.white))
////                ),
////              ),
////          Padding(
////            padding: const EdgeInsets.all(8.0),
////            child: RaisedButton(
////                color:Colors.blue,
////                onPressed: (){
////                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
////                    return StoreStockPosition();
////                  }));
////                },
////                child:Center(child: getTextWidget('STOCK POSITION', 20.0, Colors.white))
////            ),
////          ),
////              Padding(
////                padding: const EdgeInsets.all(8.0),
////                child: RaisedButton(
////                    color:Colors.blue,
////                    onPressed: (){
////                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
////                        return MultiStoreStockPosition();
////                      }));
////                    },
////                    child:Center(child: getTextWidget('GROUP STOCK POSITION', 20.0, Colors.white))
////                ),
////              ),
////              Padding(
////                padding: const EdgeInsets.all(8.0),
////                child: RaisedButton(
////                    color:Colors.blue,
////                    onPressed: (){
////                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
////                        return SearchBarCode();
////                      }));
////                    },
////                    child:Center(child: getTextWidget('SEARCH BARCODE', 20.0, Colors.white))
////                ),
////              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: RaisedButton(
//                    color:Colors.blue,
//                    onPressed: (){
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return ShowSalePositionHomePage();
//                      }));
//                    },
//                    child:Center(child: getTextWidget('SALE HISTORY', 20.0, Colors.white))
//                ),
//              ),
////              Padding(
////                padding: const EdgeInsets.all(8.0),
////                child: RaisedButton(
////                    color:Colors.blue,
////                    onPressed: (){
////                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
////                        return ShowTerminalWiseSalePosition();
////                      }));
////                    },
////                    child:Center(child: getTextWidget('STORE DAILY SALE', 20.0, Colors.white))
////                ),
////              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: RaisedButton(
//                    color:Colors.blue,
//                    onPressed: (){
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return StockInManagerOnline();
//                      }));
//                    },
//                    child:Center(child: getTextWidget('STOCK INWARD', 20.0, Colors.white))
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: RaisedButton(
//                    color:Colors.blue,
//                    onPressed: (){
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return StockInwardSummary();
//                      }));
//                    },
//                    child:Center(child: getTextWidget('STOCK INWARD SUMMARY', 20.0, Colors.white))
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: RaisedButton(
//                    color:Colors.blue,
//                    onPressed: (){
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return ShowTerminalWiseSalePosition();
//                      }));
//                    },
//                    child:Center(child: getTextWidget('STORE SALE POSITION', 20.0, Colors.white))
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: RaisedButton(
//                    color:Colors.blue,
//                    onPressed: (){
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return OnlineProductLookUp();
//                      }));
//                    },
//                    child:Center(child: getTextWidget('PRODUCT LOOKUP', 20.0, Colors.white))
//                ),
//              ),
////              Padding(
////                padding: const EdgeInsets.all(8.0),
////                child: Container(
////                  color: Colors.white,
////                  child: Dialog(
////                    child: new Row(
////                      mainAxisSize: MainAxisSize.min,
////                      children: [
////                        Expanded(
////                            flex:2,
////                            child: new CircularProgressIndicator()
////                        ),
////                        SizedBox(width:10.0),
////                        Expanded(
////                            flex:12,
////                            child: Text("Loading Stock Position...,",
////                                style:TextStyle(
////                                  fontFamily: 'Montserrat',
////                                  fontSize:12.0,
////                                  fontWeight: FontWeight.bold,
////                                )
////                            )
////                        ),
////                      ],
////                    ),
////                  ),
////                )
////              ),
//            ],
//          ),
//        );
//
//      }
  }
}