import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-check-if-admin.dart';
//import 'package:kiranawala_admin/pages/stock-inward/stock-inward-check-if-admin.dart';
//import 'package:kiranawala_admin/pages/stock-inward/stock-inward-check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-load-categories.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-show-all-categories.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:kiranawala_admin/pages/stock-inward-store-stock-position.dart';

import '../show-admin-home-page.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';


//int skuToUpdate;
//String productUpdateStatus = 'FAILURE';
//bool fullProductBasicDetailsMapAvailable = false;
//Map<String, dynamic> categoryNameCategoryDetailsMap = <String, dynamic>{};
//Map<String, dynamic> homeCategoryNameCategoryDetailsMap = <String, dynamic>{};
//List<dynamic> homeCategories = <dynamic>[];
//List<dynamic> categoryList = List<dynamic>();
//class Brand {
//  const Brand(this.brandId, this.brandName);
//  final String brandId;
//  final String brandName;
//}
//
//class Category {
//  const Category(this.categoryId, this.categoryName);
//  final String categoryId;
//  final String categoryName;
//}

//List<Brand> brands = List<Brand>();
//List<Category> categories = List<Category>();

//bool retrievingBrands = false;
//bool retrievingCategories = false;

//List<Brand> brandSearchResults = List<Brand>();
//List<Category> categorySearchResults = List<Category>();

String updatedName = '';
String selectedStatus = 'ACTIVE';
int previousSearchResultIndex = 0;

bool checkingIfAdmin = false;

String newProductName = 'PRODUCT NAME';
double newProductPrice = 1.0;
int nextProductCode;
String nextBarCode = '';

Map<int, double> productSalePositionTillDateMap = new Map();
Map<int, double> productInventoryTillDateMap = new Map();
Map<int, dynamic> productSalePositionMap = new Map<int,dynamic>();
List<dynamic> productSalePositionList = new List<dynamic>();


List<dynamic> stockInwardsProductList = List<dynamic>();
Map<String,dynamic> stockInwardProductMap = Map<String,dynamic>();
double stockInwardTotalQty = 0;
double stockInwardTotalValue = 0;
String stockInwardDate = '';
List<String> duplicates = List<String>();
bool loadingStockInwardSummaryForDate = false;


class StockInwardHomePage extends StatefulWidget {
  @override
  _StockInwardHomePageState createState() => _StockInwardHomePageState();
}

class _StockInwardHomePageState extends State<StockInwardHomePage> {


