import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/online-product-lookup.dart';

import 'online-product-lookup-results.dart';

bool changeName = false;
bool changePrice = false;
bool changeStatus = false;
bool changeCategory = false;
bool changeBrand = false;
bool changeDiscountDetails = false;
bool showOptions = true;

class OnlineProductLookupOptions extends StatefulWidget {
  @override
  _OnlineProductLookupOptionsState createState() => _OnlineProductLookupOptionsState();
}

class _OnlineProductLookupOptionsState extends State<OnlineProductLookupOptions> {

  TextEditingController productNameTextController = TextEditingController();
  TextEditingController productPriceTextController = TextEditingController();
  TextEditingController stockInwardTextController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productNameTextController.text = barCodeSearchResultsMap[skuToUpdate].productName.toString();
    productPriceTextController.text = barCodeSearchResultsMap[skuToUpdate].productPrice.toString();
    print(skuToUpdate);
    print(barCodeSearchResultsMap.length.toString());
  }
  @override
  Widget build(BuildContext context) {
//    if(showOptions)
    return Container(
      height:MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:Text('BARCODE',
//                    style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 18.0,
//                        fontWeight: FontWeight.bold,
//                        fontFamily: "Montserrat"),),
//                ),
//                Expanded(
//                    child:Text(barCodeSearchResultsMap[skuToUpdate].productBarCode.toString(),
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 18.0,
//                          fontWeight: FontWeight.bold,
//                          fontFamily: "Montserrat"),)
//                )
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:Text('SKU',
//                    style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 18.0,
//                        fontWeight: FontWeight.bold,
//                        fontFamily: "Montserrat"),),
//                ),
//                Expanded(
//                    child:Text(barCodeSearchResultsMap[skuToUpdate].productID.toString(),
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 18.0,
//                          fontWeight: FontWeight.bold,
//                          fontFamily: "Montserrat"),)
//                )
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
//                      productNameTextController.text = barCodeSearchResultsMap[skuToUpdate].productName.toString();
//                      changeNameDialog();
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            barCodeSearchResultsMap[skuToUpdate].productName.toString(),
//                            maxLines: 3,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                    child:Text('PRICE',
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 18.0,
//                          fontWeight: FontWeight.bold,
//                          fontFamily: "Montserrat"),)
//                ),
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
//                      changePriceDialog();
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:Text('BRAND',
//                    style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 18.0,
//                        fontWeight: FontWeight.bold,
//                        fontFamily: "Montserrat"),),
//                ),
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
//                      changeBrandDialog();
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            barCodeSearchResultsMap[skuToUpdate].productBrand.toString(),
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:Text('CATEGORY',
//                    style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 18.0,
//                        fontWeight: FontWeight.bold,
//                        fontFamily: "Montserrat"),),
//                ),
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
//                      changeCategoryDialog();
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            barCodeSearchResultsMap[skuToUpdate].productCategory.toString(),
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:Text('STATUS',
//                    style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 18.0,
//                        fontWeight: FontWeight.bold,
//                        fontFamily: "Montserrat"),),
//                ),
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
//                      changeStatusDialog();
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            barCodeSearchResultsMap[skuToUpdate].productStatus.toString(),
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:Text('STOCK POSITION',
//                    style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 18.0,
//                        fontWeight: FontWeight.bold,
//                        fontFamily: "Montserrat"),),
//                ),
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
////                      changePriceDialog();
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            'IN-STOCK',
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
////                      changePriceDialog();
//
//                      newProductName = barCodeSearchResultsMap[skuToUpdate].productName.toString();
//                      newProductPrice = 1.0;
//                      selectedBrandName = barCodeSearchResultsMap[skuToUpdate].productBrand.toString();
//                      selectedCategoryName = barCodeSearchResultsMap[skuToUpdate].productCategory.toString();
//                      selectedImageURL = barCodeSearchResultsMap[skuToUpdate].productImageURL.toString();
//                      nextBarCode = barCodeSearchResultsMap[skuToUpdate].productBarCode.toString();
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                          builder:(BuildContext context){
//                            return InventoryManagerCreateDuplicate();
//                          }
//                      ));
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            'CREATE DUPLICATE',
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
////                      changePriceDialog();
//
//                      newProductName = barCodeSearchResultsMap[skuToUpdate].productName.toString();
//                      newProductPrice = 1.0;
//                      selectedBrandName = barCodeSearchResultsMap[skuToUpdate].productBrand.toString();
//                      selectedCategoryName = barCodeSearchResultsMap[skuToUpdate].productCategory.toString();
//                      selectedImageURL = barCodeSearchResultsMap[skuToUpdate].productImageURL.toString();
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                          builder:(BuildContext context){
//                            return InventoryManagerCloneWithBarcode();
//                          }
//                      ));
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            'CLONE WITH BARCODE',
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
////                      changePriceDialog();
//
//                      newProductName = barCodeSearchResultsMap[skuToUpdate].productName.toString();
//                      newProductPrice = 1.0;
//                      selectedBrandName = barCodeSearchResultsMap[skuToUpdate].productBrand.toString();
//                      selectedCategoryName = barCodeSearchResultsMap[skuToUpdate].productCategory.toString();
//                      selectedImageURL = barCodeSearchResultsMap[skuToUpdate].productImageURL.toString();
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                          builder:(BuildContext context){
//                            return InventoryManagerCloneWithoutBarcode();
//                          }
//                      ));
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            'CLONE WITHOUT BARCODE',
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child:GestureDetector(
//                    onTap: (){
//                      newProductName = barCodeSearchResultsMap[skuToUpdate].productName.toString();
//                      newProductPrice = 1.0;
//                      selectedBrandName = barCodeSearchResultsMap[skuToUpdate].productBrand.toString();
//                      selectedCategoryName = barCodeSearchResultsMap[skuToUpdate].productCategory.toString();
//                      selectedImageURL = barCodeSearchResultsMap[skuToUpdate].productImageURL.toString();
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                          builder:(BuildContext context){
//                            return RetrieveStockInwardOutwardBetweenDates();
//                          }
//                      ));
//                    },
//                    child:Padding(
//                      padding: const EdgeInsets.all(2.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            'PRODUCT STOCK POSITION',
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
            Row(
              children: <Widget>[
                Expanded(
                  child:GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      overwriteStockPosition();
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height:60.0,
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            'OVERWRITE STOCK POSITION',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child:GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      stockInward();
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 60.0,
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            'ADD STOCK INWARD',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child:GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(builder: (BuildContext context){
                            return showStockInwardInvoiceList();
                          }));
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 60.0,
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            'INWARD HISTORY',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child:GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(builder: (BuildContext context){
                            return showStockOutwardInvoiceList();
                          }));
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 60.0,
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            'OUTWARD HISTORY',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Montserrat"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child: GestureDetector(
//                    onTap: (){
////                      Navigator.of(context).pop();
//                      changePriceDialog();
//                    },
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            'PRICE',
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 24.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//                Expanded(
//                  child: GestureDetector(
//                    onTap: (){
//                      changeStatusDialog();
//                    },
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            'STATUS',
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 24.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
////                Expanded(
////                  child: GestureDetector(
////                    onTap: (){
//////                        changeDiscountDetails();
////                    },
////                    child: Padding(
////                      padding: const EdgeInsets.all(8.0),
////                      child: Container(
////                        decoration:BoxDecoration(
////                            color:Colors.green,
////                            border:Border.all(color:Colors.black26),
////                            borderRadius: BorderRadius.all(Radius.circular(5.0))
////                        ),
////                        child: Center(
////                          child: Text(
////                            'DISCOUNT',
////                            maxLines: 2,
////                            textAlign: TextAlign.center,
////                            style: TextStyle(
////                                color: Colors.white,
////                                fontSize: 24.0,
////                                fontWeight: FontWeight.bold,
////                                fontFamily: "Montserrat"),
////                          ),
////                        ),
////                      ),
////                    ),
////                  ),
////                ),
//                Expanded(
//                  child: GestureDetector(
//                    onTap: (){
//                      changeNameDialog();
//                    },
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            'NAME',
//                            maxLines: 3,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Expanded(
//                  child: GestureDetector(
//                    onTap: (){
//                      changeCategoryDialog();
//                    },
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            border:Border.all(color:Colors.black26),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            barCodeSearchResultsMap[skuToUpdate].productCategory,
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 18.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//                Expanded(
//                  child: GestureDetector(
//                    onTap: (){
//                      changeBrandDialog();
//                    },
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Container(
//                        decoration:BoxDecoration(
//                            color:Colors.green,
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
//                        child: Center(
//                          child: Text(
//                            barCodeSearchResultsMap[skuToUpdate].productBrand,
//                            maxLines: 2,
//                            textAlign: TextAlign.center,
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontSize: 24.0,
//                                fontWeight: FontWeight.bold,
//                                fontFamily: "Montserrat"),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
          ]),
    );
  }

  Future<void> changePriceDialog() {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('NEW PRICE'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                    width:MediaQuery.of(context).size.width,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              child: TextField(
                                controller: productPriceTextController,
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
                                },
                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                              color:Colors.blue,
                              onPressed:() {
                                bool priceAlreadyAvailable = false;
                                num nextProductCode = 0;
                                int existingSKUWithRequiredPrice;
                                List<int> existingSKUs = List<int>();
                                print('New Price:' + productPriceTextController.text.toString());
                                var newPrice = num.parse(productPriceTextController.text.toString());
                                if (productPriceTextController.text != null && newPrice > 0) {
                                  fullProductBasicDetailsMap.forEach((key, value) {
                                    if (value.productBarCode.toString() == barCodeSearchResultsMap[skuToUpdate].productBarCode.toString()) {
                                      existingSKUs.add(value.productID);
                                      if (value.productPrice == newPrice) {
                                        priceAlreadyAvailable = true;
                                        existingSKUWithRequiredPrice = value.productID;
                                      }
                                    }
                                  });
                                  print(existingSKUs);
                                  if (priceAlreadyAvailable) {
                                    print('EXISTING SKU WITH REQUIRED PRICE:' + existingSKUWithRequiredPrice.toString());
                                    existingSKUs.forEach((existingSKU) {
                                      if (existingSKU != existingSKUWithRequiredPrice) {
                                        fullProductBasicDetailsMap[existingSKU].productStatus = 'INACTIVE';
                                        if (barCodeSearchResultsMap.containsKey(existingSKU)) {
                                          barCodeSearchResultsMap[existingSKU].productStatus = 'INACTIVE';
                                          barCodeSearchResultsMap.remove(existingSKU);
                                        }

                                        FirebaseDatabase
                                            .instance
                                            .reference()
                                            .child('stores')
                                            .child(productNode)
                                            .child('products')
                                            .child(existingSKU.toString())
                                            .child('productStatus')
                                            .set('INACTIVE');
                                      }
                                      else
                                      {
                                        fullProductBasicDetailsMap[existingSKU].productStatus = 'ACTIVE';
                                        if (barCodeSearchResultsMap.containsKey(existingSKU)) {
                                          barCodeSearchResultsMap[existingSKU].productStatus = 'ACTIVE';
                                        }
                                        else
                                        {
                                          barCodeSearchResultsMap[existingSKU] = fullProductBasicDetailsMap[existingSKU];
                                          barCodeSearchResultsMap[existingSKU].productStatus = 'ACTIVE';
                                        }
                                        FirebaseDatabase
                                            .instance
                                            .reference()
                                            .child('stores')
                                            .child(productNode)
                                            .child('products')
                                            .child(existingSKU.toString())
                                            .child('productStatus')
                                            .set('ACTIVE');
                                      }
                                    });

                                    barCodeSearchResults = List<ProductBasicDetails>();
                                    barCodeSearchResultsMap.forEach((key, value) {
                                      barCodeSearchResults.add(value);
                                    });

                                    barCodeSearchResults.sort((a,b){
                                      return (
                                          a.productName.compareTo(b.productName)
                                      );
                                    });

                                    lookupMap = Map<int,ProductBasicDetails>();

                                    fullProductBasicDetailsMap.forEach((key,value) {
                                      if(value.productStatus == 'ACTIVE')
                                      {
                                        lookupMap[value.productID] = value;
                                      }
                                    });

                                    lookupList = List<ProductBasicDetails>();

                                    lookupMap.forEach((key, value) {
                                      lookupList.add(value);
                                    });

                                    lookupList.sort((a,b){
                                      return (
                                          a.productName.compareTo(b.productName)
                                      );
                                    });


                                    skuToUpdate = existingSKUWithRequiredPrice;
                                    Navigator.of(context).pop();
                                  }
                                  else {

                                    print('PRICE NOT ALREADY AVAILABLE:' + newPrice.toString());
                                    FirebaseDatabase
                                        .instance
                                        .reference()
                                        .child('stores')
                                        .child('KIRANAWALA_MASTER')
                                        .child('lastProductCode')
                                        .runTransaction((mutableData) async {
                                      print('initState:mutabledata');
                                      print(mutableData);
                                      print(mutableData.value);
                                      if (mutableData != null &&
                                          mutableData.value != null) {
                                        nextProductCode = mutableData.value + 1;
                                        print(nextProductCode);
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child('stores')
                                            .child(productNode)
                                            .child('products')
                                            .child(nextProductCode.toString())
                                            .update(<String, dynamic>{
                                          'barcode': barCodeSearchResultsMap[skuToUpdate]
                                              .productBarCode.toString(),
                                          'productcode': nextProductCode,
                                          'title': barCodeSearchResultsMap[skuToUpdate]
                                              .productName.toUpperCase(),
                                          'price': newPrice,
                                          'category': barCodeSearchResultsMap[skuToUpdate]
                                              .productCategory.toUpperCase(),
                                          'brand': barCodeSearchResultsMap[skuToUpdate]
                                              .productBrand.toUpperCase(),
                                          'imageurl':barCodeSearchResultsMap[skuToUpdate].productImageURL,
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

                                          barCodeSearchResultsMap[nextProductCode] =
                                              ProductBasicDetails(
                                                  barCodeSearchResultsMap[skuToUpdate]
                                                      .productName.toUpperCase(),
                                                  newPrice,
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


                                          activeProductBasicDetailsMap[nextProductCode] =
                                              ProductBasicDetails(
                                                  barCodeSearchResultsMap[skuToUpdate]
                                                      .productName.toUpperCase(),
                                                  newPrice,
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

                                          fullProductBasicDetailsMap[nextProductCode] =
                                              ProductBasicDetails(
                                                  barCodeSearchResultsMap[skuToUpdate]
                                                      .productName.toUpperCase(),
                                                  newPrice,
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

                                          existingSKUs.forEach((existingSKU) {
                                            if(barCodeSearchResultsMap.containsKey(existingSKU)){
                                              barCodeSearchResultsMap[existingSKU].productStatus = 'INACTIVE';
                                              barCodeSearchResultsMap.remove(existingSKU);
                                            }
                                            fullProductBasicDetailsMap[existingSKU].productStatus = 'INACTIVE';
                                            FirebaseDatabase
                                                .instance
                                                .reference()
                                                .child('stores')
                                                .child(productNode)
                                                .child('products')
                                                .child(existingSKU.toString())
                                                .child('productStatus')
                                                .set('INACTIVE');
                                          });

                                          barCodeSearchResults = List<ProductBasicDetails>();
                                          barCodeSearchResultsMap.forEach((key, value) {
                                            barCodeSearchResults.add(value);
                                          });

                                          barCodeSearchResults.sort((a,b){
                                            return (
                                                a.productName.compareTo(b.productName)
                                            );
                                          });

                                          lookupMap = Map<int,ProductBasicDetails>();

                                          fullProductBasicDetailsMap.forEach((key,value) {
                                            if(value.productStatus == 'ACTIVE')
                                            {
                                              lookupMap[value.productID] = value;
                                            }
                                          });

                                          lookupList = List<ProductBasicDetails>();

                                          lookupMap.forEach((key, value) {
                                            lookupList.add(value);
                                          });

                                          lookupList.sort((a,b){
                                            return (
                                                a.productName.compareTo(b.productName)
                                            );
                                          });

                                          skuToUpdate = nextProductCode;
                                          Navigator.of(context).pop();
                                        });
                                      }
                                      mutableData.value =
                                          (mutableData.value ?? 0) + 1;
                                      return mutableData;
                                    });
                                  }
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
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                              color:Colors.blue,
                              onPressed:() {
                                Navigator.of(context).pop();
                              },
                              child:Text('CANCEL',
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
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> changeNameDialog() {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('CHANGE NAME'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: TextField(
                    controller: productNameTextController,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    minLines: 4,
                    maxLines: 4,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                    autofocus: true,
                    textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    cursorWidth: 8.0,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                    onChanged: (value) {
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Ok'),
              onPressed: () {
                if(productNameTextController.text != null && productNameTextController.text != '') {
                  showOptions = true;
                  changeName = false;
                  changePrice = false;
                  changeStatus = false;
                  changeCategory = false;
                  changeBrand = false;
                  changeDiscountDetails = false;
                  FirebaseDatabase
                      .instance
                      .reference()
                      .child('stores')
                      .child(productNode)
                      .child('products')
                      .child(skuToUpdate.toString())
                      .update(<String, String>{
                    'title':productNameTextController.text
                  }).then((value){
                    print('PRODUCT NAME UPDATE SUCCESSFUL :' + skuToUpdate.toString());
                    barCodeSearchResultsMap[skuToUpdate].productName = productNameTextController.text;
                    fullProductBasicDetailsMap[skuToUpdate].productName = productNameTextController.text;

                    barCodeSearchResults = List<ProductBasicDetails>();
                    barCodeSearchResultsMap.forEach((key, value) {
                      barCodeSearchResults.add(value);
                    });

                    barCodeSearchResults.sort((a,b){
                      return (
                          a.productName.compareTo(b.productName)
                      );
                    });

                    lookupMap = Map<int,ProductBasicDetails>();
                    lookupList = List<ProductBasicDetails>();

                    fullProductBasicDetailsMap.forEach((key,value) {
                      if(value.productStatus == 'ACTIVE')
                      {
                        lookupMap[value.productID] = value;
                      }
                    });

                    lookupMap.forEach((key, value) {
                      lookupList.add(value);
                    });

                    lookupList.sort((a,b){
                      return (
                          a.productName.compareTo(b.productName)
                      );
                    });

                    Navigator.of(context).pop();
                  }).catchError((dynamic error){
                    print('PRODUCT NAME UPDATE FAILED :' + skuToUpdate.toString());
                    Navigator.of(context).pop();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> overwriteStockPosition() {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('NEW INWARD QTY'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                    width:MediaQuery.of(context).size.width,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              child: TextField(
                                controller: stockInwardTextController,
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
                                },
                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                              color:Colors.blue,
                              onPressed:() {
                                print('New Price:' + stockInwardTextController.text.toString());
                                var newStockInward = double.parse(stockInwardTextController.text.toString());
                                if (stockInwardTextController.text != null && newStockInward >= 0) {
                                  recentStockInwardTime =
                                      DateFormat('HHmmss').format(
                                          DateTime.now()).toString();
                                  recentStockInwardDate =
                                      DateFormat('ddMMyyyy').format(
                                          DateTime.now()).toString();
                                  recentStockInwardInvoiceId =
                                      DateFormat('ddMMyyyyHHmmss').format(
                                          DateTime.now()).toString();
                                  recentStockInwardQty = newStockInward;
                                  stockInwardTillDate = newStockInward;

                                  FirebaseDatabase
                                      .instance
                                      .reference()
                                      .child('stores')
                                      .child('KIRANAWALA_STORE_11')
                                      .child('products')
                                      .child(skuToUpdate.toString())
                                      .child('stockOutwards')
                                      .remove()
                                      .then((value) {
                                    print('STOCK OUTWARDS RESET SUCCESSFUL:' +
                                        skuToUpdate.toString());
                                    stockOutwardTillDate = 0;
                                    recentStockOutwardQty = 0;
                                    recentStockOutwardDate = 'N/A';
                                    recentStockOutwardTime = 'N/A';

                                    FirebaseDatabase
                                        .instance
                                        .reference()
                                        .child('stores')
                                        .child('KIRANAWALA_STORE_11')
                                        .child('products')
                                        .child(skuToUpdate.toString())
                                        .child('stockInwards')
                                        .remove()
                                        .then((value) {
                                      print('STOCK INWARDS RESET SUCCESSFUL:' +
                                          skuToUpdate.toString());
                                      FirebaseDatabase.instance
                                          .reference()
                                          .child('stores')
                                          .child('KIRANAWALA_STORE_11')
                                          .child('products')
                                          .child(skuToUpdate.toString())
                                          .child('stockInwards')
                                          .child('invoices')
                                          .child(
                                          DateFormat('ddMMyyyyHHmmss').format(
                                              DateTime.now()).toString())
                                          .update(<String, dynamic>
                                      {
                                        'qty': recentStockInwardQty,
                                        'mode': 'Manual',
                                        'invoiceId': recentStockInwardInvoiceId,
                                        'date': recentStockInwardDate,
                                        'time': recentStockInwardTime,
                                        'timeStamp':DateTime.now().toString()
                                      }).then((value) {
                                        print(
                                            'Stock Inward Updated Successfully.');
                                      });

                                      FirebaseDatabase.instance
                                          .reference()
                                          .child('stores')
                                          .child('KIRANAWALA_STORE_11')
                                          .child('products')
                                          .child(skuToUpdate.toString())
                                          .child('stockInwards')
                                          .child(DateFormat('yyyy').format(
                                          DateTime.now()).toString())
                                          .child(DateFormat('MM')
                                          .format(DateTime.now())
                                          .toString())
                                          .child(DateFormat('dd')
                                          .format(DateTime.now())
                                          .toString())
                                          .set(<String, dynamic>
                                      {
                                        'invoiceId': DateFormat('ddMMyyyy')
                                            .format(DateTime.now())
                                            .toString(),
                                        'qty': recentStockInwardQty,
                                      }).then((value) {
                                        print(
                                            'Stock Inward Updated Successfully.');
                                      });
                                      FirebaseDatabase.instance
                                          .reference()
                                          .child('stores')
                                          .child('KIRANAWALA_STORE_11')
                                          .child('products')
                                          .child(skuToUpdate.toString())
                                          .child('stockInwards')
                                          .update(<String, dynamic>
                                      {
                                        'recentStockInwardTime': recentStockInwardTime,
                                        'recentStockInwardDate': recentStockInwardDate,
                                        'recentStockInwardInvoiceId': recentStockInwardInvoiceId,
                                        'recentStockInwardQty': recentStockInwardQty,
                                        'stockInwardTillDate': stockInwardTillDate
                                      }).then((value) {
                                        print(
                                            'Stock Inward Updated Successfully.');
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context){
                                            return ProductLookupResultsOnline();
                                          }
                                        ));
                                      }).catchError((dynamic error) {
                                        productUpdateStatus = 'FAILURE';
                                        print('STOCK INWARD UPDATE FAILED:' +
                                            skuToUpdate.toString());
                                      });
                                    }).catchError((dynamic error) {
                                      productUpdateStatus = 'FAILURE';
                                      print('STOCK INWARD RESET FAILED:' +
                                          skuToUpdate.toString());
                                    });
                                  }).catchError((dynamic error) {
                                    productUpdateStatus = 'FAILURE';
                                    print('STOCK OUTWARD RESET FAILED:' +
                                        skuToUpdate.toString());
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
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                              color:Colors.blue,
                              onPressed:() {
                                Navigator.of(context).pop();
                              },
                              child:Text('CANCEL',
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
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> stockInward() {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('NEW INWARD QTY'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                    width:MediaQuery.of(context).size.width,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              child: TextField(
                                controller: stockInwardTextController,
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
                                },
                              ),
                            ),
                          ],
                        ),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                              color:Colors.blue,
                              onPressed:() {
                                print('New Price:' + stockInwardTextController.text.toString());
                                var newStockInward = double.parse(stockInwardTextController.text.toString());
                                if (stockInwardTextController.text != null && newStockInward >= 0) {
                                  recentStockInwardTime = DateFormat('HH:mm:ss').format(DateTime.now()).toString();
                                  recentStockInwardDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
                                  recentStockInwardInvoiceId = DateFormat('ddMMyyyyHHmmss').format(DateTime.now()).toString();
                                  recentStockInwardQty = newStockInward;
                                  FirebaseDatabase.instance
                                      .reference()
                                      .child('stores')
                                      .child('KIRANAWALA_STORE_11')
                                      .child('products')
                                      .child(skuToUpdate.toString())
                                      .child('stockInwards')
                                      .child('stockInwardTillDate')
                                      .once()
                                      .then((stockInwardTillDateSnapshot) {
                                    stockInwardTillDate = 0;
                                    if (stockInwardTillDateSnapshot != null &&
                                        stockInwardTillDateSnapshot.value !=
                                            null) {
                                      print(stockInwardTillDateSnapshot.value);
                                      stockInwardTillDate =
                                          double.parse(stockInwardTillDateSnapshot.value.toString());
                                      print(stockInwardTillDate);
                                    }
                                    stockInwardTillDate = stockInwardTillDate +
                                        recentStockInwardQty;

                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('stores')
                                        .child('KIRANAWALA_STORE_11')
                                        .child('products')
                                        .child(skuToUpdate.toString())
                                        .child('stockInwards')
                                        .child('invoices')
                                        .child(
                                        DateFormat('ddMMyyyyHHmmss').format(
                                            DateTime.now()).toString())
                                        .update(<String, dynamic>
                                    {
                                      'qty': recentStockInwardQty,
                                      'mode': 'Manual',
                                      'invoiceId': recentStockInwardInvoiceId,
                                      'date': recentStockInwardDate,
                                      'time': recentStockInwardTime,
                                      'timeStamp':DateTime.now().toString()
                                    }).then((value) {
                                      print(
                                          'Stock Inward Updated Successfully.');
                                    });

                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('stores')
                                        .child('KIRANAWALA_STORE_11')
                                        .child('products')
                                        .child(skuToUpdate.toString())
                                        .child('stockInwards')
                                        .child(DateFormat('yyyy').format(
                                        DateTime.now()).toString())
                                        .child(DateFormat('MM')
                                        .format(DateTime.now())
                                        .toString())
                                        .child(DateFormat('dd')
                                        .format(DateTime.now())
                                        .toString())
                                        .set(<String, dynamic>
                                    {
                                      'invoiceId': DateFormat('ddMMyyyyHHmmss')
                                          .format(DateTime.now())
                                          .toString(),
                                      'qty': recentStockInwardQty,
                                    }).then((value) {
                                      print(
                                          'Stock Inward Updated Successfully.');
                                    });
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('stores')
                                        .child('KIRANAWALA_STORE_11')
                                        .child('products')
                                        .child(skuToUpdate.toString())
                                        .child('stockInwards')
                                        .update(<String, dynamic>
                                    {
                                      'recentStockInwardTime': recentStockInwardTime,
                                      'recentStockInwardDate': recentStockInwardDate,
                                      'recentStockInwardInvoiceId': recentStockInwardInvoiceId,
                                      'recentStockInwardQty': recentStockInwardQty,
                                      'stockInwardTillDate': stockInwardTillDate
                                    }).then((value) {
                                      print(
                                          'Stock Inward Updated Successfully.');
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push<dynamic>(
                                        MaterialPageRoute<dynamic>(
                                            builder: (BuildContext context){
                                              return ProductLookupResultsOnline();
                                            }
                                        )
                                      );
                                    }).catchError((dynamic error) {
                                      productUpdateStatus = 'FAILURE';
                                      print('STOCK INWARD UPDATE FAILED:' +
                                          skuToUpdate.toString());
                                    });
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
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                              color:Colors.blue,
                              onPressed:() {
                                Navigator.of(context).pop();
                              },
                              child:Text('CANCEL',
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
              ],
            ),
          ),
        );
      },
    );
  }
//  Future<void> showStockInwardInvoiceList(){
//    return showDialog<void>(
//        barrierDismissible: false,
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            title: const Text('NEW INWARD QTY'),
//            content: SingleChildScrollView(
//              child: ListView.builder(
//                itemBuilder: (BuildContext context, int index){
//                  return Text(
//                      stockInwardInvoiceList.values.length.toString()
//                  );
//                },
//                itemCount:stockInwardInvoiceList.values.length,
//              ),
//            ),
//          );
//  });
//  }
  Future<void> changeBrandDialog() {
    brandSearchResults = productBrands;
    selectedBrand = 'NOBRAND';
    print(brands.length);
    print(brandSearchResults.length);
    return
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (context, setState)
                {
                  return AlertDialog(
                    title: Text('SELECT BRAND'),
                    content:
                    Column(
                        children: <Widget>[
                          TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: 'Search Brand...',
                                hintStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize:24.0,
                                    fontWeight: FontWeight.bold,
                                    color:Colors.black
                                )
                            ),
                            onChanged: (value){
                              if(value.isNotEmpty)
                              {
                                brandSearchResults = [];
                                productBrands.forEach((brand){
                                  if(brand.toLowerCase().contains(value.toLowerCase()))
                                  {
                                    brandSearchResults.add(brand);
                                  }
                                });
                              }
                              else
                              {
                                brandSearchResults = productBrands;
                              }
                              setState(() {

                              });
                            },
                          ),
                          Container(
                            height:250,
                            width:MediaQuery.of(context).size.width,
                            child:
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: brandSearchResults.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FlatButton(
                                    color: Colors.blue,
                                    child: Text(
                                        brandSearchResults[index],
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        )),
                                    onPressed: () {
                                      selectedBrand =
                                          brandSearchResults[index];
                                      print(selectedBrand);
                                      FirebaseDatabase
                                          .instance
                                          .reference()
                                          .child('stores')
                                          .child(productNode)
                                          .child('products')
                                          .child(skuToUpdate.toString())
                                          .update(<String, String>{
                                        'brand':selectedBrand.toString()
                                      }
                                      ).then((value){
                                        print('BRAND UPDATE SUCCESSFUL:' + skuToUpdate.toString());
                                        productUpdateStatus = 'SUCCESS';
                                        barCodeSearchResultsMap[skuToUpdate].productBrand = selectedBrand;

                                        barCodeSearchResults = List<ProductBasicDetails>();
                                        barCodeSearchResultsMap.forEach((key, value) {
                                          barCodeSearchResults.add(value);
                                        });

                                        barCodeSearchResults.sort((a,b){
                                          return (
                                              a.productName.compareTo(b.productName)
                                          );
                                        });

                                        lookupMap = Map<int,ProductBasicDetails>();
                                        lookupList = List<ProductBasicDetails>();

                                        fullProductBasicDetailsMap.forEach((key,value) {
                                          if(value.productStatus == 'ACTIVE')
                                          {
                                            lookupMap[value.productID] = value;
                                          }
                                        });

                                        lookupMap.forEach((key, value) {
                                          lookupList.add(value);
                                        });

                                        lookupList.sort((a,b){
                                          return (
                                              a.productName.compareTo(b.productName)
                                          );
                                        });
                                        Navigator.of(context).pop();
                                      }).catchError((dynamic error){
                                        productUpdateStatus = 'FAILURE';
                                        print('BRAND UPDATE FAILED:' + skuToUpdate.toString());

                                        barCodeSearchResults = List<ProductBasicDetails>();
                                        barCodeSearchResultsMap.forEach((key, value) {
                                          barCodeSearchResults.add(value);
                                        });

                                        barCodeSearchResults.sort((a,b){
                                          return (
                                              a.productName.compareTo(b.productName)
                                          );
                                        });

                                        lookupMap = Map<int,ProductBasicDetails>();
                                        lookupList = List<ProductBasicDetails>();

                                        fullProductBasicDetailsMap.forEach((key,value) {
//                                          if(value.productStatus == 'ACTIVE')
//                                          {
                                          lookupMap[value.productID] = value;
//                                          }
                                        });

                                        lookupMap.forEach((key, value) {
                                          lookupList.add(value);
                                        });

                                        lookupList.sort((a,b){
                                          return (
                                              a.productName.compareTo(b.productName)
                                          );
                                        });

                                        Navigator.of(context).pop();
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ]
                    ),
                  );
                });
          }
      );
  }
}

class showStockInwardInvoiceList extends StatefulWidget {
  @override
  _showStockInwardInvoiceListState createState() => _showStockInwardInvoiceListState();
}

class _showStockInwardInvoiceListState extends State<showStockInwardInvoiceList> {
  @override
  Widget build(BuildContext context) {
    stockInwardInvoiceHistory.clear();

    stockInwardInvoiceList.forEach((dynamic key, dynamic value) {
        print(key);
        print(value);
        stockInwardInvoiceHistory.add(value);
    });
    print(stockInwardInvoiceHistory);
    stockInwardInvoiceHistory.sort((dynamic a, dynamic b){
      return DateTime.parse(b['date']+' '+b['time']).compareTo(DateTime.parse(a['date']+' '+a['time']));
    });
    print(stockInwardInvoiceHistory);
//    barCodeSearchResults.sort((a, b) {
//      return a.productName.compareTo(b.productName);
//    });
    return WillPopScope(
      onWillPop:(){
        setState(() {
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return ProductLookupResultsOnline();
              }));
        });

        return;
      },
      child: Scaffold(
        appBar:AppBar(
          title: Text('STOCK INWARD HISTORY'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed: (){
              setState(() {
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return ProductLookupResultsOnline();
                    }));
              });
            },
          ),
        ),
        body:Container(
      child:Column(
      children: <Widget>[
      Expanded(
      flex:30,
      child: Container(
      child:
      ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: stockInwardInvoiceHistory.length,
      itemBuilder: (BuildContext context, int index){


      //                                      if(fullProductStockPositionAtStore[storeIdMap[productLookupStore]] != null && fullProductStockPositionAtStore[storeIdMap[productLookupStore]][productCode] != null){
      //                                        stockInwardForRequestedProduct = fullProductStockPositionAtStore[storeIdMap[productLookupStore]][productCode];
      //                                      }
      //
      //                                      print(stockInwardForRequestedProduct);
      //                                      print(fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]]);
      return
      Container(
      padding: EdgeInsets.all(8.0),
      color:Colors.white,
      child: Container(
      margin: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      border: Border.all(color: Colors.blueGrey[100])),
      height: 100,
      child: Column(
      children: <Widget>[
      Column(children: <Widget>[
      Container(
      child: Row(
      children: <Widget>[
      Expanded(
        flex:4,
      child: Text(
      'INVOICE ID:',
      style: TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat"),
      ),
      ),
      Expanded(
        flex:8,
      child: Text(
        stockInwardInvoiceHistory[index]['invoiceId'].toString(),
      style: TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: "Montserrat"),
      ),
      ),
      ],
      ),
      ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex:4,
                child: Text(
                  'DATE',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
              Expanded(
                flex:8,
                child: Text(
                  stockInwardInvoiceHistory[index]['date'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex:4,
                child: Text(
                  'TIME:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
              Expanded(
                flex:8,
                child: Text(
                  stockInwardInvoiceHistory[index]['time'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex:4,
                child: Text(
                  'QTY:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
              Expanded(
                flex:8,
                child: Text(
                  stockInwardInvoiceHistory[index]['qty'].toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
            ],
          ),
        ),
      ]),
      ],
      ),
      ),
      );
      //                                        Padding(
      //                                          padding: const EdgeInsets.all(8.0),
      //                                          child: Container(
      //                                              padding: EdgeInsets.all(8.0),
      //                                              decoration: BoxDecoration(
      //                                                  border: Border.all(color: Colors.blueGrey),
      //                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))
      //                                              ),
      //                                              height: 400.0,
      //                                              child: Column(children: <Widget>[
      //                                                Expanded(
      //                                                  flex:16,
      //                                                  child: Row(
      //                                                    children: <Widget>[
      //                                                      Expanded(
      //                                                        flex:6,
      //                                                        child: Column(
      //                                                          children: <Widget>[
      //                                                    Expanded(
      //                                                      flex:2,
      //                                                      child: Container(
      //                                                        width:MediaQuery.of(context).size.width,
      //                                                        child: Padding(
      //                                                          padding: const EdgeInsets.all(8.0),
      //                                                          child: RaisedButton(
      //                                                            onPressed:(){
      ////                                                              productToUpdate = barCodeSearchResults[index];
      ////                                                              productToUpdateIndex = index;
      ////                                                              Navigator.of(context).pop();
      ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
      ////                                                                return UpdateProductDetails();
      ////                                                              }));
      //                                                            },
      //                                                            child: Text(
      //                                                              barCodeSearchResults[index].productID.toString(),
      //                                                              style:TextStyle(
      //                                                                  fontFamily: 'Montserrat',
      //                                                                  fontWeight: FontWeight.bold,
      //                                                                  fontSize: 20.0
      //                                                              ),
      //                                                              textAlign: TextAlign.center,
      //                                                            ),
      //                                                          ),
      //                                                        ),
      //                                                      ),
      //                                                    ),
      //                                                            Expanded(
      //                                                              flex:2,
      //                                                              child: Container(
      //                                                                width:MediaQuery.of(context).size.width,
      //                                                                child: Padding(
      //                                                                  padding: const EdgeInsets.all(8.0),
      //                                                                  child: RaisedButton(
      //                                                                    onPressed:(){
      ////                                                              productToUpdate = barCodeSearchResults[index];
      ////                                                              productToUpdateIndex = index;
      ////                                                              Navigator.of(context).pop();
      ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
      ////                                                                return UpdateProductDetails();
      ////                                                              }));
      //                                                                    },
      //                                                                    child: Text(
      //                                                                      barCodeSearchResults[index].productBarCode.toString(),
      //                                                                      style:TextStyle(
      //                                                                          fontFamily: 'Montserrat',
      //                                                                          fontWeight: FontWeight.bold,
      //                                                                          fontSize: 20.0
      //                                                                      ),
      //                                                                      textAlign: TextAlign.center,
      //                                                                    ),
      //                                                                  ),
      //                                                                ),
      //                                                              ),
      //                                                            ),
      //                                                          ],
      //                                                        ),
      //                                                      ),
      ////                                              Expanded(
      ////                                                flex:3,
      ////                                                child: Column(
      ////                                                  children: <Widget>[
      ////                                                    Expanded(
      ////                                                      flex:2,
      ////                                                      child: Padding(
      ////                                                        padding: const EdgeInsets.all(8.0),
      ////                                                        child: RaisedButton(
      ////                                                          highlightColor:Colors.blue,
      ////                                                          onPressed:(){
      ////                                                            setState(() {
      ////                                                              refreshing = true;
      ////                                                            });
      ////                                                            productToUpdate = barCodeSearchResults[index];
      ////                                                            barCodeToSearch = productToUpdate.productBarCode;
      ////                                                            removeProductFromFirebase(barCodeSearchResults[index].productID);
      ////                                                          },
      ////                                                          child:Text('DELETE')
      ////                                                        ),
      ////                                                      ),
      ////                                                    ),
      ////                                                    Expanded(
      ////                                                      flex:2,
      ////                                                      child: Padding(
      ////                                                        padding: const EdgeInsets.all(8.0),
      ////                                                        child: RaisedButton(
      ////                                                            onPressed:(){
      ////                                                              productToUpdate = barCodeSearchResults[index];
      ////                                                              productToUpdateIndex = index;
      ////                                                              Navigator.of(context).pop();
      ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
      ////                                                                return UpdateProductDetails();
      ////                                                              }));
      ////                                                            },
      ////                                                            child:Text('UPDATE')
      ////                                                        ),
      ////                                                      ),
      ////                                                    )
      ////                                                  ],
      ////                                                ),
      ////                                              )
      //
      //                                                    ],
      //                                                  ),
      //                                                ),
      //
      //                                                Expanded(
      //                                                    flex:16,
      //                                                    child: Container(
      //                                                      width:MediaQuery.of(context).size.width,
      //                                                      child: Padding(
      //                                                        padding: const EdgeInsets.all(8.0),
      //                                                        child: RaisedButton(
      //                                                          onPressed: (){
      //                                                          },
      //                                                          child: Text(
      //                                                            barCodeSearchResults[index].productName.toString(),
      //                                                            textAlign: TextAlign.center,
      //                                                            style:TextStyle(
      //                                                              // backgroundColor: Colors.blue,
      //                                                              color:Colors.green,
      //                                                              fontFamily: 'Montserrat',
      //                                                              fontWeight: FontWeight.bold,
      //                                                              fontSize: 20.0,
      //                                                            ),
      //                                                            maxLines: 3,
      //                                                          ),
      //                                                        ),
      //                                                      ),
      //                                                    )
      //                                                ),
      //                                                Expanded(
      //                                                  flex:8,
      //                                                  child: Container(
      //                                                    width:MediaQuery.of(context).size.width,
      //                                                    child: Padding(
      //                                                      padding: const EdgeInsets.all(8.0),
      //                                                      child: RaisedButton(
      //                                                        onPressed:(){
      //
      //                                                        },
      //                                                        child: Text(
      //                                                          'Rs.'+ barCodeSearchResults[index].productPrice.toString() +'/-',
      //                                                          style:TextStyle(
      //                                                              fontFamily: 'Montserrat',
      //                                                              fontWeight: FontWeight.bold,
      //                                                              fontSize: 20.0
      //                                                          ),
      //                                                          textAlign: TextAlign.center,
      //                                                        ),
      //                                                      ),
      //                                                    ),
      //                                                  ),
      //                                                ),
      //
      //                                                Expanded(
      //                                                  flex:8,
      //                                                  child: Container(
      //                                                    width:MediaQuery.of(context).size.width,
      //                                                    child: Padding(
      //                                                      padding: const EdgeInsets.all(8.0),
      //                                                      child: RaisedButton(
      //                                                          onPressed:(){
      //
      //                                                          },
      //                                                          child:
      //                                                          Text(
      //                                                            barCodeSearchResults[index].productCategory,
      //                                                            style:TextStyle(
      //                                                                fontFamily: 'Montserrat',
      //                                                                fontWeight: FontWeight.bold,
      //                                                                fontSize: 20.0
      //                                                            ),
      //                                                            textAlign: TextAlign.right,
      //                                                          )
      //                                                      ),
      //                                                    ),
      //                                                  ),
      //                                                ),
      //                                                Expanded(
      //                                                  flex:8,
      //                                                  child: Container(
      //                                                    width:MediaQuery.of(context).size.width,
      //                                                    child: Padding(
      //                                                      padding: const EdgeInsets.all(8.0),
      //                                                      child: RaisedButton(
      //                                                          onPressed:(){
      //                                                          },
      //                                                          child:
      //                                                          Text(
      //                                                            barCodeSearchResults[index].productBrand,
      //                                                            style:TextStyle(
      //                                                                fontFamily: 'Montserrat',
      //                                                                fontWeight: FontWeight.bold,
      //                                                                fontSize: 20.0
      //                                                            ),
      //                                                            textAlign: TextAlign.right,
      //                                                          )
      //                                                      ),
      //                                                    ),
      //                                                  ),
      //                                                ),
      //                                                Expanded(
      //                                                  flex:8,
      //                                                  child: Container(
      //                                                    width:MediaQuery.of(context).size.width,
      //                                                    child: Padding(
      //                                                      padding: const EdgeInsets.all(8.0),
      //                                                      child: RaisedButton(
      //                                                          onPressed:(){
      //                                                          },
      //                                                          child:
      //                                                          Text(
      //                                                            (barCodeSearchResults[index].productStatus != null)?barCodeSearchResults[index].productStatus:'N/A',
      //                                                            style:TextStyle(
      //                                                                fontFamily: 'Montserrat',
      //                                                                fontWeight: FontWeight.bold,
      //                                                                fontSize: 20.0
      //                                                            ),
      //                                                            textAlign: TextAlign.right,
      //                                                          )
      //                                                      ),
      //                                                    ),
      //                                                  ),
      //                                                ),
      //                                                Expanded(
      //                                                  flex:8,
      //                                                  child: Container(
      //                                                    width:MediaQuery.of(context).size.width,
      //                                                    child: Padding(
      //                                                      padding: const EdgeInsets.all(8.0),
      //                                                      child: RaisedButton(
      //                                                          onPressed:(){
      //                                                          },
      //                                                          child:
      //                                                          Text(
      //                                                            (barCodeSearchResults[index].productParentStore != null)?barCodeSearchResults[index].productParentStore:'N/A',
      //                                                            style:TextStyle(
      //                                                                fontFamily: 'Montserrat',
      //                                                                fontWeight: FontWeight.bold,
      //                                                                fontSize: 20.0
      //                                                            ),
      //                                                            textAlign: TextAlign.right,
      //                                                          )
      //                                                      ),
      //                                                    ),
      //                                                  ),
      //                                                ),
      //                                                Expanded(
      //                                                  flex:8,
      //                                                  child: Container(
      //                                                    width:MediaQuery.of(context).size.width,
      //                                                    child: Padding(
      //                                                      padding: const EdgeInsets.all(8.0),
      //                                                      child: RaisedButton(
      //                                                          onPressed:(){
      //                                                          },
      //                                                          child:
      //                                                          Text(
      //                                                            (barCodeSearchResults[index].productCreationTimeStamp != null)?barCodeSearchResults[index].productCreationTimeStamp:'N/A',
      //                                                            style:TextStyle(
      //                                                                fontFamily: 'Montserrat',
      //                                                                fontWeight: FontWeight.bold,
      //                                                                fontSize: 20.0
      //                                                            ),
      //                                                            textAlign: TextAlign.right,
      //                                                          )
      //                                                      ),
      //                                                    ),
      //                                                  ),
      //                                                ),
      ////                                        Expanded(
      ////                                          flex:8,
      ////                                          child:Row(
      ////                                            children: <Widget>[
      ////                                              Expanded(
      ////                                                flex:4,
      ////                                                child: Container(
      ////                                                  width:MediaQuery.of(context).size.width,
      ////                                                  child: Padding(
      ////                                                    padding: const EdgeInsets.all(8.0),
      ////                                                    child: Text(
      ////                                                      'IN',
      ////                                                      style:TextStyle(
      ////                                                          fontFamily: 'Montserrat',
      ////                                                          fontWeight: FontWeight.bold,
      ////                                                          fontSize: 20.0
      ////                                                      ),
      ////                                                      textAlign: TextAlign.center,
      ////                                                    ),
      ////                                                  ),
      ////                                                ),
      ////                                              ),
      ////                                              Expanded(
      ////                                                flex:4,
      ////                                                child: Container(
      ////                                                  width:MediaQuery.of(context).size.width,
      ////                                                  child: Padding(
      ////                                                    padding: const EdgeInsets.all(8.0),
      ////                                                    child: Text(
      ////                                                      'OUT',
      ////                                                      style:TextStyle(
      ////                                                          fontFamily: 'Montserrat',
      ////                                                          fontWeight: FontWeight.bold,
      ////                                                          fontSize: 20.0
      ////                                                      ),
      ////                                                      textAlign: TextAlign.center,
      ////                                                    ),
      ////                                                  ),
      ////                                                ),
      ////                                              ),
      ////                                              Expanded(
      ////                                                flex:4,
      ////                                                child: Container(
      ////                                                  width:MediaQuery.of(context).size.width,
      ////                                                  child: Padding(
      ////                                                    padding: const EdgeInsets.all(8.0),
      ////                                                    child: Text(
      ////                                                      'STOCK',
      ////                                                      style:TextStyle(
      ////                                                          fontFamily: 'Montserrat',
      ////                                                          fontWeight: FontWeight.bold,
      ////                                                          fontSize: 20.0
      ////                                                      ),
      ////                                                      textAlign: TextAlign.center,
      ////                                                    ),
      ////                                                  ),
      ////                                                ),
      ////                                              ),
      ////                                            ],
      ////                                          ),
      ////                                        ),
      ////                                              Expanded(
      ////                                                flex:8,
      ////                                                child:Row(
      ////                                                  children: <Widget>[
      ////                                                    Expanded(
      ////                                                      flex:4,
      ////                                                      child: Container(
      ////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
      ////                                                        width:MediaQuery.of(context).size.width,
      ////                                                        child: RaisedButton(
      ////                                                          onPressed:(){
      ////                                                            double x = (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]:0;
      //////                                                              Navigator.of(context).pop();
      ////                                                            if(x>0)
      ////                                                              {
      ////                                                            productCode = barCodeSearchResults[index].productID;
      ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
      ////                                                                return ProductStockInwardHistory();
      ////                                                              }));
      ////                                                            }
      ////                                                          },
      ////                                                          child: Padding(
      ////                                                            padding: const EdgeInsets.all(8.0),
      ////                                                            child: Text(
      ////                                                                (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID].toString():'0',
      ////                                                              style:TextStyle(
      ////                                                                  fontFamily: 'Montserrat',
      ////                                                                  fontWeight: FontWeight.bold,
      ////                                                                  fontSize: 20.0
      ////                                                              ),
      ////                                                              textAlign: TextAlign.center,
      ////                                                            ),
      ////                                                          ),
      ////                                                        ),
      ////                                                      ),
      ////                                                    ),
      ////                                                    Expanded(
      ////                                                      flex:4,
      ////                                                      child: Container(
      ////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
      ////                                                        width:MediaQuery.of(context).size.width,
      ////                                                        child: RaisedButton(
      ////                                                          onPressed:(){
      ////                                                            double x = (productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID]:0;
      ////                                                            if(x > 0){
      //////                                                              Navigator.of(context).pop();
      ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
      ////                                                                return ProductStockOutwardHistory();
      ////                                                              }));
      ////                                                            }
      ////                                                          },
      ////                                                          child: Padding(
      ////                                                            padding: const EdgeInsets.all(8.0),
      ////                                                            child: Text(
      ////                                                                (productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID].toString():'0',
      ////                                                              style:TextStyle(
      ////                                                                  fontFamily: 'Montserrat',
      ////                                                                  fontWeight: FontWeight.bold,
      ////                                                                  fontSize: 20.0
      ////                                                              ),
      ////                                                              textAlign: TextAlign.center,
      ////                                                            ),
      ////                                                          ),
      ////                                                        ),
      ////                                                      ),
      ////                                                    ),
      //////                                                    Expanded(
      //////                                                      flex:4,
      //////                                                      child: Container(
      //////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
      //////                                                        width:MediaQuery.of(context).size.width,
      //////                                                        child: Padding(
      //////                                                          padding: const EdgeInsets.all(8.0),
      //////                                                          child: Text(
      //////                                                            productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID].toString(),
      //////                                                            style:TextStyle(
      //////                                                                fontFamily: 'Montserrat',
      //////                                                                fontWeight: FontWeight.bold,
      //////                                                                fontSize: 20.0
      //////                                                            ),
      //////                                                            textAlign: TextAlign.center,
      //////                                                          ),
      //////                                                        ),
      //////                                                      ),
      //////                                                    ),
      ////                                                    Expanded(
      ////                                                      flex:4,
      ////                                                      child: Container(
      ////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
      ////                                                        width:MediaQuery.of(context).size.width,
      ////                                                        child: Padding(
      ////                                                          padding: const EdgeInsets.all(8.0),
      ////                                                          child: Text(
      ////                                                            ((
      ////                                            (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]:0)
      ////                                            - ((productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID]:0)).toString(),
      ////                                                            style:TextStyle(
      ////                                                                fontFamily: 'Montserrat',
      ////                                                                fontWeight: FontWeight.bold,
      ////                                                                fontSize: 20.0
      ////                                                            ),
      ////                                                            textAlign: TextAlign.center,
      ////                                                          ),
      ////                                                        ),
      ////                                                      ),
      ////                                                    ),
      ////                                                  ],
      ////                                                )
      ////                                              )
      //                                              ])
      //                                          ),
      //                                        );
      }
      )
      )
      )
      ],
      )
      ),
      ),
    );
  }
}


class showStockOutwardInvoiceList extends StatefulWidget {
  @override
  _showStockOutwardInvoiceListState createState() => _showStockOutwardInvoiceListState();
}

class _showStockOutwardInvoiceListState extends State<showStockOutwardInvoiceList> {
  @override
  Widget build(BuildContext context) {
    stockOutwardInvoiceHistory.clear();

    stockOutwardInvoiceList.forEach((dynamic key, dynamic value) {
      print(key);
      print(value);
      stockOutwardInvoiceHistory.add(value);
    });
    print(stockOutwardInvoiceHistory);
    stockOutwardInvoiceHistory.sort((dynamic a, dynamic b){
      return DateTime.parse(b['date']+' '+b['time']).compareTo(DateTime.parse(a['date']+' '+a['time']));
    });
    print(stockOutwardInvoiceHistory);
//    barCodeSearchResults.sort((a, b) {
//      return a.productName.compareTo(b.productName);
//    });
    return WillPopScope(
      onWillPop:(){
        setState(() {
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return ProductLookupResultsOnline();
              }));
        });

        return;
      },
      child: Scaffold(
        appBar:AppBar(
          title: Text('STOCK OUTWARD HISTORY'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed: (){
              setState(() {
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return ProductLookupResultsOnline();
                    }));
              });
            },
          ),
        ),
        body:Container(
            child:Column(
              children: <Widget>[
                Expanded(
                    flex:30,
                    child: Container(
                        child:
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: stockOutwardInvoiceHistory.length,
                            itemBuilder: (BuildContext context, int index){


                              //                                      if(fullProductStockPositionAtStore[storeIdMap[productLookupStore]] != null && fullProductStockPositionAtStore[storeIdMap[productLookupStore]][productCode] != null){
                              //                                        stockInwardForRequestedProduct = fullProductStockPositionAtStore[storeIdMap[productLookupStore]][productCode];
                              //                                      }
                              //
                              //                                      print(stockInwardForRequestedProduct);
                              //                                      print(fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]]);
                              return
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  color:Colors.white,
                                  child: Container(
                                    margin: const EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        border: Border.all(color: Colors.blueGrey[100])),
                                    height: 100,
                                    child: Column(
                                      children: <Widget>[
                                        Column(children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:4,
                                                  child: Text(
                                                    'INVOICE ID:',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:8,
                                                  child: Text(
                                                    stockOutwardInvoiceHistory[index]['invoiceId'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:4,
                                                  child: Text(
                                                    'DATE',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:8,
                                                  child: Text(
                                                    stockOutwardInvoiceHistory[index]['date'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:4,
                                                  child: Text(
                                                    'TIME:',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:8,
                                                  child: Text(
                                                    stockOutwardInvoiceHistory[index]['time'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex:4,
                                                  child: Text(
                                                    'QTY:',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:8,
                                                  child: Text(
                                                    stockOutwardInvoiceHistory[index]['qty'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Montserrat"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                );
                              //                                        Padding(
                              //                                          padding: const EdgeInsets.all(8.0),
                              //                                          child: Container(
                              //                                              padding: EdgeInsets.all(8.0),
                              //                                              decoration: BoxDecoration(
                              //                                                  border: Border.all(color: Colors.blueGrey),
                              //                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))
                              //                                              ),
                              //                                              height: 400.0,
                              //                                              child: Column(children: <Widget>[
                              //                                                Expanded(
                              //                                                  flex:16,
                              //                                                  child: Row(
                              //                                                    children: <Widget>[
                              //                                                      Expanded(
                              //                                                        flex:6,
                              //                                                        child: Column(
                              //                                                          children: <Widget>[
                              //                                                    Expanded(
                              //                                                      flex:2,
                              //                                                      child: Container(
                              //                                                        width:MediaQuery.of(context).size.width,
                              //                                                        child: Padding(
                              //                                                          padding: const EdgeInsets.all(8.0),
                              //                                                          child: RaisedButton(
                              //                                                            onPressed:(){
                              ////                                                              productToUpdate = barCodeSearchResults[index];
                              ////                                                              productToUpdateIndex = index;
                              ////                                                              Navigator.of(context).pop();
                              ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
                              ////                                                                return UpdateProductDetails();
                              ////                                                              }));
                              //                                                            },
                              //                                                            child: Text(
                              //                                                              barCodeSearchResults[index].productID.toString(),
                              //                                                              style:TextStyle(
                              //                                                                  fontFamily: 'Montserrat',
                              //                                                                  fontWeight: FontWeight.bold,
                              //                                                                  fontSize: 20.0
                              //                                                              ),
                              //                                                              textAlign: TextAlign.center,
                              //                                                            ),
                              //                                                          ),
                              //                                                        ),
                              //                                                      ),
                              //                                                    ),
                              //                                                            Expanded(
                              //                                                              flex:2,
                              //                                                              child: Container(
                              //                                                                width:MediaQuery.of(context).size.width,
                              //                                                                child: Padding(
                              //                                                                  padding: const EdgeInsets.all(8.0),
                              //                                                                  child: RaisedButton(
                              //                                                                    onPressed:(){
                              ////                                                              productToUpdate = barCodeSearchResults[index];
                              ////                                                              productToUpdateIndex = index;
                              ////                                                              Navigator.of(context).pop();
                              ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
                              ////                                                                return UpdateProductDetails();
                              ////                                                              }));
                              //                                                                    },
                              //                                                                    child: Text(
                              //                                                                      barCodeSearchResults[index].productBarCode.toString(),
                              //                                                                      style:TextStyle(
                              //                                                                          fontFamily: 'Montserrat',
                              //                                                                          fontWeight: FontWeight.bold,
                              //                                                                          fontSize: 20.0
                              //                                                                      ),
                              //                                                                      textAlign: TextAlign.center,
                              //                                                                    ),
                              //                                                                  ),
                              //                                                                ),
                              //                                                              ),
                              //                                                            ),
                              //                                                          ],
                              //                                                        ),
                              //                                                      ),
                              ////                                              Expanded(
                              ////                                                flex:3,
                              ////                                                child: Column(
                              ////                                                  children: <Widget>[
                              ////                                                    Expanded(
                              ////                                                      flex:2,
                              ////                                                      child: Padding(
                              ////                                                        padding: const EdgeInsets.all(8.0),
                              ////                                                        child: RaisedButton(
                              ////                                                          highlightColor:Colors.blue,
                              ////                                                          onPressed:(){
                              ////                                                            setState(() {
                              ////                                                              refreshing = true;
                              ////                                                            });
                              ////                                                            productToUpdate = barCodeSearchResults[index];
                              ////                                                            barCodeToSearch = productToUpdate.productBarCode;
                              ////                                                            removeProductFromFirebase(barCodeSearchResults[index].productID);
                              ////                                                          },
                              ////                                                          child:Text('DELETE')
                              ////                                                        ),
                              ////                                                      ),
                              ////                                                    ),
                              ////                                                    Expanded(
                              ////                                                      flex:2,
                              ////                                                      child: Padding(
                              ////                                                        padding: const EdgeInsets.all(8.0),
                              ////                                                        child: RaisedButton(
                              ////                                                            onPressed:(){
                              ////                                                              productToUpdate = barCodeSearchResults[index];
                              ////                                                              productToUpdateIndex = index;
                              ////                                                              Navigator.of(context).pop();
                              ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
                              ////                                                                return UpdateProductDetails();
                              ////                                                              }));
                              ////                                                            },
                              ////                                                            child:Text('UPDATE')
                              ////                                                        ),
                              ////                                                      ),
                              ////                                                    )
                              ////                                                  ],
                              ////                                                ),
                              ////                                              )
                              //
                              //                                                    ],
                              //                                                  ),
                              //                                                ),
                              //
                              //                                                Expanded(
                              //                                                    flex:16,
                              //                                                    child: Container(
                              //                                                      width:MediaQuery.of(context).size.width,
                              //                                                      child: Padding(
                              //                                                        padding: const EdgeInsets.all(8.0),
                              //                                                        child: RaisedButton(
                              //                                                          onPressed: (){
                              //                                                          },
                              //                                                          child: Text(
                              //                                                            barCodeSearchResults[index].productName.toString(),
                              //                                                            textAlign: TextAlign.center,
                              //                                                            style:TextStyle(
                              //                                                              // backgroundColor: Colors.blue,
                              //                                                              color:Colors.green,
                              //                                                              fontFamily: 'Montserrat',
                              //                                                              fontWeight: FontWeight.bold,
                              //                                                              fontSize: 20.0,
                              //                                                            ),
                              //                                                            maxLines: 3,
                              //                                                          ),
                              //                                                        ),
                              //                                                      ),
                              //                                                    )
                              //                                                ),
                              //                                                Expanded(
                              //                                                  flex:8,
                              //                                                  child: Container(
                              //                                                    width:MediaQuery.of(context).size.width,
                              //                                                    child: Padding(
                              //                                                      padding: const EdgeInsets.all(8.0),
                              //                                                      child: RaisedButton(
                              //                                                        onPressed:(){
                              //
                              //                                                        },
                              //                                                        child: Text(
                              //                                                          'Rs.'+ barCodeSearchResults[index].productPrice.toString() +'/-',
                              //                                                          style:TextStyle(
                              //                                                              fontFamily: 'Montserrat',
                              //                                                              fontWeight: FontWeight.bold,
                              //                                                              fontSize: 20.0
                              //                                                          ),
                              //                                                          textAlign: TextAlign.center,
                              //                                                        ),
                              //                                                      ),
                              //                                                    ),
                              //                                                  ),
                              //                                                ),
                              //
                              //                                                Expanded(
                              //                                                  flex:8,
                              //                                                  child: Container(
                              //                                                    width:MediaQuery.of(context).size.width,
                              //                                                    child: Padding(
                              //                                                      padding: const EdgeInsets.all(8.0),
                              //                                                      child: RaisedButton(
                              //                                                          onPressed:(){
                              //
                              //                                                          },
                              //                                                          child:
                              //                                                          Text(
                              //                                                            barCodeSearchResults[index].productCategory,
                              //                                                            style:TextStyle(
                              //                                                                fontFamily: 'Montserrat',
                              //                                                                fontWeight: FontWeight.bold,
                              //                                                                fontSize: 20.0
                              //                                                            ),
                              //                                                            textAlign: TextAlign.right,
                              //                                                          )
                              //                                                      ),
                              //                                                    ),
                              //                                                  ),
                              //                                                ),
                              //                                                Expanded(
                              //                                                  flex:8,
                              //                                                  child: Container(
                              //                                                    width:MediaQuery.of(context).size.width,
                              //                                                    child: Padding(
                              //                                                      padding: const EdgeInsets.all(8.0),
                              //                                                      child: RaisedButton(
                              //                                                          onPressed:(){
                              //                                                          },
                              //                                                          child:
                              //                                                          Text(
                              //                                                            barCodeSearchResults[index].productBrand,
                              //                                                            style:TextStyle(
                              //                                                                fontFamily: 'Montserrat',
                              //                                                                fontWeight: FontWeight.bold,
                              //                                                                fontSize: 20.0
                              //                                                            ),
                              //                                                            textAlign: TextAlign.right,
                              //                                                          )
                              //                                                      ),
                              //                                                    ),
                              //                                                  ),
                              //                                                ),
                              //                                                Expanded(
                              //                                                  flex:8,
                              //                                                  child: Container(
                              //                                                    width:MediaQuery.of(context).size.width,
                              //                                                    child: Padding(
                              //                                                      padding: const EdgeInsets.all(8.0),
                              //                                                      child: RaisedButton(
                              //                                                          onPressed:(){
                              //                                                          },
                              //                                                          child:
                              //                                                          Text(
                              //                                                            (barCodeSearchResults[index].productStatus != null)?barCodeSearchResults[index].productStatus:'N/A',
                              //                                                            style:TextStyle(
                              //                                                                fontFamily: 'Montserrat',
                              //                                                                fontWeight: FontWeight.bold,
                              //                                                                fontSize: 20.0
                              //                                                            ),
                              //                                                            textAlign: TextAlign.right,
                              //                                                          )
                              //                                                      ),
                              //                                                    ),
                              //                                                  ),
                              //                                                ),
                              //                                                Expanded(
                              //                                                  flex:8,
                              //                                                  child: Container(
                              //                                                    width:MediaQuery.of(context).size.width,
                              //                                                    child: Padding(
                              //                                                      padding: const EdgeInsets.all(8.0),
                              //                                                      child: RaisedButton(
                              //                                                          onPressed:(){
                              //                                                          },
                              //                                                          child:
                              //                                                          Text(
                              //                                                            (barCodeSearchResults[index].productParentStore != null)?barCodeSearchResults[index].productParentStore:'N/A',
                              //                                                            style:TextStyle(
                              //                                                                fontFamily: 'Montserrat',
                              //                                                                fontWeight: FontWeight.bold,
                              //                                                                fontSize: 20.0
                              //                                                            ),
                              //                                                            textAlign: TextAlign.right,
                              //                                                          )
                              //                                                      ),
                              //                                                    ),
                              //                                                  ),
                              //                                                ),
                              //                                                Expanded(
                              //                                                  flex:8,
                              //                                                  child: Container(
                              //                                                    width:MediaQuery.of(context).size.width,
                              //                                                    child: Padding(
                              //                                                      padding: const EdgeInsets.all(8.0),
                              //                                                      child: RaisedButton(
                              //                                                          onPressed:(){
                              //                                                          },
                              //                                                          child:
                              //                                                          Text(
                              //                                                            (barCodeSearchResults[index].productCreationTimeStamp != null)?barCodeSearchResults[index].productCreationTimeStamp:'N/A',
                              //                                                            style:TextStyle(
                              //                                                                fontFamily: 'Montserrat',
                              //                                                                fontWeight: FontWeight.bold,
                              //                                                                fontSize: 20.0
                              //                                                            ),
                              //                                                            textAlign: TextAlign.right,
                              //                                                          )
                              //                                                      ),
                              //                                                    ),
                              //                                                  ),
                              //                                                ),
                              ////                                        Expanded(
                              ////                                          flex:8,
                              ////                                          child:Row(
                              ////                                            children: <Widget>[
                              ////                                              Expanded(
                              ////                                                flex:4,
                              ////                                                child: Container(
                              ////                                                  width:MediaQuery.of(context).size.width,
                              ////                                                  child: Padding(
                              ////                                                    padding: const EdgeInsets.all(8.0),
                              ////                                                    child: Text(
                              ////                                                      'IN',
                              ////                                                      style:TextStyle(
                              ////                                                          fontFamily: 'Montserrat',
                              ////                                                          fontWeight: FontWeight.bold,
                              ////                                                          fontSize: 20.0
                              ////                                                      ),
                              ////                                                      textAlign: TextAlign.center,
                              ////                                                    ),
                              ////                                                  ),
                              ////                                                ),
                              ////                                              ),
                              ////                                              Expanded(
                              ////                                                flex:4,
                              ////                                                child: Container(
                              ////                                                  width:MediaQuery.of(context).size.width,
                              ////                                                  child: Padding(
                              ////                                                    padding: const EdgeInsets.all(8.0),
                              ////                                                    child: Text(
                              ////                                                      'OUT',
                              ////                                                      style:TextStyle(
                              ////                                                          fontFamily: 'Montserrat',
                              ////                                                          fontWeight: FontWeight.bold,
                              ////                                                          fontSize: 20.0
                              ////                                                      ),
                              ////                                                      textAlign: TextAlign.center,
                              ////                                                    ),
                              ////                                                  ),
                              ////                                                ),
                              ////                                              ),
                              ////                                              Expanded(
                              ////                                                flex:4,
                              ////                                                child: Container(
                              ////                                                  width:MediaQuery.of(context).size.width,
                              ////                                                  child: Padding(
                              ////                                                    padding: const EdgeInsets.all(8.0),
                              ////                                                    child: Text(
                              ////                                                      'STOCK',
                              ////                                                      style:TextStyle(
                              ////                                                          fontFamily: 'Montserrat',
                              ////                                                          fontWeight: FontWeight.bold,
                              ////                                                          fontSize: 20.0
                              ////                                                      ),
                              ////                                                      textAlign: TextAlign.center,
                              ////                                                    ),
                              ////                                                  ),
                              ////                                                ),
                              ////                                              ),
                              ////                                            ],
                              ////                                          ),
                              ////                                        ),
                              ////                                              Expanded(
                              ////                                                flex:8,
                              ////                                                child:Row(
                              ////                                                  children: <Widget>[
                              ////                                                    Expanded(
                              ////                                                      flex:4,
                              ////                                                      child: Container(
                              ////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              ////                                                        width:MediaQuery.of(context).size.width,
                              ////                                                        child: RaisedButton(
                              ////                                                          onPressed:(){
                              ////                                                            double x = (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]:0;
                              //////                                                              Navigator.of(context).pop();
                              ////                                                            if(x>0)
                              ////                                                              {
                              ////                                                            productCode = barCodeSearchResults[index].productID;
                              ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
                              ////                                                                return ProductStockInwardHistory();
                              ////                                                              }));
                              ////                                                            }
                              ////                                                          },
                              ////                                                          child: Padding(
                              ////                                                            padding: const EdgeInsets.all(8.0),
                              ////                                                            child: Text(
                              ////                                                                (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID].toString():'0',
                              ////                                                              style:TextStyle(
                              ////                                                                  fontFamily: 'Montserrat',
                              ////                                                                  fontWeight: FontWeight.bold,
                              ////                                                                  fontSize: 20.0
                              ////                                                              ),
                              ////                                                              textAlign: TextAlign.center,
                              ////                                                            ),
                              ////                                                          ),
                              ////                                                        ),
                              ////                                                      ),
                              ////                                                    ),
                              ////                                                    Expanded(
                              ////                                                      flex:4,
                              ////                                                      child: Container(
                              ////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              ////                                                        width:MediaQuery.of(context).size.width,
                              ////                                                        child: RaisedButton(
                              ////                                                          onPressed:(){
                              ////                                                            double x = (productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID]:0;
                              ////                                                            if(x > 0){
                              //////                                                              Navigator.of(context).pop();
                              ////                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
                              ////                                                                return ProductStockOutwardHistory();
                              ////                                                              }));
                              ////                                                            }
                              ////                                                          },
                              ////                                                          child: Padding(
                              ////                                                            padding: const EdgeInsets.all(8.0),
                              ////                                                            child: Text(
                              ////                                                                (productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID].toString():'0',
                              ////                                                              style:TextStyle(
                              ////                                                                  fontFamily: 'Montserrat',
                              ////                                                                  fontWeight: FontWeight.bold,
                              ////                                                                  fontSize: 20.0
                              ////                                                              ),
                              ////                                                              textAlign: TextAlign.center,
                              ////                                                            ),
                              ////                                                          ),
                              ////                                                        ),
                              ////                                                      ),
                              ////                                                    ),
                              //////                                                    Expanded(
                              //////                                                      flex:4,
                              //////                                                      child: Container(
                              //////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              //////                                                        width:MediaQuery.of(context).size.width,
                              //////                                                        child: Padding(
                              //////                                                          padding: const EdgeInsets.all(8.0),
                              //////                                                          child: Text(
                              //////                                                            productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID].toString(),
                              //////                                                            style:TextStyle(
                              //////                                                                fontFamily: 'Montserrat',
                              //////                                                                fontWeight: FontWeight.bold,
                              //////                                                                fontSize: 20.0
                              //////                                                            ),
                              //////                                                            textAlign: TextAlign.center,
                              //////                                                          ),
                              //////                                                        ),
                              //////                                                      ),
                              //////                                                    ),
                              ////                                                    Expanded(
                              ////                                                      flex:4,
                              ////                                                      child: Container(
                              ////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
                              ////                                                        width:MediaQuery.of(context).size.width,
                              ////                                                        child: Padding(
                              ////                                                          padding: const EdgeInsets.all(8.0),
                              ////                                                          child: Text(
                              ////                                                            ((
                              ////                                            (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]:0)
                              ////                                            - ((productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID]:0)).toString(),
                              ////                                                            style:TextStyle(
                              ////                                                                fontFamily: 'Montserrat',
                              ////                                                                fontWeight: FontWeight.bold,
                              ////                                                                fontSize: 20.0
                              ////                                                            ),
                              ////                                                            textAlign: TextAlign.center,
                              ////                                                          ),
                              ////                                                        ),
                              ////                                                      ),
                              ////                                                    ),
                              ////                                                  ],
                              ////                                                )
                              ////                                              )
                              //                                              ])
                              //                                          ),
                              //                                        );
                            }
                        )
                    )
                )
              ],
            )
        ),
      ),
    );
  }
}

