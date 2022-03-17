import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode-adding.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-request-name.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-request-price.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-select-product-brand.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-select-product-category.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-product-get-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-show-all-categories.dart';

import 'inventory-manager-home-page.dart';

class InventoryManagerAddNewProductWithBarcode extends StatefulWidget {
  @override
  _InventoryManagerAddNewProductWithBarcodeState createState() => _InventoryManagerAddNewProductWithBarcodeState();
}

class _InventoryManagerAddNewProductWithBarcodeState extends State<InventoryManagerAddNewProductWithBarcode> {
   bool nextProductCodeAvailable = false;

  String generateBarCode(String code) {
    int checkSum = this.checkSum(code);
    return code + '' + checkSum.toString();
  }

  int checkSum(String productCode) {
    int sum = 0;

    int N1 = int.parse(productCode.substring(0, 1));
    int N2 = int.parse(productCode.substring(1, 2));
    int N3 = int.parse(productCode.substring(2, 3));
    int N4 = int.parse(productCode.substring(3, 4));
    int N5 = int.parse(productCode.substring(4, 5));
    int N6 = int.parse(productCode.substring(5, 6));
    int N7 = int.parse(productCode.substring(6, 7));
    int N8 = int.parse(productCode.substring(7, 8));
    int N9 = int.parse(productCode.substring(8, 9));
    int N10 = int.parse(productCode.substring(9, 10));
    int N11 = int.parse(productCode.substring(10, 11));
    int N12 = int.parse(productCode.substring(11, 12));

    sum = N1 +
        N2 * 3 +
        N3 +
        N4 * 3 +
        N5 +
        N6 * 3 +
        N7 +
        N8 * 3 +
        N9 +
        N10 * 3 +
        N11 +
        N12 * 3;

    double div = (sum * 1.0) / 10;
    int ceilDiv = div.ceil();
    int checkSum = (ceilDiv * 10) - sum;
    return checkSum;
  }

  String selectedCategoryName = 'NOCATEGORY';
  String selectedBrandName = 'NOBRAND';

  @override
  void initState() {
    super.initState();
    nextBarCode = 'GET BARCODE';
    selectedBrandName = 'NOBRAND';
    selectedCategoryName = 'NOCATEGORY';
    newProductPrice = 1.0;
    newProductName = 'PRODUCT NAME';
    getNextProductCode();
  }


   void getNextProductCode() async {
     this.nextProductCodeAvailable = false;
     nextProductCode = nextProductCode = num.parse(DateFormat('yyMMddHHmmss').format(DateTime.now()));;
     setState(() {
       this.nextProductCodeAvailable = true;
     });
       }

  @override
  Widget build(BuildContext context) {
    if (nextProductCodeAvailable)
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
                            'ADD PRODUCT',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          onPressed: () {
                            if (nextBarCode != 'GET BARCODE' && nextBarCode != '' && newProductName != '' &&
                                newProductPrice != '') {
                              if(newProductPrice > 0)
                              {
                                Navigator.of(context).pop();
                                Navigator.of(context).push<dynamic>(
                                  MaterialPageRoute<dynamic>(
                                    builder:(BuildContext context){
                                      return InventoryManagerAddNewProductWithBarcodeAdding();
                                    }
                                  )
                                );
                              }
                              else
                              {
                                print('Invalid Price!!');
                              }
                            }
                            else
                            {
                              print('Invalid Price/Name');
                            }
                          },
                        ),
                      ),
                    ])));
    else {
      return
        WillPopScope(
            onWillPop:(){
              setState(() {
                Navigator.of(context).pop();
              });

              return;
            },
            child:Scaffold(
                appBar: AppBar(
                  title: Text('Add New Product'),
                ),
                body: Container(
                  color: Colors.white,
                  child: Dialog(
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(flex: 2, child: new CircularProgressIndicator()),
                        SizedBox(width: 10.0),
                        Expanded(flex: 12, child: Text("Loading Details.......")),
                      ],
                    ),
                  ),
                )));
    }
  }
}
