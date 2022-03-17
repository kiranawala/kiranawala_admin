import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/store-stock-position.dart';
import 'request-stock-inward-qty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'request-stock-inward-barcode.dart';
import 'stock-inward-product-search-results.dart';

class ProductStockIn {
  int productCode;
  String productBarCode;
  String productName;
  double productPrice;
  double productStockInQty;

  ProductStockIn(
    int productcode,
    String productbarcode,
    String productname,
    double productprice,
    double productstockinqty,
  ) {
    this.productCode = productcode;
    this.productBarCode = productbarcode;
    this.productName = productname;
    this.productPrice = productprice;
    this.productStockInQty = productstockinqty;
  }
}

List<ProductStockIn> stockInEntries = [];
Map<int, ProductStockIn> stockInMap = Map<int, ProductStockIn>();
int productStockInCodeToUpdate;
Map<String, dynamic> productStockInToUpdate = Map<String, dynamic>();
int stockInProductCount = 0;
double stockInItemCount = 0;
int stockInwardDetailsRetrieved = 0;

Map<int, ProductRecentStockInwardDetails> recentProductStockInwardDetailsMap = Map<int, ProductRecentStockInwardDetails>();

class StockInManagerOnline extends StatefulWidget {
  @override
  _StockInManagerOnlineState createState() => _StockInManagerOnlineState();
}

class _StockInManagerOnlineState extends State<StockInManagerOnline> {
  bool retrievingProductDetails = false;
  bool retrievingProductStockInwardDetails = false;
  int stockPosition = 0;
  double productStockPosition = 0;
  int productId = 0;
  bool retrievingProductsNode = false;

  void updateStockInward()
  {
    Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          return RequestStockInwardQty();
        }));
//    .then((dynamic requestValue) {
//      if (requestValue != null) {
//        addProductToStockEntry(
//            double.parse(requestValue.toString()));
//      }
//    });

//        print('STOCK IN:' + requestValue.toString());


//        FirebaseDatabase.instance.reference()
//            .child('stores')
//            .child(inventoryNode)
//            .child('stockInwards')
//            .child(DateFormat('ddMMMyyyy').format(DateTime.now()).toString())
//            .child(stockInProductToUpdate.productID.toString())
//            .child('stockInwardQty')
//            .once()
//            .then((stockInwardQtySnapshot){
//          double stockInwardQty = 0;
//          if(stockInwardQtySnapshot != null && stockInwardQtySnapshot.value != null) {
//            stockInwardQty = double.parse(
//                stockInwardQtySnapshot.value.toString());
//          }
//          stockInwardQty = stockInwardQty +
//              double.parse(requestValue.toString());
//
//          FirebaseDatabase.instance.reference()
//              .child('stores')
//              .child(inventoryNode)
//              .child('stockInwards')
//              .child(DateFormat('ddMMMyyyy').format(DateTime.now()).toString())
//              .child(stockInProductToUpdate.productID.toString())
//              .set(<String,dynamic>{
//            'productCode': stockInProductToUpdate.productID,
//            'productBarCode':stockInProductToUpdate.productBarCode,
//            'productName': stockInProductToUpdate.productName,
//            'productPrice': stockInProductToUpdate.productPrice,
//            'stockInwardQty': stockInwardQty
//          });
//        });

//        FirebaseDatabase.instance.reference()
//            .child('stores')
//            .child(inventoryNode)
//            .child('products')
//            .child(stockInProductToUpdate.productID.toString())
//            .child('stockInwards')
//            .child(DateFormat('ddMMMyyyy-HHmmss-SSS').format(DateTime.now()).toString())
//            .update(<String, dynamic>{
//          'stockInwardQty':double.parse(requestValue.toString()),
//          'date':DateFormat('ddMMMyyyy').format(DateTime.now()).toString(),
//          'time':DateFormat('HHmmss-SSS').format(DateTime.now()).toString(),
//          'mode':'manual',
//          'invoiceId':inventoryNode + '-' + DateFormat('ddMMMyyyy-HHmmss-SSS').format(DateTime.now()).toString()
//        }).then((dynamic stockInwardsUpdateStatus){
//          print('stockInward updated successfully.');
//          FirebaseDatabase.instance.reference()
//              .child('stores')
//              .child(inventoryNode)
//              .child('products')
//              .child(stockInProductToUpdate.productID.toString())
//              .update(<String, dynamic>{
//            'recentStockInwardDate':DateFormat('ddMMMyyyy').format(DateTime.now()).toString(),
//            'recentStockInwardTime':DateFormat('HHmmss-SSS').format(DateTime.now()).toString(),
//            'recentStockInwardQty':double.parse(requestValue.toString()),
//          });
//          FirebaseDatabase
//              .instance
//              .reference()
//              .child('stores')
//              .child(inventoryNode)
//              .child('products')
//              .child(stockInProductToUpdate.productID.toString())
//              .child('stockInwardTillDate')
//              .runTransaction((mutableData) async {
//            mutableData.value =(mutableData.value??0) + double.parse(requestValue.toString());
//            return mutableData;
//          });
//        });


