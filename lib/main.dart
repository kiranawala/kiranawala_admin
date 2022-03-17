import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/algolia-search-page.dart';
import 'package:kiranawala_admin/pages/authenticate-mobile-number.dart';
//import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-stock-position.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';
import 'pages/show-home-page.dart';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//String storeTerminals = '';
List<String> storeTerminals_List = List<String>();
bool refreshingCategoryWiseSales = true;
bool refreshingProductWiseSales = true;
bool refreshingTerminalWiseSales = true;
//String saleAnalysisDate = '';
//String saleAnalysisYear = '';
//String saleAnalysisMonth = '';
//String saleAnalysisDay = '';
String selectedPOSTerminal = '';
//String storeName = '';
//Map<String, String> posTerminalToStoreName = Map<String, String>();
int totalWalkins = 0;
String totalWalkinsAsString = '0';

double totalSale = 0;
String totalSaleAsString = '';

Map<dynamic,dynamic> productSalePositionMap = Map<dynamic,dynamic>();
//List<String> productListForSelectedCategory = [];
double saleAtStoreTerminal = 0.0;
int walkinsAtStoreTerminal = 0;
List<Widget> salePerTerminal = [];
List<String> productListForSelectedCategory = [];

//NILA-POS
int nextProductCode = 0;

//START - ADMIN VARIABLES & FUNCTIONS
bool AdminAuthenticating = false;
bool AdminRetrievingAddress = false;
String verificationId = '';
String OTP = '';
//String mobileNumber = '9849494143';
bool mobileNumberAvailable = false;
String mobile = '';

bool otpAuthenticated = false;
bool otpAuthenticationFailed = false;
String AdminCategorySelected;
String firebaseId = '';
String AdminFCMToken;

String newProductName = 'PRODUCT NAME';
double newProductPrice = 1.0;
String nextBarCode = '';

double totalSaleSoFarToday = 0.0;



double totalSaleForTheSelectedDate = 0.0;
String totalSaleForTheSelectedDateAsString = '0.0';

int totalWalkinsForTheSelectedDate = 0;
String totalWalkinsForTheSelectedDateAsString = '0';


double totalSaleForTheSelectedMonth = 0.0;
String totalSaleForTheSelectedMonthAsString = '0.0';

int totalWalkinsForTheSelectedMonth = 0;
String totalWalkinsForTheSelectedMonthAsString = '0';

int totalWorkingDaysForTheSelectedMonth = 0;
String totalWorkingDaysForTheSelectedMonthAsString = '0';

double averageDailySaleForTheSelectedMonth = 0;
String averageDailySaleForTheSelectedMonthAsString = '0';

int averageDailyWalkinsForTheSelectedMonth = 0;
String averageDailyWalkinsForTheSelectedMonthAsString = '0';

String firebaseID = '';
List storeList = new List<dynamic>();
List<dynamic> saleAtAllStores = new List<dynamic>();
List<dynamic> storeSaleAnalysMap = new List<dynamic>();


var saleDetails= Map<dynamic, dynamic>();
String saleDate = '';
String year = '';
String month = '';
String day = '';

String selectedOnlineOrderDate = '';
String selectedBillTime = '';
int selectedBillProductCount = 0;
double selectedBillItemCount = 0.0;
double selectedBillAmount = 0.0;
String selectedSaleDate = '';
String selectedSaleStartDate = '';
String selectedSaleEndDate = '';


bool isStoreAdmin = false;
//String currentUser = '';
String logMessage = '';
List<String> terminalsAtStore = [];
List<String> listOfManagedStores = [];
List<String> listOfManagedTerminals = [];
List<String> terminalsManaged = [];
String selectedTerminal = '';
Map<dynamic, dynamic> posTerminalStoreNameMapping = Map<dynamic, dynamic>();

int storeCount = 0;
int storeDetailsAvailableCount = 0;
int storeDetailsQueriedCount = 0;
bool allStoreDetailsAvailable = false;
String terminalsManagedAsString = '';
Map<String, List<String>> storeNamePOSMap = new Map<String, List<String>>();

//Shows if the details of a particular store are available of not!!
Map<String, bool> storeDetailsAvailable = new Map<String, bool>();

String selectedProductName;
int selectedProductCode;
//String selectedCategoryName;
//String selectedBrandName;
bool checkingIfAdmin = true;

List<dynamic> orderedProducts = List<dynamic>();
Map<dynamic, dynamic> orderDetails = Map<dynamic, dynamic>();
Map<dynamic, dynamic> selectedOrderDetails = Map<dynamic, dynamic>();
Map<String, dynamic> orders = Map<String, dynamic>();
int selectedOrderIndex = 0;
List<String> orderIds = [];


//START - CATALOG MANAGER

//ScanResult CM_barCodeScanResult;

