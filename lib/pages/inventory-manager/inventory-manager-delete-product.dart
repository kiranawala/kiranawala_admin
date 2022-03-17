import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode-adding.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-request-name.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-request-price.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-select-product-brand.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-select-product-category.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-product-get-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-deleting-product.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-show-all-categories.dart';

import 'inventory-manager-home-page.dart';

class InventoryManagerDeleteProduct extends StatefulWidget {
  @override
  _InventoryManagerDeleteProductState createState() => _InventoryManagerDeleteProductState();
}

class _InventoryManagerDeleteProductState extends State<InventoryManagerDeleteProduct> {

  @override
  void initState() {
    super.initState();
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
                        return InventoryManagerShowAllCategories();
                      }
                  )
              );
              return;
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text(
                      'DELETE PRODUCT',
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
                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                                return InventoryManagerAddProductGetBarCode();
                              })).then((dynamic value){
                                if(value != null)
                                {
                                  setState(() {
                                    nextBarCode = value.toString();
                                  });
                                }
                              });
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
                            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                              return InventoryManagerAddNewProductRequestName();
                            })).then((dynamic value){
                              if(value != null)
                              {
                                setState(() {
                                  newProductName = value.toString();
                                });
                              }
                            });

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
                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                                return InventoryManagerAddNewProductRequestPrice();
                              })).then((dynamic value){
                                if(value != null)
                                {
                                  setState(() {
                                    newProductPrice = double.parse(value.toString());
                                  });
                                }
                              });
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
                            // Navigator.of(context).pop();
                            Navigator.of(context).push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) {
                                      return InventoryManagerAddNewProductSelectProductCategory();
                                    })).then((dynamic value) {
                              {
                                print(value);
                                if (value != null)
                                  setState(() {
                                    selectedCategoryName = value.toString();
                                  });
                              }
                            });
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
                            Navigator.of(context).push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) {
                                      return InventoryManagerAddNewProductSelectProductBrand();
                                    })).then((dynamic value) {
                              print(value.toString());
                              if (value != null) {
                                setState(() {
                                  selectedBrandName = value.toString();
                                });
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            'DELETE PRODUCT',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push<dynamic>(
                                    MaterialPageRoute<dynamic>(
                                        builder:(BuildContext context){
                                          return InventoryManagerDeletingProduct();
                                        }
                                    )
                                );
                          },
                        ),
                      ),
                    ])));
  }
}
