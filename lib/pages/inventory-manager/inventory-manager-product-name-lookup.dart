import 'package:algolia/algolia.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-no-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-category-manager.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-options.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-show-all-categories.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-options.dart';


List<ProductBasicDetails> products = List<ProductBasicDetails>();
String selectedProductName = '';
int selectedProductCode = 0;


class AlgoliaApplication {
  static final Algolia algolia = Algolia.init(
    applicationId: '9O18BA0LFN',
    apiKey: '026b89dcc31cb40b79ee51e48974ff05',
  );
}

class InventoryManagerProductNameLookUp extends StatefulWidget {
  @override
  _InventoryManagerProductNameLookUpState createState() => _InventoryManagerProductNameLookUpState();
}

class _InventoryManagerProductNameLookUpState extends State<InventoryManagerProductNameLookUp> {
  TextEditingController searchTextController = TextEditingController();


  Algolia algolia = AlgoliaApplication.algolia;
  AlgoliaQuerySnapshot snap;
  List<AlgoliaObjectSnapshot> AlgoliaSearchResults = new List();


  @override
  void initState() {
    super.initState();
  }

  Future scan() async {
    setState(() {
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
              return InventoryManagerProductNameLookUp();
            }));
      }
    } on PlatformException catch (e) {
      print('Platform Exception');
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('Camera Access Denied');
        setState(() {
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return InventoryManagerProductNameLookUp();
              }));
        });
      } else {
        print('Scan Error. Not Camera Access Error');
        setState(() {

          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return InventoryManagerProductNameLookUp();
              }));
        });

      }
    } on FormatException {
      print('Scan Format Exception');
      setState(() {
      });
    } catch (e) {
      print('Error Caught in Catch Statement');
      setState(() {
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return InventoryManagerProductNameLookUp();
            }));
      });
    }
  }

  int productsFound = 0;


  Future<void> AlgoliaSearch() async {
    ///
    /// Perform Query
    ///
    AlgoliaQuery query = algolia.instance.index('dev_PRODS').search(searchTextController.text.toString());

//    // Perform multiple facetFilters
//    query = query.setFacetFilter('status:published');
//    query = query.setFacetFilter('isDelete:false');

    // Get Result/Objects
    snap = await query.getObjects();
    setState(() {
      productsFound = snap.nbHits;
      print("Products Found:" + productsFound.toString());
      print(snap);
      AlgoliaSearchResults = snap.hits;
      barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
      lookupMap = Map<int,ProductBasicDetails>();
      AlgoliaSearchResults.forEach((element) {
//        print(element.data);
        print(element.data['name']);

        barCodeSearchResultsMap[element.data['productcode']] = new ProductBasicDetails(element.data['name'],
                                                                                        element.data['price'],
                                                                                        element.data['productcode'],
                                                                                        element.data['barcode'],
                                                                                        element.data['imageurl'],
                                                                                        element.data['category'],
                                                                                        element.data['brand'],
                                                                                        'N/A',
                                                                                        'N/A',
                                                                                        'N/A');
          });
        print(barCodeSearchResultsMap);

          barCodeSearchResults = List<ProductBasicDetails>();

          barCodeSearchResultsMap.forEach((key, value) {
            barCodeSearchResults.add(value);
          });

        barCodeSearchResults.sort((a,b){
          return (
              a.productName.compareTo(b.productName)
          );
        });

      print(barCodeSearchResults);
      });


    // Checking if has [AlgoliaQuerySnapshot]
    print('Hits count: ${snap.nbHits}');
    print(barCodeSearchResults);
    setState(() {

    });
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
            barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
            barCodeSearchResults = List<ProductBasicDetails>();
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return ProductLookUp();
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
                barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
                barCodeSearchResults = List<ProductBasicDetails>();
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context){
                      return ProductLookUp();
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
                              return InventoryManagerCategoryManager();
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
                            return InventoryManagerAddNewProductWithoutBarcode();
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
                            return InventoryManagerAddNewProductWithBarcode();
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
                                      },
                                      onChanged: (value){
                                        print('Search Text :' + value);
                                        searchTextController.text = value;
                                        print('Initiating Search for :' + searchTextController.text.toString());
                                        AlgoliaSearch();
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
                                                  .productBarCode.toString(),
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
                  ]
              )
          ),
        );
  }
}