import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-category-manager.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-cart-options.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-show-all-categories.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-show-selected-category-products.dart';


//List<ProductBasicDetails> barCodeSearchResults = List<ProductBasicDetails>();
List<ProductBasicDetails> products = List<ProductBasicDetails>();
String selectedProductName = '';
int selectedProductCode = 0;

class StockInwardProductNameLookUp extends StatefulWidget {
  @override
  _StockInwardProductNameLookUpState createState() => _StockInwardProductNameLookUpState();
}

class _StockInwardProductNameLookUpState extends State<StockInwardProductNameLookUp> {
//  TextEditingController lookupTextEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
//    lookupTextEditingController.text = lookupText;
//    print(skuToUpdate);
//    barCodeSearchResults = List<ProductBasicDetails>();
//    activeProductBasicDetailsMap = Map<int,ProductBasicDetails>();
//    activeProductBasicDetailsList = List<ProductBasicDetails>();
//    fullProductBasicDetailsMap.forEach((key, value) {
//      if(value.productStatus == 'ACTIVE')
//        {
//          activeProductBasicDetailsMap[key] = value;
//          activeProductBasicDetailsList.add(value);
//        }
//    });
//    barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
//    barCodeSearchResultsMap = activeProductBasicDetailsMap;
//    barCodeSearchResultsMap.forEach((key, value) {
//      barCodeSearchResults.add(value);
//    });
//    barCodeSearchResults.sort((a,b){
//      return (
//          a.productName.compareTo(b.productName)
//      );
//    });
//    print(barCodeSearchResultsMap[skuToUpdate].productPrice);
//    print(barCodeSearchResultsMap[skuToUpdate].productStatus);


  }

  Future scan() async {
    setState(() {
//      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    try {
      barCodeToSearch = (await BarcodeScanner.scan()).toString();
      print('Scanned BarCode:' + barCodeToSearch);

      print(barCodeToSearch);
      if (barCodeToSearch.length > 0) {
        barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
        lookupMap = Map<int,ProductBasicDetails>();

        fullProductBasicDetailsMap.forEach((key,value) {
//          if(value.productStatus == 'ACTIVE' && barCodeToSearch.trim().toLowerCase() == value.productBarCode.toLowerCase())
            if(barCodeToSearch.trim().toLowerCase() == value.productBarCode.toLowerCase())
            {
            barCodeSearchResultsMap[value.productID] = value;
            lookupMap[value.productID] = value;
          }
        });

        barCodeSearchResults = List<ProductBasicDetails>();
        lookupList = List<ProductBasicDetails>();

        barCodeSearchResultsMap.forEach((key, value) {
          barCodeSearchResults.add(value);
          lookupList.add(value);
        });

        barCodeSearchResults.sort((a,b){
          return (
              a.productName.compareTo(b.productName)
          );
        });

        lookupList.sort((a,b){
          return (
              a.productName.compareTo(b.productName)
          );
        });
        setState(() {

        });
      }
      else
      {
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return StockInwardProductNameLookUp();
            }));
      }
    } on PlatformException catch (e) {
      print('Platform Exception');
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('Camera Access Denied');
        setState(() {
//          searchingBarCode = false;
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return StockInwardProductNameLookUp();
              }));
        });
      } else {
        print('Scan Error. Not Camera Access Error');
        setState(() {
//          searchingBarCode = false;
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return StockInwardProductNameLookUp();
              }));
        });

      }
    } on FormatException {
      print('Scan Format Exception');
      setState(() {
//        searchingBarCode = false;
//        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return StockInwardProductNameLookUp();
//            }));
      });
    } catch (e) {
      print('Error Caught in Catch Statement');
      setState(() {
//        searchingBarCode = false;
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return StockInwardProductNameLookUp();
            }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    barCodeSearchResults = List<ProductBasicDetails>();
//    barCodeSearchResultsMap.forEach((key, value) {
//      barCodeSearchResults.add(value);
//    });
//    barCodeSearchResults.sort((a,b){
//      return (
//          a.productName.compareTo(b.productName)
//      );
//    });
//    print(lookupTextController.text);
//      lookupTextEditingController.text = lookupText;
//      print(lookupTextEditingController.text);
      return
        WillPopScope(
          onWillPop:(){
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return StockInwardProductNameLookUp();
                }));
            return;
          },
          child: Scaffold(
            appBar:
          AppBar(
            automaticallyImplyLeading:  false,
            leading:IconButton(
              icon:Icon(Icons.keyboard_backspace),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context){
                      return StockInwardShowAllCategories();
                    }
                  )
                );
              },
            ),
            title:Text(
                'PRODUCT SEARCH',
                style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize:14.0,
                  fontWeight: FontWeight.bold,
                )
            ),
            actions: <Widget>[
              IconButton(
                  onPressed:(){
                    print('Opening Category Manager');
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context){
                              return StockInwardCategoryManager();
                            }
                        )
                    );
                  },
                  icon:Icon(Icons.category)
              ),

              IconButton(
                onPressed:(){
                  print('Adding Product(No BarCode');
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context){
                            return null;
//                            return StockInwardAddNewProductWithoutBarcode();
                          }
                      )
                  );

                },
                icon:Icon(Icons.add_box),
                tooltip: 'WITHOUT BARCODE',
              ),
              IconButton(
                onPressed:(){
                  print('Adding Product(With BarCode');
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context){
                            return null;
//                            return StockInwardAddNewProductWithBarcode();
                          }
                      )
                  );

                },
                icon:Icon(Icons.add_photo_alternate),
                tooltip: 'WITHOUT BARCODE',
              ),
              IconButton(
                  onPressed:scan,
                  icon:Icon(Icons.scanner)
              ),
            ],
          ),
              body:Column(
                  children:<Widget>[
                                Expanded(
                                  flex:2,
                                  child:Container(
                                    padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                    child: TextField(
//                                    controller: lookupTextEditingController,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize:24.0,
                                          fontWeight: FontWeight.bold,
                                          color:Colors.black
                                      ),
                                      autofocus: false,
                                      textAlignVertical: TextAlignVertical.center,
                                      decoration: InputDecoration(
                                          hintText: 'ENTER NAME/BARCODE ...',
                                          hintStyle: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize:16.0,
                                              fontWeight: FontWeight.bold,
                                              color:Colors.black
                                          )
                                      ),
                                      onTap: (){
                                        barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
                                        lookupMap = Map<int,ProductBasicDetails>();

                                        fullProductBasicDetailsMap.forEach((key,value) {
//                                        if(value.productStatus == 'ACTIVE')
//                                        {
                                        barCodeSearchResultsMap[value.productID] = value;
                                        lookupMap[value.productID] = value;
//                                        }
                                        });

                                        barCodeSearchResults = List<ProductBasicDetails>();
                                        lookupList = List<ProductBasicDetails>();

                                        barCodeSearchResultsMap.forEach((key, value) {
                                        barCodeSearchResults.add(value);
                                        lookupList.add(value);
                                        });

                                        barCodeSearchResults.sort((a,b){
                                        return (
                                        a.productName.compareTo(b.productName)
                                        );
                                        });

                                        lookupList.sort((a,b){
                                        return (
                                        a.productName.compareTo(b.productName)
                                        );
                                        });
                                        setState(() {

                                        });
                                      },
                                      onChanged: (value){
                                        print('value changed:' + value);
                                        if(value.isNotEmpty)
                                        {
                                          lookupText = value;
                                          barCodeSearchResults = [];
                                          lookupList.forEach((product){
                                            if(product.productName.toLowerCase().contains(value.toLowerCase()) || product.productBarCode.toLowerCase() == value.toLowerCase())
                                            {
                                              barCodeSearchResults.add(product);
                                              barCodeSearchResultsMap[product.productID] = product;
                                            }
                                          });

                                        }
                                        else{
                                          barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
                                          lookupMap = Map<int,ProductBasicDetails>();

                                          fullProductBasicDetailsMap.forEach((key,value) {
//                                            if(value.productStatus == 'ACTIVE')
//                                            {
                                              barCodeSearchResultsMap[value.productID] = value;
                                              lookupMap[value.productID] = value;
//                                            }
                                          });

                                          barCodeSearchResults = List<ProductBasicDetails>();
                                          lookupList = List<ProductBasicDetails>();

                                          barCodeSearchResultsMap.forEach((key, value) {
                                            barCodeSearchResults.add(value);
                                            lookupList.add(value);
                                          });

                                          barCodeSearchResults.sort((a,b){
                                            return (
                                                a.productName.compareTo(b.productName)
                                            );
                                          });

                                          lookupList.sort((a,b){
                                            return (
                                                a.productName.compareTo(b.productName)
                                            );
                                          });
                                        }
                                        setState(() {

                                        });
                                      },
                                    ),
                                  ),

                                ),
              Expanded(
                flex:18,
                child: ListView.builder(
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

                                          fullProductBasicDetailsMap.remove(skuToUpdate);

                                          lookupMap =
                                              Map<int, ProductBasicDetails>();
                                          lookupList =
                                              List<ProductBasicDetails>();

                                          fullProductBasicDetailsMap.forEach((
                                              key, value) {
//                                            if (value.productStatus ==
//                                                'ACTIVE') {
                                              lookupMap[value.productID] =
                                                  value;
//                                            }
                                          });

                                          lookupMap.forEach((key, value) {
                                            lookupList.add(value);
                                          });

                                          lookupList.sort((a, b) {
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
//                            barCodeSearchResultsMap[skuToUpdate] = fullProductBasicDetailsMap[skuToUpdate];
                                Future<void> future =  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return BottomSheet(
                                          onClosing: () {
                                          },
                                          builder: (BuildContext context) {
//                                        Navigator.of(context).pop();
                                            return StockInwardCartOptions();
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
//                                      Row(
//                                          children: <Widget>[
//                                            Expanded(
//                                              flex: 12,
//                                              child: Container(
//                                                child: Center(
//                                                  child: Text(
//                                                    "\u20B9" +
//                                                        barCodeSearchResults[index]
//                                                            .productPrice.toString(),
//                                                    style: TextStyle(
//                                                        color: Colors.black,
//                                                        fontSize: 14.0,
//                                                        fontWeight: FontWeight.bold,
//                                                        fontFamily: "Montserrat"),
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
//                                            Expanded(
//                                              flex: 12,
//                                              child: Container(
//                                                child: Center(
//                                                  child: Text(
//                                                    barCodeSearchResults[index]
//                                                        .productStatus.toString(),
//                                                    style: TextStyle(
//                                                        color: Colors.black,
//                                                        fontSize: 14.0,
//                                                        fontWeight: FontWeight.bold,
//                                                        fontFamily: "Montserrat"),
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
////                                            Expanded(
////                                              flex: 12,
////                                              child: Container(
////                                                child: Center(
////                                                  child: Text(
////                                                    'IN-STOCK',
////                                                    style: TextStyle(
////                                                        color: Colors.black,
////                                                        fontSize: 14.0,
////                                                        fontWeight: FontWeight.bold,
////                                                        fontFamily: "Montserrat"),
////                                                  ),
////                                                ),
////                                              ),
////                                            ),
//                                          ]),
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
                  ]
                //  DropdownButton(
                //     hint: Text('Select Brand'), // Not necessary for Option 1
                //     value: selectedBrand,
                //     onChanged: (newValue) {
                //       setState(() {
                //         selectedBrand = newValue;
                //       });
                //     },
                //     underline: Container(
                //             height: 2,
                //             color: Colors.deepPurpleAccent,
                //           ),
                //     items: brands.map((Brand brand) {
                //       return DropdownMenuItem(
                //         child: new Text(brand.brandName),
                //         value: brand,
                //       );
                //     }).toList(),
                //   ),
              )
          ),
        );
  }
}