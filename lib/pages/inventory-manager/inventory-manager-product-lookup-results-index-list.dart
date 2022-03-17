import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';

import '../show-admin-home-page.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-options.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

bool refreshing = false;

class ProductLookupResultsIndexedList extends StatefulWidget {
  @override
  _ProductLookupResultsIndexedListState createState() =>
      _ProductLookupResultsIndexedListState();
}

class _ProductLookupResultsIndexedListState
    extends State<ProductLookupResultsIndexedList> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    // TODO: implement initState
//    itemScrollController.jumpTo(index: 10, alignment: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    barCodeSearchResults = [];
    barCodeSearchResultsMap.forEach((key, value) {
      barCodeSearchResults.add(value);
      print(key);
      print(value.productID);
    });
    print('BarcodeSearchResults:');
    print(barCodeSearchResults);

    barCodeSearchResults.sort((a, b) {
      return a.productName.compareTo(b.productName);
    });
//    salePositionForRequestedProduct = 0;
//
//    barCodeSearchResults.forEach((product) {
//      print(product.productID.toString());
//      int productCode = product.productID;
//      storeTerminalMap[productLookupStore].forEach((terminal) {
//        if(fullProductSalePositionAtTerminal[terminal] != null && fullProductSalePositionAtTerminal[terminal][productCode] != null) {
//          print(productLookupStore);
//          print(terminal);
//          print(fullProductSalePositionAtTerminal[terminal][productCode]);
//          salePositionForRequestedProduct =
//              salePositionForRequestedProduct
//                  +
//                  fullProductSalePositionAtTerminal[terminal][productCode];
//        }
//      }) ;
//    });
//
//    barCodeSearchResults.forEach((product){
//      if(fullProductStockPositionAtStore[storeIdMap[productLookupStore]] != null && fullProductStockPositionAtStore[storeIdMap[productLookupStore]][product.productID] != null){
//        stockInwardForRequestedProduct = fullProductStockPositionAtStore[storeIdMap[productLookupStore]][product.productID];
//      }
//    });
//    print(stockInwardForRequestedProduct);
//
//    stockPositionForRequestedProduct = stockInwardForRequestedProduct - salePositionForRequestedProduct;

//    if(refreshing)
//      return Container(
//        color: Colors.white,
//        child: Dialog(
//          child: new Row(
//            mainAxisSize: MainAxisSize.min,
//            children: [
//              new CircularProgressIndicator(),
//            ],
//          ),
//        ),
//      );
//    else

    if (barCodeSearchResults.length > 0) {
      return WillPopScope(
          onWillPop: () {
            setState(() {
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                return ProductLookUp();
              }));
            });

            return;
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.keyboard_backspace),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) {
                      return ProductLookUp();
                    }));
                  },
                ),
                title: Text(
                  'Search Results',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                centerTitle: true,
              ),
              body: Container(
                  child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      children:<Widget>[
                        Text(
                          'AVAILABLE SKUs :' +
                              barCodeSearchResults.length.toString(),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                        RaisedButton(
                          color:Colors.blue,
                          onPressed:(){
                            itemScrollController.jumpTo(index: previousSearchResultIndex);
                          },
                          child:Text(
                            'Go To Previously Updated SKU',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color:Colors.white),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ]

                    ),
                  ),
                  Expanded(
                      flex: 20,
                      child: Container(
                          child: ScrollablePositionedList.builder(
                              itemCount: barCodeSearchResults.length,
                              itemScrollController: itemScrollController,
                              itemPositionsListener: itemPositionsListener,
                              itemBuilder: (BuildContext context, int index) {
//                                      print(productLookupStore);

//                                      salePositionForRequestedProduct = 0.0;
//                                      int productCode = barCodeSearchResults[index].productID;
//                                      storeTerminalMap[productLookupStore].forEach((terminal) {
//                                        if(fullProductSalePositionAtTerminal[terminal] != null && fullProductSalePositionAtTerminal[terminal][productCode] != null) {
//                                          print(productLookupStore);
//                                          print(terminal);
//                                          print(fullProductSalePositionAtTerminal[terminal][productCode]);
//                                          salePositionForRequestedProduct =
//                                              salePositionForRequestedProduct
//                                                  +
//                                                  fullProductSalePositionAtTerminal[terminal][productCode];
//                                        }
//                                      }) ;
//                                      print(salePositionForRequestedProduct);
//
//                                      stockInwardForRequestedProduct = 0.0;

//                                      if(fullProductStockPositionAtStore[storeIdMap[productLookupStore]] != null && fullProductStockPositionAtStore[storeIdMap[productLookupStore]][productCode] != null){
//                                        stockInwardForRequestedProduct = fullProductStockPositionAtStore[storeIdMap[productLookupStore]][productCode];
//                                      }
//
//                                      print(stockInwardForRequestedProduct);

//                                      print(productLookupStore);
//                                      print(storeGroups[productLookupStore]);
//                                      storeGroups[productLookupStore].forEach((store) {
//                                        print(store);
//                                        if(fullProductStockPositionAtStore[storeIdMap[store]] != null && fullProductStockPositionAtStore[storeIdMap[store]][productCode] != null){
//                                          stockInwardForRequestedProduct = stockInwardForRequestedProduct + fullProductStockPositionAtStore[storeIdMap[store]][productCode];
//                                        }
//                                      });
//
//                                      print(stockInwardForRequestedProduct);
//
//
//                                      stockPositionForRequestedProduct = 0.0;
//                                      stockPositionForRequestedProduct = stockInwardForRequestedProduct - salePositionForRequestedProduct;
//                                      print(stockPositionForRequestedProduct);
//                                      print(fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]]);
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      print('Product Selected');
                                      previousSearchResultIndex = index;
                                      skuToUpdate =
                                          barCodeSearchResults[index].productID;
//                                      Navigator.of(context).pop();
//                                      Navigator.of(context).push<dynamic>(
//                                          MaterialPageRoute<dynamic>(
//                                              builder: (BuildContext context) {
//                                        return InventoryManagerProductUpdateOptions();
//                                      }));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
//                                                decoration: BoxDecoration(
//                                                  border: Border.all(color:Colors.grey),
//                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))
//                                                ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              child: Text(
                                                  barCodeSearchResults[
                                                          index]
                                                      .productID
                                                      .toString())),
                                          Container(
                                              child: Text(
                                                  barCodeSearchResults[
                                                          index]
                                                      .productBarCode
                                                      .toString())),
                                          Container(
                                              child: Text(
                                                  barCodeSearchResults[
                                                          index]
                                                      .productName
                                                      .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color:Colors.black),)),
                                          Container(
                                              child: Text(
                                                  '\u20B9 ' + barCodeSearchResults[
                                                          index]
                                                      .productPrice
                                                      .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color:Colors.black),)),
                                          Container(
                                              child: Text(
                                                  barCodeSearchResults[
                                                          index]
                                                      .productCategory
                                                      .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color:Colors.black),)),
                                          Container(
                                              child: Text(
                                                  barCodeSearchResults[
                                                          index]
                                                      .productBrand
                                                      .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color:Colors.black),)),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Image URL')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(barCodeSearchResults[index].productImageURL.toString())
