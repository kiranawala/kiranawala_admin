import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/add-new-product-barcode.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode.dart';
import 'package:kiranawala_admin/pages/online-product-lookup-options.dart';
import 'package:kiranawala_admin/pages/online-product-lookup.dart';
import 'package:kiranawala_admin/pages/product-lookup.dart';
import 'package:kiranawala_admin/pages/search-barcode.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';

import '../main.dart';

bool retrievingStockInwardDetails = false;
bool retrievingStockOutwardDetails = false;

double stockInwardTillDate = 0;
double recentStockInwardQty = 0;
String recentStockInwardTime = '';
String recentStockInwardDate = '';
String recentStockInwardInvoiceId = '';

double stockOutwardTillDate = 0;
double recentStockOutwardQty = 0;
String recentStockOutwardDate = '';
String recentStockOutwardTime = '';
String recentStockOutwardInvoiceId = '';
String recentStockOutwardTimeStamp = '';
String recentStockInwardTimeStamp = '';

class ProductLookupResultsOnline extends StatefulWidget {
  @override
  _ProductLookupResultsOnlineState createState() => _ProductLookupResultsOnlineState();
}

class _ProductLookupResultsOnlineState extends State<ProductLookupResultsOnline> {




  void getProductStockOutwardDetailsTillDateForProductCode(String productCode, String terminal){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(productCode)
        .child('stockOutwards')
        .child(terminal)
        .once()
        .then((productSalePositionSnapshot) {
      print(productSalePositionSnapshot);
      if (productSalePositionSnapshot != null &&
          productSalePositionSnapshot.value != null) {
        if (productSalePositionSnapshot.value['stockOutwardTillDate'] != null
            &&
            productSalePositionSnapshot.value['recentStockOutwardQty'] != null
            &&
            productSalePositionSnapshot.value['recentStockOutwardDate'] != null
            && productSalePositionSnapshot.value['recentStockOutwardTime'] !=
                null
            && productSalePositionSnapshot.value['invoices'] !=
                null
        ) {
          stockOutwardTillDate = double.parse(
              productSalePositionSnapshot.value['stockOutwardTillDate']
                  .toString());
          recentStockOutwardDate =
              productSalePositionSnapshot.value['recentStockOutwardDate']
                  .toString();
          recentStockOutwardTime =
              productSalePositionSnapshot.value['recentStockOutwardTime']
                  .toString();
          recentStockOutwardQty = double.parse(
              productSalePositionSnapshot.value['recentStockOutwardQty']
                  .toString());
          stockOutwardInvoiceList = productSalePositionSnapshot.value['invoices'];
          stockOutwardInvoiceList.forEach((dynamic key, dynamic value) {
            print(value);
          });

          print(recentStockOutwardDate);
          print(recentStockOutwardTime);
          print(recentStockOutwardQty);

          if (salePositionForProductCode[productCode] == null) {
            salePositionForProductCode[productCode] =
                double.parse(
                    productSalePositionSnapshot.value['stockOutwardTillDate']
                        .toString());
          }
          else {
            salePositionForProductCode[productCode] =
                salePositionForProductCode[productCode] + double.parse(
                    productSalePositionSnapshot.value['stockOutwardTillDate']
                        .toString());
          }
        }
      }

//      if(terminalsProcessedForProductCode[productCode] == null)
//      {
//        terminalsProcessedForProductCode[productCode] = 1;
//      }
//      else
//      {
//        terminalsProcessedForProductCode[productCode] = terminalsProcessedForProductCode[productCode] + 1;
//      }
//
//      if(terminalsProcessedForProductCode[productCode] != null)
//      {
//        if(terminalsProcessedForProductCode[productCode] == storeTerminals.length)
//        {
//          print('All terminals processed successfully for productCode:' + productCode);
//        }
//      }

//      processedCount = processedCount + 1;
//
//      if(processedCount == processCount){
//        print('salePositionForProductCode:');
//        print(salePositionForProductCode);
//
        setState(() {
          retrievingStockOutwardDetails = false;
        });
//      }
    });
  }

