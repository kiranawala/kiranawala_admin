import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-no-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-product-request-barcode.dart';

//import 'package:kiranawala_admin/pages/inventory-manager/stock-inward-check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
//import 'package:kiranawala_admin/pages/inventory-manager/stock-inward-product-brand-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-request-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
//import 'package:kiranawala_admin/pages/inventory-manager/stock-inward-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-select-category.dart';
//import 'package:kiranawala_admin/pages/inventory-manager/stock-inward-product-lookup-select-store.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-select-brand.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-show-all-categories.dart';


bool searchingBarCode = true;
String productLookupStore = '';
double salePositionForRequestedProduct = 0.0;
double stockInwardForRequestedProduct = 0.0;
double stockPositionForRequestedProduct = 0.0;

class InventoryManagerAddProductGetBarCode extends StatefulWidget {
  @override
  _InventoryManagerAddProductGetBarCodeState createState() => _InventoryManagerAddProductGetBarCodeState();
}

class _InventoryManagerAddProductGetBarCodeState extends State<InventoryManagerAddProductGetBarCode> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future scan() async {
    setState(() {
      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    try {
      barCodeToSearch = (await BarcodeScanner.scan()).toString();
      print('Scanned BarCode:' + barCodeToSearch);

      print(barCodeToSearch);
      if (barCodeToSearch.length > 0) {
        Navigator.of(context).pop(barCodeToSearch);
      }
      else
      {
        Navigator.of(context).pop('');
      }
    } on PlatformException catch (e) {
      print('Platform Exception');
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        print('Camera Access Denied');
        setState(() {
          searchingBarCode = false;
          Navigator.of(context).pop('');
//          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//              builder:(BuildContext context){
//                return ProductLookUp();
//              }));
        });
      } else {
        print('Scan Error. Not Camera Access Error');
        setState(() {
          searchingBarCode = false;
          Navigator.of(context).pop('');
//          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//              builder:(BuildContext context){
//                return ProductLookUp();
//              }));
        });

      }
    } on FormatException {
      print('Scan Format Exception');
      setState(() {
        searchingBarCode = false;
        Navigator.of(context).pop('');
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return ProductLookUp();
//            }));
      });
    } catch (e) {
      print('Error Caught in Catch Statement');
      setState(() {
        searchingBarCode = false;
        Navigator.of(context).pop('');
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return ProductLookUp();
//            }));
      });
    }
  }

  Future getBarCode() async {

    setState(() {
      searchingBarCode = true;
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
    });

    barCodeToSearch = await Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          return InventoryManagerAddProductRequestBarCode();
        }));
    print(barCodeToSearch);
    if (barCodeToSearch != null && barCodeToSearch.length > 0) {
      Navigator.of(context).pop(barCodeToSearch);
    }
    else
    {
      Navigator.of(context).pop('');
    }
  }

  @override
  Widget build(BuildContext context) {
    {

          return
            WillPopScope(
                onWillPop:(){
                  Navigator.of(context).pop(null);
                  return;
                },
                child:Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                      title: Text(
                        'PRODUCT MANAGER',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            fontFamily: 'Montserrat'),
                      ),
                      leading: IconButton(icon:Icon(Icons.keyboard_backspace),
                          onPressed: (){
                            Navigator.of(context).push<dynamic>(
                              MaterialPageRoute<dynamic>(
                                builder:(BuildContext context){
                                  return InventoryManagerShowAllCategories();
                                }
                              )
                            );
                          }),

                    ),
                    body: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width:MediaQuery.of(context).size.width,
                                padding:EdgeInsets.all(8.0),
                                child:
                                RaisedButton(
                                    color:Colors.grey,
                                    onPressed:(){
                                    },
                                    child:Text('KIRANAWALA_STORE_11',
                                      style:TextStyle(
                                          fontSize: 18.0,
                                          color:Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold
                                      ),)
                                )
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
                                  onPressed: scan,
                                  child: Text('SCAN BARCODE',
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
                                    getBarCode();
                                  },
                                  child: Text('ENTER BARCODE',
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
                          ]),
                    )
                ));
    }
  }
}
