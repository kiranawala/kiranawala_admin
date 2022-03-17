import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-options.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-show-name-update-error.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';

class ProductUpdateRequestName extends StatefulWidget {
  @override
  _ProductUpdateRequestNameState createState() => _ProductUpdateRequestNameState();
}

class _ProductUpdateRequestNameState extends State<ProductUpdateRequestName> {
  TextEditingController productNameTextController = TextEditingController();
  String inputValue = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productNameTextController.text = barCodeSearchResultsMap[skuToUpdate].productName.toString();
  }

  @override
  Widget build(BuildContext context) {
    {
      return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop(null);
          return;
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.keyboard_backspace),
                tooltip: 'Go Back',
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              title:Text('CHANGE PRODUCT NAME',
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
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      width:MediaQuery.of(context).size.width,
                      child: Text('CHANGE NAME',
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
                            controller: productNameTextController,
                            textCapitalization: TextCapitalization.characters,
                            keyboardType: TextInputType.text,
                            minLines: 3,
                            maxLines: 3,
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
                              inputValue = value;
                            },
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            print('RequestValue:inputValue:' + productNameTextController.text);
                            if(productNameTextController.text != null && productNameTextController.text != '')
                              {
                                Firestore.instance.collection('stores').document('KIRANAWALA_STORE_11').collection('PRODUCTS').document(skuToUpdate.toString()).updateData(<String,dynamic>{'name':productNameTextController.text});

                                FirebaseDatabase
                                    .instance
                                    .reference()
                                    .child('stores')
                                    .child('KIRANAWALA_STORE_11')
                                    .child('products')
                                    .child(skuToUpdate.toString())
                                    .update(<String, String>{
                                  'title':productNameTextController.text
                                }).then((value){
                                  print('PRODUCT NAME UPDATE SUCCESSFUL :' + skuToUpdate.toString());
                                  ProductBasicDetails l_productBasicDetails = new ProductBasicDetails(
                                      productNameTextController.text.toUpperCase(),
                                      barCodeSearchResultsMap[skuToUpdate]
                                          .productPrice,
                                      skuToUpdate,
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

                                  barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
                                  barCodeSearchResultsMap[skuToUpdate] = l_productBasicDetails;

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
                                }).catchError((dynamic error){
                                  print('PRODUCT NAME UPDATE FAILED :' + skuToUpdate.toString());
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push<dynamic>(
                                      MaterialPageRoute<dynamic>(
                                          builder:(BuildContext context){
                                            return ShowNameUpdateError();
                                          }
                                      )
                                  );
                                });
                              }
                          },
                          child: Text('CONFIRM',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.white,
                              ))),
                    )
                  ],
                ))),
      );
    }
  }
}
