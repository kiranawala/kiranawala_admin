import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';
import 'request-mobile-number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:io' show Platform;
import 'package:store_redirect/store_redirect.dart';

Map<String, dynamic> saleDetailsAtTerminal = Map<String, dynamic>();
Map<String, dynamic> saleDetailsAtStore = Map<String, dynamic>();
Map<String, dynamic> saleDetailsPerTerminalByDate = Map<String, dynamic>();


num cartTotal = 0.0;
num productCount = 0;
num itemCount = 0;

class CartProduct {
  String productName;
  String productID;
  String productBarCode;
  String productImageURL;
  num productPrice;
  num qtyInCart;

  CartProduct(this.productName, this.productID, this.productBarCode,
      this.productPrice, this.productImageURL, this.qtyInCart);
}

List<CartProduct> cartProducts = <CartProduct>[];
Map<String, CartProduct> cartProductMap = <String, CartProduct>{};

int terminalCount = 0;
int terminalsProcessed = 0;
bool storeSalePositionAvailable = false;
bool onlineSalePositionAvailable = false;
double totalSaleForSelectedDate = 0.0;
int totalWalkinsForSelectedDate = 0;

Map<String, int> terminalsAvailableAtStore = Map<String, int>();
Map<String, int> terminalsProcessedAtStore = Map<String, int>();
Map<String, bool> isStoreProcessed = Map<String, bool>();
Map<String, double> salePositionAtStore = Map<String, double>();
Map<String, int> walkinsAtStore = Map<String, int>();

int storeCount = 0;
int storesProcessed = 0;

String selectedOnlineSalePositionDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
String selectedOnlineSalePositionDay = selectedOnlineSalePositionDate.substring(0,2);
String selectedOnlineSalePositionMonth = selectedOnlineSalePositionDate.substring(3,5);
String selectedOnlineSalePositionYear  = selectedOnlineSalePositionDate.substring(6,10);

int skuToUpdate;
String productName;
String barCode;
String productUpdateStatus = 'FAILURE';
bool fullProductBasicDetailsMapAvailable = false;
Map<String, dynamic> categoryNameCategoryDetailsMap = <String, dynamic>{};
Map<int, dynamic> categoryIndexCategoryDetailsMap = <int, dynamic>{};

Map<String, dynamic> homeCategoryNameCategoryDetailsMap = <String, dynamic>{};
List<dynamic> homeCategories = <dynamic>[];
List<dynamic> categoryList = List<dynamic>();

//String productNode  = '';
//String inventoryNode = '';
String storeName = '';
String storeLocation = '';
//String storeTerminals = '';
List<String> storeTerminals = List<String>();
List<String> stores = List<String>();
String selectedStore = '';
String selectedBrand = '';
String selectedCategory = '';

Map<String, List<ProductBasicDetails>> categoryProductListMap = new Map<String, List<ProductBasicDetails>>();
Map<String, Map<String, ProductBasicDetails>> categoryProductNameMap = new Map();
//Map<String, ProductBasicDetails> productMap = new Map<String,ProductBasicDetails>();
List<String> productNames = new List();
List<ProductBasicDetails> allProducts = new List<ProductBasicDetails>();
Map<String, bool> categoryProductsAvailable = new Map<String, bool>();
List<ProductBasicDetails> productsForCategory = new List<ProductBasicDetails>();

Map<String, dynamic> orderMap = new Map<String, dynamic>();
Map<dynamic, dynamic> billsAtTerminalForSelectedDate = Map<dynamic, dynamic>();

double cashSale = 0;
double cardSale = 0;
double upiSale = 0;
double eWalletSale = 0;
double foodCardSale = 0;
bool retrievingStoreSalePosition = true;
bool retrievingOnlineSalePosition = true;

bool storeLoading = true;
bool storeLoaded = false;
bool storeLoadingSuccessful = false;
bool retrievingProductDetails = false;

String selectedCategoryName = 'NOCATEGORY';
String selectedBrandName = 'NOBRAND';
String selectedImageURL = 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad';


//bool fullProductBasicDetailsMapAvailable = false;
bool productDiscountDetailsAtAllStoresAvailable = false;
bool productStockPositionAtAllStoresAvailable = false;
bool fullProductSalePositionMapAvailable = false;
bool fullProductStockPositionMapAvailable = false;
bool productSalePositionAtAllTerminalsAvailable = false;
bool productDiscountDetailsAvailable = false;


List<String> productBrands = List<String>();
List<String> productCategories = List<String>();


class ProductDiscountDetails {
  num discount;
  String discountStartDate;
  String discountEndDate;
  String discountStatusChangeTimeStamp;
  bool isDiscountActive;
  String discountType;
  int productCode;


  ProductDiscountDetails(
      num discount,
      String discountStartDate,
      String discountEndDate,
      String discountStatusChangeTimeStamp,
      bool isDiscountActive,
      String discountType,
      int productCode
      ) {
    this.discount = discount;
    this.discountStartDate = discountStartDate;
    this.discountEndDate = discountEndDate;
    this.discountStatusChangeTimeStamp = discountStatusChangeTimeStamp;
    this.isDiscountActive = isDiscountActive;
    this.discountType = discountType;
    this.productCode = productCode;
  }
}

class CategoryDetails{
  String categoryId;
  String categoryName;
  String categoryImage;
  String displayName;
  int displayPosition;
  String isActive;
  String isParent;

