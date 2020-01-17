import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart';

import 'nila-point-of-sale.dart';

class ShowFinalBill extends StatefulWidget {
  @override
  _ShowFinalBillState createState() => _ShowFinalBillState();
}

class _ShowFinalBillState extends State<ShowFinalBill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon:Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.of(context).pop();
              },
            );
        },
        ),      
        centerTitle: true,
        title: Text(
          'Final Bill',
          style: TextStyle(
            color:Colors.white,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 14.0,            
          ),
        ),      
    ),
    body:
    Center(
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'PRODUCT COUNT:',
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
              ),
            Expanded(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  productCount.toString(),
                  textAlign: TextAlign.right,
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],),
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ITEM COUNT:',
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
              ),
            Expanded(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  itemCount.toString(),
                  textAlign: TextAlign.right,
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],),
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'FINAL BILL',
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
              ),
              ),
            Expanded(
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  cartTotal.toString(),
                  textAlign: TextAlign.right,
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],),          
          Container(
            width:MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color:Colors.lightBlue,
                onPressed: (){

                    DateTime now = DateTime.now();
                    String dateString  = DateFormat('yyyy-MM-dd').format(now);
                    selectedSaleStartDate = DateFormat('yyyy-MM-dd').format(now);
                    selectedSaleEndDate = DateFormat('yyyy-MM-dd').format(now);

                    String billYear = dateString.substring(0,4);
                    String billMonth = dateString.substring(5,7);
                    String billDay  = dateString.substring(8,10);
                    String billDate = billDay + billMonth + billYear;
                    print(billDate);

                    String billTime = DateFormat('HHmmss').format(DateTime.now()).toString();    
                    String posID = 'MPOS_2';
                    String billID = posID + '_' + billDate + '_' + billTime;
                    print(billID);

                    invoiceEntry['billID'] = billID;
                    invoiceEntry['billDate'] = billDate;
                    invoiceEntry['billTime'] = billTime;
                  
                    FirebaseDatabase
                      .instance
                      .reference()
                      .child('storeTerminals')
                      .child('MPOS_2')
                      .child('sales')
                      .child(billYear)
                      .child(billMonth)
                      .child(billDay)
                      .child('bills')
                      .child(billID)
                      .update(invoiceEntry);


                  FirebaseDatabase
                  .instance
                  .reference()
                  .child('storeTerminals')
                  .child('MPOS_2')
                  .child('sales')
                  .child(billYear)
                  .child(billMonth)
                  .child(billDay)
                  .child('totalSale')
                  .once()
                  .then((snapshot){
                    double totalSale = 0.0;
                    if(snapshot != null && snapshot.value != null)
                    {
                      print(snapshot.value.toString());
                      totalSale = double.parse(snapshot.value.toString());
                      print('Total Sale Before:' + totalSale.toString());
                    }
                    
                    double updatedTotalSale = totalSale + invoiceEntry['billAmount'];  
                    print('Updated Sale:' + updatedTotalSale.toString());

                    FirebaseDatabase
                      .instance
                      .reference()
                      .child('storeTerminals')
                      .child('MPOS_2')
                      .child('sales')
                      .child(billYear)
                      .child(billMonth)
                      .child(billDay)
                      .update({
                        'totalSale': updatedTotalSale
                        });
                  });

                  productCodeCartEntryMap.clear();
                  cartEntries.clear();
                  cartTotal = 0.0;
                  itemCount = 0.0;
                  productCount = 0;
                  carryBagRequested = false;

                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                    return NilaPointOfSale();
                  }));

                          
                },
                child: Text(
                  'CONFIRM',
                  style:TextStyle(
                    color:Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),),
            ),
          ),
          Container(
            width:MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color:Colors.lightBlue,
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                    return NilaPointOfSale();
                  }));
                },
                child: Text(
                  'CONTINUE SHOPPING',
                  style:TextStyle(
                    color:Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  )),),
            ),
          )
        ],

      )
      ),
    );
  }
}