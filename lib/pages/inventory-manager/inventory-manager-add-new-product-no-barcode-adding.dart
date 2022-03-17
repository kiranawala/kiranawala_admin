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

class InventoryManagerAddNewProductWithoutBarcodeAdding extends StatefulWidget {
  @override
  _InventoryManagerAddNewProductWithoutBarcodeAddingState createState() => _InventoryManagerAddNewProductWithoutBarcodeAddingState();
}

class _InventoryManagerAddNewProductWithoutBarcodeAddingState extends State<InventoryManagerAddNewProductWithoutBarcodeAdding> {


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

  // void getProductBrands() async{
  //   retrievingBrands = true;

  //   FirebaseDatabase
  //   .instance
  //   .reference()
  //   .child('brands')
  //   .once()
  //   .then((productBrandsSnapshot){
  //     if(productBrandsSnapshot != null && productBrandsSnapshot.value != null)
  //     {
  //       print('Product Brands Child Node Available');
  //       print(productBrandsSnapshot.value);
  //       Map<dynamic, dynamic> brandList = productBrandsSnapshot.value;
  //       brandList.forEach((key,value){
  //         print(key.toString());
  //         print(value['name']);
  //         brands.add(new Brand(key.toString(),value['name'].toString()));
  //       });

  //       brands.sort((a,b){
  //         return (
  //           a.brandName.compareTo(b.brandName)
  //         );
  //       });

  //       setState(() {
  //         retrievingBrands = false;
  //         brandSearchResults = brands;
  //       });
  //     }
  //     else
  //     {
  //       print('Product Brands Child Not Available');
  //       setState(() {
  //         retrievingBrands = false;
  //       });
  //     }

  //   });
  // }

  // List<Category> categories = [];
  // List<Category> categorySearchResults = [];
  // Category selectedCategory;

  // bool retrievingCategories = false;

  // void getProductCategories() async{
  //   retrievingCategories = true;

  //   FirebaseDatabase
  //   .instance
  //   .reference()
  //   .child('categories')
  //   .once()
  //   .then((productCategoriesSnapshot){
  //     if(productCategoriesSnapshot != null && productCategoriesSnapshot.value != null)
  //     {
  //       print('Product Categories Child Node Available');
  //       print(productCategoriesSnapshot.value);
  //       Map<dynamic, dynamic> categoryList = productCategoriesSnapshot.value;
  //       categoryList.forEach((key,value){
  //         print(key.toString());
  //         print(value['name']);
  //         categories.add(new Category(key.toString(),value['name'].toString()));
  //       });

  //       categories.sort((a,b){
  //         return (
  //           a.categoryName.compareTo(b.categoryName)
  //         );
  //       });

  //       setState(() {
  //         retrievingCategories = false;
  //         categorySearchResults = categories;
  //       });
  //     }
  //     else
  //     {
  //       print('Product Brands Child Not Available');
  //       setState(() {
  //         retrievingCategories = false;
  //       });
  //     }

  //   });
  // }

//  void getNextProductCode() async {
//    this.nextProductCodeAvailable = false;
//    var dateAsString = DateFormat('ddMMyyyyhhmmss').format(DateTime.now());
//    print(dateAsString);
//    var year = dateAsString.substring(6,8);
//    var month = dateAsString.substring(2,4);
//    var day = dateAsString.substring(0,2);
//    var hours = dateAsString.substring(8,10);
//    var minutes = dateAsString.substring(10,12);
//    var seconds = dateAsString.substring(12,14);
//    print(year);
//    print(month);
//    print(day);
//
//    var productCreationTime =
//              day
//            + month
//            + year
//            + hours
//            + minutes
//            + seconds;
////    this.nextBarCode = productCreationTime;
//    this.nextProductCode = int.parse(productCreationTime);
//    this.nextBarCode = productCreationTime + checkSum(productCreationTime).toString();
//    print('PRODUCT SKU:' + this.nextProductCode.toString());
//    print('PRODUCT BARCODE:' + this.nextBarCode);
//    setState(() {
//      this.nextProductCodeAvailable = true;
//    });
//  }

//  void getNextProductCode() async {
//    this.nextProductCodeAvailable = false;
//    FirebaseDatabase
//        .instance
//        .reference()
//        .child('stores')
//        .child('KIRANAWALA_MASTER')
//        .child('lastProductCode')
//        .runTransaction((mutableData) async {
//      print('initState:mutabledata');
//      print(mutableData);
//      print(mutableData.value);
//      if(mutableData != null && mutableData.value != null)
//      {
////        this.nextProductCode = int.parse('279786' + (mutableData.value + 1).toString().padLeft(6,'0'));
//        this.nextProductCode = mutableData.value + 1;
//        this.nextBarCode = (mutableData.value + 1).toString();
////        this.nextBarCode = generateBarCode(this.nextProductCode.toString());
//        setState(() {
//          this.nextProductCodeAvailable = true;
//        });
//      }
//      mutableData.value =(mutableData.value??0) + 1;
//      return mutableData;
//    });
//  }

  @override
  Widget build(BuildContext context)
      {
        if(addingProduct)
        return
          WillPopScope(
              onWillPop: () {
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) {
                          return ProductLookUp();
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
                                      'ADDING PRODUCT.......',
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
                          return ProductLookUp();
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
                            'PRODUCT ADDED SUCCESSFULLY',
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
