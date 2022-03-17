import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'ShowOrders.dart';
import 'showOrderCount.dart';
//import 'package:kiranawala/main.dart';
//import 'check-if-admin.dart';

import 'ShowTerminalWiseSalePositionStreamBuilder.dart';

class ShowProductWiseSalePosition extends StatefulWidget {
  @override
  _ShowProductWiseSalePositionState createState() => _ShowProductWiseSalePositionState();
}

class _ShowProductWiseSalePositionState extends State<ShowProductWiseSalePosition> {
  // Map<dynamic, dynamic> categoryList = {};
  Map<dynamic,dynamic> productSalePositionMap = Map<dynamic, dynamic>();
  // List<Map> ProductWiseSale = [];
  List<String> productList = [];
  bool refreshingData = false;
  String lastUpdatedTimeStampAsString = '';


List<dynamic> billList = List<dynamic>();
List<Widget> productSaleWidgetList = [];

 void getTotalSaleAndWalkinsForDate(){

    print('getting Fresh Data');
    salePerTerminal = [];
      FirebaseDatabase.instance.
          reference().
          child('storeTerminals').
          child(selectedPOSTerminal).
          child('sales').
          child(saleAnalysisYear).
          child(saleAnalysisMonth).
          child(saleAnalysisDay).
          child('totalSale').
          once().
          then((totalSaleSnapshot){
            if (totalSaleSnapshot != null && totalSaleSnapshot.value != null) {         
              FirebaseDatabase.instance.
                reference().
                child('storeTerminals').
                child(selectedPOSTerminal).
                child('sales').
                child(saleAnalysisYear).
                child(saleAnalysisMonth).
                child(saleAnalysisDay).
                child('totalWalkins').
                once().
                then((totalWalkinsSnapshot){
                  if (totalWalkinsSnapshot != null && totalWalkinsSnapshot.value != null) {     
                    totalSale = double.parse(totalSaleSnapshot.value.toString());
                    totalSaleAsString = totalSale.toStringAsFixed(0);

                    totalWalkins = totalWalkinsSnapshot.value;
                    totalWalkinsAsString = totalWalkins.toStringAsFixed(0);
                    setState(() {
                      print(totalSaleAsString);
                      print(totalWalkinsAsString);
                    });
                  }
                });
            }
          });
           setState(() {
            print(totalSaleAsString);
            print(totalWalkinsAsString);
            });
  }

 void getProductSalePositionForDate()
  {
    productSaleWidgetList = [];
    productList = [];
    FirebaseDatabase.instance
      .reference()
      .child('storeTerminals')
      .child(selectedPOSTerminal)
      .child('sales')
      .child(saleAnalysisYear)
      .child(saleAnalysisMonth)
      .child(saleAnalysisDay)
      .child('productSalePosition')
      .once()
      .then((snapshot){
        if(snapshot != null && snapshot.value != null)
        {
          print(snapshot.value);
          print(snapshot.value.length);          
          Map<dynamic,dynamic> productSalePositionMap = snapshot.value;
          productSalePositionMap.forEach((dynamic key,dynamic value){
            // print(value);
            print(key);
            productList.add(key);
          });
          print(productList);
          productList.sort((b,a){return productSalePositionMap[a]['salePosition'].compareTo(productSalePositionMap[b]['salePosition']);});
          print(productList);
          productList.forEach((product){
             productSaleWidgetList.add(
              InkWell(
                onTap:(){                 
                },
                child: Container(
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
                      flex:12,
                      child:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          Text(
                            productSalePositionMap[product]['productDetails']['productName'].toString(),
                            textAlign: TextAlign.left,
                          )
                        )
                    ),
                    Expanded(
                      flex:2,
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text(
                          productSalePositionMap[product]['salePosition'].toString(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),                   
                  ],
            ),
                ),
              ),
            );
          });
          
          setState(() {   
            refreshingData = false;   
            lastUpdatedTimeStampAsString = DateFormat('yyyyMMMdd:hhmmss').format(DateTime.now()).toString();      
          });             
        }      
      });
  }

