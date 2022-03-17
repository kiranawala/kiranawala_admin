import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-options.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';

class ProductUpdateCreateDuplicate extends StatefulWidget {
  @override
  _ProductUpdateCreateDuplicateState createState() => _ProductUpdateCreateDuplicateState();
}

class _ProductUpdateCreateDuplicateState extends State<ProductUpdateCreateDuplicate> {
  TextEditingController productPriceTextController = TextEditingController();
  String inputValue = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productPriceTextController.text = newProductPrice.toString();
  }


  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
      onWillPop:(){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return ProductUpdateOptions();
                }
            )
        );
        return;
      },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon:Icon(Icons.keyboard_backspace),
              tooltip: 'Go Back',
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder:(BuildContext context){
                          return ProductUpdateOptions();
                        }
                    )
                );
              },
            ),
            title:Text('CHANGE PRODUCT PRICE',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),

          ),
            body:

            Container(
                width:MediaQuery.of(context).size.width,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Container(
                  width:MediaQuery.of(context).size.width,
                      child: Text(barCodeSearchResultsMap[skuToUpdate].productName.toString(),
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width:MediaQuery.of(context).size.width,
                      child: Text('CHANGE PRICE',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Column(
                        children:<Widget>[
                          Container(
                            width:MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey
                            ),
                            child: Text('FROM',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            child: Text('\u20B9 ' + barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ]

                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width:MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.grey
                          ),
                          child: Text('TO',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          child: TextField(
                            controller:productPriceTextController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: Colors.black,
                            ),
                            autofocus: true,
                            textAlign: TextAlign.center,
                            cursorColor: Colors.black,
                            cursorWidth: 8.0,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold)),
                            onChanged: (value) {
                              inputValue = value.toString();
                            },
                          ),
                        ),
                      ],
                    ),
//                    Container(
//                      child: Text(barCodeSearchResultsMap[skuToUpdate].productName.toString(),
//                        maxLines: 3,
//                        style: TextStyle(
//                          fontFamily: 'Montserrat',
//                          fontWeight: FontWeight.bold,
//                          fontSize: 24.0,
//                          color: Colors.black,
//                        ),
//                      ),
//                    ),
//                    Container(
//                      child: Text(barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
//                        maxLines: 3,
//                        style: TextStyle(
//                          fontFamily: 'Montserrat',
//                          fontWeight: FontWeight.bold,
//                          fontSize: 24.0,
//                          color: Colors.black,
//                        ),
//                      ),
//                    ),
//                    Container(
//                      height:100.0,
//                      child: TextField(
//                        textCapitalization: TextCapitalization.characters,
//                        keyboardType: TextInputType.number,
//                    minLines: 3,
//                    maxLines: 3,
////                    keyboardType: TextInputType.text,
//                        style:TextStyle(
//                          fontFamily: 'Montserrat',
//                          fontWeight:FontWeight.bold,
//                          fontSize: 24.0,
//                          color:Colors.black,
//                        ),
//                        autofocus: true,
//                        textAlign: TextAlign.center,
//                        cursorColor: Colors.black,
//                        cursorWidth: 8.0,
//                        decoration: InputDecoration(
//                          hintText: barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
//                            hintStyle: TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontSize: 30.0,
//                                fontWeight: FontWeight.bold)),
//                        onChanged: (value) {
//                          inputValue = value.toString();
//                        },
//                      ),
//                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          color:Colors.blue,
                          onPressed:() {
                            print('RequestValue:inputValue:' + inputValue);
                            if (inputValue != null &&
                                num.parse(inputValue) > 0) {

                              nextProductCode = num.parse(DateFormat('yyMMddHHmmss').format(DateTime.now()));

                              Firestore.instance.collection('stores').document('KIRANAWALA_STORE_11').collection('PRODUCTS').document(nextProductCode.toString()).setData(<String,dynamic>{
                                'name':barCodeSearchResultsMap[skuToUpdate]
                                    .productName.toUpperCase(),
                                'price':num.parse(inputValue),
                                'barcode':barCodeSearchResultsMap[skuToUpdate]
                                    .productBarCode.toString(),
                                'productcode':nextProductCode,
                                'category':barCodeSearchResultsMap[skuToUpdate]
                                    .productCategory.toUpperCase(),
                                'brand':barCodeSearchResultsMap[skuToUpdate]
                                    .productBrand.toUpperCase(),
                                'imageurl':barCodeSearchResultsMap[skuToUpdate]
                                    .productImageURL,
                              });
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('stores')
                                  .child('KIRANAWALA_STORE_11')
                                  .child('products')
                                  .child(nextProductCode.toString())
                                  .update(<String, dynamic>{
                                'barcode': barCodeSearchResultsMap[skuToUpdate]
                                    .productBarCode.toString(),
                                'productcode': nextProductCode,
                                'title': barCodeSearchResultsMap[skuToUpdate]
                                    .productName.toUpperCase(),
                                'price': num.parse(inputValue),
                                'category': barCodeSearchResultsMap[skuToUpdate]
                                    .productCategory.toUpperCase(),
                                'brand': barCodeSearchResultsMap[skuToUpdate]
                                    .productBrand.toUpperCase(),
                                'imageurl': barCodeSearchResultsMap[skuToUpdate]
                                    .productImageURL,
                                'stockposition': 0,
                                'productStatus': 'ACTIVE',
                                'creationTimeStamp': DateFormat(
                                    'yyyy-mm-dd HHmmss.SSS').format(
                                    DateTime.now()).toString(),
                                'parentStore': inventoryNode,
                                'milliSecondsSinceEpoch': DateTime
                                    .now()
                                    .millisecondsSinceEpoch / 1000
                              }).then((value) {
                                print('Product Added Successfully.');
                                ProductBasicDetails l_productBasicDetails = new ProductBasicDetails(
                                    barCodeSearchResultsMap[skuToUpdate]
                                        .productName.toUpperCase(),
                                    num.parse(inputValue),
                                    nextProductCode,
                                    barCodeSearchResultsMap[skuToUpdate]
                                        .productBarCode,
                                    barCodeSearchResultsMap[skuToUpdate]
                                        .productImageURL,
                                    barCodeSearchResultsMap[skuToUpdate]
                                        .productCategory,
                                    barCodeSearchResultsMap[skuToUpdate]
                                        .productBrand,
                                    'ACTIVE',
                                    barCodeSearchResultsMap[skuToUpdate]
                                        .productParentStore,
                                    barCodeSearchResultsMap[skuToUpdate]
                                        .productCreationTimeStamp
                                );

                                barCodeSearchResultsMap[nextProductCode] = l_productBasicDetails;

                                barCodeSearchResults = List<ProductBasicDetails>();
                                barCodeSearchResultsMap.forEach((key, value) {
                                  barCodeSearchResults.add(value);
                                });
                                Navigator.of(context).pop();
                                Navigator.of(context).push<dynamic>(
                                    MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) {
                                          return InventoryManagerProductNameLookUp();
                                        }
                                    )
                                );
                              });
                            }
                          },
                          child:Text('CONFIRM',
                              style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight:FontWeight.bold,
                                fontSize: 24.0,
                                color:Colors.white,
                              ))
                      ),
                    )
                  ],
                )

            )
        ),
      );

  }
}
