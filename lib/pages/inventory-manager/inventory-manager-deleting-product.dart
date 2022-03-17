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
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-category-manager.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-barcode-lookup.dart';
//import 'package:kiranawala_admin/pages/inventory-manager/stock-inward-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-show-all-categories.dart';

//import 'package:kiranawala_admin/pages/inventory-manager-store-stock-position.dart';
//import 'package:kiranawala_admin/pages/inventory-manager-store-stock-position.dart';

class InventoryManagerDeletingProduct extends StatefulWidget {
  @override
  _InventoryManagerDeletingProductState createState() => _InventoryManagerDeletingProductState();
}

class _InventoryManagerDeletingProductState extends State<InventoryManagerDeletingProduct> {


  bool deletingProduct = true;

  @override
  void initState() {
    super.initState();
    print(nextProductCode.toString());
    print(nextBarCode.toString());
    print(newProductName);
    print(newProductPrice);
    print(selectedCategoryName);
    print(selectedBrandName);
    print(inventoryNode);
    print(skuToUpdate);

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(productNode)
        .child('products')
        .child(skuToUpdate.toString())
        .remove().then((value) {
      print('Product Deleted Successfully.');

      barCodeSearchResultsMap.remove(skuToUpdate);
      fullProductBasicDetailsMap.remove(skuToUpdate);

        setState(() {
          deletingProduct = false;
        });

    });
  }

  @override
  Widget build(BuildContext context)
      {
        if(deletingProduct)
        return
          WillPopScope(
              onWillPop: () {
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) {
                          return InventoryManagerShowAllCategories();
                        }
                    )
                );

                return;
              },
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
//                    title: Text(
//                        'ADD NEW PRODUCT(NO BARCODE)',
//                        style: TextStyle(
//                          fontFamily: 'Montserrat',
//                          fontSize: 14.0,
//                          color: Colors.white,
//                          fontWeight: FontWeight.bold,
//                        )
//                    ),
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
                                  return InventoryManagerShowAllCategories();
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
                            width:MediaQuery.of(context).size.width,
                            child:RaisedButton(
                              color: Colors.grey[300],
                              onPressed:(){},
                              child:Text('NEW PRODUCT(NO BARCODE)',
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
                            child:RaisedButton(
                              color: Colors.grey[300],
                              onPressed:(){},
                              child:Text(skuToUpdate.toString(),
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
                              color: Colors.grey[300],
                              onPressed:(){},
                              child:Text(nextBarCode,
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 24.0,
                                      color: Colors.black,
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
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child:
                                    LinearProgressIndicator(),
//                                  RaisedButton(
//                                      color: Colors.blue,
//                                      child: Text(
//                                        'ADDING PRODUCT.......',
//                                        textAlign: TextAlign.center,
//                                        style: TextStyle(
//                                          color: Colors.white,
//                                          fontFamily: 'Montserrat',
//                                          fontWeight: FontWeight.bold,
//                                          fontSize: 18.0,
//                                        ),
//                                      ),
//                                      onPressed: () {}
//                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: RaisedButton(
                                    color: Colors.blue,
                                    child: Text(
                                      'DELETING PRODUCT.......',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    onPressed: () {}
                                  ),
                                ),
                              ],

                            ),
                          ),
                        ),

//                Align(
//                  alignment: Alignment.bottomCenter,
//                  child: Container(
//                    width: MediaQuery.of(context).size.width,
//                    child: RaisedButton(
//                      color: Colors.blue,
//                      child: Text(
//                        'ADD PRODUCT',
//                        style: TextStyle(
//                          color: Colors.white,
//                          fontFamily: 'Montserrat',
//                          fontWeight: FontWeight.bold,
//                          fontSize: 24.0,
//                        ),
//                      ),
//                      onPressed: () {
//                        if (this.newProductName != '' &&
//                            this.newProductPrice != '') {
//                          if (this.newProductPrice > 0) {
//                            FirebaseDatabase.instance
//                                .reference()
//                                .child('stores')
//                                .child(productNode)
//                                .child('products')
//                                .child(this.nextProductCode.toString())
//                                .update(<String, dynamic>{
//                              'barcode': this.nextBarCode.toLowerCase(),
//                              'productcode': this.nextProductCode,
//                              'title': this.newProductName,
//                              'price': this.newProductPrice,
//                              'category': selectedCategoryName,
//                              'brand': selectedBrandName,
//                              'imageurl':
//                                  'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
//                            }).then((value) {
//                              print('Product Added Successfully.');
//                                barCodeSearchResults = [];
//                                barCodeSearchResults.add(new ProductBasicDetails(
//                                  newProductName,
//                                  newProductPrice,
//                                  int.parse(nextProductCode.toString()),
//                                  this.nextBarCode,
//                                  'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
//                                  selectedCategoryName,
//                                  selectedBrandName,
//                                ));
//                                barCodeToSearch = this.nextBarCode;
//                                print(barCodeSearchResults.length.toString());
//                                barCodeSearchResults.forEach((element) {
//                                  print(element.productID);
//                                  print(element.productBarCode);
//                                  print(element.productName);
//                                  print(element.productPrice);
//                                });
////                                Navigator.of(context).pop();
//                                Navigator.of(context).push<dynamic>(
//                                    MaterialPageRoute<dynamic>(
//                                        builder: (BuildContext context) {
//                                  return ProductManager();
//                                }));
//                            }).catchError((dynamic onError) {
//                              print('Product Could not be added. Try Again!!');
//                              // Navigator.of(context).pop();
//                            });
//                          } else {
//                            print('Invalid Price!!');
//                          }
//                        } else {
//                          print('Invalid Price/Name');
//                        }
//                      },
//                    ),
//                  ),
//                ),
                      ])));
        else
          return
            WillPopScope(
              onWillPop: () {
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) {
                          return InventoryManagerShowAllCategories();
                        }
                    )
                );

                return;
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
//                  title: Text(
//                      'ADDING NEW PRODUCT(NO BARCODE)',
//                      style: TextStyle(
//                        fontFamily: 'Montserrat',
//                        fontSize: 14.0,
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                      )
//                  ),
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
                ),
                body:

                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width:MediaQuery.of(context).size.width,
                          child:RaisedButton(
                            color: Colors.blue,
                            onPressed:(){},
                            child:Text('NEW PRODUCT (NO BARCODE)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
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
                            color: Colors.grey[300],
                            onPressed:(){},
                            child:Text(nextBarCode,
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24.0,
                                    color: Colors.black,
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
                          color:Colors.grey[300],
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
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color:Colors.blue,
                          onPressed: (){},
                          child: Text(
                            'PRODUCT DELETED SUCCESSFULLY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
              ),
            );
      }
}