List<ProductStockPosition> CM_barCodeSearchResults = [];
String CM_barCodeToSearch;
bool CM_searchingBarCode = false;
bool CM_scanningBarCode = false;
String CM_barCodeSearchMessage;

String CM_productName;
String CM_productBarCode;
double CM_productPrice;
int CM_productCode;
String CM_productCategory;
String CM_productBrand;
//END - CATALOG MANAGER

//START - CUSTOMER SUBSCRIPTION MANAGER
bool customerSubscriptionsAvailable = false;
bool customerSubscriptionsLoaded = false;
Map<String, bool> customerSubscriptionAvailable = Map<String, bool>();
Map<String, dynamic> subscriptionFrequencySubscriptionDetailsMap = Map<String, dynamic>();
Map<String, List<SubscribedProduct>> customerSubscriptionFrequencySubscribedProductsMap = Map<String, List<SubscribedProduct>>();
String customerSelectedSubscriptionFrequency = '';

int customerSubscribedProductCount = 0;
double customerSubscribedItemCount = 0;
double customerSubscriptionTotalValue = 0.0;

List<SubscribedProduct> subscribedProducts = <SubscribedProduct>[];

Map<String, SubscribedProduct> productIdSubscribedProductMap = <String, SubscribedProduct>{}; // Map(productId => SubscribedProduct)


Map<dynamic, dynamic> everyDaySubscription = Map<String, dynamic>();
Map<dynamic, dynamic> everyOtherDaySubscription = Map<String, dynamic>();
Map<dynamic, dynamic> everyThirdDaySubscription = Map<String, dynamic>();
Map<dynamic, dynamic> weeklySubscription = Map<String, dynamic>();
Map<dynamic, dynamic> biWeeklySubscription = Map<String, dynamic>();
Map<dynamic, dynamic> triWeeklySubscription = Map<String, dynamic>();
Map<dynamic, dynamic> monthlySubscription = Map<String, dynamic>();


//END - CUSTOMER SUBSCRIPTION MANAGER


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

class AdminProductDetails {
  String productName;
  String productID;
  String productBarCode;
  num productPrice;
  String productImageURL;
  String productCategory;
  String productBrand;
  double productStockPosition;
  AdminProductDetails(String productName, num productPrice, String productID,
      String productBarCode, String productImageURL, String productCategory, String productBrand, double productStockPosition) {
    this.productName = productName;
    this.productPrice = productPrice;
    this.productID = productID;
    this.productBarCode = productBarCode;
    this.productImageURL = productImageURL;
    this.productCategory = productCategory;
    this.productBrand = productBrand;
    this.productStockPosition = productStockPosition;
  }

  String getProductName() {
    return this.productName;
  }
}

class ProductStockPosition {
  String productName;
  int productID;
  String productBarCode;
  num productPrice;
  String productImageURL;
  String productCategory;
  String productBrand;
  double productInventoryTillDate = 0.0;
  double productSalePositionTillDate = 0.0;
  double productStockPosition = 0.0;
  ProductStockPosition(
      String productName,
      num productPrice,
      int productID,
      String productBarCode,
      String productImageURL,
      String productCategory,
      String productBrand,
      double productInventoryTillDate,
      double productSalePositionTillDate,
      double productStockPosition) {
    this.productName = productName;
    this.productPrice = productPrice;
    this.productID = productID;
    this.productBarCode = productBarCode;
    this.productImageURL = productImageURL;
    this.productCategory = productCategory;
    this.productBrand = productBrand;
    this.productInventoryTillDate = productInventoryTillDate;
    this.productSalePositionTillDate = productSalePositionTillDate;
    this.productStockPosition = productStockPosition;

  }

  void setProductStockPosition(double productStockPosition)
  {
    this.productStockPosition = productStockPosition;
  }

  void setProductSalePositionTillDate(double salePositionTillDate)
  {
    this.productSalePositionTillDate = salePositionTillDate;
  }

  void setProductInventoryTillDate(double productInventoryTillDate)
  {
    this.productInventoryTillDate = productInventoryTillDate;
  }
}


// class CarryBag {
//   const CarryBag(this.size, this.price);
//     final String size;
//     final double price;
// }

// CarryBag selectedCarryBag;

class CartEntry {
  int productCode;
  String productBarCode;
  String productName;
  double productPrice;
  String productCategory;
  String productBrand;
  double productBilledQty;
  double productBillAmount;

  CartEntry(
      int productcode,
      String productbarcode,
      String productname,
      double productprice,
      String productcategory,
      String productbrand,
      double productbilledqty,
      double productbillamount ){
    this.productCode = productcode;
    this.productBarCode = productbarcode;
    this.productName = productname;
    this.productPrice = productprice;
    this.productCategory = productcategory;
    this.productBrand = productbrand;
    this.productBilledQty = productbilledqty;
    this.productBillAmount = productbillamount;
  }
}

