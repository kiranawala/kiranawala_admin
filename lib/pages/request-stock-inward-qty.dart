import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/stock-in-manager-online.dart';
import 'package:kiranawala_admin/pages/stock-inward-qty-update-status.dart';
import 'package:kiranawala_admin/pages/store-stock-position.dart';

class RequestStockInwardQty extends StatefulWidget {
//  final String displayMessage;
//  RequestStockInwardQty(this.displayMessage);
  @override
  _RequestStockInwardQtyState createState() => _RequestStockInwardQtyState();
}

class _RequestStockInwardQtyState extends State<RequestStockInwardQty> {
  double inputValue = 0;
  bool updatingStockInward = false;

  @override
  Widget build(BuildContext context) {

    if(updatingStockInward)
      {
        return
          WillPopScope(
            onWillPop:(){
              Navigator.of(context).pop();
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
//                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                  return UpdateProductDetails();
//                }));
                    },
                  ),
                ),
                body:Container(
                  child:
                  Dialog(
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        Text("UPDATING STOCK",
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                          fontWeight:FontWeight.bold,
                          fontSize: 20.0,
                          color:Colors.black,
                        ),),
                      ],
                    ),
                  ),
                )
            ),
          );
      }
    return
      WillPopScope(
      onWillPop:(){
        Navigator.of(context).pop();
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
//                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                  return UpdateProductDetails();
//                }));
              },
            ),
          ),
            body:Container(
                width:MediaQuery.of(context).size.width,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child:
                            Text(stockInProductToUpdate.productName.toString(),
                              style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight:FontWeight.bold,
                                fontSize: 20.0,
                                color:Colors.black,
                              ),),
                    ),
                    Container(
                            child:Text('\u20B9' + stockInProductToUpdate.productPrice.toString() + '/-',
                              style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight:FontWeight.bold,
                                fontSize: 20.0,
                                color:Colors.black,
                              ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        child:Row(
                          children:<Widget>[
                            Expanded(
                              child: Text('SKU:',
                                style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight:FontWeight.bold,
                                  fontSize: 12.0,
                                  color:Colors.black,
                                ),),
                            ),
                            Expanded(
                              child: Text(stockInProductToUpdate.productID.toString(),
                                style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight:FontWeight.bold,
                                  fontSize: 20.0,
                                  color:Colors.black,
                                ),),
                            ),
                          ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        child:Row(
                            children:<Widget>[
                              Expanded(
                                child: Text('BarCode:',
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 12.0,
                                    color:Colors.black,
                                  ),),
                              ),
                              Expanded(
                                child: Text(stockInProductToUpdate.productBarCode.toString(),
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 20.0,
                                    color:Colors.black,
                                  ),),
                              ),
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        child:Row(
                            children:<Widget>[
                              Expanded(
                                child: Text('Total Inward:',
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 12.0,
                                    color:Colors.black,
                                  ),),
                              ),
                              Expanded(
                                child: Text(
                                  (recentProductStockInwardDetailsMap[stockInProductToUpdate.productID] != null)?
                                  (recentProductStockInwardDetailsMap[stockInProductToUpdate.productID].stockInwardQtyTillDate.toString()):
                                  'N/A',
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 20.0,
                                    color:Colors.black,
                                  ),),
                              ),
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        child:Row(
                            children:<Widget>[
                              Expanded(
                                child: Text('Recent Inward:',
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 12.0,
                                    color:Colors.black,
                                  ),),
                              ),
                              Expanded(
                                child: Text(
                                  (recentProductStockInwardDetailsMap[stockInProductToUpdate.productID] != null)?
                                  (recentProductStockInwardDetailsMap[stockInProductToUpdate.productID].recentStockInwardQty.toString()):
                                      'N/A',
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 20.0,
                                    color:Colors.black,
                                  ),),
                              ),
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        child:Row(
                            children:<Widget>[
                              Expanded(
                                child: Text('Recent Inward Date:',
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 12.0,
                                    color:Colors.black,
                                  ),),
                              ),
                              Expanded(
                                child: Text(
                                    (recentProductStockInwardDetailsMap[stockInProductToUpdate.productID] != null)?
                                  (recentProductStockInwardDetailsMap[stockInProductToUpdate.productID].recentStockInwardDate.toString()):
                                      'N/A',
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 20.0,
                                    color:Colors.black,
                                  ),),
                              ),
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        child:Row(
                            children:<Widget>[
                              Expanded(
                                child: Text('Recent Inward Time:',
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 12.0,
                                    color:Colors.black,
                                  ),),
                              ),
                              Expanded(
                                child: Text(
                                    (recentProductStockInwardDetailsMap[stockInProductToUpdate.productID] != null)?
                                  recentProductStockInwardDetailsMap[stockInProductToUpdate.productID].recentStockInwardTime.toString():
                                  'N/A',
                                  style:TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight:FontWeight.bold,
                                    fontSize: 20.0,
                                    color:Colors.black,
                                  ),),
                              ),
                            ]
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        height:100.0,
                        child: TextField(
                          textCapitalization: TextCapitalization.characters,
                          keyboardType: TextInputType.number,
                      minLines: 3,
                      maxLines: 3,
//                    keyboardType: TextInputType.text,
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight:FontWeight.bold,
                            fontSize: 24.0,
                            color:Colors.black,
                          ),
                          autofocus: true,
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          cursorWidth: 8.0,
                          decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold)),
                          onChanged: (value) {
                            inputValue = double.parse(value);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0.0,8.0,0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: RaisedButton(
                            color:Colors.blue,
                            onPressed:(){
                              if(inputValue > 0) {
                                setState(() {
                                  updatingStockInward = true;
                                });
//                                stockInwardDetailsMap[stockInProductToUpdate.productID] = ProductStockInwardDetails(
//                                    stockInProductToUpdate.productID,
//                                    DateFormat('ddMMMyyyy').format(DateTime.now()).toString(),
//                                    DateFormat('hhmmss-SSS').format(DateTime.now()).toString(),
//                                    inputValue
//                                );

//                                if(productCodeStockInwardQtyTillDateMap[stockInProductToUpdate.productID] != null)
//                                  productCodeStockInwardQtyTillDateMap[stockInProductToUpdate.productID] = productCodeStockInwardQtyTillDateMap[stockInProductToUpdate.productID] + inputValue;
//                                else
//                                  productCodeStockInwardQtyTillDateMap[stockInProductToUpdate.productID] = inputValue;
//
//                                print(productCodeStockInwardQtyTillDateMap[stockInProductToUpdate.productID]);
//                                setState(() {
//                                  updatingStockInward = false;
//                                });

                                FirebaseDatabase.instance.reference()
                                    .child('stores')
                                    .child(inventoryNode)
                                    .child('stockInwards')
                                    .child(DateFormat('ddMMyyyy').format(DateTime.now()).toString())
                                    .child(stockInProductToUpdate.productID.toString())
                                    .child('stockInwardQty')
                                    .once()
                                    .then((stockInwardQtySnapshot){
                                  double stockInwardQty = 0;
                                  if(stockInwardQtySnapshot != null && stockInwardQtySnapshot.value != null) {
                                    stockInwardQty = double.parse(
                                        stockInwardQtySnapshot.value.toString());
                                  }
                                  stockInwardQty = stockInwardQty + inputValue;

                                  FirebaseDatabase.instance.reference()
                                      .child('stores')
                                      .child(inventoryNode)
                                      .child('stockInwards')
                                      .child(DateFormat('ddMMyyyy').format(DateTime.now()).toString())
                                      .child(stockInProductToUpdate.productID.toString())
                                      .set(<String,dynamic>{
                                    'productCode': stockInProductToUpdate.productID,
                                    'productBarCode':stockInProductToUpdate.productBarCode,
                                    'productName': stockInProductToUpdate.productName,
                                    'productPrice': stockInProductToUpdate.productPrice,
                                    'stockInwardQty': stockInwardQty
                                  });
                                });

                                FirebaseDatabase.instance.reference()
                                    .child('stores')
                                    .child(inventoryNode)
                                    .child('products')
                                    .child(stockInProductToUpdate.productID.toString())
                                    .child('stockInwards')
                                    .child('invoices')
                                    .child(inventoryNode + '_' +DateFormat('ddMMyyyy_HHmmss_SSS').format(DateTime.now()).toString())
                                    .update(<String, dynamic>{
                                  'stockInwardQty':inputValue,
                                  'date':DateFormat('ddMMyyyy').format(DateTime.now()).toString(),
                                  'time':DateFormat('HHmmss-SSS').format(DateTime.now()).toString(),
                                  'mode':'manual',
                                  'invoiceId':inventoryNode + '_' + DateFormat('ddMMyyyy_HHmmss_SSS').format(DateTime.now()).toString()
                                }).then((dynamic stockInwardsUpdateStatus){
                                  print('stockInward updated successfully.');
                                  FirebaseDatabase.instance.reference()
                                      .child('stores')
                                      .child(inventoryNode)
                                      .child('products')
                                      .child(stockInProductToUpdate.productID.toString())
                                      .child('stockInwards')
                                      .update(<String, dynamic>{
                                    'recentStockInwardDate':DateFormat('ddMMyyyy').format(DateTime.now()).toString(),
                                    'recentStockInwardTime':DateFormat('HHmmss-SSS').format(DateTime.now()).toString(),
                                    'recentStockInwardQty':inputValue,
                                    'recentStockInwardInvoiceId':inventoryNode + '_' + DateFormat('ddMMyyyy_HHmmss_SSS').format(DateTime.now()).toString()
                                  });
                                  FirebaseDatabase
                                      .instance
                                      .reference()
                                      .child('stores')
                                      .child(inventoryNode)
                                      .child('products')
                                      .child(stockInProductToUpdate.productID.toString())
                                      .child('stockInwards')
                                      .child('stockInwardTillDate')
                                      .runTransaction((mutableData) async {
                                    mutableData.value =(mutableData.value??0) + inputValue;
                                    return mutableData;
                                  });
                                });
                                FirebaseDatabase.instance.reference()
                                    .child('stores')
                                    .child(inventoryNode)
                                    .child('products')
                                    .child(stockInProductToUpdate.productID.toString())
                                    .child('basicDetails')
                                    .update(<String, dynamic>{
                                  'productCode':stockInProductToUpdate.productID,
                                  'productBarcode':stockInProductToUpdate.productBarCode,
                                  'productName':stockInProductToUpdate.productName,
                                  'productPrice':stockInProductToUpdate.productPrice,
                                  'productImageURL':stockInProductToUpdate.productImageURL,
                                  'productCategory':stockInProductToUpdate.productCategory,
                                  'productBrand':stockInProductToUpdate.productBrand,
                                });
//                                setState(() {
//                                  updatingStockInward = true;
//                                });
//                                print('RequestValue:inputValue:' + inputValue.toString());
//                                Navigator.of(context).pop(inputValue);
                              Navigator.of(context).pop();
                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
                                return StockInwardQtyUpdateStatus();
                              }));
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
                    )
                  ],
                )

            )
        ),
      );

  }
}
