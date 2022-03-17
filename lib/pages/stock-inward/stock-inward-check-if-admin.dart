import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-home-page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'dart:io' show Platform;
import 'package:store_redirect/store_redirect.dart';

import '../show-admin-home-page.dart';



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
//      String productParentStore,
//      String productCreationTimeStamp
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
//
//Map<int, ProductBasicDetails> barCodeSearchResultsMap = new Map();
//Map<int, ProductBasicDetails> productMap = new Map();
//
//
//Map<int, ProductBasicDetails> fullProductBasicDetailsMap = new Map();
//List<ProductBasicDetails> fullProductBasicDetailsList = new List();
//
//Map<int, ProductDiscountDetails> fullProductDiscountMap = new Map();
//List<ProductDiscountDetails> fullProductDiscountList = new List();


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

//Map<String, String> storeIdMap = {
//  'S-MART I':'KIRANAWALA_STORE_4',
//  'S-MART II':'KIRANAWALA_STORE_3',
//  'S-MART III':'KIRANAWALA_STORE_2',
//  'S-MART IV':'KIRANAWALA_STORE_6',
//  'S-MART V':'KIRANAWALA_STORE_7',
//  'S-MART VI':'KIRANAWALA_STORE_5',
//  'S-MART VII':'KIRANAWALA_STORE_8',
//};

//Map<String, List<String>> storeGroups = {
//  'S-MART GROUP':['S-MART I','S-MART II','S-MART III','S-MART IV','S-MART V','S-MART VI','S-MART VII'],
//  'S-MART I':['S-MART I'],
//  'S-MART II':['S-MART II'],
//  'S-MART III':['S-MART III'],
//  'S-MART IV':['S-MART IV'],
//  'S-MART V':['S-MART V'],
//  'S-MART VI':['S-MART VI'],
//  'S-MART VII':['S-MART VII'],
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




//Map<String, String> posTerminalToStoreName = Map<String, String>();

//String mobileNumber = 'N/A';
bool mobileNumberAvailable = false;
bool isAdmin = false;
bool checkingIfAdmin = true;
//String inventoryNode = 'KIRANAWALA_STORE_11';
//String productNode = 'KIRANAWALA_STORE_11';
//String productNode  = '';
//String inventoryNode = '';
//String storeName = '';
//String storeLocation = '';
//String storeTerminals = '';
//List<String> storeTerminals = List<String>();
//List<String> stores = List<String>();
//String selectedStore = '';

String discountStartDate = 'VALID FROM';
String discountEndDate = 'VALID TILL';
List<String> discountTypes = [
  'PERCENT','AMOUNT'
];
String discountType = 'DISCOUNT TYPE';
double discountValue = 0.0;
bool isDiscountActive = false;


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
//String selectedOnlineSalePositionDay = 'N/A';
//String selectedOnlineSalePositionMonth = 'N/A';
//String selectedOnlineSalePositionYear = 'N/A';
//String selectedOnlineSalePositionDate = DateFormat('dd-MM-yyyy').format(DateTime.now());


//DateTime now = DateTime.now();
//selectedOnlineSalePositionDate  = DateFormat('dd-MM-yyyy').format(now);

//String selectedOnlineSalePositionDay = selectedOnlineSalePositionDate.substring(0,2);
//String selectedOnlineSalePositionMonth = selectedOnlineSalePositionDate.substring(3,5);
//String selectedOnlineSalePositionYear  = selectedOnlineSalePositionDate.substring(6,10);


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
//
//List<Brand> brands = List<Brand>();
//List<Category> categories = List<Category>();
//

//List<Brand> brandSearchResults = List<Brand>();
//List<Category> categorySearchResults = List<Category>();
//
//String selectedBrand = '';
String selectedCategory = '';
String updatedName = '';
String selectedStatus = 'ACTIVE';
int previousSearchResultIndex = 0;

