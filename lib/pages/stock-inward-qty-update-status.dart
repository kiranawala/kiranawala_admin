import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-store-stock-position.dart';

import 'stock-in-manager-online.dart';

class StockInwardQtyUpdateStatus extends StatefulWidget {
  @override
  _StockInwardQtyUpdateStatusState createState() => _StockInwardQtyUpdateStatusState();
}

class _StockInwardQtyUpdateStatusState extends State<StockInwardQtyUpdateStatus> {
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop:(){
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
            return StockInManagerOnline();
          }));
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
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                    return StockInManagerOnline();
                  }));
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
                      width:MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color:Colors.blue),
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child:
                      Text('INWARD QTY UPDATED',
                        textAlign: TextAlign.center,
                        style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight:FontWeight.bold,
                          fontSize: 20.0,
                          color:Colors.black,
                        ),),
                    ),
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
                        width:MediaQuery.of(context).size.width,
                        child:RaisedButton(
                          color:Colors.blue,
                          onPressed: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                              return StockInManagerOnline();
                            }));
                          },
                            child:Text('NEXT PRODUCT',
                              style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight:FontWeight.bold,
                                fontSize: 20.0,
                                color:Colors.black,
                              ),

                            )
                        ),
                      ),
                    ),
                  ],
                )

            )
        ),
      );
  }
}