//      } else {
//        print('STOCK IN: VALUE IS NULL');
//      }
//    });
  }

  void getProductDetails()
  {
    setState(() {
      retrievingProductDetails = true;
      retrievingProductStockInwardDetails = true;
      barCodeSearchResults = [];
      stockInwardDetailsRetrieved = 0;
    });

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(productNode)
        .child('products')
        .orderByChild('barcode')
        .equalTo(barCodeToSearch.toLowerCase())
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
      if (snapshot != null && snapshot.value != null) {
        Map<dynamic, dynamic> productDetailsMap = snapshot.value;
        if (productDetailsMap.length == 1) {
          print(productDetailsMap.length);
          productDetailsMap.forEach((dynamic code, dynamic product) {
            barCodeSearchResults.add(new ProductBasicDetails(
              product['title'].toString(),
              double.parse(product['price'].toString()),
              int.parse(product['productcode'].toString()),
              product['barcode'].toString(),
              product['imageurl'].toString(),
              product['category'].toString(),
              product['brand'].toString(),
            ));
          });
          print(barCodeSearchResults);
          barCodeSearchResults.forEach((element) {
            getProductRecentStockInwardDetails(element.productID);
          });
          setState(() {
            retrievingProductDetails = false;
          });
        } else if (productDetailsMap.length > 1) {
          productDetailsMap.forEach((dynamic code, dynamic product) {
            barCodeSearchResults.add(new ProductBasicDetails(
              product['title'].toString(),
              double.parse(product['price'].toString()),
              int.parse(product['productcode'].toString()),
              product['barcode'].toString(),
              product['imageurl'].toString(),
              product['category'].toString(),
              product['brand'].toString(),
            ));
          });
          barCodeSearchResults.sort((a, b) {
            return a.productName.compareTo(b.productName);
          });
          print(barCodeSearchResults);
          barCodeSearchResults.forEach((element) {
            getProductRecentStockInwardDetails(element.productID);
          });
          setState(() {
            retrievingProductDetails = false;
          });
        }
      } else {
        setState(() {
          retrievingProductDetails = false;
          retrievingProductStockInwardDetails = false;
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) {
                    return StockInwardProductSearchResults();
                  }));
        });

        print(barCodeToSearch + ':product not in system');
      }
    });
  }

  Future scan() async {
    try {
      barCodeToSearch = (await BarcodeScanner.scan()).toString();
      print('Scanned BarCode:' + barCodeToSearch);

      print(barCodeToSearch);
      if (barCodeToSearch.length > 0) {
        getProductDetails();
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          retrievingProductDetails = false;
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return StockInManagerOnline();
              }));
        });
      } else {
        setState(() {
          retrievingProductDetails = false;
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return StockInManagerOnline();
              }));
        });

      }
    } on FormatException {
      setState(() {
        retrievingProductDetails = false;
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return StockInManagerOnline();
            }));
      });
    } catch (e) {
      setState(() {
        retrievingProductDetails = false;
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return StockInManagerOnline();
            }));
      });
    }
  }

  void getProductRecentStockInwardDetails(int productCode){
   print('Retrieving Product Details:' + productCode.toString());
   setState(() {
     retrievingProductStockInwardDetails = true;
   });
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(inventoryNode)
        .child('products')
        .child(productCode.toString())
        .child('stockInwards')
        .once()
        .then((snapshot){
      if(snapshot != null && snapshot.value != null) {
        recentProductStockInwardDetailsMap[
        int.parse(productCode.toString())] =
            ProductRecentStockInwardDetails(
              int.parse(productCode.toString()),
              (snapshot.value['recentStockInwardDate'] != null)
                  ? snapshot.value['recentStockInwardDate']
                  : 'N/A',
              (snapshot.value['recentStockInwardTime'] != null)
                  ? snapshot.value['recentStockInwardTime']
                  : 'N/A',
              (snapshot.value['recentStockInwardQty'] != null)
                  ? double.parse(
                  snapshot.value['recentStockInwardQty'].toString())
                  : 0,
              (snapshot.value['stockInwardTillDate'] != null)
                  ? double.parse(
                  snapshot.value['stockInwardTillDate'].toString())
                  : 0,);
      }
      else
        {
          recentProductStockInwardDetailsMap[
          int.parse(productCode.toString())] =
              ProductRecentStockInwardDetails(
                int.parse(productCode.toString()),
                'N/A',
                'N/A',
                0,
                  0);
        }
      stockInwardDetailsRetrieved = stockInwardDetailsRetrieved + 1;
      print('Stock Inward Details Retrieved For:' +
          stockInwardDetailsRetrieved.toString());
      if(stockInwardDetailsRetrieved == barCodeSearchResults.length){
        if(retrievingProductDetails == false) {
          setState(() {
            retrievingProductStockInwardDetails = false;
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) {
                      return StockInwardProductSearchResults();
                    }));
          });
        }
        print('Stock Inward Details Retrieved For All Products');


      }
    });
  }
  Future getBarCode() async {
    barCodeToSearch = await Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
      return RequestStockInwardBarCode();
    }));
    print(barCodeToSearch);
    if (barCodeToSearch.length > 0) {
      getProductDetails();
    }
  }

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

  Future<bool> setValueInSharedPreference(
      String sharedPreferenceKey, String sharedPreferenceValue) async {
    var _preferences = await SharedPreferences.getInstance();
    return _preferences.setString(sharedPreferenceKey, sharedPreferenceValue);
  }