//Map<String, dynamic> categoryNameCategoryDetailsMap = <String, dynamic>{};
//Map<String, dynamic> homeCategoryNameCategoryDetailsMap = <String, dynamic>{};
//List<dynamic> homeCategories = <dynamic>[];
//List<dynamic> categoryList = List<dynamic>();
//
//Map<String, List> storeOnlineOrderIdsMap = new Map<String, List>();
//Map<String, dynamic> orderMap = new Map<String, dynamic>();
//Map<dynamic, dynamic> selectedOnlineOrderDetails = new Map<String, dynamic>();

//Map<dynamic, dynamic> billsAtTerminalForSelectedDate = Map<dynamic, dynamic>();
//List<dynamic> billedProducts = List<dynamic>();

Widget getTextWidget(String text, double fontSize, Color color){
  return Text(text,
    style:TextStyle(
        fontFamily: 'Montserrat',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color:color
    ),
    textAlign: TextAlign.center,
  );
}

class StockInwardCheckIfAdmin extends StatefulWidget {
  @override
  _StockInwardCheckIfAdminState createState() => _StockInwardCheckIfAdminState();
}

class _StockInwardCheckIfAdminState extends State<StockInwardCheckIfAdmin> {

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

  void getActiveCategoriesFromStore() {
    print("getActiveCategoriesFromStore:storeId");
    print(inventoryNode);

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
        print("getActiveCategoriesFromStore:snapshot.value");
        print(snapshot.value.length);
        print(snapshot.value);
        categoryList = snapshot.value;
        categoryList.forEach((dynamic categoryDetails) {
          if (categoryDetails['categoryId'] != null &&
              categoryDetails['categoryImage'] != null &&
              categoryDetails['displayPosition'] != null &&
              categoryDetails['displayName'] != null &&
              categoryDetails['isActive'] != null &&
              categoryDetails['isParent'] != null) {
//            if (categoryDetails['isActive'] == 'YES')
//            {
              categoryNameCategoryDetailsMap[categoryDetails['categoryName']] =
                  categoryDetails;
//              if (categoryDetails['isParent'] == 'YES') {
//                if (categoryDetails['subCategories'] != null) {
//                  homeCategories.add(categoryDetails);
//                  homeCategoryNameCategoryDetailsMap[
//                  categoryDetails['categoryName']] = categoryDetails;
//                }
//              }
//            }
          }
        });

        homeCategories.sort((dynamic a, dynamic b) {
          return a['displayPosition'].compareTo(b['displayPosition']);
        });
      }
    });
  }


//  void getMobileNumber() {
//    getValueFromSharedPreference('mobileNumber').then((value) {
//      if (value != '') {
//        print('getValueFromSharedPreference:mobileNumber' + value);
//        setState(() {
//          mobileNumber = value;
//          mobileNumberAvailable = true;
//          checkIfAdmin();
//        });
//      }
//      else {
//        Navigator.of(context).push<dynamic>(
//            MaterialPageRoute<dynamic>(builder: (BuildContext context) {
//              return RequestMobileNumber();
//            })).then((dynamic value) {
//          if (value
//              .toString()
//              .length != 0) {
//            print('getMobileNumber:' + value);
//            setState(() {
//              mobileNumber = value.toString();
//              mobileNumberAvailable = true;
//              checkIfAdmin();
//            });
//          }
//        });
//      }
//    });
//  }

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
        salePositionAtAllTerminalsAvailable = true;

        if (this.mounted) {
          setState(() {
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
      }
      discountDetailsAvailable = true;

//          print(discountsProcessed);
//          print(storeIdMap.length);
        if (this.mounted) {
          setState(() {
            print('Store Processed for Discount Details.');
          });
        }

//            print(fullProductDiscountDetailsAtStore);
//            print(fullProductDiscountDetailsAtStore.length);
//            fullProductDiscountDetailsAtStore.forEach((key, value) {
//              print(key);
//            });

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
//        Map<int, double> stockPositionMap = new Map();
        productsSnapshot.value.forEach((dynamic productCode,
            dynamic productSnapshot) {
          if (productSnapshot['stockInwards'] != null &&
              productSnapshot['stockInwards']['stockInwardTillDate'] != null) {
//              print(productCode);
//              print(productSnapshot['stockInwards']['stockInwardTillDate'].toString());
            fullProductStockPositionMap[int.parse(productCode.toString())]
            = double.parse(
                productSnapshot['stockInwards']['stockInwardTillDate']
                    .toString());
          }
        });
        stockPositionAvailable = true;

        print('Full Stock Position Map Of Store:' + storeId.toString() + ':' +
            fullProductStockPositionMap.length.toString());
      }

      if (this.mounted) {
        setState(() {
          stockPositionAvailable = true;
          print('Store Processed For Stock Position.');
        });
      }
    });
  }