  void loadProductBasicDetails()
  {
  fullProductBasicDetailsMapAvailable = false;

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
//                (productSnapshot['status'] != null)
//                    ? productSnapshot['status'].toString().toUpperCase()
//                    : 'INACTIVE',
                'ACTIVE',
                (productSnapshot['productParent'] != null)
                    ? productSnapshot['productParent']
                    : 'N/A',
                (productSnapshot['productCreationTimeStamp'] != null)
                    ? productSnapshot['productCreationTimeStamp']
                    : 'N/A'
            );
//            if(product.productStatus == 'ACTIVE')
//            {
              activeProductBasicDetailsMap[int.parse(productCode.toString())] = product;
              activeProductBasicDetailsList.add(product);
//            }
            fullProductBasicDetailsMap[int.parse(productCode.toString())] =
                product;
            fullProductBasicDetailsList.add(product);
          }
        });
      }
      barCodeSearchResultsMap = activeProductBasicDetailsMap;

        fullProductBasicDetailsMapAvailable = true;

        print('Full Product Map :' +
            fullProductBasicDetailsMap.length.toString());


        if (this.mounted) {
          setState(() {
          });
        }
    });

  }


  void getActiveCategoriesFromStore() {
//    print("getActiveCategoriesFromStore:storeId");
//    print(inventoryNode);

    categoryNameCategoryDetailsMap = <String, dynamic>{};
    homeCategoryNameCategoryDetailsMap = <String, dynamic>{};
    homeCategories = <dynamic>[];
    categoryList = <dynamic>[];

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(inventoryNode)
        .child('categoriesMaster')
        .once()
        .then((snapshot) {
      if (snapshot != null && snapshot.value != null) {
//        print("getActiveCategoriesFromStore:snapshot.value");
//        print(snapshot.value.length);
//        print(snapshot.value);
        categoryList = snapshot.value;
        int index = 0;
        categoryList.forEach((dynamic categoryDetails) {
//          print(categoryDetails);
          if (categoryDetails['categoryId'] != null &&
              categoryDetails['categoryImage'] != null &&
              categoryDetails['displayPosition'] != null &&
              categoryDetails['displayName'] != null &&
              categoryDetails['isActive'] != null &&
              categoryDetails['isParent'] != null) {
            if (categoryDetails['isActive'] == 'YES')
            {
            categoryNameCategoryDetailsMap[categoryDetails['categoryName']] =
                categoryDetails;
              if (categoryDetails['isParent'] == 'YES') {
                if (categoryDetails['subCategories'] != null) {
                  homeCategories.add(categoryDetails);
                  homeCategoryNameCategoryDetailsMap[
                  categoryDetails['categoryName']] = categoryDetails;
                }
              }
            }
          }
          categoryIndexCategoryDetailsMap[index] = categoryDetails;
          index = index + 1;
        });

//        print(categoryIndexCategoryDetailsMap);
        homeCategories.sort((dynamic a, dynamic b) {
          return a['displayPosition'].compareTo(b['displayPosition']);
        });
      }
//      print('categoryNameCategoryDetailsMap');
//      print(categoryNameCategoryDetailsMap);
    });
  }

  void getProductDiscountDetails()
  {
    print(inventoryNode);
    fullProductDiscountMap = new Map();
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(inventoryNode)
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
      }
      productDiscountDetailsAvailable = true;