List<CartEntry> cartEntries = [];
Map<int, Map<String,dynamic>> productCodeCartEntryMap = {};
int cartProductCodeToUpdate;
Map<String, dynamic> cartProductToUpdate = Map<String, dynamic>();
String billAsString = '';
String whatsappNumber = '';


//bool isAdmin = false;

class InvoiceEntry {
  String billID;
  String billDate;
  String billTime;
  String storeID;
  String posID;
  int productCount;
  double itemCount;
  double billAmount;
  List<CartEntry> billedProducts;
  String paymentType;
  String cardType;
  InvoiceEntry(
      String billID,
      String billdate,
      String billtime,
      String storeid,
      String posid,
      int productcount,
      double itemcount,
      double billamount,
      String paymentType,
      String cardType,
      List<CartEntry> billedProducts)
  {
    this.billID = billID;
    this.billDate = billdate;
    this.billTime = billtime;
    this.storeID = storeid;
    this.posID = posid;
    this.productCount = productcount;
    this.itemCount = itemcount;
    this.billAmount = billamount;
    this.billedProducts = billedProducts;
    this.paymentType = paymentType;
    this.cardType = cardType;
  }
}

Map<String, dynamic> invoiceEntry = Map<String,dynamic>();
List<Map<String,dynamic>> AdminCartProducts = [];
Map<int,dynamic> AdminCartProductMap = Map<int,dynamic>();
bool processingBill = false;
double AdminCartTotal = 0.0;
int AdminProductCount = 0;
double AdminItemCount = 0.0;

Map<int, double> productSalePositionTillDateMap = new Map();
Map<int, double> productInventoryTillDateMap = new Map();



//Map<dynamic,dynamic> productSalePositionMap = Map<dynamic,dynamic>();
//List<String> productListForSelectedCategory = [];


Map<String, dynamic> AdminCategoryNameCategoryDetailsMap = Map<String, dynamic>();
Map<String, dynamic> AdminHomeCategoryNameCategoryDetailsMap = Map<String, dynamic>();
List<dynamic> AdminHomeCategories = List<dynamic>();
bool AdminHomeCategoriesAvailable = false;
List<dynamic> subCategories = List<dynamic>();
Map<String, bool> AdminCategoryProductsAvailable = new Map<String, bool>();
List<AdminProductDetails> AdminProductsForCategory = new List();
String productsFirebaseNode = 'stores/stockManagerFor/products';
String productInventoryFirebaseNode = 'stores/stockManagerFor/inventory';

String saleFirebaseNode = 'storeTerminals/POS_2/sales';

List<AdminProductDetails> AdminAllProducts = new List();
List<String> AdminProductNames = new List();
Map<String, AdminProductDetails> AdminProductMap = new Map();
Map<String, Map<String, AdminProductDetails>> AdmincategoryProductNameMap = new Map();
Map<String, List<AdminProductDetails>> AdmincategoryProductListMap =
new Map<String, List<AdminProductDetails>>();


//String barCodeToSearch = '';
//List<ProductStockPosition> barCodeSearchResults = new List();
//List<ProductStockPosition> stringSearchResults = new List();


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
String selectedOnlineSalePositionDay = 'N/A';
String selectedOnlineSalePositionMonth = 'N/A';
String selectedOnlineSalePositionYear = 'N/A';
String selectedOnlineSalePositionDate = 'N/A';


int onlineOrderProductCount = 0;
double onlineOrderItemCount = 0;
double onlineOrderAmount = 0;

Map<String, List> storeOnlineOrderIdsMap = new Map<String, List>();
Map<String, dynamic> orderMap = new Map<String, dynamic>();
Map<dynamic, dynamic> selectedOnlineOrderDetails = new Map<String, dynamic>();

//List<ProductBasicDetails> products = [];
//List<ProductBasicDetails> productSearchResults = [];
//ProductBasicDetails selectedProduct;
bool retrievingProducts = false;


//List<Category> categories = [];
//List<Category> categorySearchResults = [];
//
//List<Brand> brands = [];
//List<Brand> brandSearchResults = [];

ProductStockPosition productToUpdate;
int productToUpdateIndex;
ProductStockPosition productToDuplicate;


//START - SUBSCRPTION MODE / DELIVERY ACKNOWLEDGEMENTS
bool subscriptionFrequency = false;

String unacknowledgedDeliveryBillId = '';
//END - START - SUBSCRPTION MODE / DELIVERY ACKNOWLEDGEMENTS

Future<bool> setAdminPhoneNumber(String phoneNumber) async{
  var _preferences = await SharedPreferences.getInstance();
  return _preferences.setString('phoneNumber',phoneNumber);
}