//  void getProductSalePostionAtStore(String storeId){
////    print(storeId);
////    print(storeIdTerminalMap[storeId]);
//    storeIdTerminalMap[storeId].forEach((posTerminal) {
////      print(posTerminal);
//      getProductSalePositionAtTerminal(posTerminal);
//    });
//  }





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

    salePositionProcessed = 0;
    storeTerminals.forEach((String terminal){
      print(terminal);
      getProductSalePositionAtTerminal(terminal);
    });

    stores.forEach((String storeId){
      print(storeId);
      getProductDiscountDetailsAtStore(storeId);
//      getProductSalePostionAtStore(storeId);
      getProductStockPositionAtStore(storeId);
    });


    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(productNode)
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

//  void checkIfAdmin() {
//    checkingIfAdmin = true;
//    FirebaseDatabase.instance
//        .reference()
//        .child('storeAdmins')
//        .onValue
//        .listen((event) {
//      if (event.snapshot != null && event.snapshot.value != null) {
//        if (event.snapshot.value[mobileNumber] != null &&
//            event.snapshot.value[mobileNumber]['productNode'] != null &&
//            event.snapshot.value[mobileNumber]['inventoryNode'] != null) {
//          productNode =
//              event.snapshot.value[mobileNumber]['productNode'].toString();
//          inventoryNode =
//              event.snapshot.value[mobileNumber]['inventoryNode'].toString();
//          storeName =
//              event.snapshot.value[mobileNumber]['storeName'].toString();
//          storeLocation =
//              event.snapshot.value[mobileNumber]['storeLocation'].toString();
//          stores = event.snapshot.value[mobileNumber]['stores'].toString().split(',');
//          selectedStore = stores[0];
////          storeTerminals =
////              event.snapshot.value[mobileNumber]['storeTerminals'].toString().split(',');
////          storeTerminals_List = storeTerminals.split(',');
//          stores.forEach((storeElement) {
//            storeIdTerminalMap[storeElement].toList().forEach((storeTerminal) {
//              storeTerminals.add(storeTerminal);
//            });
//          });
//          print(storeTerminals);
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
//
//
//
//          setState(() {
//            isAdmin = true;
//          });
//        }
//      }
//      setState(() {
//        checkingIfAdmin = false;
//      });
//    });
//  }

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
    inventoryNode = 'KIRANAWALA_STORE_11';
    productNode = 'KIRANAWALA_STORE_11';
    getActiveCategoriesFromStore();

    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
