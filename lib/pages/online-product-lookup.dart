import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/online-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/product-lookup-request-barcode-online.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';

import 'product-lookup-results.dart';
import 'product-lookup-select-store.dart';
import 'product-name-lookup.dart';
import 'product-lookup-request-barcode.dart';
import 'select-product-name-static.dart';
import 'select-store-no-return.dart';





bool searchingBarCode = false;
String barCodeToAdd = 'N/A';
String productLookupStore = '';
double salePositionForRequestedProduct = 0.0;
double stockInwardForRequestedProduct = 0.0;
double stockPositionForRequestedProduct = 0.0;
Map<dynamic,dynamic> stockInwardInvoiceList = new Map<dynamic,dynamic>();
List<dynamic> stockInwardInvoiceHistory = new List<dynamic>();

Map<dynamic,dynamic> stockOutwardInvoiceList = new Map<dynamic,dynamic>();
List<dynamic> stockOutwardInvoiceHistory = new List<dynamic>();

class OnlineProductLookUp extends StatefulWidget {
  @override
  _OnlineProductLookUpState createState() => _OnlineProductLookUpState();
}

class _OnlineProductLookUpState extends State<OnlineProductLookUp> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    salePositionForRequestedProduct = 0;
    stockInwardForRequestedProduct = 0;
    stockPositionForRequestedProduct = 0;

//    if(fullProductBasicDetailsMapAvailable)
//      {
//        print('All Products downloaded from Store');
//      }
  }

  void getProductDetailsOnline()
  {
    setState(() {
      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
  });

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
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

            var productBasicDetails = new ProductBasicDetails(
                product['title'].toString(),
                double.parse(product['price'].toString()),
                int.parse(product['productcode'].toString()),
                product['barcode'].toString(),
                product['imageurl'].toString(),
                product['category'].toString(),
                product['brand'].toString(),
                (product['productStatus'] != null)
                    ? product['productStatus']
                    : 'INACTIVE',
                (product['productParent'] != null)
                    ? product['productParent']
                    : 'N/A',
                (product['productCreationTimeStamp'] != null)
                    ? product['productCreationTimeStamp']
                    : 'N/A'
            );

            barCodeSearchResultsMap[int.parse(code.toString())] = productBasicDetails;
          });
          print(barCodeSearchResultsMap);
          setState(() {
            searchingBarCode = false;
          });
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return ProductLookupResultsOnline();
                  }
              )
          );
        } else if (productDetailsMap.length > 1) {
          productDetailsMap.forEach((dynamic code, dynamic product) {

            var productBasicDetails = new ProductBasicDetails(
                product['title'].toString(),
                double.parse(product['price'].toString()),
                int.parse(product['productcode'].toString()),
                product['barcode'].toString(),
                product['imageurl'].toString(),
                product['category'].toString(),
                product['brand'].toString(),
                (product['productStatus'] != null)
                    ? product['productStatus']
                    : 'INACTIVE',
                (product['productParent'] != null)
                    ? product['productParent']
                    : 'N/A',
                (product['productCreationTimeStamp'] != null)
                    ? product['productCreationTimeStamp']
                    : 'N/A'
            );

            barCodeSearchResultsMap[int.parse(code.toString())] = productBasicDetails;
          });

          print(barCodeSearchResultsMap);

          setState(() {
            searchingBarCode = false;
          });
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return ProductLookupResultsOnline();
                  }
              )
          );
        }
      } else {
        setState(() {
          searchingBarCode = false;
        });
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return ProductLookupResultsOnline();
                }
            )
        );

        print(barCodeToSearch + ':product not in system');
      }
    });
  }

  Future scan() async {
    setState(() {
      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    try {
      barCodeToSearch = (await BarcodeScanner.scan()).toString();
      print('Scanned BarCode:' + barCodeToSearch);

      print(barCodeToSearch);
      if (barCodeToSearch.length > 0) {
        getProductDetailsOnline();
      }
      else
      {
        setState(() {
          searchingBarCode = false;
        });
      }
    } on PlatformException catch (e) {
      print('Platform Exception');
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('Camera Access Denied');
        setState(() {
          searchingBarCode = false;
//          Navigator.of(context).pop();
//          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//              builder:(BuildContext context){
//                return ProductLookUp();
//              }));
        });
      } else {
        print('Scan Error. Not Camera Access Error');
        setState(() {
          searchingBarCode = false;
//          Navigator.of(context).pop();
//          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//              builder:(BuildContext context){
//                return ProductLookUp();
//              }));
        });

      }
    } on FormatException {
      print('Scan Format Exception');
      setState(() {
        searchingBarCode = false;
//        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return ProductLookUp();
//            }));
      });
    } catch (e) {
      print('Error Caught in Catch Statement');
      setState(() {
        searchingBarCode = false;
//        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return ProductLookUp();
//            }));
      });
    }
  }

  Future getBarCode() async {

    setState(() {
      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    barCodeToSearch = await Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          return ProductLookUpRequestBarCodeOnline();
        }));
    print(barCodeToSearch);
    if (barCodeToSearch != null && barCodeToSearch.length > 0) {
      getProductDetailsOnline();
    }
  }

  @override
  Widget build(BuildContext context) {
    {
      if(searchingBarCode)
        {
          return
            WillPopScope(
                onWillPop:(){
                  setState(() {
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return ShowAdminHomePage();
                            }
                        )
                    );
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
                        'PRODUCT LOOKUP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            fontFamily: 'Montserrat'),
                      ),
                      leading: IconButton(icon:Icon(Icons.keyboard_backspace),
                          onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                    builder:(BuildContext context){
                                      return ShowAdminHomePage();
                                    }
                                )
                            );
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
                                  child: Text('PLEASE BE PATIENT.......',
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
                                child: LinearProgressIndicator(),
                              ),
                            ),
                          ]),
                    )
                ));
        }
      else
        {
          return
            WillPopScope(
                onWillPop:(){
                  setState(() {
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return ShowAdminHomePage();
                            }
                        )
                    );
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
                        'PRODUCT LOOKUP',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            fontFamily: 'Montserrat'),
                      ),
                      leading: IconButton(icon:Icon(Icons.keyboard_backspace),
                          onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                    builder:(BuildContext context){
                                      return ShowAdminHomePage();
                                    }
                                )
                            );
                          }),

                    ),
                    body: RaisedButton(
                      onPressed:(){},
                      child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width:MediaQuery.of(context).size.width,
                                  padding:EdgeInsets.all(8.0),
                                  child:
                                  RaisedButton(
                                      color:Colors.grey,
                                      onPressed:(){
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push<dynamic>
                                          (MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context){
                                              return ProductLookUpSelectStore();
                                            }
                                        )
                                        );
                                      },
                                      child:Text(productLookupStore,
                                        style:TextStyle(
                                            fontSize: 18.0,
                                            color:Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold
                                        ),)
                                  )
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
                      ),
                    )
                ));
        }

    }
  }
}
