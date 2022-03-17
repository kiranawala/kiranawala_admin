import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup.dart';

bool refreshing = false;


class ProductLookupResults extends StatefulWidget {
  @override
  _ProductLookupResultsState createState() => _ProductLookupResultsState();
}

class _ProductLookupResultsState extends State<ProductLookupResults> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

    if (barCodeSearchResults.length > 0) {
      return WillPopScope(
          onWillPop: () {
            setState(() {
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                    return ProductLookUp();
                  }));
            });

            return;
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.keyboard_backspace),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) {
                              return ProductLookUp();
                            }));
                  },
                ),
                title: Text(
                  'Search Results',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                centerTitle: true,
              ),
              body:
              Container(
                color:Colors.white,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                            children:<Widget>[
                              Text(
                                'AVAILABLE SKUs :' +
                                    barCodeSearchResults.length.toString(),
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ]

                        ),
                      ),
                      Expanded(
                          flex: 20,
                          child:
                          Container(
                            color:Colors.white,
                              child: ListView.builder(
                                  itemCount: barCodeSearchResults.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return


//                                      Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: RaisedButton(
//                                        onPressed: ()
//                                        {
//                                          print('Product Selected');
//                                          previousSearchResultIndex = index;
//                                          skuToUpdate =
//                                              barCodeSearchResults[index].productID;
//                                            Future<void> future =  showModalBottomSheet(
//                                                context: context,
//                                                builder: (BuildContext context) {
//                                                  return BottomSheet(
//                                                      onClosing: () {
//                                                      },
//                                                      builder: (BuildContext context) {
//                                                        return StockInwardProductUpdateOptions();
//                                                      });
//                                                });
//                                            future.then((void value) => {
//                                             setState((){})
//                                            });
//                                        },
//                                        child: Padding(
//                                          padding: const EdgeInsets.all(8.0),
//                                          child: Column(
//                                            mainAxisAlignment:
//                                            MainAxisAlignment.center,
//                                            crossAxisAlignment:
//                                            CrossAxisAlignment.center,
//                                            children: <Widget>[
//                                              Container(
//                                                child: Image.network(
//                                                  barCodeSearchResults[
//                                                  index]
//                                                      .productImageURL
//                                                      .toString(),
//                                                ),
//                                              ),
////                                              Container(
////                                                  child: Text(
////                                                      barCodeSearchResults[
////                                                      index]
////                                                          .productID
////                                                          .toString(),
////                                                    style: TextStyle(
////                                                        fontFamily: 'Montserrat',
////                                                        fontWeight: FontWeight.bold,
////                                                        fontSize: 20.0,
////                                                        color:Colors.black),)),
////                                              Container(
////                                                  child: Text(
////                                                      barCodeSearchResults[
////                                                      index]
////                                                          .productBarCode
////                                                          .toString(),
////                                                    style: TextStyle(
////                                                        fontFamily: 'Montserrat',
////                                                        fontWeight: FontWeight.bold,
////                                                        fontSize: 20.0,
////                                                        color:Colors.black),)),
//                                              Container(
//                                                  child: Text(
//                                                    barCodeSearchResults[
//                                                    index]
//                                                        .productName
//                                                        .toString(),
//                                                    maxLines: 3,
//                                                    style: TextStyle(
//                                                        fontFamily: 'Montserrat',
//                                                        fontWeight: FontWeight.bold,
//                                                        fontSize: 20.0,
//                                                        color:Colors.black),)),
//                                              Container(
//                                                  child: Text(
//                                                    '\u20B9 ' + barCodeSearchResults[
//                                                    index]
//                                                        .productPrice
//                                                        .toString(),
//                                                    style: TextStyle(
//                                                        fontFamily: 'Montserrat',
//                                                        fontWeight: FontWeight.bold,
//                                                        fontSize: 20.0,
//                                                        color:Colors.black),)),
////                                              Container(
////                                                  child: Text(
////                                                    barCodeSearchResults[
////                                                    index]
////                                                        .productCategory
////                                                        .toString(),
////                                                    style: TextStyle(
////                                                        fontFamily: 'Montserrat',
////                                                        fontWeight: FontWeight.bold,
////                                                        fontSize: 20.0,
////                                                        color:Colors.black),)),
////                                              Container(
////                                                  child: Text(
////                                                    barCodeSearchResults[
////                                                    index]
////                                                        .productBrand
////                                                        .toString(),
////                                                    style: TextStyle(
////                                                        fontFamily: 'Montserrat',
////                                                        fontWeight: FontWeight.bold,
////                                                        fontSize: 20.0,
////                                                        color:Colors.black),)),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Image URL')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(barCodeSearchResults[index].productImageURL.toString())
////                                                          ),
////                                                        ),
////                                                      ],
////                                                    ),
//                                              Container(
//                                                  child: Text(
//                                                    barCodeSearchResults[
//                                                    index]
//                                                        .productStatus
//                                                        .toString(),
//                                                    style: TextStyle(
//                                                        fontFamily: 'Montserrat',
//                                                        fontWeight: FontWeight.bold,
//                                                        fontSize: 20.0,
//                                                        color:Colors.black),)),
////                                              Container(
////                                                  child: Text(
////                                                      barCodeSearchResults[
////                                                      index]
////                                                          .productParentStore
////                                                          .toString())),
////                                              Container(
////                                                  child: Text(
////                                                      barCodeSearchResults[
////                                                      index]
////                                                          .productCreationTimeStamp
////                                                          .toString())),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Discount')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(
////                                      (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discount.toString():'N/A'))
//////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
////                                                          ),
////                                                        ),
////                                                      ],
////                                                    ),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Discount Type')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(
////                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discountType.toString():'N/A'))
//////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
////                                                          ),
////                                                        ),
////                                                      ],
////                                                    ),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Discount Start Date')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(
////                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discountStartDate.toString():'N/A'))
//////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
////                                                          ),
////                                                        ),
////                                                      ],
////                                                    ),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Discount End Date')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(
////                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discountEndDate.toString():'N/A'))
//////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
////                                                          ),
////                                                        ),
////                                                      ],
////                                                    ),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Is Discount Active?')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(
////
////                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].isDiscountActive.toString():'N/A'))
//////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
////                                                          ),
////                                                        ),
////                                                      ],
////                                                    ),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Status Change Timestamp')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(
////                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discountStatusChangeTimeStamp.toString():'N/A'))
//////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
////                                                          ),
////                                                        ),
////                                                      ],
////                                                    ),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Units Sold Till Date')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(
////                                                                  salePositionForRequestedProduct.toString())
//////                                                                  (fullProductSalePositionAtTerminal['POS_8'][barCodeSearchResults[index].productID] != null?fullProductSalePositionAtTerminal['POS_8'][barCodeSearchResults[index].productID].toString():'N/A'))
////                                                          ),
////                                                        ),
////                                                      ],
////                                                    ),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Units Purchased Till Date')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(
////                                                                  stockInwardForRequestedProduct.toString(),
//////                                                                  (fullProductStockPositionMap[barCodeSearchResults[index].productID] != null?fullProductStockPositionMap[barCodeSearchResults[index].productID].toString():'N/A'))
////                                                          ),
////                                                        ),)
////                                                      ],
////                                                    ),
////                                                    Row(
////                                                      children: <Widget>[
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text('Final Stock Position:')
////                                                          ),
////                                                        ),
////                                                        Expanded(
////                                                          child: Container(
////                                                              child:Text(
////                                                                stockPositionForRequestedProduct.toString())
//////                                                                  (fullProductStockPositionMap[barCodeSearchResults[index].productID] != null
//////                                                                    && fullProductSalePositionMap[barCodeSearchResults[index].productID] != null)?
//////                                                                  (fullProductStockPositionMap[barCodeSearchResults[index].productID]
//////                                                                      - fullProductSalePositionMap[barCodeSearchResults[index].productID]).toString():
//////                                                                  'N/A')
////                                                          ),
////                                                        ),
////                                                      ],
////                                                    )
//                                            ],
//                                          ),
//                                        ),
//                                      ),
//                                    );
                                    Dismissible(
                                      child: Container(
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
                                                            return null;
//                                                            return StockInwardProductUpdateOptions();
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
                                            height: 120,
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 4,
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
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: Column(children: <Widget>[
                                                    Center(
                                                      child: Text(
                                                        barCodeSearchResults[index]
                                                            .productName
                                                            .toUpperCase(),
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.0,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: "Montserrat"),
                                                      ),
                                                    ),
                                                    Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 12,
                                                            child: Container(
                                                              child: Center(
                                                                child: Text(
                                                                  "\u20B9" +
                                                                      barCodeSearchResults[index]
                                                                          .productPrice.toString(),
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18.0,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontFamily: "Montserrat"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            flex: 12,
                                                            child: Container(
                                                              child: Center(
                                                                child: Text(
                                                                      barCodeSearchResults[index]
                                                                          .productStatus.toString(),
                                                                  style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18.0,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontFamily: "Montserrat"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }))
                      )
                    ],
                  ))));
    } else
      return WillPopScope(
          onWillPop: () {
            setState(() {
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                    return ProductLookUp();
                  }));
            });

            return;
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('SEARCH RESULTS'),
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.keyboard_backspace),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) {
                                return ProductLookUp();
                              }));
                    }),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    barCodeToSearch,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                  Text(
                    'PRODUCT NOT IN SYSTEM',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              )));
  }
}
