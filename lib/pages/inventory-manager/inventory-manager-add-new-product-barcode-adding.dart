import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-no-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-request-name.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-request-price.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-select-product-brand.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-select-product-category.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-product-get-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-category-manager.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-barcode-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-show-all-categories.dart';
//import 'package:kiranawala_admin/pages/inventory-manager-store-stock-position.dart';
//import 'package:kiranawala_admin/pages/inventory-manager-store-stock-position.dart';

class InventoryManagerAddNewProductWithBarcodeAdding extends StatefulWidget {
  @override
  _InventoryManagerAddNewProductWithBarcodeAddingState createState() => _InventoryManagerAddNewProductWithBarcodeAddingState();
}

class _InventoryManagerAddNewProductWithBarcodeAddingState extends State<InventoryManagerAddNewProductWithBarcodeAdding> {

  bool addingProduct = true;

  @override
  void initState() {
    super.initState();
    print(nextProductCode.toString());
    print(nextBarCode.toString());
    print(newProductName);
    print(newProductPrice);
    print(selectedCategoryName);
    print(selectedBrandName);
    print(selectedImageURL);
    print(inventoryNode);

    Firestore.instance.collection('stores').document('KIRANAWALA_STORE_11').collection('PRODUCTS').document(nextProductCode.toString()).setData(<String,dynamic>{
      'name':newProductName,
      'price':num.parse(newProductPrice.toString()),
      'barcode':nextBarCode.toString(),
      'productcode':nextProductCode,
      'category':selectedCategoryName.toUpperCase(),
      'brand':selectedBrandName.toUpperCase(),
      'imageurl':selectedImageURL,
    });
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(nextProductCode.toString())
        .update(<String, dynamic>
    {
      'barcode': nextBarCode,
      'productcode': nextProductCode,
      'title': newProductName.toUpperCase(),
      'price': num.parse(newProductPrice.toString()),
      'category': selectedCategoryName,
      'brand': selectedBrandName,
      'imageurl': selectedImageURL,
      'stockposition': 0,
      'productStatus': 'ACTIVE',
      'creationTimeStamp': DateFormat('yyyy-mm-dd HHmmss.SSS').format(
          DateTime.now()).toString(),
      'parentStore': inventoryNode,
      'milliSecondsSinceEpoch': DateTime
          .now()
          .millisecondsSinceEpoch / 1000
    }).then((value) {
      print('Product Added Successfully.');
        ProductBasicDetails product = ProductBasicDetails(
            newProductName.toUpperCase(),
            num.parse(newProductPrice.toString()),
            nextProductCode,
            nextBarCode.toString(),
            selectedImageURL,
            selectedCategoryName,
            selectedBrandName,
            'ACTIVE',
            inventoryNode,
            DateFormat('yyyy-mm-dd HHmmss.SSS')
                .format(DateTime.now())
                .toString()
        );
        barCodeSearchResultsMap[nextProductCode] =
            product;

        setState(() {
          addingProduct = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (addingProduct)
      return
        WillPopScope(
            onWillPop:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ProductLookUp();
                      }
                  )
              );
              return;
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                title: Text(
                    'ADD NEW PRODUCT(WITH BARCODE)',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                ),
                  automaticallyImplyLeading: false,
                  leading:IconButton(
                    icon:Icon(Icons.keyboard_backspace),
                    onPressed:(){
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                              builder:(BuildContext context){
                                return ProductLookUp();
                              }
                          )
                      );
                    },
                  ),                  actions: <Widget>[
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
                          print('opening barcode scanner');
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context){
                                    return InventoryManagerProductBarcodeLookUp();
                                  }
                              )
                          );
                        },
                        icon:Icon(Icons.scanner)
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
                        onPressed:(){
                          print('STARTING PRODUCT SEARCH');

                          barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
                          lookupMap = Map<int,ProductBasicDetails>();

                          fullProductBasicDetailsMap.forEach((key,value) {
                            if(value.productStatus == 'ACTIVE')
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

                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context){
                                    return InventoryManagerProductNameLookUp();
                                  }
                              )
                          );
                        },
                        icon:Icon(Icons.search)
                    )
                  ],
            ),
                body:

                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width:MediaQuery.of(context).size.width,
                          child:RaisedButton(
                            color: Colors.grey[300],
                            onPressed:(){},
                            child:Text(nextProductCode.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                          )
                      ),
                      Container(
                          width:MediaQuery.of(context).size.width,
                          child:
                          RaisedButton(
                            color: Colors.blue,
                            onPressed:(){
                            },
                            child:Text(nextBarCode,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )
                      ),

                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color:Colors.grey[300],
                          child:Text(
                            newProductName,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0),
                          ),
                          onPressed: (){
                          },
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
                            color:Colors.grey[300],
                            child:Text(
                              newProductPrice.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0),
                            ),
                            onPressed:(){
                            }
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color:Colors.grey[300],
                          child: Text(
                            selectedCategoryName,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          onPressed: () {
                          },
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color: Colors.grey[300],
                          child: Text(
                            selectedBrandName,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          onPressed: () {
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children:<Widget>[
                            Expanded(
                              child: LinearProgressIndicator(),
                            ),
                            Expanded(
                              child:Text(
                                'ADDING PRODUCT....'
                              )
                            )
                          ])
                      )
            ]
                        ),
                      ),

           );
    else {
      return
        WillPopScope(
            onWillPop:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ProductLookUp();
                      }
                  )
              );
              return;
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text(
                      'ADD NEW PRODUCT(WITH BARCODE)',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  automaticallyImplyLeading: false,
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
                          print('opening barcode scanner');
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context){
                                    return InventoryManagerProductBarcodeLookUp();
                                  }
                              )
                          );
                        },
                        icon:Icon(Icons.scanner)
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
                        onPressed:(){
                          print('STARTING PRODUCT SEARCH');

                          barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
                          lookupMap = Map<int,ProductBasicDetails>();

                          fullProductBasicDetailsMap.forEach((key,value) {
                            if(value.productStatus == 'ACTIVE')
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

                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context){
                                    return InventoryManagerProductNameLookUp();
                                  }
                              )
                          );
                        },
                        icon:Icon(Icons.search)
                    )
                  ],
                  leading:IconButton(
                    icon:Icon(Icons.keyboard_backspace),
                    onPressed:(){
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                              builder:(BuildContext context){
                                return ProductLookUp();
                              }
                          )
                      );
                    },
                  ),
                ),
                body:

                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                Container(
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
                                  selectedImageURL),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
              ]
                )
        ),
                      Container(
                          width:MediaQuery.of(context).size.width,
                          child:RaisedButton(
                            color: Colors.grey[300],
                            onPressed:(){},
                            child:Text(nextProductCode.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )),
                          )
                      ),
                      Container(
                          width:MediaQuery.of(context).size.width,
                          child:
                          RaisedButton(
                            color: Colors.blue,
                            onPressed:(){
                            },
                            child:Text(nextBarCode,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          )
                      ),

                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color:Colors.grey[300],
                          child:Text(
                            newProductName,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0),
                          ),
                          onPressed: (){
                          },
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
                            color:Colors.grey[300],
                            child:Text(
                              newProductPrice.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0),
                            ),
                            onPressed:(){
                            }
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color:Colors.grey[300],
                          child: Text(
                            selectedCategoryName,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          onPressed: () {
                          },
                        ),
                      ),
                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color: Colors.grey[300],
                          child: Text(
                            selectedBrandName,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          onPressed: () {
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            color: Colors.blue,
                            child: Text(
                              'PRODUCT ADDED SUCCESSFULLY',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            onPressed: () {
                            },
                          ),
                        ),
                      ),

                    ])));
    }
  }
}