@override
  void initState()
  {
    super.initState(); 
    print('ShowProductWiseSalePosition:');
    print(storeTerminals_List);
    print(isAdmin.toString());
    getTotalSaleAndWalkinsForDate();
    getProductSalePositionForDate();    

    
    // FirebaseDatabase.instance
    //                   .reference()
    //                   .child('storeTerminals')
    //                   .child('POS_1')
    //                   .child('sales')
    //                   .child(year)
    //                   .child(month)
    //                   .child(day)
    //                   .child('categorySalePosition')
    //                   .once()
    //                   .then((categorySalePosition){
    //                     if(categorySalePosition != null && categorySalePosition.value != null)
    //                     {
    //                       print(categorySalePosition.value);
    //                       categoryList = categorySalePosition.value;
    //                       categoryList.forEach((category, details){
    //                         print(category + ' ' + details['totalSale'].toString());
    //                         ProductWiseSale.add({'category':category,'totalSale':details['totalSale']}); 
    //                       });
    //                       print(categoryList);                          
    //                     }
    //                     setState(() {
                          
    //                     });
    //                   });
    // terminalsAtStore.forEach((storeTerminal){
    //     salePerTerminal.add(
    //                         Container(
    //                           child:Row(children: <Widget>[
    //                             Text(storeTerminal),
    //                             Text('0.0'),
    //                             Text('0'),
                                
    //                           ],)
    //                         ));                    
    // });
    
    refreshingProductWiseSales = true;
    // getFreshData();
  }

  void orderBySaleValue()
  {
      productList = [];
      productSalePositionMap.forEach((dynamic key,dynamic value){
        productList.add(key);
      });
      print(productList);
      productList.sort((a, b){
                                return productSalePositionMap[a]['salePosition'].compareTo(productSalePositionMap[b]['salePosition']);
                              });
      print(productList);
      setState(() {
            refreshingData = false;   
            lastUpdatedTimeStampAsString = DateFormat('yyyyMMMdd:hhmmss').format(DateTime.now()).toString();
      });
  }

  @override
  Widget build(BuildContext context) {
   return WillPopScope(
     onWillPop: (){
       Navigator.of(context).pop();
       Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
           builder: (BuildContext context){
             return ShowTerminalWiseSalePosition();
           }
       ));
       return;
     },
   child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'PRODUCT-WISE DAILY SALES',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                  builder: (BuildContext context){
                    return ShowTerminalWiseSalePosition();
                  }
              ));
            },
          ),
        ),
        drawer: new Drawer(
        child: new ListView(children: <Widget>[       
          Divider(),
          InkWell(
            onTap: () {
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (context) =>
                          ShowOrders()));
            },
            child: ListTile(
              title: Text('Online Orders'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),
          Divider(),   
            Divider(),
          InkWell(
            onTap: () {
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (context) =>
                          ShowOrderCount()));
            },
            child: ListTile(
              title: Text('Order Count'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),      
        ]),
      ),
      body:
      Container(
        child:  
        Column(
          children:<Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                        height: 30.0,
                                        child:FlatButton(
                                          onPressed: () {
                                              DatePicker.showDatePicker(context,
                                                                    showTitleActions: true,
                                                                    minTime: DateTime(2019, 11, 01),
                                                                    maxTime: DateTime.now(), 
                                                                    onChanged: (date) {
                                                                      print('change $date');
                                                                    }, 
                                                                    onConfirm: (date) {
                                                                      saleAnalysisDate = DateFormat('yyyy-MM-dd').format(date);
                                                                      saleAnalysisYear = saleAnalysisDate.substring(0,4);
                                                                      saleAnalysisMonth = saleAnalysisDate.substring(5,7);
                                                                      saleAnalysisDay = saleAnalysisDate.substring(8,10);
                                                                      print(date);
                                                                      print(saleAnalysisDate);
                                                                      print(saleAnalysisYear);
                                                                      print(saleAnalysisMonth);
                                                                      print(saleAnalysisDay);
                                                                      setState(() {});
                                                                    }, 
                                              currentTime: DateTime.now(), locale: LocaleType.en);
                                          },
                                          child: Text(
                                            saleAnalysisDate.toUpperCase(),
                                              style: TextStyle(color: Colors.blue,
                                                fontSize: 14.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color:Colors.white), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                        height: 30.0,
                                        child:FlatButton(
                                          color:Colors.blue,
                                          onPressed: () {                    
                                            print('Refreshing Data...');                                              
                                            setState(() {
                                              refreshingData = true;
                                            });
                                            getTotalSaleAndWalkinsForDate();
                                            getProductSalePositionForDate();              
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Refresh',
                                              style: TextStyle(color: Colors.white,
                                              fontSize: 8.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold),
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
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                        height: 30.0,
                                        child:Text(
                                            'Rs.' + totalSaleAsString + '/-',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.blue,
                                              fontSize: 14.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                        height: 30.0,
                                        child:Text(
                                            productSaleWidgetList.length.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.blue,
                                              fontSize: 14.0,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Container(
                                      height:30.0,
                                      child:Text(
                                        'Last Updated at:',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blue,
                                          fontSize: 12.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                      ),
                                  ),
                                  Expanded(
                                      child: Container(
                                      height:30.0,
                                      child:Text(
                                        lastUpdatedTimeStampAsString,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blue,
                                          fontSize: 12.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                      ),
                                  ),

                                ],),
            Expanded(
              flex:50,
              child: Container(
                                  height:400.0,
                                  child: Align(
                                  alignment: Alignment.center,
                                  child:ListView(
                                    children: <Widget>[
                                                Divider(
                                                  height: 5.0,
                                                ),
                                                Column(
                                                  children: productSaleWidgetList,
                                                ),                             
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                              ],
                                            ),
                              )
                            ),
            ),                
          ]         
      )
    )
  ));
  }
}