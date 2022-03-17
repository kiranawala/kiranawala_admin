import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-new-product-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-clone-static-details-with-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-clone-static-details-without-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-create-duplicate.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-delete-product.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-stock-position.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-retrieve-stock-inward-outward-between-dates.dart';

bool changeName = false;
bool changePrice = false;
bool changeStatus = false;
bool changeCategory = false;
bool changeBrand = false;
bool changeDiscountDetails = false;
bool showOptions = true;

class InventoryManagerProductUpdateOptions extends StatefulWidget {
  @override
  _InventoryManagerProductUpdateOptionsState createState() => _InventoryManagerProductUpdateOptionsState();
}

class _InventoryManagerProductUpdateOptionsState extends State<InventoryManagerProductUpdateOptions> {

  TextEditingController productNameTextController = TextEditingController();
  TextEditingController productPriceTextController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productNameTextController.text = barCodeSearchResultsMap[skuToUpdate].productName.toString();
    productPriceTextController.text = barCodeSearchResultsMap[skuToUpdate].productPrice.toString();
    print(skuToUpdate);
    print(barCodeSearchResultsMap.length.toString());

    if(barCodeSearchResultsMap[skuToUpdate].productStatus.toUpperCase() == 'ACTIVE')
      selectedStatus = 'INACTIVE';
    else
      selectedStatus = 'ACTIVE';
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
            Row(
              children: <Widget>[
                Expanded(
                  child:Text('BARCODE',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),),
                ),
                Expanded(
                    child:Text(barCodeSearchResultsMap[skuToUpdate].productBarCode.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat"),)
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child:Text('SKU',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),),
                ),
                Expanded(
                    child:Text(barCodeSearchResultsMap[skuToUpdate].productID.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat"),)
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child:GestureDetector(
                    onTap: (){
//                      Navigator.of(context).pop();
                      productNameTextController.text = barCodeSearchResultsMap[skuToUpdate].productName.toString();
                      changeNameDialog();
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            barCodeSearchResultsMap[skuToUpdate].productName.toString(),
                            maxLines: 3,
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
                    child:Text('PRICE',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat"),)
                ),
                Expanded(
                  child:GestureDetector(
                      onTap: (){
//                      Navigator.of(context).pop();
                        changePriceDialog();
                      },
                  child:Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration:BoxDecoration(
                          color:Colors.green,
                          border:Border.all(color:Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      child: Center(
                        child: Text(
                          barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
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
                  child:Text('BRAND',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),),
                ),
                Expanded(
                  child:GestureDetector(
                    onTap: (){
//                      Navigator.of(context).pop();
                      changeBrandDialog();
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            barCodeSearchResultsMap[skuToUpdate].productBrand.toString(),
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
                  child:Text('CATEGORY',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),),
                ),
                Expanded(
                  child:GestureDetector(
                    onTap: (){
//                      Navigator.of(context).pop();
                      changeCategoryDialog();
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            barCodeSearchResultsMap[skuToUpdate].productCategory.toString(),
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
                  child:Text('STATUS',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),),
                ),
                Expanded(
                  child:GestureDetector(
                    onTap: (){
//                      Navigator.of(context).pop();
                      changeStatusDialog();
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            barCodeSearchResultsMap[skuToUpdate].productStatus.toString(),
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
                  child:Text('STOCK POSITION',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),),
                ),
                Expanded(
                  child:GestureDetector(
                    onTap: (){
//                      Navigator.of(context).pop();
//                      changePriceDialog();
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            'IN-STOCK',
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
//                      Navigator.of(context).pop();
//                      changePriceDialog();

                    newProductName = barCodeSearchResultsMap[skuToUpdate].productName.toString();
                    newProductPrice = 1.0;
                    selectedBrandName = barCodeSearchResultsMap[skuToUpdate].productBrand.toString();
                    selectedCategoryName = barCodeSearchResultsMap[skuToUpdate].productCategory.toString();
                    selectedImageURL = barCodeSearchResultsMap[skuToUpdate].productImageURL.toString();
                    nextBarCode = barCodeSearchResultsMap[skuToUpdate].productBarCode.toString();
                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return InventoryManagerCreateDuplicate();
                      }
                    ));
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                              'CREATE DUPLICATE',
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
//                      Navigator.of(context).pop();
//                      changePriceDialog();

                      newProductName = barCodeSearchResultsMap[skuToUpdate].productName.toString();
                      newProductPrice = 1.0;
                      selectedBrandName = barCodeSearchResultsMap[skuToUpdate].productBrand.toString();
                      selectedCategoryName = barCodeSearchResultsMap[skuToUpdate].productCategory.toString();
                      selectedImageURL = barCodeSearchResultsMap[skuToUpdate].productImageURL.toString();
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                          builder:(BuildContext context){
                            return InventoryManagerCloneWithBarcode();
                          }
                      ));
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            'CLONE WITH BARCODE',
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
//                      Navigator.of(context).pop();
//                      changePriceDialog();

                      newProductName = barCodeSearchResultsMap[skuToUpdate].productName.toString();
                      newProductPrice = 1.0;
                      selectedBrandName = barCodeSearchResultsMap[skuToUpdate].productBrand.toString();
                      selectedCategoryName = barCodeSearchResultsMap[skuToUpdate].productCategory.toString();
                      selectedImageURL = barCodeSearchResultsMap[skuToUpdate].productImageURL.toString();
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                          builder:(BuildContext context){
                            return InventoryManagerCloneWithoutBarcode();
                          }
                      ));
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            'CLONE WITHOUT BARCODE',
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
                      newProductName = barCodeSearchResultsMap[skuToUpdate].productName.toString();
                      newProductPrice = 1.0;
                      selectedBrandName = barCodeSearchResultsMap[skuToUpdate].productBrand.toString();
                      selectedCategoryName = barCodeSearchResultsMap[skuToUpdate].productCategory.toString();
                      selectedImageURL = barCodeSearchResultsMap[skuToUpdate].productImageURL.toString();
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                          builder:(BuildContext context){
                            return RetrieveStockInwardOutwardBetweenDates();
                          }
                      ));
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            'PRODUCT STOCK POSITION',
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
                             resetStockPosition();
                          },
                    child:Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        decoration:BoxDecoration(
                            color:Colors.green,
                            border:Border.all(color:Colors.black26),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Center(
                          child: Text(
                            'RESET STOCK POSITION',
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
  Future<void> changeStatusDialog() {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('CHANGE STATUS'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                    crossAxisAlignment:  CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
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
                        child: Text('\u20B9 ' + barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color:Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))
                        ),
                        child: Column(
                            crossAxisAlignment:  CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:<Widget>[

                              Container(
                                  child:Text('CHANGE STATUS',
                                      style:TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize:24.0,
                                          fontWeight: FontWeight.bold,
                                          color:Colors.black
                                      )
                                  )
                              ),
                              Row(
                                  children:<Widget>[
                                    Expanded(
                                      flex:2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'FROM',
                                            style:TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize:24.0,
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black
                                            )
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            barCodeSearchResultsMap[skuToUpdate].productStatus.toString(),
                                            style:TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize:24.0,
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black
                                            )
                                        ),
                                      ),
                                    ),
                                  ]),
                              Row(
                                  children:<Widget>[
                                    Expanded(
                                      flex:2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            'TO',
                                            style:TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize:24.0,
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black
                                            )
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                            onPressed:(){
                                              if(selectedStatus == 'ACTIVE')
                                              {
                                                setState(() {
                                                  selectedStatus = 'INACTIVE';
                                                });
                                              }
                                              else
                                              {
                                                setState(() {
                                                  selectedStatus = 'ACTIVE';
                                                });
                                              }
                                            },
                                            child:
                                            Text(
                                                selectedStatus,
                                                style:TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontSize:24.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:Colors.black
                                                )
                                            )
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ]),
                      ),
                      Container(
                          padding: EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width,
                          child:RaisedButton(
                              color:Colors.blue,
                              onPressed:(){
                                List<int> skusAlreadyAvailable = List<int>();
                                fullProductBasicDetailsMap.forEach((key, value) {
                                  if (value.productBarCode.toString() == barCodeSearchResultsMap[skuToUpdate].productBarCode.toString()) {
                                    skusAlreadyAvailable.add(value.productID);
                                  }
                                });
                                print(skusAlreadyAvailable);

                                print(skuToUpdate.toString());
                                print(productNode);
                                print(barCodeSearchResultsMap[skuToUpdate].productCategory.toString());
                                print(selectedCategory.toString());
                                print(barCodeSearchResultsMap[skuToUpdate].productBrand.toString());
                                print(selectedBrand.toString());
                                FirebaseDatabase
                                    .instance
                                    .reference()
                                    .child('stores')
                                    .child(productNode)
                                    .child('products')
                                    .child(skuToUpdate.toString())
                                    .update(<String, String>{
                                  'productStatus':selectedStatus.toString(),
                                }
                                ).then((value){
                                  print('STATUS UPDATE SUCCESSFUL:' + skuToUpdate.toString());
                                  productUpdateStatus = 'SUCCESS';
                                  barCodeSearchResultsMap[skuToUpdate].productStatus = selectedStatus;

                                  if(selectedStatus == 'ACTIVE')
                                  {
                                    skusAlreadyAvailable.forEach((sku) {
                                      if(sku != skuToUpdate)
                                      {
                                        fullProductBasicDetailsMap[sku].productStatus = 'INACTIVE';
                                        if(barCodeSearchResultsMap.containsKey(sku)){
                                          barCodeSearchResultsMap[sku].productStatus = 'INACTIVE';
                                        }
                                        FirebaseDatabase
                                            .instance
                                            .reference()
                                            .child('stores')
                                            .child(productNode)
                                            .child('products')
                                            .child(sku.toString())
                                            .child('productStatus')
                                            .set('INACTIVE');
                                      }
                                    });
                                  }

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
                                  print('CATEGORY/STATUS UPDATE FAILED:' + skuToUpdate.toString());
                                });
                              },
                              child:Text('CONFIRM',
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:24.0,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.white
                                  ))
                          )
                      )
                    ]),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                }
            )
          ],
        );
      },
    );
  }

  Future<void> changeCategoryDialog() {
    categorySearchResults = productCategories;
    selectedCategory = 'NOCATEGORY';
    print(categories.length);
    print(categorySearchResults.length);
    return
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (context, setState)
                {
                  return AlertDialog(
                    title: Text('SELECT CATEGORY'),
                    content:
                    Column(
                        children: <Widget>[
                          TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: 'Search Category...',
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
                                categorySearchResults = [];
                                productCategories.forEach((category){
                                  if(category.toLowerCase().contains(value.toLowerCase()))
                                  {
                                    categorySearchResults.add(category);
                                  }
                                });
                              }
                              else
                              {
                                categorySearchResults = productCategories;
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
                              itemCount: categorySearchResults.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: FlatButton(
                                    color: Colors.blue,
                                    child: Text(
                                        categorySearchResults[index],
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white
                                        )),
                                    onPressed: () {
                                      selectedCategory =
                                          categorySearchResults[index];
                                      print(selectedCategory);
                                      FirebaseDatabase
                                          .instance
                                          .reference()
                                          .child('stores')
                                          .child(productNode)
                                          .child('products')
                                          .child(skuToUpdate.toString())
                                          .update(<String, String>{
                                        'category':selectedCategory.toString(),
                                      }
                                      ).then((value){
                                        print('CATEGORY SUCCESSFUL:' + skuToUpdate.toString());
                                        productUpdateStatus = 'SUCCESS';
                                        barCodeSearchResultsMap[skuToUpdate].productCategory = selectedCategory;

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
                                        print('CATEGORY UPDATE FAILED:' + skuToUpdate.toString());

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

  Future<void> resetStockPosition() {
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
      print('STOCK INWARDS RESET SUCCESSFUL:' + skuToUpdate.toString());
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
        print('STOCK OUTWARDS RESET SUCCESSFUL:' + skuToUpdate.toString());
        salePositionForProductCode[skuToUpdate.toString()] = 0;
        stockInwardForProductCode[skuToUpdate.toString()] = 0;
        Navigator.of(context).pop();
      }).catchError((dynamic error) {
        productUpdateStatus = 'FAILURE';
        print('STOCK OUTWARDS RESET FAILED:' + skuToUpdate.toString());
      });
    }).catchError((dynamic error){
      productUpdateStatus = 'FAILURE';
      print('STOCK INWARDS RESET FAILED:' + skuToUpdate.toString());
    });
  }
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