Future<bool> setListOfManagedStores(String listOfManagedStores) async{
  var _preferences = await SharedPreferences.getInstance();
  return _preferences.setString('storeList',listOfManagedStores);
}

Future<String> getListOfManagedStores() async{
  var _preferences = await SharedPreferences.getInstance();
  var storeList = _preferences.getString('storeList');
  print(storeList);
  if(storeList == null)
  {
    print('getListOfManagedStores:List of Managed Stores is null.returning empty string!!');
    return '';
  }
  else
  {
    print('getListOfManagedStores:List of Managed Stores found!!');
    print(storeList);
    return storeList.toString();
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
    return storeList.toString();
  }
}
Future<bool> setValueInSharedPreference(String sharedPreferenceKey, String sharedPreferenceValue) async{
  var _preferences = await SharedPreferences.getInstance();
  return _preferences.setString(sharedPreferenceKey,sharedPreferenceValue);
}

void getProductInventoryTillDate()
{
  FirebaseDatabase.instance
      .reference()
      .child(productInventoryFirebaseNode)
  // .child('2019')
  // .child('12')
  // .child('23')
  // .child('inventory')
      .once()
      .then((snapshot) {
    Map<dynamic, dynamic> values = snapshot.value;
    if (snapshot.value != null) {
      values.forEach((dynamic key,dynamic value){
        // print(key);
        // print(value);
        productInventoryTillDateMap[int.parse(key.toString())] = double.parse(value['stockPosition'].toString());
      });
      print(productInventoryTillDateMap.length);
    }
  });
}
void getProductSalePositionTillDate()
{
  FirebaseDatabase.instance
      .reference()
      .child(saleFirebaseNode)
  // .child('2019')
  // .child('12')
  // .child('23')
      .child('productSalePosition')
      .once()
      .then((snapshot) {
    Map<dynamic, dynamic> values = snapshot.value;
    if (snapshot.value != null) {
      values.forEach((dynamic key,dynamic value){
        // print(key);
        // print(value);
        productSalePositionTillDateMap[int.parse(key.toString())] = double.parse(value['salePosition'].toString());
      });
      print(productSalePositionTillDateMap.length);
    }
  });
}

void getProductsForAllActiveCategories() {
  // print('getProductsForAllActiveCategories:HELLO');
  categoryNameCategoryDetailsMap.forEach((dynamic key, dynamic value) {
    // print(f['categoryName']);
    categoryProductsAvailable[key] = false;
  });

  categoryNameCategoryDetailsMap.forEach((dynamic key, dynamic value) {
    String category = key;
    productsForCategory.clear();
    FirebaseDatabase.instance
        .reference()
        .child(productsFirebaseNode)
        .orderByChild('category')
        .equalTo(category)
        .once()
        .then((snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      if (snapshot.value != null) {
        List<AdminProductDetails> prodsForCategory = new List();
        Map<String, AdminProductDetails> prodCodeProdDetailsMap = new Map();
        values.forEach((dynamic key,dynamic values) {
          if (values['productcode'].runtimeType.toString() == 'String') {
            if (values['price'].runtimeType.toString() == 'String') {
              AdminAllProducts.add(new AdminProductDetails(
                values['title'],
                double.parse(values['price'].toString()),
                values['productcode'],
                values['barcode'],
                values['imageurl'],
                values['category'],
                values['brand'],
                double.parse(values['stockposition'].toString()),
              ));

              AdminProductMap[values['productcode']] = new AdminProductDetails(
                  values['title'],
                  double.parse(values['price'].toString()),
                  values['productcode'],
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              );

              productNames.add(values['title']);

              prodsForCategory.add(new AdminProductDetails(
                  values['title'],
                  double.parse(values['price'].toString()),
                  values['productcode'],
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              )
              );
              prodCodeProdDetailsMap[values['productcode']] =
              new AdminProductDetails(
                  values['title'],
                  double.parse(values['price'].toString()),
                  values['productcode'],
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              );
            } else {
              AdminAllProducts.add(
                  new AdminProductDetails(
                      values['title'],
                      values['price'],
                      values['productcode'],
                      values['barcode'],
                      values['imageurl'],
                      values['category'],
                      values['brand'],
                      double.parse(values['stockposition'].toString())
                  )
              );
              productNames.add(values['title']);

              AdminProductMap[values['productcode']] = new AdminProductDetails(
                  values['title'],
                  values['price'],
                  values['productcode'],
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              );
              prodsForCategory.add(
                  new AdminProductDetails(
                      values['title'],
                      values['price'],
                      values['productcode'],
                      values['barcode'],
                      values['imageurl'],
                      values['category'],
                      values['brand'],
                      double.parse(values['stockposition'].toString())
                  )
              );
              prodCodeProdDetailsMap[values['productcode']] =
              new AdminProductDetails(
                  values['title'],
                  values['price'],
                  values['productcode'],
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              );
            }
          } else {
            if (values['price'].runtimeType.toString() == 'String') {
              AdminAllProducts.add(new AdminProductDetails(
                  values['title'],
                  double.parse(values['price'].toString()),
                  values['productcode'].toString(),
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              )
              );

              productNames.add(values['title']);

              AdminProductMap[values['productcode'].toString()] =
              new AdminProductDetails(
                  values['title'],
                  double.parse(values['price'].toString()),
                  values['productcode'].toString(),
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              );

              prodsForCategory.add(new AdminProductDetails(
                  values['title'],
                  double.parse(values['price'].toString()),
                  values['productcode'].toString(),
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              )
              );
              prodCodeProdDetailsMap[values['productcode'].toString()] =
              new AdminProductDetails(
                  values['title'],
                  double.parse(values['price'].toString()),
                  values['productcode'].toString(),
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              );
            } else {
              AdminAllProducts.add(new AdminProductDetails(
                  values['title'],
                  values['price'],
                  values['productcode'].toString(),
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              )
              );

              AdminProductMap[values['productcode'].toString()] =
              new AdminProductDetails(
                  values['title'],
                  values['price'],
                  values['productcode'].toString(),
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              );

              productNames.add(values['title']);

              prodsForCategory.add(new AdminProductDetails(
                  values['title'],
                  values['price'],
                  values['productcode'].toString(),
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              )
              );
              prodCodeProdDetailsMap[values['productcode'].toString()] =
              new AdminProductDetails(
                  values['title'],
                  values['price'],
                  values['productcode'].toString(),
                  values['barcode'],
                  values['imageurl'],
                  values['category'],
                  values['brand'],
                  double.parse(values['stockposition'].toString())
              );
            }
          }
          categoryProductsAvailable[category] = true;
          AdmincategoryProductListMap[category] = prodsForCategory;
          AdmincategoryProductNameMap[category] = prodCodeProdDetailsMap;
        });
        // print('Products Retrieved for Category:' + category + ':' + prodsForCategory.length.toString());
      }
      print('Total No. Of. Retrieved Products:' +
          allProducts.length.toString());
    });
  });
}