  void getProductStockInwardDetailsForProductCode(String productCode){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(productCode)
        .child('stockInwards')
        .once()
        .then((productStockInwardSnapshot) {
      print(productStockInwardSnapshot);
      if (productStockInwardSnapshot != null &&
          productStockInwardSnapshot.value != null) {
        if(productStockInwardSnapshot.value['stockInwardTillDate'] != null
            && productStockInwardSnapshot.value['recentStockInwardDate'] != null
            && productStockInwardSnapshot.value['recentStockInwardTime'] != null
            && productStockInwardSnapshot.value['recentStockInwardQty'] != null
            && productStockInwardSnapshot.value['invoices'] != null
        )
        {
          stockInwardInvoiceList = productStockInwardSnapshot.value['invoices'];
          stockInwardTillDate = double.parse(productStockInwardSnapshot.value['stockInwardTillDate'].toString());
          recentStockInwardDate = productStockInwardSnapshot.value['recentStockInwardDate'].toString();
          recentStockInwardTime = productStockInwardSnapshot.value['recentStockInwardTime'].toString();
          recentStockInwardQty = double.parse(productStockInwardSnapshot.value['recentStockInwardQty'].toString());

          print(stockInwardTillDate);
          print(recentStockInwardDate);
          print(recentStockInwardTime);
          print(recentStockInwardQty);
          print(stockInwardInvoiceList);

          stockInwardTillDate =
                double.parse(productStockInwardSnapshot.value['stockInwardTillDate'].toString());
        }
      }
      setState(() {
        retrievingStockInwardDetails = false;
      });

    });
  }


//  void removeProductFromFirebase(int productId)
//  {
//    setState(() {
//      refreshing = true;
//    });
//    FirebaseDatabase
//        .instance
//        .reference()
//        .child('stores')
//        .child('KIRANAWALA_MASTER')
//        .child('products')
//        .child(productId.toString())
//        .update(<String, dynamic>{
//      'status': 'inactive',
//      'deactivatedOn': DateTime.now().toString()
//    }).then((value) {
//      print('Product Removed Successfully!!');
//    }).catchError((dynamic onError){
//      print('NETWORK ERROR');
//    });
//    barCodeSearchResultsMap.remove(productId);
//    if(barCodeToSearch.length > 0){
//      barCodeSearchResults = List<ProductBasicDetails>();
//      barCodeSearchResultsMap.forEach((key, value) {
//        barCodeSearchResults.add(value);
//      });
//      if(barCodeSearchResults.length > 0)
//      {
//        setState(() {
//          refreshing = false;
//        });
//      }
//      else
//      {
//        refreshing = false;
//        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
//          return SearchBarCode();
//        }));
//      }
//    }
//    else{
//      refreshing = false;
//      Navigator.of(context).pop();
//    }
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    barCodeSearchResults = [];
    barCodeSearchResultsMap.forEach((key, value) {
      barCodeSearchResults.add(value);
      print(key);
      print(value.productID);

      retrievingStockInwardDetails = true;
      retrievingStockOutwardDetails = true;
      stockInwardTillDate = 0;
      stockOutwardTillDate = 0;
      recentStockInwardQty = 0;
      recentStockOutwardQty = 0;
      recentStockInwardTime = 'N/A';
      recentStockOutwardTime = 'N/A';
      recentStockOutwardDate = 'N/A';
      recentStockInwardDate = 'N/A';
      recentStockInwardInvoiceId = 'N/A';
      recentStockOutwardInvoiceId = 'N/A';

      getProductStockInwardDetailsForProductCode(value.productID.toString());
      getProductStockOutwardDetailsTillDateForProductCode(value.productID.toString(), 'POS_11');
    });
  }

  @override
  Widget build(BuildContext context) {
    barCodeSearchResults = [];
    barCodeSearchResultsMap.forEach((key, value) {
      barCodeSearchResults.add(value);
      print(key);
      print(value.productID);
    });
    print('BarcodeSearchResults:');
    print(barCodeSearchResults);

    barCodeSearchResults.sort((a, b) {
      return a.productName.compareTo(b.productName);
    });
//    salePositionForRequestedProduct = 0;
//
//    barCodeSearchResults.forEach((product) {
//      print(product.productID.toString());
//      int productCode = product.productID;
//      storeTerminalMap[productLookupStore].forEach((terminal) {
//        if(fullProductSalePositionAtTerminal[terminal] != null && fullProductSalePositionAtTerminal[terminal][productCode] != null) {
//          print(productLookupStore);
//          print(terminal);
//          print(fullProductSalePositionAtTerminal[terminal][productCode]);
//          salePositionForRequestedProduct =
//              salePositionForRequestedProduct
//                  +
//                  fullProductSalePositionAtTerminal[terminal][productCode];
//        }
//      }) ;
//    });
//
//    barCodeSearchResults.forEach((product){
//      if(fullProductStockPositionAtStore[storeIdMap[productLookupStore]] != null && fullProductStockPositionAtStore[storeIdMap[productLookupStore]][product.productID] != null){
//        stockInwardForRequestedProduct = fullProductStockPositionAtStore[storeIdMap[productLookupStore]][product.productID];
//      }
//    });
//    print(stockInwardForRequestedProduct);
//
//    stockPositionForRequestedProduct = stockInwardForRequestedProduct - salePositionForRequestedProduct;

    if(retrievingStockInwardDetails || retrievingStockOutwardDetails)
      {
        return
            Container(
              color: Colors.white,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('PLEASE BE PATIENT.......',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        fontFamily: 'Montserrat'
                    ),
                  ),
                  new LinearProgressIndicator(),
                ],
              ),
            );
      }
    else
    {
      if(barCodeSearchResults.length > 0)
        return
          WillPopScope(
              onWillPop:(){
                setState(() {
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return OnlineProductLookUp();
                      }));
                });

                return;
              },
              child:Scaffold(
                  appBar:AppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                      icon:Icon(Icons.keyboard_backspace),
                      onPressed: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return OnlineProductLookUp();
                            }));
                      },
                    ),
                    title:Text(
                      'Search Results',
                      style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                    ),
                    centerTitle: true,
                  ),

                  body:Container(
                      child:Column(
                        children: <Widget>[
                          Expanded(
                            flex:2,
                            child: Text(
                              'Products Found:' + barCodeSearchResults.length.toString(),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                              ),
                            ),
                          ),
                          Expanded(
                              flex:30,
                              child: Container(
                                  child:
                                  ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: barCodeSearchResults.length,
                                      itemBuilder: (BuildContext context, int index){

    //                                      if(fullProductStockPositionAtStore[storeIdMap[productLookupStore]] != null && fullProductStockPositionAtStore[storeIdMap[productLookupStore]][productCode] != null){
    //                                        stockInwardForRequestedProduct = fullProductStockPositionAtStore[storeIdMap[productLookupStore]][productCode];
    //                                      }
    //
    //                                      print(stockInwardForRequestedProduct);
    //                                      print(fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]]);
                                        return
                                          Container(
                                            padding: EdgeInsets.all(8.0),
                                            color:Colors.white,
                                            child: RaisedButton(
                                              onPressed: ()
                                              {
                                                print('Product Selected');
                                                skuToUpdate =
                                                    barCodeSearchResults[index].productID;
                                                Future<void> future =  showModalBottomSheet(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return BottomSheet(
                                                          onClosing: () {
                                                          },
                                                          builder: (BuildContext context) {
                                                            return OnlineProductLookupOptions();
                                                          });
                                                    });
                                                future.then((void value) => {
                                                  setState((){})
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(2.0),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                    border: Border.all(color: Colors.blueGrey[100])),
                                                height: 700,
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Center(
                                                        child: Text(
                                                          barCodeSearchResults[index]
                                                              .productName
                                                              .toUpperCase(),
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 24.0,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: "Montserrat"),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                              'SKU:',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: "Montserrat"),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              barCodeSearchResults[index]
                                                                  .productID.toString(),
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: "Montserrat"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                              'BARCODE:',
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: "Montserrat"),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              barCodeSearchResults[index]
                                                                  .productBarCode.toString(),
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 18.0,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontFamily: "Montserrat"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      height:240,
                                                      child: new Stack(
                                                        children: <Widget>[
                                                          new Container(
                                                            //margin: new EdgeInsets.only(left: 46.0),
                                                            decoration: new BoxDecoration(
                                                              shape: BoxShape.rectangle,
                                                              color: new Color(0xFFFFFFFF),
                                                              borderRadius:
                                                              new BorderRadius.circular(8.0),
                                                              image: DecorationImage(
                                                                image: NetworkImage(
                                                                    barCodeSearchResults[index]
                                                                        .productImageURL),
                                                                fit: BoxFit.contain,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 0.0,
                                                            bottom: 0.0,
                                                            child: Container(
                                                              height: 40.0,
                                                              child: Text(
                                                                    (stockInwardTillDate - stockOutwardTillDate).toString(),
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: "Montserrat",
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 30.0,
                                                                ),
                                                                maxLines: 2,
                                                                softWrap: true,
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            left: 0.0,
                                                            top: 0.0,
                                                            child: Container(
                                                              height: 40.0,
                                                              child: Text(
                                                                "\u20B9" +
                                                                    barCodeSearchResults[index]
                                                                        .productPrice.toString(),
                                                                style: TextStyle(
                                                                  color: Colors.deepOrange,
                                                                  fontFamily: "Montserrat",
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 30.0,
                                                                ),
                                                                maxLines: 2,
                                                                softWrap: true,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(children: <Widget>[

//                                                      Container(
//                                                        child: Center(
//                                                          child: Text(
//                                                            "\u20B9" +
//                                                                barCodeSearchResults[index]
//                                                                    .productPrice.toString(),
//                                                            style: TextStyle(
//                                                                color: Colors.black,
//                                                                fontSize: 18.0,
//                                                                fontWeight: FontWeight.bold,
//                                                                fontFamily: "Montserrat"),
//                                                          ),
//                                                        ),
//                                                      ),
//                                                      Container(
//                                                        child: Center(
//                                                          child: Text(
//                                                            barCodeSearchResults[index]
//                                                                .productStatus.toString(),
//                                                            style: TextStyle(
//                                                                color: Colors.black,
//                                                                fontSize: 18.0,
//                                                                fontWeight: FontWeight.bold,
//                                                                fontFamily: "Montserrat"),
//                                                          ),
//                                                        ),
//                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Text(
                                                                'CATEGORY:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                barCodeSearchResults[index]
                                                                    .productCategory.toString(),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Text(
                                                                'BRAND:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                barCodeSearchResults[index]
                                                                    .productBrand.toString(),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],

                                                        ),
                                                      ),

//                                                      Container(
//                                                        child: Row(
//                                                          children: <Widget>[
//                                                            Expanded(
//                                                              flex:6,
//                                                              child: Text(
//                                                                'STOCK POSITION:',
//                                                                style: TextStyle(
//                                                                    color: Colors.black,
//                                                                    fontSize: 18.0,
//                                                                    fontWeight: FontWeight.bold,
//                                                                    fontFamily: "Montserrat"),
//                                                              ),
//                                                            ),
//                                                            Expanded(
//                                                              flex:2,
//                                                              child: Text(
//                                                                (stockInwardTillDate - stockOutwardTillDate).toString(),
//                                                                style: TextStyle(
//                                                                    color: Colors.black,
//                                                                    fontSize: 18.0,
//                                                                    fontWeight: FontWeight.bold,
//                                                                    fontFamily: "Montserrat"),
//                                                              ),
//                                                            ),
//                                                          ],
//                                                        ),
//                                                      ),

                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex:6,
                                                              child: Text(
                                                                'INWARD TILL DATE:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex:2,
                                                              child: Text(
                                                                stockInwardTillDate.toString(),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex:6,
                                                              child: Text(
                                                                'RECENT INWARD DATE:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex:2,
                                                              child: Text(
                                                                recentStockInwardDate,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex:6,
                                                              child: Text(
                                                                'RECENT INWARD TIME:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex:2,
                                                              child: Text(
                                                                recentStockInwardTime.toString(),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex:6,
                                                              child: Text(
                                                                'RECENT INWARD QTY:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex:2,
                                                              child: Text(
                                                                recentStockInwardQty.toString(),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex:6,
                                                              child: Text(
                                                                'OUTWARD TILL DATE:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex:2,
                                                              child: Text(
                                                                stockOutwardTillDate.toString(),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex:6,
                                                              child: Text(
                                                                'RECENT OUTWARD DATE:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex:2,
                                                              child: Text(
                                                                recentStockOutwardDate,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex:6,
                                                              child: Text(
                                                                'RECENT OUTWARD TIME:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex:2,
                                                              child: Text(
                                                                recentStockOutwardTime,
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex:6,
                                                              child: Text(
                                                                'RECENT OUTWARD QTY:',
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex:2,
                                                              child: Text(
                                                                recentStockOutwardQty.toString(),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 18.0,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontFamily: "Montserrat"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
    //                                        Padding(
    //                                          padding: const EdgeInsets.all(8.0),
    //                                          child: Container(
    //                                              padding: EdgeInsets.all(8.0),
    //                                              decoration: BoxDecoration(
    //                                                  border: Border.all(color: Colors.blueGrey),
    //                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))
    //                                              ),
    //                                              height: 400.0,
    //                                              child: Column(children: <Widget>[
    //                                                Expanded(
    //                                                  flex:16,
    //                                                  child: Row(
    //                                                    children: <Widget>[
    //                                                      Expanded(
    //                                                        flex:6,
    //                                                        child: Column(
    //                                                          children: <Widget>[
    //                                                    Expanded(
    //                                                      flex:2,
    //                                                      child: Container(
    //                                                        width:MediaQuery.of(context).size.width,
    //                                                        child: Padding(
    //                                                          padding: const EdgeInsets.all(8.0),
    //                                                          child: RaisedButton(
    //                                                            onPressed:(){
    ////                                                              productToUpdate = barCodeSearchResults[index];
    ////                                                              productToUpdateIndex = index;
    ////                                                              Navigator.of(context).pop();
    ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
    ////                                                                return UpdateProductDetails();
    ////                                                              }));
    //                                                            },
    //                                                            child: Text(
    //                                                              barCodeSearchResults[index].productID.toString(),
    //                                                              style:TextStyle(
    //                                                                  fontFamily: 'Montserrat',
    //                                                                  fontWeight: FontWeight.bold,
    //                                                                  fontSize: 20.0
    //                                                              ),
    //                                                              textAlign: TextAlign.center,
    //                                                            ),
    //                                                          ),
    //                                                        ),
    //                                                      ),
    //                                                    ),
    //                                                            Expanded(
    //                                                              flex:2,
    //                                                              child: Container(
    //                                                                width:MediaQuery.of(context).size.width,
    //                                                                child: Padding(
    //                                                                  padding: const EdgeInsets.all(8.0),
    //                                                                  child: RaisedButton(
    //                                                                    onPressed:(){
    ////                                                              productToUpdate = barCodeSearchResults[index];
    ////                                                              productToUpdateIndex = index;
    ////                                                              Navigator.of(context).pop();
    ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
    ////                                                                return UpdateProductDetails();
    ////                                                              }));
    //                                                                    },
    //                                                                    child: Text(
    //                                                                      barCodeSearchResults[index].productBarCode.toString(),
    //                                                                      style:TextStyle(
    //                                                                          fontFamily: 'Montserrat',
    //                                                                          fontWeight: FontWeight.bold,
    //                                                                          fontSize: 20.0
    //                                                                      ),
    //                                                                      textAlign: TextAlign.center,
    //                                                                    ),
    //                                                                  ),
    //                                                                ),
    //                                                              ),
    //                                                            ),
    //                                                          ],
    //                                                        ),
    //                                                      ),
    ////                                              Expanded(
    ////                                                flex:3,
    ////                                                child: Column(
    ////                                                  children: <Widget>[
    ////                                                    Expanded(
    ////                                                      flex:2,
    ////                                                      child: Padding(
    ////                                                        padding: const EdgeInsets.all(8.0),
    ////                                                        child: RaisedButton(
    ////                                                          highlightColor:Colors.blue,
    ////                                                          onPressed:(){
    ////                                                            setState(() {
    ////                                                              refreshing = true;
    ////                                                            });
    ////                                                            productToUpdate = barCodeSearchResults[index];
    ////                                                            barCodeToSearch = productToUpdate.productBarCode;
    ////                                                            removeProductFromFirebase(barCodeSearchResults[index].productID);
    ////                                                          },
    ////                                                          child:Text('DELETE')
    ////                                                        ),
    ////                                                      ),
    ////                                                    ),
    ////                                                    Expanded(
    ////                                                      flex:2,
    ////                                                      child: Padding(
    ////                                                        padding: const EdgeInsets.all(8.0),
    ////                                                        child: RaisedButton(
    ////                                                            onPressed:(){
    ////                                                              productToUpdate = barCodeSearchResults[index];
    ////                                                              productToUpdateIndex = index;
    ////                                                              Navigator.of(context).pop();
    ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
    ////                                                                return UpdateProductDetails();
    ////                                                              }));
    ////                                                            },
    ////                                                            child:Text('UPDATE')
    ////                                                        ),
    ////                                                      ),
    ////                                                    )
    ////                                                  ],
    ////                                                ),
    ////                                              )
    //
    //                                                    ],
    //                                                  ),
    //                                                ),
    //
    //                                                Expanded(
    //                                                    flex:16,
    //                                                    child: Container(
    //                                                      width:MediaQuery.of(context).size.width,
    //                                                      child: Padding(
    //                                                        padding: const EdgeInsets.all(8.0),
    //                                                        child: RaisedButton(
    //                                                          onPressed: (){
    //                                                          },
    //                                                          child: Text(
    //                                                            barCodeSearchResults[index].productName.toString(),
    //                                                            textAlign: TextAlign.center,
    //                                                            style:TextStyle(
    //                                                              // backgroundColor: Colors.blue,
    //                                                              color:Colors.green,
    //                                                              fontFamily: 'Montserrat',
    //                                                              fontWeight: FontWeight.bold,
    //                                                              fontSize: 20.0,
    //                                                            ),
    //                                                            maxLines: 3,
    //                                                          ),
    //                                                        ),
    //                                                      ),
    //                                                    )
    //                                                ),
    //                                                Expanded(
    //                                                  flex:8,
    //                                                  child: Container(
    //                                                    width:MediaQuery.of(context).size.width,
    //                                                    child: Padding(
    //                                                      padding: const EdgeInsets.all(8.0),
    //                                                      child: RaisedButton(
    //                                                        onPressed:(){
    //
    //                                                        },
    //                                                        child: Text(
    //                                                          'Rs.'+ barCodeSearchResults[index].productPrice.toString() +'/-',
    //                                                          style:TextStyle(
    //                                                              fontFamily: 'Montserrat',
    //                                                              fontWeight: FontWeight.bold,
    //                                                              fontSize: 20.0
    //                                                          ),
    //                                                          textAlign: TextAlign.center,
    //                                                        ),
    //                                                      ),
    //                                                    ),
    //                                                  ),
    //                                                ),
    //
    //                                                Expanded(
    //                                                  flex:8,
    //                                                  child: Container(
    //                                                    width:MediaQuery.of(context).size.width,
    //                                                    child: Padding(
    //                                                      padding: const EdgeInsets.all(8.0),
    //                                                      child: RaisedButton(
    //                                                          onPressed:(){
    //
    //                                                          },
    //                                                          child:
    //                                                          Text(
    //                                                            barCodeSearchResults[index].productCategory,
    //                                                            style:TextStyle(
    //                                                                fontFamily: 'Montserrat',
    //                                                                fontWeight: FontWeight.bold,
    //                                                                fontSize: 20.0
    //                                                            ),
    //                                                            textAlign: TextAlign.right,
    //                                                          )
    //                                                      ),
    //                                                    ),
    //                                                  ),
    //                                                ),
    //                                                Expanded(
    //                                                  flex:8,
    //                                                  child: Container(
    //                                                    width:MediaQuery.of(context).size.width,
    //                                                    child: Padding(
    //                                                      padding: const EdgeInsets.all(8.0),
    //                                                      child: RaisedButton(
    //                                                          onPressed:(){
    //                                                          },
    //                                                          child:
    //                                                          Text(
    //                                                            barCodeSearchResults[index].productBrand,
    //                                                            style:TextStyle(
    //                                                                fontFamily: 'Montserrat',
    //                                                                fontWeight: FontWeight.bold,
    //                                                                fontSize: 20.0
    //                                                            ),
    //                                                            textAlign: TextAlign.right,
    //                                                          )
    //                                                      ),
    //                                                    ),
    //                                                  ),
    //                                                ),
    //                                                Expanded(
    //                                                  flex:8,
    //                                                  child: Container(
    //                                                    width:MediaQuery.of(context).size.width,
    //                                                    child: Padding(
    //                                                      padding: const EdgeInsets.all(8.0),
    //                                                      child: RaisedButton(
    //                                                          onPressed:(){
    //                                                          },
    //                                                          child:
    //                                                          Text(
    //                                                            (barCodeSearchResults[index].productStatus != null)?barCodeSearchResults[index].productStatus:'N/A',
    //                                                            style:TextStyle(
    //                                                                fontFamily: 'Montserrat',
    //                                                                fontWeight: FontWeight.bold,
    //                                                                fontSize: 20.0
    //                                                            ),
    //                                                            textAlign: TextAlign.right,
    //                                                          )
    //                                                      ),
    //                                                    ),
    //                                                  ),
    //                                                ),
    //                                                Expanded(
    //                                                  flex:8,
    //                                                  child: Container(
    //                                                    width:MediaQuery.of(context).size.width,
    //                                                    child: Padding(
    //                                                      padding: const EdgeInsets.all(8.0),
    //                                                      child: RaisedButton(
    //                                                          onPressed:(){
    //                                                          },
    //                                                          child:
    //                                                          Text(
    //                                                            (barCodeSearchResults[index].productParentStore != null)?barCodeSearchResults[index].productParentStore:'N/A',
    //                                                            style:TextStyle(
    //                                                                fontFamily: 'Montserrat',
    //                                                                fontWeight: FontWeight.bold,
    //                                                                fontSize: 20.0
    //                                                            ),
    //                                                            textAlign: TextAlign.right,
    //                                                          )
    //                                                      ),
    //                                                    ),
    //                                                  ),
    //                                                ),
    //                                                Expanded(
    //                                                  flex:8,
    //                                                  child: Container(
    //                                                    width:MediaQuery.of(context).size.width,
    //                                                    child: Padding(
    //                                                      padding: const EdgeInsets.all(8.0),
    //                                                      child: RaisedButton(
    //                                                          onPressed:(){
    //                                                          },
    //                                                          child:
    //                                                          Text(
    //                                                            (barCodeSearchResults[index].productCreationTimeStamp != null)?barCodeSearchResults[index].productCreationTimeStamp:'N/A',
    //                                                            style:TextStyle(
    //                                                                fontFamily: 'Montserrat',
    //                                                                fontWeight: FontWeight.bold,
    //                                                                fontSize: 20.0
    //                                                            ),
    //                                                            textAlign: TextAlign.right,
    //                                                          )
    //                                                      ),
    //                                                    ),
    //                                                  ),
    //                                                ),
    ////                                        Expanded(
    ////                                          flex:8,
    ////                                          child:Row(
    ////                                            children: <Widget>[
    ////                                              Expanded(
    ////                                                flex:4,
    ////                                                child: Container(
    ////                                                  width:MediaQuery.of(context).size.width,
    ////                                                  child: Padding(
    ////                                                    padding: const EdgeInsets.all(8.0),
    ////                                                    child: Text(
    ////                                                      'IN',
    ////                                                      style:TextStyle(
    ////                                                          fontFamily: 'Montserrat',
    ////                                                          fontWeight: FontWeight.bold,
    ////                                                          fontSize: 20.0
    ////                                                      ),
    ////                                                      textAlign: TextAlign.center,
    ////                                                    ),
    ////                                                  ),
    ////                                                ),
    ////                                              ),
    ////                                              Expanded(
    ////                                                flex:4,
    ////                                                child: Container(
    ////                                                  width:MediaQuery.of(context).size.width,
    ////                                                  child: Padding(
    ////                                                    padding: const EdgeInsets.all(8.0),
    ////                                                    child: Text(
    ////                                                      'OUT',
    ////                                                      style:TextStyle(
    ////                                                          fontFamily: 'Montserrat',
    ////                                                          fontWeight: FontWeight.bold,
    ////                                                          fontSize: 20.0
    ////                                                      ),
    ////                                                      textAlign: TextAlign.center,
    ////                                                    ),
    ////                                                  ),
    ////                                                ),
    ////                                              ),
    ////                                              Expanded(
    ////                                                flex:4,
    ////                                                child: Container(
    ////                                                  width:MediaQuery.of(context).size.width,
    ////                                                  child: Padding(
    ////                                                    padding: const EdgeInsets.all(8.0),
    ////                                                    child: Text(
    ////                                                      'STOCK',
    ////                                                      style:TextStyle(
    ////                                                          fontFamily: 'Montserrat',
    ////                                                          fontWeight: FontWeight.bold,
    ////                                                          fontSize: 20.0
    ////                                                      ),
    ////                                                      textAlign: TextAlign.center,
    ////                                                    ),
    ////                                                  ),
    ////                                                ),
    ////                                              ),
    ////                                            ],
    ////                                          ),
    ////                                        ),
    ////                                              Expanded(
    ////                                                flex:8,
    ////                                                child:Row(
    ////                                                  children: <Widget>[
    ////                                                    Expanded(
    ////                                                      flex:4,
    ////                                                      child: Container(
    ////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
    ////                                                        width:MediaQuery.of(context).size.width,
    ////                                                        child: RaisedButton(
    ////                                                          onPressed:(){
    ////                                                            double x = (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]:0;
    //////                                                              Navigator.of(context).pop();
    ////                                                            if(x>0)
    ////                                                              {
    ////                                                            productCode = barCodeSearchResults[index].productID;
    ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
    ////                                                                return ProductStockInwardHistory();
    ////                                                              }));
    ////                                                            }
    ////                                                          },
    ////                                                          child: Padding(
    ////                                                            padding: const EdgeInsets.all(8.0),
    ////                                                            child: Text(
    ////                                                                (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID].toString():'0',
    ////                                                              style:TextStyle(
    ////                                                                  fontFamily: 'Montserrat',
    ////                                                                  fontWeight: FontWeight.bold,
    ////                                                                  fontSize: 20.0
    ////                                                              ),
    ////                                                              textAlign: TextAlign.center,
    ////                                                            ),
    ////                                                          ),
    ////                                                        ),
    ////                                                      ),
    ////                                                    ),
    ////                                                    Expanded(
    ////                                                      flex:4,
    ////                                                      child: Container(
    ////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
    ////                                                        width:MediaQuery.of(context).size.width,
    ////                                                        child: RaisedButton(
    ////                                                          onPressed:(){
    ////                                                            double x = (productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID]:0;
    ////                                                            if(x > 0){
    //////                                                              Navigator.of(context).pop();
    ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
    ////                                                                return ProductStockOutwardHistory();
    ////                                                              }));
    ////                                                            }
    ////                                                          },
    ////                                                          child: Padding(
    ////                                                            padding: const EdgeInsets.all(8.0),
    ////                                                            child: Text(
    ////                                                                (productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID].toString():'0',
    ////                                                              style:TextStyle(
    ////                                                                  fontFamily: 'Montserrat',
    ////                                                                  fontWeight: FontWeight.bold,
    ////                                                                  fontSize: 20.0
    ////                                                              ),
    ////                                                              textAlign: TextAlign.center,
    ////                                                            ),
    ////                                                          ),
    ////                                                        ),
    ////                                                      ),
    ////                                                    ),
    //////                                                    Expanded(
    //////                                                      flex:4,
    //////                                                      child: Container(
    //////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
    //////                                                        width:MediaQuery.of(context).size.width,
    //////                                                        child: Padding(
    //////                                                          padding: const EdgeInsets.all(8.0),
    //////                                                          child: Text(
    //////                                                            productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID].toString(),
    //////                                                            style:TextStyle(
    //////                                                                fontFamily: 'Montserrat',
    //////                                                                fontWeight: FontWeight.bold,
    //////                                                                fontSize: 20.0
    //////                                                            ),
    //////                                                            textAlign: TextAlign.center,
    //////                                                          ),
    //////                                                        ),
    //////                                                      ),
    //////                                                    ),
    ////                                                    Expanded(
    ////                                                      flex:4,
    ////                                                      child: Container(
    ////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
    ////                                                        width:MediaQuery.of(context).size.width,
    ////                                                        child: Padding(
    ////                                                          padding: const EdgeInsets.all(8.0),
    ////                                                          child: Text(
    ////                                                            ((
    ////                                            (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]:0)
    ////                                            - ((productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID]:0)).toString(),
    ////                                                            style:TextStyle(
    ////                                                                fontFamily: 'Montserrat',
    ////                                                                fontWeight: FontWeight.bold,
    ////                                                                fontSize: 20.0
    ////                                                            ),
    ////                                                            textAlign: TextAlign.center,
    ////                                                          ),
    ////                                                        ),
    ////                                                      ),
    ////                                                    ),
    ////                                                  ],
    ////                                                )
    ////                                              )
    //                                              ])
    //                                          ),
    //                                        );
                                      }
                                  )
                              )
                          )
                        ],
                      )
                  )
              ));
      else
        return
          WillPopScope(
              onWillPop:(){
                setState(() {
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return OnlineProductLookUp();
                      }));
                });

                return;
              },
              child: Scaffold(
                  appBar:AppBar(
                    automaticallyImplyLeading: false,
                    title:Text('SEARCH RESULTS'),
                    centerTitle: true,
                    leading: IconButton(
                        icon:Icon(Icons.keyboard_backspace),
                        onPressed:(){
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                            return OnlineProductLookUp();
                          }));
                        }
                    ),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          barCodeToSearch,
                          style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 36.0,
                              color:Colors.deepOrangeAccent
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'PRODUCT NOT IN SYSTEM',
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,

                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: RaisedButton(
                          color:Colors.blue,
                          onPressed:(){
                            barCodeToAdd  = barCodeToSearch;
                            Navigator.of(context).pop();
                            Navigator.of(context).push<dynamic>(
                              MaterialPageRoute<dynamic>(
                                builder:(BuildContext context){
                                  return AddNewProductWithBarcode();
                                }
                              )
                            );
                          },
                          child:Text('ADD PRODUCT',
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color:Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      )
                    ],
                  )
              ));
    }

  }
}