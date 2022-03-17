import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-request-barcode.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-single-store.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-postion-select-product-name-static.dart';
import 'package:kiranawala_admin/pages/show-sale-position-home.dart';

import '../show-admin-home-page.dart';

String barCodeToSearch = '';
int productCode = 0;
//List<ProductBasicDetails> barCodeSearchResults = List<ProductBasicDetails>();
//Map<int, ProductBasicDetails> barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
//String productNode = 'KIRANAWALA_MASTER';

class SelectProducts extends StatefulWidget {
  @override
  _SelectProductsState createState() => _SelectProductsState();
}

class _SelectProductsState extends State<SelectProducts> {

  int stockPosition = 0;
  double productStockPosition = 0;
  int productId = 0;
  bool retrievingProductsNode = false;

  void getProductDetails()
  {
    print('SelectProductState:getProductDetails:' + productNode.toString());
    print('SelectProductState:getProductDetails:' + barCodeToSearch.toString());

    setState(() {
      retrievingProductDetails = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
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
        if (productDetailsMap.length >= 1) {
          print(productDetailsMap.length);
          productDetailsMap.forEach((dynamic code, dynamic product) {
            if(product['status'] == null )
            {
              barCodeSearchResultsMap[int.parse(product['productcode'].toString())] =
              new ProductBasicDetails(
                product['title'].toString(),
                double.parse(product['price'].toString()),
                int.parse(product['productcode'].toString()),
                product['barcode'].toString(),
                product['imageurl'].toString(),
                product['category'].toString(),
                product['brand'].toString(),
                'ACTIVE',
                'N/A',
                'N/A'
              );
            }
            else
            {
              if(product['status'] == 'active')
              {
                barCodeSearchResultsMap[int.parse(product['productcode'].toString())] =
                new ProductBasicDetails(
                  product['title'].toString(),
                  double.parse(product['price'].toString()),
                  int.parse(product['productcode'].toString()),
                  product['barcode'].toString(),
                  product['imageurl'].toString(),
                  product['category'].toString(),
                  product['brand'].toString(),
                    'ACTIVE',
                    'N/A',
                    'N/A'
                );
              }
            }
          });
          print(barCodeSearchResultsMap);
          barCodeSearchResults.sort((a, b) {
            return a.productName.compareTo(b.productName);
          });
          if(barCodeSearchResultsMap.length > 0){
            barCodeSearchResultsMap.forEach((key, value) {
              barCodeSearchResults.add(value);
            });
            setState(() {
              retrievingProductDetails = false;
            });
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return ShowProductSalePositionSingleStore();
                    }
                )
            );
//              setState(() {
//                retrievingProductDetails = false;
//              });
          }
          else
          {
            setState(() {
              retrievingProductDetails = false;
              Navigator.of(context).pop();
//              Navigator.of(context).push<dynamic>(
//                  MaterialPageRoute<dynamic>(
//                      builder: (BuildContext context) {
//                        return ProductStockPositionSearchResults();
//                      }));
            });
          }

        }
      } else {
        setState(() {
          retrievingProductDetails = false;
          Navigator.of(context).pop();
//          Navigator.of(context).push<dynamic>(
//              MaterialPageRoute<dynamic>(
//                  builder: (BuildContext context) {
//                    return ProductStockPositionSearchResults();
//                  }));
        });

        print(barCodeToSearch + ':product not in system');
      }
    });
  }

  Future scan() async {
    setState(() {
      retrievingProductDetails = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    try {
      barCodeToSearch = (await BarcodeScanner.scan()).toString();
      print('Scanned BarCode:' + barCodeToSearch);

      print(barCodeToSearch);
      if (barCodeToSearch.length > 0) {
        getProductDetails();
      }
    } on PlatformException catch (e) {
      print('Platform Exception');
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('Camera Access Denied');
        setState(() {
          retrievingProductDetails = false;
//          Navigator.of(context).pop();
//          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//              builder:(BuildContext context){
//                return ProductLookUp();
//              }));
        });
      } else {
        print('Scan Error. Not Camera Access Error');
        setState(() {
          retrievingProductDetails = false;
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
        retrievingProductDetails = false;
//        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return ProductLookUp();
//            }));
      });
    } catch (e) {
      print('Error Caught in Catch Statement');
      setState(() {
        retrievingProductDetails = false;
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
      retrievingProductDetails = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    barCodeToSearch = await Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          return ProductLookUpRequestBarCode();
        }));
    print(barCodeToSearch);
    if (barCodeToSearch.length > 0) {
      getProductDetails();
    }
    else
      {
        setState(() {
          retrievingProductDetails = false;
//          Navigator.of(context).pop();
//              Navigator.of(context).push<dynamic>(
//                  MaterialPageRoute<dynamic>(
//                      builder: (BuildContext context) {
//                        return ProductStockPositionSearchResults();
//                      }));
        });
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    {
      if(retrievingProductDetails ){
        return
          WillPopScope(
              onWillPop:(){
                setState(() {
                  retrievingProductDetails = false;
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ShowSalePositionHomePage();
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
                          retrievingProductDetails = false;
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                              builder:(BuildContext context){
                                return ShowSalePositionHomePage();
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
                              child: Text("LOADING PRODUCT DETAILS")),
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
                retrievingProductDetails = false;
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return ShowProductSalePositionSingleStore();
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
                    'PRODUCT MANAGER',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        fontFamily: 'Montserrat'),
                  ),
                  leading: IconButton(icon:Icon(Icons.keyboard_backspace),
                      onPressed: (){
                        retrievingProductDetails = false;
                        Navigator.of(context).pop();
                        Navigator.of(context).push<dynamic>(
                            MaterialPageRoute<dynamic>(
                                builder:(BuildContext context){
                                  return ShowProductSalePositionSingleStore();
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
//                                retrievingProductDetails = true;
                                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                                    builder:(BuildContext context){
                                      return SelectProductNameStatic();
                                    }
                                )).then((dynamic code){
                                  if(code != null)
                                  {
                                    setState(() {
                                      retrievingProductDetails = false;
                                    });
                                    print(code.toString());
                                  }
                                });
                              },
                              child: Text('SEARCH NAME',
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
}