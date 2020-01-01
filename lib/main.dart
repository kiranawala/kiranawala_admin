import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/HomePage.dart';
import 'package:kiranawala_admin/pages/ShowCategoryWiseSalePositionStreamBuilder.dart';
import 'package:shared_preferences/shared_preferences.dart';


bool otpAuthenticated = false;
String categorySelected;
String mobileNumber = '';
String firebaseId = '';

double totalSaleSoFarToday = 0.0;

int totalWalkins = 0;
String totalWalkinsAsString = '0';

double totalSale = 0;
String totalSaleAsString = '';

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
List storeList = new List();
List<dynamic> saleAtAllStores = new List();
List<dynamic> storeSaleAnalysMap = new List();
double saleAtStoreTerminal = 0.0;
int walkinsAtStoreTerminal = 0;
List<Widget> salePerTerminal = [];

var saleDetails={};
String saleDate = '';
String year = '';
String month = '';
String day = '';

String selectedOrderDate = '';
String selectedPOSTerminal = '';
String selectedBillTime = '';
String selectedSaleDate = '';
String selectedSaleStartDate = '';
String selectedSaleEndDate = '';

bool refreshingTerminalWiseSales = true;
bool refreshingCategoryWiseSales = true;
bool refreshingProductWiseSales = true;
bool isStoreAdmin = false;
String currentUser = '';
String logMessage = '';
List<String> terminalsAtStore = [];
String selectedTerminal = '';
var posTerminalStoreNameMapping = {
  'POS_2' : 'S-MART III',
  'POS_4' : 'S-MART I',
  'POS_1' : 'RV VILLAGE'
};

class ProductDetails {
  String productName;
  String productID;
  String productBarCode;
  num productPrice;
  String productImageURL;
  String productCategory;
  String productBrand;
  double productStockPosition;
  ProductDetails(String productName, num productPrice, String productID,
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

  getProductName() {
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


Map<dynamic,dynamic> productSalePositionMap = {};
List<String> productListForSelectedCategory = [];


Map<String, dynamic> categoryNameCategoryDetailsMap = {};
Map<String, dynamic> homeCategoryNameCategoryDetailsMap = {};
List<dynamic> homeCategories = [];
bool homeCategoriesAvailable = false;
List<dynamic> subCategories = [];
Map<String, bool> categoryProductsAvailable = new Map<String, bool>();
List<ProductDetails> productsForCategory = new List();
String productsFirebaseNode = 'stores/KIRANAWALA_STORE_2/products';
String productInventoryFirebaseNode = 'stores/KIRANAWALA_STORE_2/inventory';

String saleFirebaseNode = 'storeTerminals/POS_2/sales';

List<ProductDetails> allProducts = new List();
List<String> productNames = new List();
Map<String, ProductDetails> productMap = new Map();
Map<String, Map<String, ProductDetails>> categoryProductNameMap = new Map();
Map<String, List<ProductDetails>> categoryProductListMap =
new Map<String, List<ProductDetails>>();
Map<int, double> productSalePositionTillDateMap = new Map();
Map<int, double> productInventoryTillDateMap = new Map();



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
              values.forEach((key,value){
                print(key);
                print(value);
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
              values.forEach((key,value){
                print(key);
                print(value);
                productSalePositionTillDateMap[int.parse(key.toString())] = double.parse(value['salePosition'].toString());
              });
              print(productSalePositionTillDateMap.length);
            }            
          });
}