  CategoryDetails(
      String categoryId,
      String categoryName,
      String categoryImage,
      String displayName,
      int displayPosition,
      String isActive,
      String isParent) {
    this.categoryId = categoryId;
    this.categoryName = categoryName;
    this.categoryImage = categoryImage;
    this.displayName = displayName;
    this.displayPosition = displayPosition;
    this.isActive = isActive;
    this.isParent  = isParent;
  }
}


class ProductBasicDetails {
  String productName;
  int productID;
  String productBarCode;
  num productPrice;
  String productImageURL;
  String productCategory;
  String productBrand;
  String productStatus;
  String productParentStore;
  String productCreationTimeStamp;


  ProductBasicDetails(
      String productName,
      num productPrice,
      int productID,
      String productBarCode,
      String productImageURL,
      String productCategory,
      String productBrand,
      String productStatus,
      String productParentStore,
      String productCreationTimeStamp
      ) {
    this.productName = productName;
    this.productPrice = productPrice;
    this.productID = productID;
    this.productBarCode = productBarCode;
    this.productImageURL = productImageURL;
    this.productCategory = productCategory;
    this.productBrand = productBrand;
    this.productStatus = productStatus;
    this.productParentStore = productParentStore;
    this.productCreationTimeStamp = productCreationTimeStamp;
  }
}

class Brand {
  const Brand(this.brandId, this.brandName);
  final String brandId;
  final String brandName;
}

class Category {
  Category(num categoryId, String categoryName){
    this.categoryId = categoryId;
    this.categoryName = categoryName;
  }
   num categoryId;
   String categoryName;
}

Map<dynamic,dynamic> stockInward = Map<dynamic, dynamic>();

Map<String,double> stockInwardByDate = Map<String, double>();
Map<String, double> stockOutwardByDate = Map<String, double>();
Map<String, double> terminalSalePosition = Map<String, double>();
Map<String,double> productSalePosition = Map<String, double>();
Map<String,double> productStockInward = Map<String, double>();

Map<dynamic, dynamic> productSalePositionByDateAtTerminal = Map<dynamic, dynamic>();

Map<String, double> salePositionAtTerminal = Map<String, double>();
Map<String, int> walkinsAtTerminal = Map<String, int>();

List<Category> categories = [];
List<String> categorySearchResults = [];
List<CategoryDetails> categoryMaster = [];
String categoryName = 'SELECT CATEGORY';
//Category selectedCategory;
bool retrievingCategories = false;
bool stockInwardUploadSuccessful = true;


String brandName = 'SELECT BRAND';

List<Brand> brands = [];
List<String> brandSearchResults = [];
//Category selectedCBrand;
bool retrievingBrands = false;

Map<String, double> salePositionForProductCode = Map<String, double>();
Map<String, double> stockInwardForProductCode = Map<String, double>();
Map<String, double> recentStockInwardQtyForProductCode = Map<String, double>();
Map<String, String> recentStockInwardDateForProductCode = Map<String, String>();
Map<String, String> recentStockInwardTimeForProductCode = Map<String, String>();
Map<String, double> recentStockOutwardQtyForProductCode = Map<String, double>();
Map<String, String> recentStockOutwardDateForProductCode = Map<String, String>();
Map<String, String> recentStockOutwardTimeForProductCode = Map<String, String>();


List<ProductBasicDetails> barCodeSearchResults = new List<ProductBasicDetails>();
String barCodeToSearch = '';

Map<int, ProductBasicDetails> barCodeSearchResultsMap = new Map();
Map<int, ProductBasicDetails> lookupMap = new Map();
List<ProductBasicDetails> lookupList = new List<ProductBasicDetails>();
String lookupText = '';

Map<int, ProductBasicDetails> productMap = new Map();


Map<int, ProductBasicDetails> fullProductBasicDetailsMap = new Map();
List<ProductBasicDetails> fullProductBasicDetailsList = new List();

Map<int, ProductBasicDetails> activeProductBasicDetailsMap = new Map();
List<ProductBasicDetails> activeProductBasicDetailsList = new List();

Map<int, ProductDiscountDetails> fullProductDiscountMap = new Map();
List<ProductDiscountDetails> fullProductDiscountList = new List();

Map<int, double> fullProductSalePositionMap = new Map();
Map<int, double> fullProductStockPositionMap = new Map();

Map<String, Map<int, ProductBasicDetails>> fullProductBasicDetailsAtStore = new Map();
Map<String, Map<int, ProductDiscountDetails>> fullProductDiscountDetailsAtStore = new Map();
Map<String, Map<int, double>> fullProductStockPositionAtStore = new Map();
Map<String, Map<int, double>> fullProductSalePositionAtStore = new Map();
Map<String, Map<int, double>> fullProductSalePositionAtTerminal = new Map();


Map<String, bool> salePositionForTerminalAvailable = new Map();
Map<String, bool> salePositionForTerminalProcessed = new Map();
Map<String, bool> storeStockPositionAvailable = new Map();


int discountsProcessed = 0;
int stockPositionProcessed = 0;
int salePositionProcessed = 0;

List<String> allTerminals =  List<String>();

//Map<int, double> fullProductSalePositionMap = new Map();
//Map<int, double> fullProductStockPositionMap = new Map();

