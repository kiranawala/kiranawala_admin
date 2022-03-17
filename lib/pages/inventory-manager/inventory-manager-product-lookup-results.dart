import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-no-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-options.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-options.dart';

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
    showOptions = true;
    changeName = false;
    changePrice = false;
    changeCategory = false;
    changeBrand = false;
    changeDiscountDetails = false;
    changeStatus = false;
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
                            child:ListView.builder(
                                itemCount: barCodeSearchResults.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return
                                    Dismissible(
                                      key:Key(barCodeSearchResults[index].productID.toString()),
                                      confirmDismiss: (direction) async {
                                        if (direction == DismissDirection.endToStart) {
                                          final bool res = await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(
                                                    "ARE YOU SURE?",
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        fontSize: 24.0,
                                                        color:Colors.black
                                                    ),),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(fontFamily: 'Montserrat', fontWeight:FontWeight.bold,
                                                            fontSize: 24.0,color: Colors.black),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    FlatButton(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold,
                                                              fontSize: 24.0,color: Colors.red),
                                                        ),
                                                        onPressed: () {
                                                          skuToUpdate = barCodeSearchResults[index].productID;
                                                          // TODO: Delete the item from DB etc..
                                                          FirebaseDatabase
                                                              .instance
                                                              .reference()
                                                              .child('stores')
                                                              .child(productNode)
                                                              .child('products')
                                                              .child(skuToUpdate.toString())
                                                              .remove().then((value) {
                                                            print('PRODUCT DELETION SUCCESSFUL:' +
                                                                skuToUpdate.toString());
                                                            productUpdateStatus = 'SUCCESS';

                                                            barCodeSearchResultsMap.remove(
                                                                skuToUpdate);

                                                            barCodeSearchResults =
                                                                List<ProductBasicDetails>();
                                                            barCodeSearchResultsMap.forEach((key,
                                                                value) {
                                                              barCodeSearchResults.add(value);
                                                            });

                                                            barCodeSearchResults.sort((a, b) {
                                                              return (
                                                                  a.productName.compareTo(
                                                                      b.productName)
                                                              );
                                                            });
                                                            setState(() {});
                                                            Navigator.of(context).pop();
                                                          });
                                                        }
                                                    ),
                                                  ],
                                                );
                                              });
                                          return res;
                                        } else {
                                          return null;
                                        }
                                      },
                                      onDismissed:(direction) {},
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        color:Colors.white,
                                        child: RaisedButton(
                                          onPressed: ()
                                          {
                                            print('Product Selected');
                                            skuToUpdate = barCodeSearchResults[index].productID;
                                            barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
                                            barCodeSearchResults.forEach((element) {
                                              barCodeSearchResultsMap[element.productID] = element;
                                            });
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push<dynamic>(
                                                MaterialPageRoute<dynamic>(
                                                    builder: (BuildContext context){
                                                      return ProductUpdateOptions();
                                                    }
                                                )
                                            );
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
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
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
                                                      ),
                                                      Positioned(
                                                        right:0,
                                                        child: Container(
                                                          color:Colors.yellow,
                                                          child: Text(
                                                            "\u20B9" +
                                                                barCodeSearchResults[index]
                                                                    .productPrice.toString(),
                                                            maxLines: 4,
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 18.0,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: "Montserrat"),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right:0,
                                                        bottom:0,
                                                        child: Container(
                                                          child: (barCodeSearchResults[index]
                                                              .productStatus == 'ACTIVE')?Icon(Icons.check_circle,color:Colors.green):Icon(Icons.check_circle,color:Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 6,
                                                  child: Column(children: <Widget>[
                                                    Expanded(
                                                      flex:4,
                                                      child:  Center(
                                                        child: Text(
                                                          barCodeSearchResults[index]
                                                              .productName
                                                              .toUpperCase(),
                                                          maxLines: 4,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: "Montserrat"),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex:1,
                                                      child:  Center(
                                                        child: Text(
                                                          barCodeSearchResults[index]
                                                              .productBarCode
                                                              .toUpperCase(),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: "Montserrat"),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex:1,
                                                      child:  Center(
                                                        child: Text(
                                                          barCodeSearchResults[index]
                                                              .productID.toString(),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: "Montserrat"),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex:1,
                                                      child:  Center(
                                                        child: Text(
                                                          barCodeSearchResults[index]
                                                              .productCategory.toString(),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: "Montserrat"),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex:1,
                                                      child:  Center(
                                                        child: Text(
                                                          barCodeSearchResults[index]
                                                              .productBrand.toString(),
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: "Montserrat"),
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                }),
                      )
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
                  Center(
                    child: Text(
                      barCodeToSearch,
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  Center(
                    child: Text(
                      'NO PRODUCT(S) IN SYSTEM',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                      textAlign: TextAlign.center,
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
                                    return InventoryManagerAddNewProductWithBarcode();
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
                                    return InventoryManagerAddNewProductWithoutBarcode();
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
                ],
              )));
  }
}