  void getProductsForAllActiveCategories() {
    // print('getProductsForAllActiveCategories:HELLO');
    categoryNameCategoryDetailsMap.forEach((key, value) {
      // print(f['categoryName']);
      categoryProductsAvailable[key] = false;
    });

    categoryNameCategoryDetailsMap.forEach((key, value) {
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
          List<ProductDetails> prodsForCategory = new List();
          Map<String, ProductDetails> prodCodeProdDetailsMap = new Map();
          values.forEach((key, values) {
            if (values['productcode'].runtimeType.toString() == 'String') {
              if (values['price'].runtimeType.toString() == 'String') {
                allProducts.add(new ProductDetails(
                    values['title'],
                    double.parse(values['price'].toString()),
                    values['productcode'],
                    values['barcode'],
                    values['imageurl'],
                    values['category'],
                    values['brand'],
                    double.parse(values['stockposition'].toString()),
                    ));

                productMap[values['productcode']] = new ProductDetails(
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

                prodsForCategory.add(new ProductDetails(
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
                    new ProductDetails(
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
                allProducts.add(
                  new ProductDetails(
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

                productMap[values['productcode']] = new ProductDetails(
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
                  new ProductDetails(
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
                  new ProductDetails(
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
                allProducts.add(new ProductDetails(
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

                productMap[values['productcode'].toString()] =
                    new ProductDetails(
                        values['title'],
                        double.parse(values['price'].toString()),
                        values['productcode'].toString(),
                        values['barcode'],
                        values['imageurl'],
                        values['category'],
                        values['brand'],
                        double.parse(values['stockposition'].toString())
                        );

                prodsForCategory.add(new ProductDetails(
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
                    new ProductDetails(
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
                allProducts.add(new ProductDetails(
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

                productMap[values['productcode'].toString()] =
                    new ProductDetails(
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

                prodsForCategory.add(new ProductDetails(
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
                    new ProductDetails(
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
            categoryProductListMap[category] = prodsForCategory;
            categoryProductNameMap[category] = prodCodeProdDetailsMap;
          });
          // print('Products Retrieved for Category:' + category + ':' + prodsForCategory.length.toString());
        }
        print('Total No. Of. Retrieved Products:' +
            allProducts.length.toString());
      });
    });
  }



void main(){

  getProductSalePositionTillDate();
  getProductInventoryTillDate();

    categoryNameCategoryDetailsMap = {};
      homeCategoryNameCategoryDetailsMap = {}; 
      FirebaseDatabase.instance
            .reference()
            .child('stores')
            .child('KIRANAWALA_STORE_2')
            .child('lastBillNumber')
            .child('categoriesMaster')
            .once()
            .then((snapshot) {
          if (snapshot != null && snapshot.value != null) {
            // print(snapshot);
            List<dynamic> categoryListSnapshot = snapshot.value;
            // print(categorySnapshot);
            categoryListSnapshot.forEach((categoryDetails) {
              // print(categoryNode);
              // print(categoryDetails);
              // print(categoryDetails['categoryId']);
              // print(categoryDetails['displayPosition']);
              // print(categoryDetails['displayName']);
              // print(categoryDetails['isActive']);
              // print(categoryDetails['isParent']);
              // print(categoryDetails['categoryImage']);
              if (categoryDetails['categoryId'] != null &&
                  categoryDetails['categoryImage'] != null &&
                  categoryDetails['displayPosition'] != null &&
                  categoryDetails['displayName'] != null &&
                  categoryDetails['isActive'] != null &&
                  categoryDetails['isParent'] != null) {
                // print(categoryDetails);
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
              }
            });
            // setState(() {
            //   homeCategoriesAvailable = true;
            // });
            print(homeCategories.length.toString());
            print(homeCategories);
            homeCategories.sort((a, b) {
              return a['displayPosition'].compareTo(b['displayPosition']);
            });
            print(homeCategories);
            print(subCategories.length.toString());
            getProductsForAllActiveCategories();
          }
          // print('Number of HOME Categories:' + homeCategories.length.toString());
          // // print(homeCategories);
          // print('Number of SUB Categories:' + subCategories.length.toString());
          // // print(subCategories);
        });

  
    DateTime now = DateTime.now();
    selectedSaleDate = DateFormat('yyyy-MM-dd').format(now);
    selectedSaleStartDate = DateFormat('yyyy-MM-dd').format(now);
    selectedSaleEndDate = DateFormat('yyyy-MM-dd').format(now);

    year = selectedSaleDate.substring(0,4);
    month = selectedSaleDate.substring(5,7);
    day = selectedSaleDate.substring(8,10);

    year = selectedSaleStartDate.substring(0,4);
    month = selectedSaleStartDate.substring(5,7);
    day = selectedSaleStartDate.substring(8,10);

    year = selectedSaleEndDate.substring(0,4);
    month = selectedSaleEndDate.substring(5,7);
    day = selectedSaleEndDate.substring(8,10);

  // FirebaseDatabase.instance.
  //               reference().
  //               child('storeTerminals').   
  //               child('POS_2').
  //               child('sales').
  //               child(year).
  //               child(month).
  //               child(day).
  //               child('totalSale').  
  //               once().
  //               then((snapshot){
  //                 if(snapshot != null && snapshot.value != null){
  //                  totalSaleSoFarToday = double.parse(snapshot.value.toString());
  //                  print('Sale So Far Today:' + totalSaleSoFarToday.toString());
  //                 }
  //               });                           

 runApp(
   new MaterialApp(
     theme: ThemeData(fontFamily: 'Montserrat'),
    debugShowCheckedModeBanner: false,  
    home: HomePage(),    
  ));
}


// void totalSaleForToday()
// {
//     DateTime now = DateTime.now();
//     saleDate = DateFormat('yyyy-MM-dd').format(now);

//     var year = saleDate.substring(0,4);
//     var month = saleDate.substring(5,7);
//     var day = saleDate.substring(8,10);

//   FirebaseDatabase.instance.
//                 reference().
//                 child('storeTerminals').   
//                 child('POS_2').
//                 child('sales').
//                 child(year).
//                 child(month).
//                 child(day).
//                 child('totalSale').  
//                 once().
//                 then((snapshot){
//                   if(snapshot != null && snapshot.value != null){
//                    totalSaleSoFarToday = snapshot.value;
//                    print('Sale So Far Today:' + totalSaleSoFarToday.toString());
//                   }
//                 });   

// }


//  void totalSaleForTheDay(posID)
//   {
//     DateTime now = DateTime.now();

//     saleDate = DateFormat('yyyy-MM-dd').format(now);

//     var year = saleDate.substring(0,4);
//     var month = saleDate.substring(5,7);
//     var day = saleDate.substring(8,10);

//     FirebaseDatabase.instance.
//                 reference().
//                 child('storeTerminals').
//                 child(posID).
//                 child('sales').
//                 child(year).
//                 child(month).
//                 child(day).
//                 once().
//                 then((snapshot){
//                   if(snapshot != null && snapshot.value != null){
//                       totalSaleSoFarToday = double.parse(snapshot.value['totalSale'].toString());
//                       totalWalkins = int.parse(snapshot.value['totalWalkins'].toString());
//                       storeSaleAnalysMap.add({
//                         'totalSale':totalSaleSoFarToday,
//                         'totalWalkins':totalWalkins,
//                         'posID':posID
//                       });                    
//                   }
//                 });

//                 storeSaleAnalysMap.forEach((key){
//                   print(key.toString());
//                   print(key['posID']);
//                   print(key['totalSale']);
//                   print(key['totalWalkins']);
//                 });
//   }

  Future<bool> setPhoneNumber(String phoneNumber) async{
  var _preferences = await SharedPreferences.getInstance();
    return _preferences.setString('phoneNumber',phoneNumber);
  }