//      print(fullProductDiscountMap);
//          print(discountsProcessed);
//          print(storeIdMap.length);
        if (this.mounted) {
          setState(() {
//            print('Discount Details loaded.');
          });


//            print(fullProductDiscountDetailsAtStore);
//            print(fullProductDiscountDetailsAtStore.length);
//            fullProductDiscountDetailsAtStore.forEach((key, value) {
//              print(key);
//            });
      }
    });
  }



  Future<String> getMobileNumber() async
  {
    var _preferences = await SharedPreferences.getInstance();
    mobileNumber = _preferences.getString('mobileNumber');
//    print(mobileNumber);
    if(mobileNumber == null)
    {
//      print('mobile number is null.returning empty string!!');
      return '';
    }
    else
    {
//      print('phone number found' + mobileNumber.toString());
      return mobileNumber.toString();
    }
  }

  Future<String> getValueFromSharedPreference(String sharedPreferenceKey) async{
    var _preferences = await SharedPreferences.getInstance();
    var sharedPreferenceValue = _preferences.getString(sharedPreferenceKey);
    print(sharedPreferenceValue);
    if(sharedPreferenceValue == null)
    {
      print('getValueFromSharedPreference:'+ sharedPreferenceKey + ' is null.returning empty string!!');
      return '';
    }
    else
    {
      print('getValueFromSharedPreference:'+ sharedPreferenceKey + ' is ' + sharedPreferenceValue);
      print(sharedPreferenceValue);
      return sharedPreferenceValue.toString();
    }
  }
  Future<bool> setValueInSharedPreference(String sharedPreferenceKey, String sharedPreferenceValue) async{
    var _preferences = await SharedPreferences.getInstance();
    return _preferences.setString(sharedPreferenceKey,sharedPreferenceValue);
  }

  void getStockInwardForDate()
  {
    stockInwardsProductList = List<dynamic>();
    stockInwardTotalQty = 0;
    stockInwardTotalValue = 0;
    setState(() {
      loadingStockInwardSummaryForDate = true;
    });
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_2')
        .child('stockInwards')
        .child(stockInwardDate)
        .once()
        .then((stockInwardsForDateSnapshot){
      print(stockInwardsForDateSnapshot.value);
      if(stockInwardsForDateSnapshot != null && stockInwardsForDateSnapshot.value != null)
      {
        stockInwardsForDateSnapshot.value.forEach((dynamic key, dynamic stockInwardProduct) {
          stockInwardsProductList.add(<String, dynamic>{
            'productCode': stockInwardProduct['productCode'],
            'productBarCode':stockInwardProduct['productBarCode'],
            'productName': stockInwardProduct['productName'],
            'productPrice': stockInwardProduct['productPrice'],
            'stockInwardQty': stockInwardProduct['stockInwardQty'],
          });
          stockInwardTotalQty = stockInwardTotalQty + double.parse(stockInwardProduct['stockInwardQty'].toString());
          stockInwardTotalValue = stockInwardTotalValue +
              (double.parse(stockInwardProduct['productPrice'].toString()) *
                  double.parse(stockInwardProduct['stockInwardQty'].toString()) );
        });

        print('No.Of Products:' + stockInwardsProductList.length.toString());
        print('Total No. Of Units:' + stockInwardTotalQty.toString());
        print('Total Value:' + stockInwardTotalValue.toString());
        print(stockInwardsProductList);
        setState(() {
          loadingStockInwardSummaryForDate = false;
        });
      }
      else
      {
        setState(() {
          loadingStockInwardSummaryForDate = false;
        });
      }
    });
  }


  void getProductSalePositionTillDate()
  {
    FirebaseDatabase.instance
        .reference()
        .child('storeTerminals')
        .child(posTerminal)
        .child('sales')
        .child('productSalePosition')
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (snapshot.value != null) {
        values.forEach((dynamic key,dynamic value){
          productSalePositionTillDateMap[int.parse(key.toString())] = double.parse(value['salePosition'].toString());
          productSalePositionMap[int.parse(key.toString())] = value;
          print(key.toString()  + ':' + value['productName'].toString() + ':' + value['salePosition'].toString());
        });
        print('Product Sale Position:' + productSalePositionTillDateMap.length.toString());
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inventoryNode = 'KIRANAWALA_STORE_11';
    productNode = 'KIRANAWALA_STORE_11';
    posTerminal = 'POS_11';
//    checkingIfAdmin = false;
//    getProductSalePositionTillDate();

    print('Product Node:' + productNode);
//      getValueFromSharedPreference('mobileNumber').then((value) {
//        if (value != '') {
//          print('getValueFromSharedPreference:mobileNumber' + value);
//          setState(() {
//            mobileNumber = value;
//            FirebaseDatabase.instance
//                .reference()
//                .child('storeAdmins')
//                .onValue
//                .listen((event) {
//              if (event.snapshot != null && event.snapshot.value != null) {
//                if (event.snapshot.value[mobileNumber] != null &&
//                    event.snapshot.value[mobileNumber]['productNode'] != null &&
//                    event.snapshot.value[mobileNumber]['inventoryNode'] != null
//                    &&
//                    event.snapshot.value[mobileNumber]['userId'] != null &&
//                    event.snapshot.value[mobileNumber]['latestSKU'] != null) {
//                  productNode =
//                      event.snapshot.value[mobileNumber]['productNode'].toString();
//                  print('Product Node:' + productNode);
//                  inventoryNode =
//                      event.snapshot.value[mobileNumber]['inventoryNode'].toString();
//                  print('Inventory Node:' + inventoryNode);
//                  userId = event.snapshot.value[mobileNumber]['userId'].toString();
//                  print('User ID:' + userId);
//                  latestSKU = int.parse(event.snapshot.value[mobileNumber]['latestSKU'].toString());
//                  nextSKU = latestSKU + 1;
//                  print('Latest SKU:' + latestSKU.toString());
//                  print('Next SKU:' + nextSKU.toString());
//          storeTerminals =
//              event.snapshot.value[mobileNumber]['storeTerminals'].toString().split(',');
//          print(inventoryNode);
//          terminalsAvailableAtStore[inventoryNode] = storeTerminals.length;
//          print(storeTerminals);
//          storeTerminals.forEach((terminal) {
//            posTerminalToStoreName[terminal] = storeName;
//            posTerminalToStoreIdMap[terminal] = inventoryNode;
//          });
//          print(terminalsAvailableAtStore[inventoryNode]);
//          print(posTerminalToStoreName);
//          print(posTerminalToStoreIdMap);

//          storeTerminals_List = storeTerminals.split(',');
//          stores.forEach((storeElement) {
//            storeIdTerminalMap[storeElement].toList().forEach((storeTerminal) {
//              storeTerminals.add(storeTerminal);
//            });
//          });
//                  print(storeTerminals);
//          storeTerminals.forEach((storeTerminalElement) {
//            FirebaseDatabase
//            .instance
//                .reference()
//                .child('storeTerminals')
//                .child(storeTerminalElement)
//                .child('storeName')
//                .once()
//                .then((storeNameSnapshot){
//                  print(storeTerminalElement + ':' + storeNameSnapshot.value);
//                  posTerminalToStoreName[storeTerminalElement] = storeNameSnapshot.value;
//            });
//          });

//              if(!fullProductBasicDetailsMapAvailable
//                  || !productDiscountDetailsAtAllStoresAvailable
//                  || !productStockPositionAtAllStoresAvailable
//                  || !productSalePositionAtAllTerminalsAvailable
//              )
//              {
//                loadAllStores();
//              }
//                  setValueInSharedPreference('mobileNumber', mobileNumber);
                  if(!fullProductBasicDetailsMapAvailable)
                  {
                    loadProductBasicDetails();
                    getProductDiscountDetails();
//      getActiveCategoriesFromStore();
                  }
//                  Navigator.of(context).pop();
//                  Navigator.of(context).push<dynamic>(
//                      MaterialPageRoute<dynamic>(
//                          builder:(BuildContext context){
//                            return StockInwardHomePage();
//                          }
//                      )
//                  );

                }
//              }
//              setState(() {
//                checkingIfAdmin = false;
//              });
//            });
//          });
//        }
//        else {
//          Navigator.of(context).push<dynamic>(
//              MaterialPageRoute<dynamic>(builder: (BuildContext context) {
//                return RequestMobileNumber();
//              })).then((dynamic value) {
//            if (value
//                .toString()
//                .length != 0) {
//              print('getMobileNumber:' + value);
//              setState(() {
//                mobileNumber = value.toString();
//                FirebaseDatabase.instance
//                    .reference()
//                    .child('storeAdmins')
//                    .onValue
//                    .listen((event) {
//                  if (event.snapshot != null && event.snapshot.value != null) {
//                    if (event.snapshot.value[mobileNumber] != null &&
//                        event.snapshot.value[mobileNumber]['productNode'] != null &&
//                        event.snapshot.value[mobileNumber]['inventoryNode'] != null
//                        &&
//                        event.snapshot.value[mobileNumber]['userId'] != null &&
//                        event.snapshot.value[mobileNumber]['latestSKU'] != null) {
//                      productNode =
//                          event.snapshot.value[mobileNumber]['productNode'].toString();
//                      print('Product Node:' + productNode);
//                      inventoryNode =
//                          event.snapshot.value[mobileNumber]['inventoryNode'].toString();
//                      print('Inventory Node:' + inventoryNode);
//                      userId = event.snapshot.value[mobileNumber]['userId'].toString();
//                      print('User ID:' + userId);
//                      latestSKU = int.parse(event.snapshot.value[mobileNumber]['latestSKU'].toString());
//                      nextSKU = latestSKU + 1;
//                      print('Latest SKU:' + latestSKU.toString());
//                      print('Next SKU:' + nextSKU.toString());
//                      storeName =
//                          event.snapshot.value[mobileNumber]['storeName'].toString();
//                      print('Store Name:' + storeName);
//                      storeLocation =
//                          event.snapshot.value[mobileNumber]['storeLocation'].toString();
//                      print('Store Location:' + storeLocation);
//                      stores = event.snapshot.value[mobileNumber]['stores'].toString().split(',');
//                      print(stores);
//                      storeCount = stores.length;
//                      selectedStore = stores[0];
////                      print(storeIdTerminalMap);
////                      storeTerminals = [];
////                      stores.forEach((store) {
////                        print(store);
////                        storeIdTerminalMap[store].forEach((terminal) {
////
////                          print(terminal);
////                          if(!storeTerminals.contains(terminal))
////                          {
////                            storeTerminals.add(terminal);
////                          }
////                        });
////                      });
////          storeTerminals =
////              event.snapshot.value[mobileNumber]['storeTerminals'].toString().split(',');
////          print(inventoryNode);
////          terminalsAvailableAtStore[inventoryNode] = storeTerminals.length;
////          print(storeTerminals);
////          storeTerminals.forEach((terminal) {
////            posTerminalToStoreName[terminal] = storeName;
////            posTerminalToStoreIdMap[terminal] = inventoryNode;
////          });
////          print(terminalsAvailableAtStore[inventoryNode]);
////          print(posTerminalToStoreName);
////          print(posTerminalToStoreIdMap);
//
////          storeTerminals_List = storeTerminals.split(',');
////          stores.forEach((storeElement) {
////            storeIdTerminalMap[storeElement].toList().forEach((storeTerminal) {
////              storeTerminals.add(storeTerminal);
////            });
////          });
////                      print(storeTerminals);
////          storeTerminals.forEach((storeTerminalElement) {
////            FirebaseDatabase
////            .instance
////                .reference()
////                .child('storeTerminals')
////                .child(storeTerminalElement)
////                .child('storeName')
////                .once()
////                .then((storeNameSnapshot){
////                  print(storeTerminalElement + ':' + storeNameSnapshot.value);
////                  posTerminalToStoreName[storeTerminalElement] = storeNameSnapshot.value;
////            });
////          });
//
////              if(!fullProductBasicDetailsMapAvailable
////                  || !productDiscountDetailsAtAllStoresAvailable
////                  || !productStockPositionAtAllStoresAvailable
////                  || !productSalePositionAtAllTerminalsAvailable
////              )
////              {
////                loadAllStores();
////              }
//                      setValueInSharedPreference('mobileNumber', mobileNumber);
//
//                      if(!fullProductBasicDetailsMapAvailable)
//                      {
//                        loadProductBasicDetails();
//                        getProductDiscountDetails();
//                        getProductBrands();
//                        getProductCategories();
//                        getActiveCategoriesFromStore();
//                        getCategoriesMaster();
////      getActiveCategoriesFromStore();
//                      }
//                    }
//                  }
//                  setState(() {
//                    checkingIfAdmin = false;
//                  });
//                });
//              });
//            }
//          });
//        }
//      });


//  }
  @override
  Widget build(BuildContext context) {
    if(fullProductBasicDetailsMapAvailable && !retrievingBrands && !retrievingCategories){
      return WillPopScope(
          onWillPop: (){
//            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return StockInwardHomePage();
                }
              )
            );
            return;
          },
          child:Scaffold(
              appBar: AppBar(
                  automaticallyImplyLeading:  false,
                  centerTitle:true,
                  title: Text('Inventory Manager',
                      style:TextStyle(
                          fontSize:18.0,
                          fontWeight:FontWeight.bold,
                          color:Colors.white,
                          fontFamily: 'Montserrat'
                      )
                  ),
//                  leading:IconButton(
//                      icon:Icon(Icons.keyboard_backspace),
//                      onPressed:(){
//                        Navigator.of(context).pop();
//                      }
//                  )
              ),
              body:Container(
                  color:Colors.white,
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex:6,
                                child:Text(
                                  'No. Of. SKUs:',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                            Expanded(
                                flex:2,
                                child:Text(
                                  fullProductBasicDetailsMap.length.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex:6,
                                child:Text(
                                  'No. Of. Units:',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                            Expanded(
                                flex:2,
                                child:Text(
                                  'N/A',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex:6,
                                child:Text(
                                  'No. Of. ACTIVE Products:',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                            Expanded(
                                flex:2,
                                child:Text(
                                  'N/A',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex:6,
                                child:Text(
                                  'No. Of. ONLINE Products:',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                            Expanded(
                                flex:2,
                                child:Text(
                                  'N/A',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex:6,
                                child:Text(
                                  'No. Of. Discounted Products:',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                            Expanded(
                                flex:2,
                                child:Text(
                                  fullProductDiscountMap.length.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex:6,
                                child:Text(
                                  'Total MRP Value:',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                            Expanded(
                                flex:2,
                                child:Text(
                                  'N/A',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex:6,
                                child:Text(
                                  'No. Of. Active Categories:',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                            Expanded(
                                flex:2,
                                child:Text(
                                  'N/A',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex:6,
                                child:Text(
                                  'No. Of. Brands:',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                            Expanded(
                                flex:2,
                                child:Text(
                                  'N/A',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight:FontWeight.bold,
                                      fontSize:14.0,
                                      color:Colors.black
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: RaisedButton(
//                            color:Colors.blue,
//                            onPressed:(){
//                              Navigator.of(context).pop();
//                              Navigator.of(context).push<dynamic>(
//                                  MaterialPageRoute<dynamic>(
//                                      builder:(BuildContext context){
//                                        return ProductLookUp();
//                                      }
//                                  )
//                              );
//                            },
//                            child:Text(
//                              'PRODUCT MANAGER',
//                              style: TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontWeight:FontWeight.bold,
//                                  fontSize:14.0,
//                                  color:Colors.white
//                              ),
//                            )
//                        ),
//                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            color:Colors.blue,
                            onPressed:(){
                              Navigator.of(context).pop();
                              Navigator.of(context).push<dynamic>(
                                  MaterialPageRoute<dynamic>(
                                      builder:(BuildContext context){
                                        return StockInwardShowAllCategories();
                                      }
                                  )
                              );
                            },
                            child:Text(
                              'PRODUCT MANAGER',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight:FontWeight.bold,
                                  fontSize:14.0,
                                  color:Colors.white
                              ),
                            )
                        ),
                      )

                    ],
                  )
              )
          )
      );
    }
    else
      {
        return WillPopScope(
            onWillPop: (){
//              Navigator.of(context).pop();
//              Navigator.of(context).push<dynamic>(
//                MaterialPageRoute<dynamic>(
//                  builder:(BuildContext context){
//                    return StockInwardCheckIfAdmin();
//                  }
//                )
//              );
              return;
            },
            child:Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading:  false,
                    centerTitle:true,
                    title: Text('Inventory Manager',
                        style:TextStyle(
                            fontSize:18.0,
                            fontWeight:FontWeight.bold,
                            color:Colors.white,
                            fontFamily: 'Montserrat'
                        )
                    ),
//                    leading:IconButton(
//                        icon:Icon(Icons.keyboard_backspace),
//                        onPressed:(){
////                          Navigator.of(context).pop();
//                          Navigator.of(context).push<dynamic>(
//                              MaterialPageRoute<dynamic>(
//                                  builder:(BuildContext context){
//                                    return StockInwardCheckIfAdmin();
//                                  }
//                              )
//                          );
//                        }
//                    )
                ),
                body:
                new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisSize: MainAxisSize.min,
                  children: [
                    new LinearProgressIndicator(),
                    SizedBox(width:10.0),
                    Text("Retrieving Data....."),
                  ],
                ),
            )
        );
      }

  }
}