Map<dynamic, dynamic> carryBagMap = Map<dynamic, dynamic>();
List<String> carryBags = [];
String selectedCarryBag = '';
bool carryBagRequested = false;

//END - ADMIN VARIABLES


bool processingPayment = false;
String paymentStatus = 'unknown';

String creationDate = '';
String creationTime = '';
num availableBalance = 0.0;
num transactionCount = 0;
num totalAmountSpent = 0.0;
num lastTransactionAmount = 0.0;
String lastTransactionDate = '';
String lastTransactionTime = '';
num amountEntered = 0;
List<dynamic> transactions = List<dynamic>();

String currentUser = '';
//String mobileNumber = '';
//String mobile = '';


//bool isStoreAdmin = false;
//String logMessage = '';
//List<String> terminalsAtStore = [];
//String selectedTerminal = '';

bool retrievingWallet = false;
Widget walletStatusWidget;

//bool otpAuthenticated = false;
//String firebaseId = '';

class TransactionDetails {
  String transactionDate;
  String transactionTime;
  num amountSpent;

  TransactionDetails(this.transactionDate, this.transactionTime, this.amountSpent);
}

//Store selectedStore;
StoreDetails selectedStoreDetails ;
bool proceedToStore = false;
bool retrievingProductsNode = false;
bool retrievingStoreDetails = false;
bool storeLoadingSuccessful = false;
bool onlineStoresLoaded = false;



String latitude;
String longitude;
String addressFromGoogle;
String fullName = 'FAROOQ ANSARI SHAIK';
//  String verificationId = '';
//  String OTP = '';

bool savingAddress = false;
LatLng currentPosition = LatLng(0.0, 0.0);

//  /// Sign in using an sms code as input.
//  void _signInWithPhoneNumber(String smsCode) async {
//
//    print('Getting credential using OTP and Verification Id');
//    final AuthCredential credential = PhoneAuthProvider.getCredential(
//        verificationId: verificationId, smsCode: smsCode);
//
//    print('Getting USER from credential');
//
//    final FirebaseUser user =
//        await FirebaseAuth.instance.signInWithCredential(credential);
//    print('USER retrieved successfully.');
//    otpAuthenticated = true;
//    mobileNumber = mobile;
//    firebaseId = user.uid.toString();
//    print('OTP verified successfully!!');
//    // checkAndRetrieveCustomerInfo();
//  }

class StoreDetails
{
  String storeName;
  String storeContactNumber;
  String storeAddress;
  String storeLocality;
  String storePINCode;
  String storeGST;
  String storeFSSAI;
  double storeMinimumOrderValue;

