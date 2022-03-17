import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-no-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-category-manager.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-show-all-categories.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-options.dart';


//List<ProductBasicDetails> barCodeSearchResults = List<ProductBasicDetails>();
List<ProductBasicDetails> products = List<ProductBasicDetails>();
String selectedProductName = '';
int selectedProductCode = 0;

class InventoryManagerProductSalePosition extends StatefulWidget {
  @override
  _InventoryManagerProductSalePositionState createState() => _InventoryManagerProductSalePositionState();
}

class _InventoryManagerProductSalePositionState extends State<InventoryManagerProductSalePosition> {
//  TextEditingController lookupTextEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    productSalePositionMap.forEach((int key, dynamic value) {
      productSalePositionList.add(value);
    });

    print(productSalePositionList);
    print(productSalePositionList.length.toString());

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
              return InventoryManagerProductNameLookUp();
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
                return InventoryManagerProductNameLookUp();
              }));
        });
      } else {
        print('Scan Error. Not Camera Access Error');
        setState(() {
//          searchingBarCode = false;
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
//        searchingBarCode = false;
//        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return InventoryManagerProductNameLookUp();
//            }));
      });
    } catch (e) {
      print('Error Caught in Catch Statement');
      setState(() {
//        searchingBarCode = false;
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return InventoryManagerProductNameLookUp();
            }));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    print(productSalePositionMap);


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
                return InventoryManagerProductNameLookUp();
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
                            return InventoryManagerShowAllCategories();
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
//                          productSalePositionTillDateMap = Map<int,double>();
//                          Map<int,double> l_productSalePositionMap = Map<int,double>();
//                          lookupMap = Map<int,ProductBasicDetails>();
//
//                          productSalePositionTillDateMap.forEach((key,value) {
//                            l_productSalePositionMap[key] = value;
////                            lookupMap[value.productID] = value;
//                          });
//
//
//                          l_productSalePositionResults = Map<
//
//                          barCodeSearchResults = List<ProductBasicDetails>();
//                          lookupList = List<ProductBasicDetails>();
//
//                          barCodeSearchResultsMap.forEach((key, value) {
//                            barCodeSearchResults.add(value);
//                            lookupList.add(value);
//                          });
//
//                          barCodeSearchResults.sort((a,b){
//                            return (
//                                a.productName.compareTo(b.productName)
//                            );
//                          });
//
//                          lookupList.sort((a,b){
//                            return (
//                                a.productName.compareTo(b.productName)
//                            );
//                          });
//                          setState(() {
//
//                          });
                        },
                        onChanged: (value){
                          print('value changed:' + value);
                          if(value.isNotEmpty)
                          {
                            lookupText = value;
                            productSalePositionList = new List<dynamic>();
                            productSalePositionMap.forEach((int key, dynamic productSalePosition){
//                              print(productSalePosition['productName'].toString().toLowerCase());
//                              print(value.toString().toLowerCase());
                              if(productSalePosition['productName'].toString().toLowerCase().contains(value.toString().toLowerCase()))
                              {
                                productSalePositionList.add(productSalePosition);
                              }
                          });
                              productSalePositionList.sort((dynamic a,dynamic b){
                                return (
                                    a['productName'].toString().compareTo(b['productName'].toString())
                                );
                              });
                          }
                          else{
                            productSalePositionList = new List<dynamic>();
//                            productSalePositionMap.forEach((int value, dynamic productSalePosition){
//                                productSalePositionList.add(productSalePosition);
//                            });
//
//                            productSalePositionList.sort((dynamic a,dynamic b){
//                              return (
//                                  a['productName'].compareTo(b['productName'])
//                              );
//                            });
                          }
//                          print(productSalePositionList);
                          setState(() {
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex:18,
                    child: ListView.builder(
                        itemCount: productSalePositionList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return
                            Container(
                              padding: EdgeInsets.all(8.0),
                              color:Colors.white,
                              child: RaisedButton(
                                onPressed: ()
                                {
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex:40,
                                      child:
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            productSalePositionList[index]['productName']
                                                .toUpperCase(),
                                            maxLines: 4,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                          Text(
                                            productSalePositionList[index]['productDetails']['productBarCode']
                                                .toUpperCase(),
                                            maxLines: 4,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                          Text(
                                            productSalePositionList[index]['productDetails']['productCode'].toString(),
                                            maxLines: 4,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ],
                                      )

                                    ),
                                    Expanded(
                                      flex:4,
                                      child:Text(
                                        productSalePositionList[index]['productDetails']['productPrice'].toString(),
                                        maxLines: 4,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Montserrat"),
                                      ),
                                    ),
                                    Expanded(
                                      flex:4,
                                      child:  Center(
                                        child: Text(
                                          productSalePositionList[index]['salePosition'].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat"),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:4,
                                      child:  Center(
                                        child: Text(
                                          productSalePositionList[index]['salePosition'].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat"),
                                        ),
                                      ),
                                    ),
                                  ],
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