//Map<String, Map<int, ProductBasicDetails>> fullProductBasicDetailsAtStore = new Map();
//Map<String, Map<int, ProductDiscountDetails>> fullProductDiscountDetailsAtStore = new Map();
//Map<String, Map<int, double>> fullProductStockPositionAtStore = new Map();
//Map<String, Map<int, double>> fullProductSalePositionAtStore = new Map();
//Map<String, Map<int, double>> fullProductSalePositionAtTerminal = new Map();
//
//
//Map<String, bool> salePositionForTerminalAvailable = new Map();
//Map<String, bool> salePositionForTerminalProcessed = new Map();
//Map<String, bool> storeStockPositionAvailable = new Map();
//
bool stockPositionAvailable = false;
bool discountDetailsAvailable = false;
bool salePositionAtAllTerminalsAvailable = false;


//int discountsProcessed = 0;
//int stockPositionProcessed = 0;
//int salePositionProcessed = 0;
//
//List<String> allTerminals =  List<String>();
//
//
//bool storeLoading = true;
//bool storeLoaded = false;
//bool storeLoadingSuccessful = false;


//bool fullProductBasicDetailsMapAvailable = false;
//bool productDiscountDetailsAtAllStoresAvailable = false;
//bool productStockPositionAtAllStoresAvailable = false;
//bool fullProductSalePositionMapAvailable = false;
//bool fullProductStockPositionMapAvailable = false;
//
//bool retrievingBrands = false;
//bool retrievingCategories = false;
//

Map<String, List<String>> storeIdTerminalMap = Map<String, List<String>>();
Map<String, List<String>> storeTerminalMap = Map<String, List<String>>();
Map<String, String> storeIdMap = Map<String, String>();
Map<String, String> posTerminalToStoreName = Map<String, String>();
Map<String, String> posTerminalToStoreIdMap = Map<String, String>();
Map<String, String> storeIdNameMap = Map<String, String>();


void loadStoreDetails(){
  FirebaseDatabase
    .instance
    .reference()
    .child('storeDetails')
    .once()
    .then((storeDetailsSnapshot){
//      print(storeDetailsSnapshot);
      if(storeDetailsSnapshot != null && storeDetailsSnapshot.value != null){
        storeDetailsSnapshot.value.forEach((dynamic storeId, dynamic storeDetails){
//          print(storeId.toString());
//          print(storeDetails['storeId'].toString());
//          print(storeDetails['storeName'].toString());
//          print(storeDetails['storeTerminals'].toString());
          storeIdTerminalMap[storeId] = storeDetails['storeTerminals'].split(',');
          storeIdMap[storeDetails['storeName'].toString()] = storeDetails['storeId'].toString();
          storeIdNameMap[storeDetails['storeId'].toString()] = storeDetails['storeName'].toString();

          storeTerminalMap[storeDetails['storeName'].toString()] = storeDetails['storeTerminals'].split(',');
          storeDetails['storeTerminals'].split(',').forEach((dynamic terminal){
            posTerminalToStoreName[terminal] = storeDetails['storeName'].toString();
//            if(!storeTerminals.contains(terminal))
//              {
//                storeTerminals.add(terminal);
//              }
//            storeTerminals.add(terminal);
          });
      });
        print(storeIdTerminalMap);
        print(storeIdMap);
        print(storeIdNameMap);
        print(storeTerminalMap);
        print(posTerminalToStoreName);
        print('Store Details Snapshot Available');

      }
  });
}


//Map<String, List<String>> storeIdTerminalMap = {
//  'KIRANAWALA_STORE_1':['POS_1','POS_9'],
//  'KIRANAWALA_STORE_4':['POS_4'],
//  'KIRANAWALA_STORE_3':['POS_3'],
//  'KIRANAWALA_STORE_2':['POS_2'],
//  'KIRANAWALA_STORE_6':['POS_6'],
//  'KIRANAWALA_STORE_7':['POS_7'],
//  'KIRANAWALA_STORE_5':['POS_5'],
//  'KIRANAWALA_STORE_8':['POS_8'],
//  'KIRANAWALA_STORE_11':['POS_11']
//};

Map<String, List<String>> storeGroups = {
  'S-MART GROUP':['S-MART I','S-MART II','S-MART III','S-MART IV','S-MART V','S-MART VI','S-MART VII'],
  'S-MART I':['S-MART I'],
  'S-MART II':['S-MART II'],
  'S-MART III':['S-MART III'],
  'S-MART IV':['S-MART IV'],
  'S-MART V':['S-MART V'],
  'S-MART VI':['S-MART VI'],
  'S-MART VII':['S-MART VII'],
};

//Map<String, String> storeIdMap = {
//  'S-MART I':'KIRANAWALA_STORE_4',
//  'S-MART II':'KIRANAWALA_STORE_3',
//  'S-MART III':'KIRANAWALA_STORE_2',
//  'S-MART IV':'KIRANAWALA_STORE_6',
//  'S-MART V':'KIRANAWALA_STORE_7',
//  'S-MART VI':'KIRANAWALA_STORE_5',
//  'S-MART VII':'KIRANAWALA_STORE_8',
//};

//Map<String, List<String>> storeTerminalMap = {
//  'S-MART GROUP':['POS_4','POS_3','POS_2','POS_5','POS_6','POS_7','POS_8'],
//  'S-MART I':['POS_4'],
//  'S-MART II':['POS_3'],
//  'S-MART III':['POS_2'],
//  'S-MART IV':['POS_6'],
//  'S-MART V':['POS_7'],
//  'S-MART VI':['POS_5'],
//  'S-MART VII':['POS_8','POS_9'],
//};



String mobileNumber = '9849494143';
bool mobileNumberAvailable = true;
bool isAdmin = true;
bool checkingIfAdmin = true;
String productNode;
String inventoryNode;
String posTerminal;
String userId;
int latestSKU;
int nextSKU;