  String storeId;
  int displayPosition;

  StoreDetails(this.storeName,this.storeContactNumber, this.storeAddress, this.storeLocality, this.storePINCode, this.storeGST, this.storeFSSAI, this.storeMinimumOrderValue, this.storeId, this.displayPosition);

}

class CustomerDetails {
  String firstName;
  String lastName;
  String mobileNumber;
  String alternateMobileNumber;
  void constructor() {
    this.firstName = '';
    this.lastName = '';
    this.mobileNumber = '';
    this.alternateMobileNumber = '';
  }
}

class AddressDetails {
  String fullAddress;
  String landmark;
  String locality;
  void constructor() {
    this.fullAddress = '';
    this.landmark = '';
    this.locality = '';
  }
}

CustomerDetails customerDetails = CustomerDetails();
AddressDetails addressDetails = AddressDetails();

class ProductDetails {
  String productName;
  String productID;
  String productBarCode;
  num productPrice;
  String productImageURL;
  ProductDetails(String productName, num productPrice, String productID,
      String productBarCode, String productImageURL) {
    this.productName = productName;
    this.productPrice = productPrice;
    this.productID = productID;
    this.productBarCode = productBarCode;
    this.productImageURL = productImageURL;
  }

  String getProductName() {
    return productName;
  }
}

//START - SUBSCRIPTIONS//
Map<String, dynamic> categoryNameCategoryDetailsMapForSubscription = <String, dynamic>{};
Map<String, dynamic> homeCategoryNameCategoryDetailsMapForSubscription = <String,dynamic>{};
List<dynamic> homeCategoriesForSubscription = <dynamic>[];
Map<String, bool> categoryProductsAvailableForSubscription = new Map<String, bool>();
List<ProductDetails> productsForCategoryForSubscription = new List<ProductDetails>();
List<ProductDetails> allProductsForSubscription = new List<ProductDetails>();
Map<String, ProductDetails> productMapForSubscription = new Map<String,ProductDetails>();
List<String> productNamesForSubscription = new List();
Map<String, List<ProductDetails>> categoryProductListMapForSubscription = new Map<String, List<ProductDetails>>();
Map<String, Map<String, ProductDetails>> categoryProductNameMapForSubscription = new Map();
String categorySelectedForSubscription;
Store selectedStoreForSubscription;
StoreDetails selectedStoreDetailsForSubscription ;
bool proceedToStoreForSubscription = false;
bool retrievingProductsNodeForSubscription = false;
bool retrievingStoreDetailsForSubscription = false;
bool storeLoadingSuccessfulForSubscription = false;
bool onlineStoresLoadedForSubscription = false;
String registeredMobileNumberForSubscription = '9849494143';
List<SubscribedProduct> allSubscribedProducts = List<SubscribedProduct>();
//END - SUBSCRIPTIONS//

////////////////////////////////////////////////////////////////////////////////////////////////////
Map<String, dynamic> categoryNameCategoryDetailsMap = <String, dynamic>{};
Map<String, dynamic> homeCategoryNameCategoryDetailsMap = <String,dynamic>{};
List<dynamic> homeCategories = <dynamic>[];
Map<String, bool> categoryProductsAvailable = new Map<String, bool>();
List<ProductDetails> productsForCategory = new List<ProductDetails>();
List<ProductDetails> allProducts = new List<ProductDetails>();
//Map<String, ProductDetails> productMap = new Map<String,ProductDetails>();
List<String> productNames = new List();
Map<String, List<ProductDetails>> categoryProductListMap = new Map<String, List<ProductDetails>>();
Map<String, Map<String, ProductDetails>> categoryProductNameMap = new Map();
String categorySelected;
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

class SubscribedProduct {
  String productName;
  String productID;
  String productBarCode;
  String productImageURL;
  num productPrice;
  num subscribedQty;
  String subscriptionFrequency;

  SubscribedProduct(this.productName, this.productID, this.productBarCode,
      this.productPrice, this.productImageURL, this.subscribedQty, this.subscriptionFrequency);
}

List<CartProduct> cartProducts = <CartProduct>[];
Map<String, ProductDetails> categoryProductMap = Map();
Map<String, CartProduct> cartProductMap = <String, CartProduct>{};
Map<String, dynamic> categoryNameMap = <String, dynamic>{};
Map<String, dynamic> subCategoryMap = <String, dynamic>{};






num cartTotal = 0.0;
num productCount = 0;
num itemCount = 0;
// bool otpAuthenticated = false;
// String categorySelected;
// String mobileNumber = '1234567890';
// String firebaseId = '';
String orderFirebaseId = '';
String storeAddress = '';
String customerFirstName;
String customerLastName;
String customerAlternateMobileNumber;
List<Widget> listAddresses = <Widget>[];
bool customerDetailsAvailable = false;
bool productsAvailable = false;
bool authenticating = false;
bool retrievingAddress = false;
String fcm_token;


