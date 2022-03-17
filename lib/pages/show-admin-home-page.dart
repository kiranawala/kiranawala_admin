import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/ShowBillsForDate.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-barcode-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/online-product-lookup.dart';
import 'package:kiranawala_admin/pages/show-daily-sale-per-store.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/show-bills-for-selected-store.dart';
import 'package:kiranawala_admin/pages/show-bills.dart';
import 'package:kiranawala_admin/pages/show-online-orders.dart';

import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/show-sale-position-home.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-home-page.dart';

class ShowAdminHomePage extends StatefulWidget {
  @override
  _ShowAdminHomePageState createState() => _ShowAdminHomePageState();
}

class _ShowAdminHomePageState extends State<ShowAdminHomePage> {

  void getTerminalSalePosition(String storeTerminal){
    print('Retrieving Sale Position For Terminal ' + storeTerminal.toString());
    FirebaseDatabase
      .instance
      .reference()
      .child('storeTerminals')
      .child(storeTerminal)
      .child('sales')
      .child(selectedOnlineSalePositionYear)
      .child(selectedOnlineSalePositionMonth)
      .child(selectedOnlineSalePositionDay)
      .once()
      .then((terminalSaleSnapshot){
//        print(terminalSaleSnapshot);
        if(terminalSaleSnapshot != null && terminalSaleSnapshot.value != null) {
          if (terminalSaleSnapshot.value['totalSale'] != null &&
              terminalSaleSnapshot.value['totalWalkins'] != null) {
            saleDetailsAtTerminal[storeTerminal] = <String, dynamic> {
              'cashSale':(terminalSaleSnapshot.value['cashSale'] != null?terminalSaleSnapshot.value['cashSale']:0),
              'bankCardSale':(terminalSaleSnapshot.value['bankCardSale'] != null?terminalSaleSnapshot.value['bankCardSale']:0),
              'upiSale':(terminalSaleSnapshot.value['upiSale'] != null?terminalSaleSnapshot.value['upiSale']:0),
              'foodCardSale':(terminalSaleSnapshot.value['foodCardSale'] != null?terminalSaleSnapshot.value['foodCardSale']:0),
              'eWalletSale':(terminalSaleSnapshot.value['eWalletSale'] != null?terminalSaleSnapshot.value['eWalletSale']:0),
              'totalSale':(terminalSaleSnapshot.value['totalSale'] != null?terminalSaleSnapshot.value['totalSale']:0),
              'totalWalkins':(terminalSaleSnapshot.value['totalWalkins'] != null?terminalSaleSnapshot.value['totalWalkins']:0),
            };
            billsAtTerminalForSelectedDate[storeTerminal] = terminalSaleSnapshot.value['bills'];
//            print(billsAtTerminalForSelectedDate);
            totalSaleForSelectedDate = totalSaleForSelectedDate
                                        + double.parse(terminalSaleSnapshot.value['totalSale'].toString());

            salePositionAtTerminal[storeTerminal] = double.parse(terminalSaleSnapshot.value['totalSale'].toString());
            walkinsAtTerminal[storeTerminal] = int.parse(terminalSaleSnapshot.value['totalWalkins'].toString());

            totalWalkinsForSelectedDate = totalWalkinsForSelectedDate +
                                          int.parse(terminalSaleSnapshot.value['totalWalkins'].toString());
            if( terminalSaleSnapshot.value['cashSale'] != null)
            cashSale = cashSale + double.parse(terminalSaleSnapshot.value['cashSale'].toString());

            if( terminalSaleSnapshot.value['bankCardSale'] != null)
              cardSale = cardSale + double.parse(terminalSaleSnapshot.value['bankCardSale'].toString());

            if( terminalSaleSnapshot.value['upiSale'] != null)
              upiSale = upiSale + double.parse(terminalSaleSnapshot.value['upiSale'].toString());

            if( terminalSaleSnapshot.value['eWalletSale'] != null)
              eWalletSale = eWalletSale + double.parse(terminalSaleSnapshot.value['eWalletSale'].toString());

            if( terminalSaleSnapshot.value['foodCardSale'] != null)
              foodCardSale = foodCardSale + double.parse(terminalSaleSnapshot.value['foodCardSale'].toString());
          }
          else
            {
              saleDetailsAtTerminal[storeTerminal] = <String, dynamic> {
                'cashSale':0,
                'bankCardSale':0,
                'upiSale':0,
                'foodCardSale':0,
                'eWalletSale':0,
                'totalSale':0,
                'totalWalkins':0,
              };
            }
        }
        else
          {
            saleDetailsAtTerminal[storeTerminal] = <String, dynamic> {
              'cashSale':0,
              'bankCardSale':0,
              'upiSale':0,
              'foodCardSale':0,
              'eWalletSale':0,
              'totalSale':0,
              'totalWalkins':0,
            };
          }
        terminalsProcessed = terminalsProcessed + 1;
        if(terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] != null){
          terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] = terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] + 1;
        }
        else
          {
            terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] = 1;
          }
        if(terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] == terminalsAvailableAtStore[posTerminalToStoreIdMap[storeTerminal]] )
          {
            isStoreProcessed[posTerminalToStoreIdMap[storeTerminal]] = true;
            print('All Terminals processed at Store:' + posTerminalToStoreIdMap[storeTerminal]);
            storeIdTerminalMap[posTerminalToStoreIdMap[storeTerminal]].forEach((terminal) {
              if(salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]] != null)
                salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]] = double.parse(salePositionAtTerminal[terminal].toString()) + double.parse(salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]].toString());
              else
                salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]] = double.parse(salePositionAtTerminal[terminal].toString());
            });
            print(salePositionAtStore);
            print(salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]]);
            storesProcessed = storesProcessed + 1;
            print('Stores Processed:' + storesProcessed.toString());
            print('Stores To Be Processed:' + storeCount.toString());
            if(storesProcessed == storeCount)
              {
                print('All Store Processed successfully');
              }
          }
        print('Store Id:' + posTerminalToStoreIdMap[storeTerminal].toString());
        print('Store Terminal:' + storeTerminal.toString());
        print('Terminals Processed At Store:' + terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]].toString());
        print('Terminals Available At Store:' + terminalsAvailableAtStore[posTerminalToStoreIdMap[storeTerminal]].toString());
        if(terminalsProcessed == terminalCount)
          {
            storeSalePositionAvailable = true;
            retrievingStoreSalePosition = false;
            if(this.mounted)
            setState(() {
            });
          }
    });

    }

  void getStoreSalePostion()
  {
    storeSalePositionAvailable = false;
    retrievingStoreSalePosition = true;
    terminalCount = storeTerminals.length;
    terminalsProcessed = 0;
    totalSaleForSelectedDate = 0;
    totalWalkinsForSelectedDate = 0;
    cashSale = 0;
    cardSale = 0;
    upiSale = 0;
    eWalletSale = 0;
    foodCardSale = 0;

    storeTerminals.forEach((storeTerminal){
      print('Calling getTerminalSalePosition For Terminal ' + storeTerminal.toString());
      getTerminalSalePosition(storeTerminal);
    });
  }

  void getOnlineSalePosition() {
    onlineSalePositionAvailable = false;
    retrievingOnlineSalePosition = true;
    orderMap = new Map<String, dynamic>();
//    print(selectedOnlineSalePositionDay);
//    print(selectedOnlineSalePositionMonth);
//    print(selectedOnlineSalePositionYear);
//    print(inventoryNode);
    List<String> storeOrderIds = new List<String>();
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('onlineOrders')
        .child(selectedOnlineSalePositionYear)
        .child(selectedOnlineSalePositionMonth)
        .child(selectedOnlineSalePositionDay)
        .onValue
        .listen((onlineOrdersSnapshot) {
//      print(onlineOrdersSnapshot);
      if (onlineOrdersSnapshot != null && onlineOrdersSnapshot.snapshot.value != null) {
        Map<dynamic, dynamic> map = onlineOrdersSnapshot.snapshot.value;
        map.forEach((dynamic key, dynamic value) {
          storeOrderIds.add(key.toString());
          orderMap[key.toString()] = value;
        });
        print('Order Count:' + orderMap.length.toString());
      }
      else {
        print('No Orders at the moment!!');
      }
      onlineSalePositionAvailable = true;
      retrievingOnlineSalePosition = false;
      if(this.mounted)
      {
        setState(() {
        });
      }
    });
  }

  Widget getStoreSalePositionWidget(){
    if(storeSalePositionAvailable)
      {
        return
        Container
          (
          child:

          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('Total Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: RaisedButton(
                        onPressed:(){
                          if(stores.length > 1)
                            {
                              Navigator.of(context).pop();
                              Navigator.of(context).push<dynamic>(
                                  MaterialPageRoute<dynamic>(
                                      builder:(BuildContext context){
                                        return ShowDailySalePerStore();
                                      }
                                  )
                              );
                            }
                          else
                            {
                              selectedStore = stores[0];
                              Navigator.of(context).pop();
                              Navigator.of(context).push<dynamic>(
                                MaterialPageRoute<dynamic>(
                                  builder:(BuildContext context){
                                    return ShowBillsForSelectedStore();
                                  }
                                )
                              );
                            }
                        },
                        child: Text( totalSaleForSelectedDate.toStringAsFixed(0),
                          style: TextStyle(color: Colors.deepOrangeAccent,
                              fontSize: 30.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:6,
                      child: Text('Total Walkins:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:4,
                      child: Text(totalWalkinsForSelectedDate.toString(),
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('Cash Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: Text(cashSale.toStringAsFixed(0),
                        style: TextStyle(color: Colors.deepOrangeAccent,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('Bank Card Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: Text( cardSale.toStringAsFixed(0),
                        style: TextStyle(color: Colors.deepOrangeAccent,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('UPI Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: Text(upiSale.toStringAsFixed(0),
                        style: TextStyle(color: Colors.deepOrangeAccent,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('eWallet Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: Text( eWalletSale.toStringAsFixed(0),
                        style: TextStyle(color: Colors.deepOrangeAccent,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('Food Card Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: Text(foodCardSale.toStringAsFixed(0),
                        style: TextStyle(color: Colors.deepOrangeAccent,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ));

      }
    else
      {
        return Container(
          child:Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('Total Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: new LinearProgressIndicator(),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:6,
                      child: Text('Total Walkins:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:4,
                      child: new LinearProgressIndicator(),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('Cash Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: new LinearProgressIndicator(),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('Bank Card Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: LinearProgressIndicator(),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('UPI Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: LinearProgressIndicator(),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('eWallet Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: new LinearProgressIndicator(),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:4,
                      child: Text('Food Card Sale:',
                        style: TextStyle(color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                        ),),
                    ),
                    Expanded(
                      flex:2,
                      child: Text('\u20B9 ',
                        style: TextStyle(color: Colors.black,
                            fontSize: 30.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child: new LinearProgressIndicator(),
                    )
                  ],
                ),
              ),
            ],
          )
        );

      }
  }

  Widget getOnlineSalePositionWidget()
  {
    if(onlineSalePositionAvailable)
      {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child:Row(
            children: <Widget>[
              Expanded(
                flex:4,
                child: Text('Online Orders:',
                  style: TextStyle(color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                  ),),
              ),
              Expanded(
                flex:4,
                child: RaisedButton(
                  onPressed: (){
                    if(orderMap.length > 0 )
                    {
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                              builder:(BuildContext context){
                                return ShowOnlineOrders();
                              }
                          )
                      );
                    }
                  },
                  child: Text(orderMap.length.toString(),
                    style: TextStyle(color: Colors.black,
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        );
      }
    else
      {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child:Row(
            children: <Widget>[
              Expanded(
                flex:4,
                child: Text('Online Orders:',
                  style: TextStyle(color: Colors.black,
                    fontSize: 20.0,
                    fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                  ),),
              ),
              Expanded(
                flex:4,
                child:
                Container(
                  color: Colors.white,
                  child: Dialog(
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            flex:2,
                            child: new LinearProgressIndicator()
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrievingOnlineSalePosition = true;
    retrievingStoreSalePosition = true;

    storeTerminals = ['POS_2','POS_11'];
    stores = ['KIRANAWALA_STORE_11'];

    storesProcessed = 0;
    storeTerminals.forEach((element) {
      terminalsProcessedAtStore[posTerminalToStoreIdMap[element]] = 0;
      salePositionAtTerminal[element] = 0;
      salePositionAtStore[posTerminalToStoreIdMap[element]] = 0;
    });
    getOnlineSalePosition();
    getStoreSalePostion();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return;
      },
      child:Scaffold(
        appBar: AppBar(
      centerTitle: true,
          title:Text(storeName,
            style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
    ),
        ),
      ),
    drawer: Drawer(
      child:ListView(
        children:<Widget>[
          RaisedButton(
            color:Colors.blue,
            onPressed:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return ShowSalePositionHomePage();
                  }
                )
              );
            },
              child: Text('SALE ANALYSIS',
                style: TextStyle(color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold
                ),
              )
          ),
          RaisedButton(
              color:Colors.blue,
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
              child: Text('INVENTORY MANAGER',
                style: TextStyle(color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold
                ),
              )
          ),
          RaisedButton(
              color:Colors.blue,
              onPressed: (){
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                  return StockInwardHomePage();
                }));
              },
              child:Center(child: getTextWidget('STOCK INWARD', 20.0, Colors.white))
          ),
          RaisedButton(
              color:Colors.blue,
              onPressed: (){
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                  return OnlineProductLookUp();
                }));
              },
              child:Center(child: getTextWidget('PRODUCT LOOKUP', 20.0, Colors.white))
          ),

        ]
      )
    ),
    body:Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(border: Border.all(color:Colors.white), borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child:Row(
          children: <Widget>[
            Expanded(
              flex:8,
              child: RaisedButton(
                color:Colors.blue,
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2019, 11, 01),
                      maxTime: DateTime.now(),
                      onChanged: (date) {
                      },
                      onConfirm: (date) {
                        selectedOnlineSalePositionDate = DateFormat('dd-MM-yyyy').format(date);
                        selectedOnlineSalePositionDay = selectedOnlineSalePositionDate.substring(0,2);
                        selectedOnlineSalePositionMonth = selectedOnlineSalePositionDate.substring(3,5);
                        selectedOnlineSalePositionYear = selectedOnlineSalePositionDate.substring(6,10);
                        setState(() {});

                        storesProcessed = 0;
                        storeTerminals.forEach((element) {
                          terminalsProcessedAtStore[posTerminalToStoreIdMap[element]] = 0;
                          salePositionAtTerminal[element] = 0;
                          salePositionAtStore[posTerminalToStoreIdMap[element]] = 0;
                        });
                        getOnlineSalePosition();
                        getStoreSalePostion();
                      },
                      currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text(
                  selectedOnlineSalePositionDate.toUpperCase(),
                  style: TextStyle(color: Colors.white,
                      fontSize: 30.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex:2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color:Colors.blue,
                  onPressed: (){
                    if(!retrievingStoreSalePosition && !retrievingOnlineSalePosition){

                      storesProcessed = 0;
                      storeTerminals.forEach((element) {
                        terminalsProcessedAtStore[posTerminalToStoreIdMap[element]] = 0;
                        salePositionAtTerminal[element] = 0;
                        salePositionAtStore[posTerminalToStoreIdMap[element]] = 0;
                      });
                      getOnlineSalePosition();
                      getStoreSalePostion();
                    }
                  },
                  child:
                    Icon(Icons.refresh,color:Colors.white,size:30.0)

                ),
              ),
            )
          ],
        )
      ),
//      Container(
//        height:300,
//        width:MediaQuery.of(context).size.width,
//        padding:EdgeInsets.all(8.0),
//        child:ListView.builder(
//          itemCount:stores.length,
//            itemBuilder: (BuildContext context, int index)
//            {
//              return Row(
//                children: <Widget>[
//                  Expanded(
//                      flex:4,
//                      child: Text(
//                        storeIdNameMap[stores[index].toString()],
//                          style:TextStyle(
//                              fontFamily:'Montserrat',
//                              fontSize:18.0,
//                              fontWeight:FontWeight.bold
//                          ),
//                          textAlign: TextAlign.right,
//                      )),
//                  Expanded(
//                      flex:1,
//                      child: Text(
//                        '\u20B9',
//                        style:TextStyle(
//                            fontFamily:'Montserrat',
//                            fontSize:30.0,
//                            fontWeight:FontWeight.bold
//                        ),
//                        textAlign: TextAlign.right,
//                      )),
//                  Expanded(
//                      flex:4,
//                      child: RaisedButton(
////                        color:Colors.grey,
//                        onPressed:(){
//                          selectedStore = stores[index];
//                          Navigator.of(context).push<dynamic>(
//                            MaterialPageRoute<dynamic>(
//                              builder:(BuildContext context){
//                                return ShowBillsForSelectedStore();
//                              }
//                            )
//                          );
//                        },
//                        child: Text(
//                        (salePositionAtStore[stores[index]] != null)?salePositionAtStore[stores[index]].toStringAsFixed(0):'N/A',
//                            style:TextStyle(
//                              fontFamily:'Montserrat',
//                              fontSize:30.0,
//                              fontWeight:FontWeight.bold
//                            ),
//                            textAlign: TextAlign.right,
//                        ),
//                      )
//                  ),
////                  Expanded(
////                      flex:2,
////                      child: Text(
////                          walkinsAtStore[stores[index]].toString(),
////                          textAlign: TextAlign.right,
////                      ))
//                ],
//              );
//
//            })
//      ),
      getStoreSalePositionWidget(),
      getOnlineSalePositionWidget(),

    ],
    )
    )
    );
  }
}