//                                                          ),
//                                                        ),
//                                                      ],
//                                                    ),
                                          Container(
                                              child: Text(
                                                  barCodeSearchResults[
                                                          index]
                                                      .productStatus
                                                      .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0,
                                                    color:Colors.black),)),
                                          Container(
                                              child: Text(
                                                  barCodeSearchResults[
                                                          index]
                                                      .productParentStore
                                                      .toString())),
                                          Container(
                                              child: Text(
                                                  barCodeSearchResults[
                                                          index]
                                                      .productCreationTimeStamp
                                                      .toString())),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Discount')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(
//                                      (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discount.toString():'N/A'))
////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
//                                                          ),
//                                                        ),
//                                                      ],
//                                                    ),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Discount Type')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(
//                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discountType.toString():'N/A'))
////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
//                                                          ),
//                                                        ),
//                                                      ],
//                                                    ),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Discount Start Date')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(
//                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discountStartDate.toString():'N/A'))
////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
//                                                          ),
//                                                        ),
//                                                      ],
//                                                    ),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Discount End Date')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(
//                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discountEndDate.toString():'N/A'))
////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
//                                                          ),
//                                                        ),
//                                                      ],
//                                                    ),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Is Discount Active?')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(
//
//                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].isDiscountActive.toString():'N/A'))
////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
//                                                          ),
//                                                        ),
//                                                      ],
//                                                    ),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Status Change Timestamp')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(
//                                                                  (fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]] != null && fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID] != null?fullProductDiscountDetailsAtStore[storeIdMap[productLookupStore]][barCodeSearchResults[index].productID].discountStatusChangeTimeStamp.toString():'N/A'))
////                                                                barCodeSearchResults[index].productCreationTimeStamp.toString())
//                                                          ),
//                                                        ),
//                                                      ],
//                                                    ),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Units Sold Till Date')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(
//                                                                  salePositionForRequestedProduct.toString())
////                                                                  (fullProductSalePositionAtTerminal['POS_8'][barCodeSearchResults[index].productID] != null?fullProductSalePositionAtTerminal['POS_8'][barCodeSearchResults[index].productID].toString():'N/A'))
//                                                          ),
//                                                        ),
//                                                      ],
//                                                    ),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Units Purchased Till Date')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(
//                                                                  stockInwardForRequestedProduct.toString(),
////                                                                  (fullProductStockPositionMap[barCodeSearchResults[index].productID] != null?fullProductStockPositionMap[barCodeSearchResults[index].productID].toString():'N/A'))
//                                                          ),
//                                                        ),)
//                                                      ],
//                                                    ),
//                                                    Row(
//                                                      children: <Widget>[
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text('Final Stock Position:')
//                                                          ),
//                                                        ),
//                                                        Expanded(
//                                                          child: Container(
//                                                              child:Text(
//                                                                stockPositionForRequestedProduct.toString())
////                                                                  (fullProductStockPositionMap[barCodeSearchResults[index].productID] != null
////                                                                    && fullProductSalePositionMap[barCodeSearchResults[index].productID] != null)?
////                                                                  (fullProductStockPositionMap[barCodeSearchResults[index].productID]
////                                                                      - fullProductSalePositionMap[barCodeSearchResults[index].productID]).toString():
////                                                                  'N/A')
//                                                          ),
//                                                        ),
//                                                      ],
//                                                    )
                                        ],
                                      ),
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
                              })))
                ],
              ))));
    } else
      return WillPopScope(
          onWillPop: () {
            setState(() {
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                return ProductLookUp();
              }));
            });

            return;
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('SEARCH RESULTS'),
                centerTitle: true,
                leading: IconButton(
                    icon: Icon(Icons.keyboard_backspace),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) {
                        return ProductLookUp();
                      }));
                    }),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    barCodeToSearch,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                  Text(
                    'PRODUCT NOT IN SYSTEM',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              )));
  }
}