class CustomerAddress {
  String fullAddress;
  String landmark;
  String locality;
  CustomerAddress(this.fullAddress, this.locality, this.landmark);
}

CustomerAddress shippingAddress = CustomerAddress(
    'KIRANAWALA RETAIL IT SOLUTIONS, I FLOOR, ABOVE S-MART SUPERMARKET,1-111/2/2/1, KONDAPUR X ROADS, 500084',
    'KONDAPUR X ROADS',
    '8TH POLICE BATALLION');

List<CustomerAddress> customerAddresses = <CustomerAddress>[];

// bool otpAuthenticated = false;
// String categorySelected;
// String mobileNumber = '1234567890';
// String firebaseId = '';
// String orderFirebaseId = '';
// String storeAddress = '';
// String storeContactNumber = '';
// String customerFirstName;
// String customerLastName;
// String customerAlternateMobileNumber;
// List<Widget> listAddresses = new List<Widget>();
// bool customerDetailsAvailable = false;

class Store {
  const Store(this.storeId, this.storeName, this.displayPosition);
  final String storeId;
  final String storeName;
  final int displayPosition;
}

class DeliveryTimeSlot {
  const DeliveryTimeSlot(this.deliveryTimeSlot, this.offset);
  final String deliveryTimeSlot;
  final String offset;
}

class DeliveryDate {
  const DeliveryDate(this.deliveryDate, this.dayOffset);
  final String deliveryDate;
  final String dayOffset;
}

DeliveryDate selectedDeliveryDate;
DeliveryTimeSlot selectedDeliveryTimeSlot;
String orderCustomization = 'NONE';
/////////////////////////////////////////////////////////////////////////////////////////////////////

Future<bool> setMobileNumber(String mobileNumber) async
{
  var _preferences = await SharedPreferences.getInstance();
  return _preferences.setString('mobileNumber',mobileNumber);
}

Future<bool> setManagedStores(String managedStores) async
{
  var _preferences = await SharedPreferences.getInstance();
  return _preferences.setString('managedStores',managedStores);
}

Future<bool> setManagedTerminals(String managedTerminals) async
{
  var _preferences = await SharedPreferences.getInstance();
  return _preferences.setString('managedTerminals',managedTerminals);
}

Future<bool> setPosTerminalStoreName(String posTerminal, String storeName) async
{
  var _preferences = await SharedPreferences.getInstance();
  return _preferences.setString(posTerminal,storeName);
}

Future<String> getManagedStores() async
{
  var _preferences = await SharedPreferences.getInstance();
  String managedStores = _preferences.getString('managedStores');
  print(managedStores);
  if(managedStores == null)
  {
    print('managedStores is null.returning empty string!!');
    return '';
  }
  else
  {
    print('managedStores found' + managedStores.toString());
    return managedStores.toString();
  }
}

Future<String> getManagedTerminals() async
{
  var _preferences = await SharedPreferences.getInstance();
  String managedTerminals = _preferences.getString('managedTerminals');
  print(managedTerminals);
  if(managedTerminals == null)
  {
    print('managedTerminals is null.returning empty string!!');
    return '';
  }
  else
  {
    print('managedTerminals found' + managedTerminals.toString());
    return managedTerminals.toString();
  }
}
//Future<String> getMobileNumber() async
//{
//  var _preferences = await SharedPreferences.getInstance();
//  mobileNumber = _preferences.getString('mobileNumber');
//  print(mobileNumber);
//  if(mobileNumber == null)
//  {
//    print('mobile number is null.returning empty string!!');
//    return '';
//  }
//  else
//  {
//    print('phone number found' + mobileNumber.toString());
//    return mobileNumber.toString();
//  }
//}

Future<String> getPosTerminalStoreName(String posTerminal) async
{
  var _preferences = await SharedPreferences.getInstance();
  String storeName = _preferences.getString(posTerminal);
  print(storeName);
  if(storeName == null)
  {
    print('storeName is null.returning empty string!!');
    return '';
  }
  else
  {
    print('storeName found' + storeName.toString());
    return storeName.toString();
  }
}

Future<bool> removeMobileNumber() async
{
  print('removeMobileNumber:inside');
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  return _preferences.remove('mobileNumber');
}

Future <bool> removeStoreList() async
{
  SharedPreferences _preferences = await SharedPreferences.getInstance();
  return _preferences.remove('storeList');
}