//    if(!isAdmin)
//      {
//        mobileNumberAvailable = false;
//        mobileNumber = '';
//        getMobileNumber();
//      }
  }

  @override
  Widget build(BuildContext context) {
//    if (mobileNumberAvailable) {
//      if (checkingIfAdmin) {
//        return WillPopScope(
//            onWillPop:(){
//          setState(() {
//            checkingIfAdmin = false;
//            isAdmin = false;
//            Navigator.of(context).pop();
//            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                builder:(BuildContext context){
//                  return StockInwardCheckIfAdmin();
//                }));
//          });
//          return;
//        },
//    child:Scaffold(
//            appBar: AppBar(
//              automaticallyImplyLeading: false,
//              centerTitle: true,
//              title: Text('LOGIN'),
//            ),
//            body:
//            Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Center(child: Text(mobileNumber,
//                    style: TextStyle(
//                      fontFamily: 'Montserrat',
//                      fontSize: 16.0,
//                      fontWeight: FontWeight.bold,
//                    ))),
//                Center(child: Text('Checking If Admin',
//                    style: TextStyle(
//                      fontFamily: 'Montserrat',
//                      fontSize: 16.0,
//                      fontWeight: FontWeight.bold,
//                    ))),
//                CircularProgressIndicator(),
//              ],
//            )
//        ));
//      }
//      else {
//        if (isAdmin) {
                return WillPopScope(
                    onWillPop:(){
                  setState(() {
                    checkingIfAdmin = false;
                    isAdmin = false;
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                        builder:(BuildContext context){
                          return ShowAdminHomePage();
                        }));
                  });

                  return;
                },
    child:Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      centerTitle: true,
                      title: Text('INVENTORY MANAGER',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: IconButton(
                        icon:Icon(Icons.keyboard_backspace),
                        onPressed: (){
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                              builder:(BuildContext context){
                                return ShowAdminHomePage();
                              }));
                        },
                      ),
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
                                    return StockInwardHomePage();
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
//        }
//        else
//          {
//            return WillPopScope(
//                onWillPop:(){
//              setState(() {
//                checkingIfAdmin = false;
//                isAdmin = false;
//                Navigator.of(context).pop();
//                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                    builder:(BuildContext context){
//                      return StockInwardCheckIfAdmin();
//                    }));
//              });
//              return;
//            },
//    child:Scaffold(
//                appBar: AppBar(
//                  automaticallyImplyLeading: false,
//                  centerTitle: true,
//                  title: Text('LOGIN'),
//                ),
//                body:
//                Column(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Center(
//                        child: Text('MOBILE NUMBER N/A',
//                            style: TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontWeight: FontWeight.bold,
//                                fontSize: 16.0
//                            ))
//                    ),
//                    Center(
//                      child: RaisedButton(
//                          color: Colors.blue,
//                          onPressed: () {
//                            getMobileNumber();
//                          },
//                          child: Text('TRY AGAIN',
//                              style: TextStyle(
//                                  color: Colors.white,
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 16.0,
//                                  fontFamily: 'Montserrat'
//                              ))
//                      ),
//                    ),
//                  ],
//                )
//            ));
//          }
//      }
//    }
//    else {
//      return WillPopScope(
//      onWillPop:(){
//      setState(() {
//checkingIfAdmin = false;
//isAdmin = false;
//      Navigator.of(context).pop();
//      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//      builder:(BuildContext context){
//      return StockInwardCheckIfAdmin();
//      }));
//      });
//
//      return;
//      },
//      child:Scaffold(
//          appBar: AppBar(
//            automaticallyImplyLeading: false,
//            centerTitle: true,
//            title: Text('LOGIN'),
//          ),
//          body:
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Center(
//                  child: Text('MOBILE NUMBER N/A',
//                      style: TextStyle(
//                          fontFamily: 'Montserrat',
//                          fontWeight: FontWeight.bold,
//                          fontSize: 16.0
//                      ))
//              ),
//              Center(
//                child: RaisedButton(
//                    color: Colors.blue,
//                    onPressed: () {
//                      getMobileNumber();
//                    },
//                    child: Text('TRY AGAIN',
//                        style: TextStyle(
//                            color: Colors.white,
//                            fontWeight: FontWeight.bold,
//                            fontSize: 16.0,
//                            fontFamily: 'Montserrat'
//                        ))
//                ),
//              ),
//            ],
//          )
//      ));
//    }
  }
}