String saleAnalysisDate = '';
String saleAnalysisYear = '';
String saleAnalysisMonth = '';
String saleAnalysisDay = '';


String selectedOnlineOrderCustomization = 'N/A';
double selectedOnlineOrderItemCount = 0;
int selectedOnlineOrderProductCount = 0;
String WHATSAPP_URL_ONLINE_ORDER = "whatsapp://send?text=OnlineOrderDetails";

String onlineOrderDateYear;
String onlineOrderDateMonth;
String onlineOrderDateDay;
num onlineOrderCount = 0.0;
String selectedOnlineOrderDateAsDDMMYYYY = '';
String selectedOnlineStore = 'N/A';
String selectedOnlineSalePositionDateAsddMMyyyy = 'N/A';
Map<int, String> categoryStatus = new Map<int, String>();
//String selectedOnlineSalePositionDay = 'N/A';
//String selectedOnlineSalePositionMonth = 'N/A';
//String selectedOnlineSalePositionYear = 'N/A';


//DateTime now = DateTime.now();
//selectedOnlineSalePositionDate  = DateFormat('dd-MM-yyyy').format(now);



String requestedDeliveryDate = 'N/A';
String requestedDeliveryTime = 'N/A';
String locality = 'N/A';
String fullAddress = 'N/A';
String landmark = 'N/A';

String firstName = 'N/A';
String lastName = 'N/A';
String contactNumber = 'N/A';
String customerId = 'N/A';

String orderDate = 'N/A';
String orderTime = 'N/A';
String orderAmount = 'N/A';

int onlineOrderProductCount = 0;
double onlineOrderItemCount = 0;
double onlineOrderAmount = 0;

Map<String, List> storeOnlineOrderIdsMap = new Map<String, List>();
Map<dynamic, dynamic> selectedOnlineOrderDetails = new Map<String, dynamic>();

List<dynamic> billedProducts = List<dynamic>();

class CheckIfAdmin extends StatefulWidget {
  @override
  _CheckIfAdminState createState() => _CheckIfAdminState();
}

class _CheckIfAdminState extends State<CheckIfAdmin> {

