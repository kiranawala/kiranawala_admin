import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/main.dart' as prefix0;
import 'package:kiranawala_admin/pages/send-bill-to-whatsapp.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';

import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import 'ShowTerminalWiseSalePositionStreamBuilder.dart';

class ShowBilledProducts extends StatefulWidget {
  @override
  _ShowBilledProductsState createState() => _ShowBilledProductsState();
}

List<String> orderIds = new List<String>();
List<dynamic> billedProductList = [];
List<Widget> billedProductWidgetList = [];

class _ShowBilledProductsState extends State<ShowBilledProducts> {

  @override
  void initState() {
    super.initState();
    orderIds = [];
    print('ShowBilledProducts:initState()');
    getBilledProducts();    
  }

  getBilledProducts()
  {
    var billId = selectedPOSTerminal + '_' + day + month + year + '_' + selectedBillTime;
    print(billId);
    billedProductWidgetList = [];
    billedProductList = [];
    billAsString = '';
    billAsString = billAsString + 'Final Bill:' + '\t' + selectedBillAmount.toString() + '\n';
    billAsString = billAsString + 'No. Of Products:' + '\t' + selectedBillProductCount.toString() + '\n';
    billAsString = billAsString + 'No. Of Items:' + '\t' + selectedBillItemCount.toString() + '\n';
    FirebaseDatabase
      .instance
      .reference()
      .child('storeTerminals')
      .child(selectedPOSTerminal)
      .child('sales')
      .child(year)
      .child(month)
      .child(day)
      .child('bills')
      .child(billId)
      .child('billedProducts')
      .once()
      .then((snapshot){
        if(snapshot != null && snapshot.value != null)
        {
          print(snapshot.value);
          print(snapshot.value.length);
          List<dynamic> billedProducts = snapshot.value;
          billedProducts.forEach((billedProduct){

            billedProductList.add({
              'name':billedProduct['productName'],
              'price':billedProduct['productPrice'],
              'qty':billedProduct['productBilledQty'],
              'amount':billedProduct['productBillAmount']
            });

            // if(billedProduct['productName'].toString().length > 16 )
            // {
            // billAsString = billAsString 
            //                   + billedProduct['productName'].substring(0,16) + '\t' 
            //                   + billedProduct['productPrice'].toString() + '\t' 
            //                   + billedProduct['productBilledQty'].toString() + '\t' 
            //                   + billedProduct['productBillAmount'] + '\n';
            // }
            // else
            // {
              billAsString = billAsString 
                              + billedProduct['productName'] + '\t' 
                              + billedProduct['productPrice'].toString() + '\t' 
                              + billedProduct['productBilledQty'].toString() + '\t' 
                              + billedProduct['productBillAmount'].toString() + '\n';
            // }
          });

          print(billedProductList);
        
          billedProductList.forEach((billedProduct){
             billedProductWidgetList.add(
              Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(children: <Widget>[
                    Expanded(
                      flex:8,
                      child:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          Text(
                            billedProduct['name'],
                            textAlign: TextAlign.right,
                          )
                        )
                    ),
                    Expanded(
                      flex:3,      
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text(
                          billedProduct['price'].toString(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Expanded(
                      flex:2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text(
                          billedProduct['qty'].toString(),
                          textAlign: TextAlign.right,
                          )
                        )                  
                    ),
                      Expanded(
                      flex:3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text(
                          billedProduct['amount'].toString(),
                          textAlign: TextAlign.right,
                          )
                        )                  
                    ),
                  ],
            ),
                ),
            );
          });

          
          setState(() {            
          });             
        }      
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
    appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context){
                     return SendBillToWhatsapp(); 
                    }
                  ));
                // FlutterOpenWhatsapp.sendSingleMessage("+919849494143", billAsString);
              },
            )
          ],
          title: const Text(
            'Billed Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        drawer: new Drawer(
        child: new ListView(children: <Widget>[       
          Divider(),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShowTerminalWiseSalePosition()));
            },
            child: ListTile(
              title: Text('Terminal-Wise Sales'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),
          Divider(),    
            Divider(),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShowOrderCount()));
            },
            child: ListTile(
              title: Text('Online Orders'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),     
        ]),
      ),
              body:Container(
          child: Align(
            alignment: Alignment.center,
            child:ListView(
                            children: <Widget>[
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 8.0),
                              //   child: Center(
                              //         child:Row(children: <Widget>[
                              //   Expanded(
                              //     child:Padding(padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       'TIME',
                              //       textAlign: TextAlign.right,
                              //       )
                              //     ),  ),        
                              //   Expanded(
                              //     child:Padding(padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       'AMOUNT',
                              //       textAlign: TextAlign.right,
                              //     ),
                              //     )
                                  
                              //   ),
                              //   Expanded(
                              //     child:Padding(padding: const EdgeInsets.all(8.0),
                              //     child: Text(
                              //       'PRODUCTS',
                              //       textAlign: TextAlign.right,
                              //       )
                              //     ),
                              //   ),                                                   
                              // ],)),
                              // ),
                              Divider(
                                height: 5.0,
                              ),
                              Column(
                                children: billedProductWidgetList,
                              ),                             
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
          )
        ),
      );
    }
}