//  void getStockInwardDetails()
//  {
//
//    print('Inside getStockInwardDetails()');
//    stockInwardDetailsLoading = true;
//    stockInwardDetailsLoaded = false;
//    FirebaseDatabase.instance
//        .reference()
//        .child('stores')
//        .child(inventoryNode)
//        .child('products')
//        .onValue
//        .listen((event) {
//      print('getStockInwardDetails:' + event.snapshot.value.toString());
//      if (event.snapshot != null && event.snapshot.value != null) {
//        Map<dynamic, dynamic> values = event.snapshot.value;
//        values.forEach((dynamic productcode, dynamic values) {
//              stockInwardDetailsMap[
//              int.parse(productcode.toString())] = ProductStockInwardDetails(
//                (values['productcode'].runtimeType.toString() == 'String')?int.parse(values['productcode']):values['productcode'],
//                (values['recentStockInwardDate'] != null)
//                    ? values['recentStockInwardDate']
//                    : 'N/A',
//                (values['recentStockInwardTime'] != null)
//                    ? values['recentStockInwardTime']
//                    : 'N/A',
//                (values['recentStockInwardQty'] != null)
//                    ? double.parse(values['recentStockInwardQty'].toString())
//                    : 0,);
//
//              if(values['stockInwards'] != null){
////                print(values['stockInwards']);
//                List<dynamic> productStockInwardsTillDate = new List<dynamic>();
////                productStockInwardsTillDate  = values['stockInwards'];
//                double productStockInwardQtyTillDate = 0;
//                values['stockInwards'].forEach((dynamic key, dynamic value) {
////                  print(productcode.toString() + ':');
////                if(value['date'] == '02Jul2020') {
////                  print(productcode.toString());
////                  print(value['date']);
////                  print(value['time']);
////                  print(value['stockInwardQty']);
//                  productStockInwardsTillDate.add(<String, dynamic>{
//                    'date':value['date'],
//                    'time':value['time'],
//                    'qty':value['stockInwardQty']
//                  });
//                  productStockInwardQtyTillDate = productStockInwardQtyTillDate + double.parse((value['stockInwardQty'].toString()));
////                }
////                  print(value['stockInwardQty']);
//                });
//                productCodeStockInwardsTillDateMap[int.parse(productcode.toString())] = productStockInwardsTillDate;
//                productCodeStockInwardQtyTillDateMap[int.parse(productcode.toString())] = productStockInwardQtyTillDate;
//              }
//
////              values['stockInwards'].forEach((dynamic stockInward){
////                print(stockInward);
////              });
//        });
////        print(productCodeStockInwardsMap);
//        print(productCodeStockInwardsTillDateMap.length);
//        print(productCodeStockInwardQtyTillDateMap.length);
////        productCodeStockInwardsMap.forEach((dynamic key, dynamic value) {
////          print(key);
////          print(value);
////
////        });
//        print('Stock Inward Details Available:' +
//            stockInwardDetailsMap.length.toString());
//        stockInwardDetailsList = new List<ProductStockInwardDetails>();
//        stockInwardDetailsMap.forEach((key, value) {
//          stockInwardDetailsList.add(value);
//        });
//        setState(() {
//          stockInwardDetailsLoading = false;
//          stockInwardDetailsLoaded = true;
//        });
//
//
//
////        print(stockInwardDetailsMap[272727908616].recentStockInwardQty);
////        print(stockInwardDetailsMap[272727908616].recentStockInwardDate);
////        print(stockInwardDetailsMap[272727908616].recentStockInwardTime);
//
//      } else {
//        setState(() {
//          stockInwardDetailsLoading = false;
//          stockInwardDetailsLoaded = false;
//        });
//      }
//    });
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getStockInwardDetails().then((value){
//      if(value != null && value == true)
//        {
//          setState(() {
//            stockInwardDetailsLoading = false;
//            stockInwardDetailsLoaded = true;
//          });
//        }
//      else
//        {
//          setState(() {
//            stockInwardDetailsLoading = false;
//            stockInwardDetailsLoaded = false;
//          });
//        }
//    });
    }

  @override
  Widget build(BuildContext context) {
    {
      if(retrievingProductDetails || retrievingProductStockInwardDetails){
        return
          WillPopScope(
            onWillPop:(){
              setState(() {
                retrievingProductStockInwardDetails = false;
                retrievingProductDetails = false;
                Navigator.of(context).pop();
//                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                    builder:(BuildContext context){
//                      return CheckIfAdmin();
//                    }));
              });

          return;
        },
    child:Scaffold(
          appBar: AppBar(
            centerTitle:  true,
            automaticallyImplyLeading: false,
            title:Text('PRODUCT LOOKUP'),
            leading: IconButton(icon:Icon(Icons.keyboard_backspace),
              onPressed: (){
              Navigator.of(context).pop();
//              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                return CheckIfAdmin();
//              }));
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
                  Expanded(
                      flex: 12,
                      child: Text( barCodeToSearch.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            fontFamily: 'Montserrat'),)),
                ],
              ),
            ),
          )
        ));
      }
      else
        {
          return WillPopScope(
            onWillPop:(){
              setState(() {
                retrievingProductStockInwardDetails = false;
                retrievingProductDetails = false;
                Navigator.of(context).pop();
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
                  'STOCK INWARD',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      fontFamily: 'Montserrat'),
                ),
                leading: IconButton(icon:Icon(Icons.keyboard_backspace),
                    onPressed: (){
                      Navigator.of(context).pop();
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return CheckIfAdmin();
//                      }));
                    }),

              ),
              body: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: RaisedButton(
                            color: Colors.blue,
                            elevation: 4.0,
                            onPressed: scan,
                            child: Text('SCAN BARCODE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: RaisedButton(
                            color: Colors.blue,
                            elevation: 4.0,
                            onPressed: () {
                              getBarCode();
                            },
                            child: Text('ENTER BARCODE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
              )
          ));
        }

      }
    }

  void addProductToStockEntry(double qty) {
    print('addProductToStockEntry:productCodeProductStockInMap:');
    stockInwardDetailsMap[stockInProductToUpdate.productID] = ProductStockInwardDetails(
        stockInProductToUpdate.productID,
        DateFormat('ddMMMyyyy').format(DateTime.now()).toString(),
        DateFormat('hhmmss-SSS').format(DateTime.now()).toString(),
        qty
    );
    setState(() {

    });
    print(stockInwardDetailsMap[stockInProductToUpdate.productID].recentStockInwardQty);
  }

  void clearStockEntry() {
    stockInMap.clear();
    stockInEntries.clear();
    stockInItemCount = 0;
    stockInProductCount = 0;
    setState(() {});
  }
}