//void main() {
//  removeMobileNumber();

  // getProductSalePositionTillDate();
  // getProductInventoryTillDate();

  //   getPhoneNumber().then((value){
  //   print(value);
  //   mobileNumber = value;
  //   print(mobileNumber);
  //   if(mobileNumber == '')
  //   {
  //     FirebaseAuth.instance.currentUser().then((value)
  //     {
  //       print('current user is ' + value.toString());
  //       if (value == null)
  //       {
  //        runApp(new MaterialApp(
  //         debugShowCheckedModeBanner: false,
  //         home:FirebaseMobileAuthentication(),
  //       ));
  //       }
  //       else
  //       {
  //         currentUser = value.toString();
  //         mobileNumber = value.phoneNumber;
  //         print(currentUser);
  //         print(mobileNumber);
  //         setPhoneNumber(mobileNumber);
  //         // retrievingWallet = true;
  //         // retrieveWalletStatus();
  //         runApp(new MaterialApp(
  //           debugShowCheckedModeBanner: false,
  //           home:MakePayment(),
  //           // home:StoreSelection(),
  //         ));
  //       }
  //     });
  //   }
  //   else
  //   {
  //     // retrievingWallet = true;
  //     // retrieveWalletStatus();
  //     runApp(new MaterialApp(
  //       debugShowCheckedModeBanner: false,
  //       home:MakePayment(),
  //     ));
  //   }
  // });
//  runApp(MaterialApp(
//    debugShowCheckedModeBanner: false,
//    home:StoreSelection(),
//  ));
//}

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

//List<String> stores = [
//  'S-MART GROUP',
//  'S-MART I',
//  'S-MART II',
//  'S-MART III',
//  'S-MART IV',
//  'S-MART V',
//  'S-MART VI',
//  'S-MART VII',
//];



//Map<String, String> storeIdMap = {
//  'S-MART I':'KIRANAWALA_STORE_4',
//  'S-MART II':'KIRANAWALA_STORE_3',
//  'S-MART III':'KIRANAWALA_STORE_2',
//  'S-MART IV':'KIRANAWALA_STORE_6',
//  'S-MART V':'KIRANAWALA_STORE_7',
//  'S-MART VI':'KIRANAWALA_STORE_5',
//  'S-MART VII':'KIRANAWALA_STORE_8',
//};

//Map<String, List<String>> storeIdTerminalMap = {
//  'KIRANAWALA_STORE_4':['POS_4'],
//  'KIRANAWALA_STORE_3':['POS_3'],
//  'KIRANAWALA_STORE_2':['POS_2'],
//  'KIRANAWALA_STORE_6':['POS_6'],
//  'KIRANAWALA_STORE_7':['POS_7'],
//  'KIRANAWALA_STORE_5':['POS_5'],
//  'KIRANAWALA_STORE_8':['POS_8','POS_9'],
//};



//List<String> allTerminals =  List<String>();
//String selectedStore = stores[0];
bool storeResetSuccessful = true;

//String productNode = '';
//String inventoryNode = '';
//String storeLocation = '';


void main()
  {



    carryBags.add('SMALL');
    carryBags.add('MEDIUM');
    carryBags.add('LARGE');
    carryBags.add('XTRA-LARGE');

    carryBagMap['SMALL'] =
    {
      'productCode':272727911936,
      'productBarCode': '2727279119360',
      'productName':'CARRY BAG SMALL 1N',
      'productPrice':2.0,
      'productCategory':'HOME',
      'productBrand':'KIRANAWALA',
      'productBilledQty':1,
      'productBillAmount':2.0,
    };
    carryBagMap['MEDIUM'] =
    {
      'productCode':272727911934,
      'productBarCode': '2727279119346',
      'productName':'CARRY BAG MEDIUM 1N',
      'productPrice':3.0,
      'productCategory':'HOME',
      'productBrand':'KIRANAWALA',
      'productBilledQty':1,
      'productBillAmount':3.0,
    };
    carryBagMap['LARGE'] =
    {
      'productCode':272727911933,
      'productBarCode': '2727279119339',
      'productName':'CARRY BAG LARGE 1N',
      'productPrice':4.0,
      'productCategory':'HOME',
      'productBrand':'KIRANAWALA',
      'productBilledQty':1,
      'productBillAmount':4.0,
    };
    carryBagMap['XTRA-LARGE'] =
    {
      'productCode':272727911935,
      'productBarCode': '2727279119353',
      'productName':'CARRY BAG XL 1N',
      'productPrice':5.0,
      'productCategory':'HOME',
      'productBrand':'KIRANAWALA',
      'productBilledQty':1,
      'productBillAmount':5.0,
    };
 runApp(
   new MaterialApp(
     theme: ThemeData(fontFamily: 'Kohinoor-Boldx'),
    debugShowCheckedModeBanner: false,
//   home:ProductStockPosition(),
   //home:AuthenticateMobileNumber()
   home:ShowAdminHomePage()
//   home:AlgoliaSearchPage()
  ));
}




