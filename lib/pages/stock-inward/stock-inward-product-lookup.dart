import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

import 'package:kiranawala_admin/pages/stock-inward/stock-inward-home-page.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-request-barcode.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-select-category.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-select-brand.dart';


bool searchingBarCode = true;
String productLookupStore = '';
double salePositionForRequestedProduct = 0.0;
double stockInwardForRequestedProduct = 0.0;
double stockPositionForRequestedProduct = 0.0;

class ProductLookUp extends StatefulWidget {
  @override
  _ProductLookUpState createState() => _ProductLookUpState();
}

class _ProductLookUpState extends State<ProductLookUp> {

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

  void getProductDetails()
  {

    setState(() {
      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });


    fullProductBasicDetailsMap.forEach((int productCode, ProductBasicDetails product) {
      if(product.productBarCode == barCodeToSearch)
        {
          barCodeSearchResultsMap[productCode] = product;
        }
    });

          print(barCodeSearchResultsMap);
          print(barCodeSearchResultsMap.length);

          if(barCodeSearchResultsMap.length > 0){
//            barCodeSearchResultsMap.forEach((key, value) {
//              barCodeSearchResults.add(value);
//            });

//            salePositionForRequestedProduct = 0;
//
//            barCodeSearchResults.forEach((product) {
//              print(product.productID.toString());
//              int productCode = product.productID;
//              storeTerminalMap[productLookupStore].forEach((terminal) {
//                if(fullProductSalePositionAtTerminal[terminal] != null && fullProductSalePositionAtTerminal[terminal][productCode] != null) {
//                  print(productLookupStore);
//                  print(terminal);
//                  print(fullProductSalePositionAtTerminal[terminal][productCode]);
//                  salePositionForRequestedProduct =
//                      salePositionForRequestedProduct
//                          +
//                          fullProductSalePositionAtTerminal[terminal][productCode];
//                }
//              }) ;
//
//            });

//            print('salePositionForRequestedProduct' + salePositionForRequestedProduct.toString());

//            barCodeSearchResults.sort((a, b) {
//              return a.productName.compareTo(b.productName);
//            });

            setState(() {
              searchingBarCode = false;
            });
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return ProductLookupResults();
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
              searchingBarCode = false;
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ProductLookupResults();
                      }
                  )
              );
//              Navigator.of(context).push<dynamic>(
//                  MaterialPageRoute<dynamic>(
//                      builder: (BuildContext context) {
//                        return ProductStockPositionSearchResults();
//                      }));
            });
          }

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
        getProductDetails();
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
          return ProductLookUpRequestBarCode();
        }));
    print(barCodeToSearch);
    if (barCodeToSearch != null && barCodeToSearch.length > 0) {
      getProductDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    {

//      if(productDiscountDetailsAtAllStoresAvailable && productStockPositionAtAllStoresAvailable)
//        {
          return
            WillPopScope(
                onWillPop:(){
                  setState(() {
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return StockInwardHomePage();
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
                            Navigator.of(context).pop();
                            Navigator.of(context).push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                    builder:(BuildContext context){
                                      return StockInwardHomePage();
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

                            Container(
                                width:MediaQuery.of(context).size.width,
                                padding:EdgeInsets.all(8.0),
                                child:
                                Text(storeIdNameMap[productNode],
                                  style:TextStyle(
                                      fontSize: 18.0,
                                      color:Colors.black,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width:MediaQuery.of(context).size.width,
                                  padding:EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border:Border.all(color:Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                                  ),
                                  child:
                                  Text(' PRODUCT LOOKUP',
                                    style:TextStyle(
                                        fontSize: 18.0,
                                        color:Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  )
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
                                          return StockInwardProductNameLookUp();
                                        }
                                    )).then((dynamic code){
                                      if(code != null)
                                      {
                                        setState(() {
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
                                          return SelectProductCategory();
                                        }
                                    )).then((dynamic code){
                                      if(code != null)
                                      {
                                        setState(() {
                                        });
                                        print(code.toString());
                                      }
                                    });
                                  },
                                  child: Text('SEARCH BY CATEGORY',
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
                                          return SelectProductBrand();
                                        }
                                    )).then((dynamic code){
                                      if(code != null)
                                      {
                                        setState(() {
                                        });
                                        print(code.toString());
                                      }
                                    });
                                  },
                                  child: Text('SEARCH BY BRAND',
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
                                  width:MediaQuery.of(context).size.width,
                                  padding:EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                                  ),
                                  child:
                                  Text('NEW PRODUCT',
                                    style:TextStyle(
                                        fontSize: 18.0,
                                        color:Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  )
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
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push<dynamic>(
                                        MaterialPageRoute<dynamic>(
                                            builder:(BuildContext context){
                                              return null;
//                                              return StockInwardAddNewProductWithBarcode();
                                            }
                                        )
                                    );
                                  },
                                  child: Text('ADD PRODUCT(BARCODE)',
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
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push<dynamic>(
                                      MaterialPageRoute<dynamic>(
                                        builder:(BuildContext context){
                                          return null;
//                                          return StockInwardAddNewProductWithoutBarcode();
                                        }
                                      )
                                    );
                                  },
                                  child: Text('ADD PRODUCT(NO BARCODE)',
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
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Container(
//                                width: MediaQuery
//                                    .of(context)
//                                    .size
//                                    .width,
//                                child: RaisedButton(
//                                  color: Colors.blue,
//                                  elevation: 4.0,
//                                  onPressed: () {
////                                retrievingProductDetails = true;
//                                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                                        builder:(BuildContext context){
//                                          return ProductNameLookUp();
//                                        }
//                                    )).then((dynamic code){
//                                      if(code != null)
//                                      {
//                                        setState(() {
//                                        });
//                                        print(code.toString());
//                                      }
//                                    });
//                                  },
//                                  child: Text('SEARCH BY ONLINE STATUS',
//                                    style: TextStyle(
//                                        color: Colors.white,
//                                        fontWeight: FontWeight.bold,
//                                        fontSize: 18.0,
//                                        fontFamily: 'Montserrat'
//                                    ),
//                                  ),
//                                ),
//                              ),
//                            ),
                          ]),
                    )
                ));
//        }
//      else
//        {
//          return Container(
//            color: Colors.white,
//            child: Dialog(
//              child: new Row(
//                mainAxisSize: MainAxisSize.min,
//                children: [
//                  Expanded(
//                      flex:2,
//                      child: new CircularProgressIndicator()
//                  ),
//                  SizedBox(width:10.0),
//                  Expanded(
//                      flex:12,
//                      child: Text("Retrieving Stock Position...,",
//                          style:TextStyle(
//                            fontFamily: 'Montserrat',
//                            fontSize:12.0,
//                            fontWeight: FontWeight.bold,
//                          )
//                      )
//                  ),
//                ],
//              ),
//            ),
//          );
//        }


    }
  }
}