  Future<String> getValueFromSharedPreference(
      String sharedPreferenceKey) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String sharedPreferenceValue = _preferences.getString(sharedPreferenceKey);
    print(sharedPreferenceValue);
    if (sharedPreferenceValue == null) {
      print('getValueFromSharedPreference:' +
          sharedPreferenceKey +
          ' is null.returning empty string!!');
      return '';
    } else {
      print('getValueFromSharedPreference:' +
          sharedPreferenceKey +
          ' is ' +
          sharedPreferenceValue);
      print(sharedPreferenceValue);
      return sharedPreferenceValue;
    }
  }

  Future<bool> setValueInSharedPreference(String sharedPreferenceKey,
      String sharedPreferenceValue) async {
    var _preferences = await SharedPreferences.getInstance();
    return _preferences.setString(sharedPreferenceKey, sharedPreferenceValue);
  }

  void getMobileNumber() {
    getValueFromSharedPreference('mobileNumber').then((value) {
      if (value != '') {
        print('getValueFromSharedPreference:mobileNumber' + value);
        setState(() {
          mobileNumber = value;
          mobileNumberAvailable = true;
          checkIfAdmin();
        });
      }
      else {
        Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(builder: (BuildContext context) {
              return RequestMobileNumber();
            })).then((dynamic value) {
          if (value
              .toString()
              .length != 0) {
            print('getMobileNumber:' + value);
            setState(() {
              mobileNumber = value.toString();
              mobileNumberAvailable = true;
              checkIfAdmin();
            });
          }
        });
      }
    });
  }

  void getActiveCategoriesFromStore() {
//    print("getActiveCategoriesFromStore:storeId");
//    print(selectedStoreDetails.storeId);

    categoryNameCategoryDetailsMap = <String, dynamic>{};
    categoryIndexCategoryDetailsMap = <int, dynamic>{};
    homeCategoryNameCategoryDetailsMap = <String, dynamic>{};
    homeCategories = <dynamic>[];
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('categoriesMaster')
        .once()
        .then((snapshot) {
      if (snapshot != null && snapshot.value != null) {
//        print("getActiveCategoriesFromStore:snapshot.value");
//        print(snapshot.value.length);
//        print(snapshot.value);
        List<dynamic> categoryListSnapshot = snapshot.value;
        int i = 0;
        categoryListSnapshot.forEach((dynamic categoryDetails) {
          if (categoryDetails['categoryId'] != null &&
              categoryDetails['categoryImage'] != null &&
              categoryDetails['displayPosition'] != null &&
              categoryDetails['displayName'] != null &&
              categoryDetails['isActive'] != null &&
              categoryDetails['isParent'] != null) {
            if (categoryDetails['isActive'] == 'YES') {
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
            categoryStatus[i] = categoryDetails['isActive'];
            i = i + 1;
            categoryIndexCategoryDetailsMap[i] = categoryDetails;

          }
        });

        print('CategoryIndexCategoryDetailsMap');
        print(categoryIndexCategoryDetailsMap);

        homeCategories.sort((dynamic a, dynamic b) {
          return a['displayPosition'].compareTo(b['displayPosition']);
        });

        homeCategories.forEach((dynamic element) {
          categories.add(Category(element['categoryId'],element['categoryName']));
        });

        print(categories);
      }
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
          print(productCode.runtimeType.toString());
          if(productCode.runtimeType.toString() == 'String')
            {
              salePositionMap[int.parse(productCode.toString())]
              = double.parse(productSnapshot['salePosition'].toString());
            }
        });
        fullProductSalePositionAtTerminal[posTerminal] =
            salePositionMap;
        salePositionForTerminalAvailable[posTerminal] = true;
      }
      salePositionForTerminalProcessed[posTerminal] = true;
      salePositionProcessed = salePositionProcessed + 1;
      if(salePositionProcessed == storeTerminals.length)
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
      if(discountsProcessed == stores.length)
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

  void getProductSalePostionAtStore(String storeId){
//    print(storeId);
//    print(storeIdTerminalMap[storeId]);
    storeIdTerminalMap[storeId].forEach((posTerminal) {
//      print(posTerminal);
      getProductSalePositionAtTerminal(posTerminal);
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

//    allTerminals = List<String>();
//    storeIdMap.forEach((String store, String storeId){
//      storeIdTerminalMap[storeId].forEach((String terminal){
//        print(terminal);
//        allTerminals.add(terminal);
//      });
//    });
//    print(allTerminals);
//    print(allTerminals.length.toString());

    salePositionProcessed = 0;
    storeTerminals.forEach((String terminal){
      print(terminal);
      getProductSalePositionAtTerminal(terminal);
    });


    stores.forEach((String storeId){
      print(storeId);
      getProductDiscountDetailsAtStore(storeId);
      getProductSalePostionAtStore(storeId);
      getProductStockPositionAtStore(storeId);
    });


    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(productNode)
        .child('products')
        .once()
        .then((productsSnapshot){
      if(productsSnapshot != null && productsSnapshot.value != null) {
        productsSnapshot.value.forEach((dynamic productCode,
            dynamic productSnapshot) {
          if (productSnapshot['title'] != null &&
              productSnapshot['title'] != '') {
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
            fullProductBasicDetailsMap[int.parse(productCode.toString())] =
                product;
            fullProductBasicDetailsList.add(product);
          }
        });
      }
        if (this.mounted) {
          setState(() {
            storeLoading = false;
            storeLoaded = true;
            storeLoadingSuccessful = true;
          });
        }

      fullProductBasicDetailsMapAvailable = true;
      print('Full Product Map :' +
          fullProductBasicDetailsMap.length.toString());
    });

  }

  void checkIfAdmin() {
    FirebaseDatabase
        .instance
        .reference()
        .child('storeDetails')
        .once()
        .then((storeDetailsSnapshot){
//      print(storeDetailsSnapshot);
      if(storeDetailsSnapshot != null && storeDetailsSnapshot.value != null){
        storeDetailsSnapshot.value.forEach((dynamic storeId, dynamic storeDetails){
//          print(storeId.toString());
//          print(storeDetails['storeId'].toString());
//          print(storeDetails['storeName'].toString());
//          print(storeDetails['storeTerminals'].toString());
          storeIdTerminalMap[storeId] = storeDetails['storeTerminals'].split(',');
          storeIdMap[storeDetails['storeName'].toString()] = storeDetails['storeId'].toString();
          storeIdNameMap[storeDetails['storeId'].toString()] = storeDetails['storeName'].toString();

          storeTerminalMap[storeDetails['storeName'].toString()] = storeDetails['storeTerminals'].split(',');

          storeDetails['storeTerminals'].split(',').forEach((dynamic terminal){
            posTerminalToStoreName[terminal] = storeDetails['storeName'].toString();
            posTerminalToStoreIdMap[terminal] = storeDetails['storeId'].toString();
            terminalsAvailableAtStore[storeDetails['storeId'].toString()] = storeDetails['storeTerminals'].split(',').length;
            if(!storeTerminals.contains(terminal))
            {
              storeTerminals.add(terminal);
            }
            storeTerminals.add(terminal);
          });

        });
//        print(storeIdTerminalMap);
//        print(storeIdMap);
//        print(storeIdNameMap);
//        print(storeTerminalMap);
//        print(posTerminalToStoreName);
//        print(terminalsAvailableAtStore);
        print('Store Details Snapshot Available');
        checkingIfAdmin = true;
        FirebaseDatabase.instance
            .reference()
            .child('storeAdmins')
            .onValue
            .listen((event) {
          if (event.snapshot != null && event.snapshot.value != null) {
            if (event.snapshot.value[mobileNumber] != null &&
                event.snapshot.value[mobileNumber]['productNode'] != null &&
                event.snapshot.value[mobileNumber]['inventoryNode'] != null
                &&
                event.snapshot.value[mobileNumber]['userId'] != null &&
                event.snapshot.value[mobileNumber]['latestSKU'] != null) {
              productNode =
                  event.snapshot.value[mobileNumber]['productNode'].toString();
              inventoryNode =
                  event.snapshot.value[mobileNumber]['inventoryNode'].toString();
              userId = event.snapshot.value[mobileNumber]['userId'].toString();
              latestSKU = int.parse(event.snapshot.value[mobileNumber]['latestSKU'].toString());
              nextSKU = latestSKU + 1;
              print('Latest SKU:' + latestSKU.toString());
              print('Next SKU:' + nextSKU.toString());
              storeName =
                  event.snapshot.value[mobileNumber]['storeName'].toString();
              storeLocation =
                  event.snapshot.value[mobileNumber]['storeLocation'].toString();
              stores = event.snapshot.value[mobileNumber]['stores'].toString().split(',');
//              print(stores);
              storeCount = stores.length;
              selectedStore = stores[0];
              print(storeIdTerminalMap);
              storeTerminals = [];
              stores.forEach((store) {
                print(store);
                storeIdTerminalMap[store].forEach((terminal) {

                  print(terminal);
                  if(!storeTerminals.contains(terminal))
                    {
                      storeTerminals.add(terminal);
                    }
                });
              });
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
          print(storeTerminals);
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

              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ShowAdminHomePage();
                      }
                  )
              );
            }
          }
          setState(() {
            checkingIfAdmin = false;
          });
        });
      }
    });

  }

  int currentVersion = 0;
  int latestVersion = 0;

  int currentBuildNumber = 0;
  int latestBuildNumber = 0;

  String appName = 'N/A';
  String packageName = 'N/A';
  String version = 'N/A';

  bool is64Bit = false;

  void versionCheck(BuildContext context) async {
    print('versionCheck:Entered:');
    //Get Current installed version of app
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
//  print(Platform.executable);
//  print(Platform.);
    print(Platform.operatingSystemVersion);

    //if operating system version contains 'x64′ string, your device has a 64-bit OS;
    // if you cannot find this string, then is 32-bit.
    if (Platform.operatingSystemVersion.contains('x64') ||
        Platform.operatingSystemVersion.contains('ARM64')) is64Bit = true;

//  print(Platform.operatingSystem);
//  print(Platform);

    //CFBundleDisplayName in Info.plist
    appName = packageInfo.appName.toString();
    //Bundle Identifier - Runner -> General -> Bundle Identifier (eg:com.kiranawala.storemanager)
    packageName = packageInfo.packageName.toString();
    //Runner -> General -> Version
    version = packageInfo.version.toString();
    //Runner -> General -> Build
    currentBuildNumber = int.parse(packageInfo.buildNumber.toString());

    print('versionCheck:App Name:' + appName);
    print('versionCheck:Package Name:' + packageName);
    print('versionCheck:Version:' + version);
    print('versionCheck:Build Number:' + currentBuildNumber.toString());

    currentVersion = int.parse(packageInfo.version.trim().replaceAll(".", ""));
    currentBuildNumber = int.parse(currentBuildNumber.toString());
    print('versionCheck:Version(as a number for comparing with remote config):' +
        currentVersion.toString());
    print('versionCheck:Current Build Number:' + currentBuildNumber.toString());

    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    final defaults = <String, dynamic>{
      'kiranawala_ios_version': '1.0.11',
      'kiranawala_ios_build_number': '1'
    };

    try {
      await remoteConfig.setDefaults(defaults);
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();

      if (Platform.isIOS) {
        latestVersion = int.parse(remoteConfig
            .getString('kiranawala_admin_ios_version')
            .trim()
            .replaceAll(".", ""));
        latestBuildNumber = int.parse(remoteConfig
            .getString('kiranawala_admin_ios_build_number')
            .trim()
            .replaceAll(".", ""));
      }
      if (Platform.isAndroid) {
        latestVersion = int.parse(remoteConfig
            .getString('kiranawala_admin_android_version')
            .trim()
            .replaceAll(".", ""));
        latestBuildNumber = int.parse(remoteConfig
            .getString('kiranawala_admin_android_build_number')
            .trim()
            .replaceAll(".", ""));
      }

      print('versionCheck:Latest Version (on Firebase Remote Config):' +
          latestVersion.toString());
      print('versionCheck:Latest Build Number (on Firebase Remote Config):' +
          latestBuildNumber.toString());

      if (latestVersion > currentVersion) {
        showVersionDialog(context);
      } else {
        if (latestVersion == currentVersion) {
          if (!is64Bit) {
            print('Version Update Check:' + is64Bit.toString());
            if (latestBuildNumber - 1 > currentBuildNumber) {
              showVersionDialog(context);
            }
          } else {
            if (latestBuildNumber > currentBuildNumber) {
              showVersionDialog(context);
            }
          }
        }
      }
    } on FetchThrottledException catch (exception) {
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showVersionDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "NEW VERSION AVAILABLE";
        String message = "UPDATING NOW....";
        String btnLabel = "OK";
        return new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () {
                Navigator.pop(context);
                StoreRedirect.redirect(
                    androidAppId: "com.kiranawala.kiranawala_admin",
                    iOSAppId: "1490671653");
              },
            ),
          ],
        );
      },
    );
  }




  @override
  void initState() {

    super.initState();
      productBrands = List<String>();
      productBrands.add('DURACELL');
      productBrands.add('LIJJAT');
      productBrands.add('SGR(777) FOODS');
      productBrands.add('LASER');
      productBrands.add('JABSONS');
      productBrands.add('SNACATAC');
      productBrands.add('DS SPICES');
      productBrands.add('ZYDUS WELLNESS');
      productBrands.add('HENNA GROUP');
      productBrands.add('DWIBHASHI');
      productBrands.add('LOHIYA');
      productBrands.add('PEPSI');
      productBrands.add('TOP RAMEN');
      productBrands.add('WEIKFIELD');
      productBrands.add('CONTINENTAL');
      productBrands.add('HATSUN');
      productBrands.add('AMUL');
      productBrands.add('CADBURY');
      productBrands.add('TIP-TOP KIRANA');
      productBrands.add('TIP-TOP HOMECARE');
      productBrands.add('PARLE');
      productBrands.add('EVEREST');
      productBrands.add('MTR');
      productBrands.add('BAMBINO');
      productBrands.add('SHANTI NAMKEENS');
      productBrands.add('MILKY MIST');
      productBrands.add('ID FRESH');
      productBrands.add('GRB');
      productBrands.add('PATANJALI');
      productBrands.add('BRITANNIA');
      productBrands.add('NIVEA');
      productBrands.add('FEM');
      productBrands.add('LOTUS');
      productBrands.add('BANJARAS');
      productBrands.add('NYCIL');
      productBrands.add('DENVER');
      productBrands.add('PARK AVENUE');
      productBrands.add('FOGG');
      productBrands.add('NAVRATNA');
      productBrands.add('DERMI COOL');
      productBrands.add('PRIYA');
      productBrands.add('LION');
      productBrands.add('GOLDDROP');
      productBrands.add('FREEDOM');
      productBrands.add('FORTUNE');
      productBrands.add('LOREAL');
      productBrands.add('VIJAYA');
      productBrands.add('HALDIRAMS');
      productBrands.add('HERITAGE');
      productBrands.add('KIRANAWALA');
      productBrands.add('UNIBIC');
      productBrands.add('KWALITY WALLS');
      productBrands.add('CYCLE');
      productBrands.add('SCTOCH-BRITE');
      productBrands.add('LG');
      productBrands.add('INDULEKHA');
      productBrands.add('BISLERI');
      productBrands.add('KINGFISHER');
      productBrands.add('MOGU MOGU');
      productBrands.add('SCHWEPPES');
      productBrands.add('DUKES');
      productBrands.add('PARRYS');
      productBrands.add('NESTLE');
      productBrands.add('FUNFOODS');
      productBrands.add('TATA');
      productBrands.add('ANOYA');
      productBrands.add('EVEREADY');
      productBrands.add('NIPPO');
      productBrands.add('LOTTE');
      productBrands.add('EPIGAMIA');
      productBrands.add('SUGAR FREE');
      productBrands.add('SRILALITHA');
      productBrands.add('INDIA GATE');
      productBrands.add('KOHINOOR');
      productBrands.add('DAAWAT');
      productBrands.add('PAMPERS');
      productBrands.add('MAMY POKO');
      productBrands.add('DURGA GHEE');
      productBrands.add('KELLOGGS');
      productBrands.add('AGROTECH');
      productBrands.add('UNANI');
      productBrands.add('HERSHEYS');
      productBrands.add('COLGATE-PALMOLIVE');
      productBrands.add('SCJOHNSON');
      productBrands.add('JOHNSONS');
      productBrands.add('SPENCERS');
      productBrands.add('CREATIVE MARKETING');
      productBrands.add('KARACHI BAKERY');
      productBrands.add('PROCTER & GAMBLE');
      productBrands.add('CELLO');
      productBrands.add('MONTEX');
      productBrands.add('NATRAJ');
      productBrands.add('APSARA');
      productBrands.add('CAMLIN');
      productBrands.add('LUXOR');
      productBrands.add('LINC');
      productBrands.add('DOMYOS');
      productBrands.add('GURU');
      productBrands.add('VICKY');
      productBrands.add('M-SEAL');
      productBrands.add('NANDINI');
      productBrands.add('PIDILITE');
      productBrands.add('PRIME QUALITY');
      productBrands.add('UNILEVER');
      productBrands.add('CAVINKARE');
      productBrands.add('RECKITT BENCKISER');
      productBrands.add('PERFETTI');
      productBrands.add('VCARE');
      productBrands.add('NISSINS');
      productBrands.add('VINI');
      productBrands.add('DABUR');
      productBrands.add('ITC');
      productBrands.add('HIMALAYA');
      productBrands.add('FLAIR');
      productBrands.add('PCI');
      productBrands.add('AVA');
      productBrands.add('EMAMI');
      productBrands.add('ECOF');
      productBrands.add('BAULI');
      productBrands.add('WRIGLEY');
      productBrands.add('MARS');
      productBrands.add('JYOTHY LABS');
      productBrands.add('GLAXO SMITHKLINE');
      productBrands.add('RASNA');
      productBrands.add('AJAY');
      productBrands.add('BUDWEISER');
      productBrands.add('STREAX');
      productBrands.add('AMRUTANJAN');
      productBrands.add('KEO KARPIN');
      productBrands.add('BAJAJ');
      productBrands.add('AMBICA');
      productBrands.add('VANESA');
      productBrands.add('RUCHI SOYA');
      productBrands.add('FERRARI');
      productBrands.add('WIPRO');
      productBrands.add('CAPITAL FOODS');
      productBrands.add('KARNATAKA SOAPS');
      productBrands.add('MARINO');
      productBrands.add('MARICO');
      productBrands.add('SWASTIK');
      productBrands.add('ANURAG');
      productBrands.add('LASER');
      productBrands.add('RED BULL');
      productBrands.add('HECTOR BEVERAGES');
      productBrands.add('ASWINI');
      productBrands.add('VICCO');
      productBrands.add('HEERA');

      productBrands.sort((dynamic a, dynamic b) {
        return a.compareTo(b);
      });

    productCategories = List<String>();
    productCategories.add('BREAD, CEREALS & OATS');
    productCategories.add('LEAFY VEG');
    productCategories.add('NON-LEAFY VEG');
    productCategories.add('LOOSE GROCERY');
    productCategories.add('FROZEN VEG');
    productCategories.add('FRUITS');
    productCategories.add('DALS');
    productCategories.add('WHOLE SPICES');
    productCategories.add('POWDERED SPICES');
    productCategories.add('BLENDED SPICES');
    productCategories.add('SOFT DRINKS');
    productCategories.add('ATTA');
    productCategories.add('RAVA');
    productCategories.add('RICE');
    productCategories.add('NOODLES & VERMICELLI');
    productCategories.add('SALT, SUGAR & JAGGERY');
    productCategories.add('COOKING PASTES');
    productCategories.add('MILK SHAKES');
    productCategories.add('FRUIT JUICES');
    productCategories.add('DRY FRUITS & NUTS');
    productCategories.add('TEA, COFFEE & WHITENERS');
    productCategories.add('COOKING OILS, DALDA & GHEE');
    productCategories.add('INSTANT FOOD & READY-TO-COOK');
    productCategories.add('STATIONERY & PARTY NEEDS');
    productCategories.add('BAKING');
    productCategories.add('SPREADS & SAUCES');
    productCategories.add('PICKLES');
    productCategories.add('FABRIC CARE');
    productCategories.add('ORAL CARE');
    productCategories.add('BATH & SHOWER');
    productCategories.add('FEMININE HYGIENE');
    productCategories.add('DISHWASH');
    productCategories.add('PEST CONTROL');
    productCategories.add('POOJA ITEMS');
    productCategories.add('HAIR CARE');
    productCategories.add('SHAVING NEEDS');
    productCategories.add('BEAUTY & MAKE-UP');
    productCategories.add('SURFACE & TOILET CLEANERS');
    productCategories.add('FRESH DAIRY & PRODUCTS');
    productCategories.add('PAPADS & FRYUMS');
    productCategories.add('HANDWASH & SANITIZER');
    productCategories.add('AIR FRESHENERS');
    productCategories.add('MEDICINES & SUPPLEMENTS');
    productCategories.add('WATER');
    productCategories.add('SNACKS');
    productCategories.add('ICE CREAMS & FROZEN DESSERTS');
    productCategories.add('HEALTH & NUTRITION DRINKS');
    productCategories.add('SHOE CARE');
    productCategories.add('DISPOSABLES');
    productCategories.add('CLEANING ACCESSORIES');
    productCategories.add('PAANWAALA');
    productCategories.add('PET CARE');
    productCategories.add('PLASTIC & STEEL WARE');
    productCategories.add('ELECTRICAL ACCESSORIES');

    productCategories.sort((dynamic a, dynamic b) {
      return a.compareTo(b);
    });

      setState(() {

      });


    FirebaseDatabase.instance
        .reference()
        .child('.info/connected')
        .onValue
        .listen((event) {
      if (
      event != null
          && event.snapshot != null
          && event.snapshot.value != null) {
        print(event.snapshot);
        print(event);
        print(event.snapshot.value);
        print('Database is connected');
      }
      else
        {
          print('Database connection is lost');
        }
    });

    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    if(!isAdmin)
      {
        mobileNumberAvailable = false;
        mobileNumber = '';
        getMobileNumber();
      }

    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_14')
        .child('storeCreatedOn')
        .set(DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    if (mobileNumberAvailable) {
      if (checkingIfAdmin) {
        return WillPopScope(
            onWillPop:(){
          setState(() {
            checkingIfAdmin = false;
            isAdmin = false;
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return CheckIfAdmin();
                }));
          });
          return;
        },
    child:Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('LOGIN'),
            ),
            body:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Text(mobileNumber,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ))),
                Center(child: Text('Checking If Admin',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ))),
                LinearProgressIndicator(),
              ],
            )
        ));
      }
      else {
        if (isAdmin) {
                return WillPopScope(
                    onWillPop:(){
                  setState(() {
                    checkingIfAdmin = false;
                    isAdmin = false;
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                        builder:(BuildContext context){
                          return CheckIfAdmin();
                        }));
                  });

                  return;
                },
    child:Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: Text('LOGIN'),
                    ),
                    body:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text('MOBILE:',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(mobileNumber,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text('PRODUCTS:',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(productNode,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text('INVENTORY:',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(inventoryNode,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text('TERMINALS:',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(storeTerminals.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text('STORE:',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(storeName,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text('LOCATION:',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(storeLocation,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )
                              ]),
                        ),
                        Container(
                          width:MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color:Colors.blue,
                            onPressed:(){
                              Navigator.of(context).pop();
                              Navigator.of(context).push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                  builder:(BuildContext context){
                                    return ShowAdminHomePage();
                                  }
                                )
                              );
                            },
                            child: Text('PROCEED',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.white,
                                )),
                          ),
                        ),
                      ],
                    )
                ));
        }
        else
          {
            return WillPopScope(
                onWillPop:(){
              setState(() {
                checkingIfAdmin = false;
                isAdmin = false;
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return CheckIfAdmin();
                    }));
              });
              return;
            },
    child:Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  title: Text('LOGIN'),
                ),
                body:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Text('MOBILE NUMBER N/A',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0
                            ))
                    ),
                    Center(
                      child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            getMobileNumber();
                          },
                          child: Text('TRY AGAIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  fontFamily: 'Montserrat'
                              ))
                      ),
                    ),
                  ],
                )
            ));
          }
      }
    }
    else {
      return WillPopScope(
      onWillPop:(){
      setState(() {
      checkingIfAdmin = false;
      isAdmin = false;
      Navigator.of(context).pop();
      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
      builder:(BuildContext context){
      return CheckIfAdmin();
      }));
      });

      return;
      },
      child:Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('LOGIN'),
          ),
          body:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Text('MOBILE NUMBER N/A',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0
                      ))
              ),
              Center(
                child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      getMobileNumber();
                    },
                    child: Text('TRY AGAIN',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            fontFamily: 'Montserrat'
                        ))
                ),
              ),
            ],
          )
      ));
    }
  }
}