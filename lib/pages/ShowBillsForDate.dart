import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'ShowBilledProducts.dart';
import 'showOrderCount.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'ShowTerminalWiseSalePositionStreamBuilder.dart';

class ShowBillsForDate extends StatefulWidget {
  @override
  _ShowBillsForDateState createState() => _ShowBillsForDateState();
}

List<String> orderIds = new List<String>();
List<dynamic> billList = <dynamic>[];
List<Widget> billWidgetList = [];
bool refreshingData = false;
String lastUpdateTimeStampAsString;

class _ShowBillsForDateState extends State<ShowBillsForDate> {

  @override
  void initState() {
    super.initState();
    orderIds = [];
    print('ShowBillsForDate:initState()');
    refreshingData = true;
    getTotalSaleAndWalkinsForDate();
    getBillsForDate();    
  }


void getTotalSaleAndWalkinsForDate(){

    print('getting Fresh Data');
    salePerTerminal = [];
      FirebaseDatabase.instance.
          reference().
          child('storeTerminals').
          child('POS_11').
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
                child('POS_11').
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


  void getBillsForDate()
  {
    billWidgetList = [];
    billList = <dynamic>[];
    FirebaseDatabase
      .instance
      .reference()
      .child('storeTerminals')
      .child('POS_11')
      .child('sales')
      .child(saleAnalysisYear)
      .child(saleAnalysisMonth)
      .child(saleAnalysisDay)
      .child('bills')
      .orderByChild('billTime')
      .once()
      .then((snapshot){
        if(snapshot != null && snapshot.value != null)
        {

          Map<dynamic,dynamic> map = snapshot.value;
          map.forEach((dynamic key,dynamic value){
            billList.add(<dynamic, dynamic>{
              'billTime':value['billTime'],
              'billAmount':value['billAmount'],
              'productCount':value['productCount'],
              'itemCount':value['itemCount']
            });
          });
          billList.sort((dynamic a,dynamic b){return b['billTime'].compareTo(a['billTime']);});
          billList.forEach((dynamic bill){
             billWidgetList.add(

              InkWell(
                onTap:(){
                  selectedBillTime = bill['billTime'];
                  selectedBillProductCount = int.parse(bill['productCount'].toString());
                  selectedBillItemCount = double.parse(bill['itemCount'].toString());
                  selectedBillAmount = double.parse(bill['billAmount'].toString());
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context)=>
                      ShowBilledProducts()
                  ));
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
                      flex:8,
                      child:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                          Text(
                            bill['billTime'],
                            textAlign: TextAlign.right,
                          )
                        )
                    ),
                    Expanded(
                      flex:8,      
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text(
                          bill['billAmount'].toString(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                    Expanded(
                      flex:3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text(
                          bill['productCount'].toString(),
                          textAlign: TextAlign.right,
                          )
                        )                  
                    ),                 
                     Expanded(
                      flex:5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text(
                          bill['itemCount'].toString(),
                          textAlign: TextAlign.right,
                          )
                        )                  
                    ),                 
                  ],
            ),
                ),
              ),
            );
          });
          
          setState(() {         
            refreshingData = false;   
            lastUpdateTimeStampAsString = DateFormat('yyyyMMMdd:hhmmss').format(DateTime.now()).toString();
          });
        }      
      });
  }
  @override
  Widget build(BuildContext context) {

    if(!refreshingData)
      return
        WillPopScope(
            onWillPop:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                return ShowTerminalWiseSalePosition();
              }));
              return;
            },
            child:  Scaffold(
        resizeToAvoidBottomPadding: true,
    appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading:IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
            ),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                return ShowTerminalWiseSalePosition();
              }));
            },
          ),
          title: Text(
//            storeName,
          'JUSTGROCERY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
              body:Column(
                              children: <Widget>[
                                Expanded(
                                  flex:2,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex:2,
                                        child: FlatButton(
                                          color:Colors.grey,
                                          onPressed: () {
                                              DatePicker.showDatePicker(context,
                                                                    showTitleActions: true,
                                                                    minTime: DateTime(2019, 11, 01),
                                                                    maxTime: DateTime.now(),
                                                                    onChanged: (date) {
                                                                      print('change $date');
                                                                    },
                                                                    onConfirm: (date) {
                                                                      saleAnalysisDate = DateFormat('dd-MM-yyyy').format(date);
                                                                      saleAnalysisDay = saleAnalysisDate.substring(0,2);
                                                                      saleAnalysisMonth = saleAnalysisDate.substring(3,5);
                                                                      saleAnalysisYear = saleAnalysisDate.substring(6,10);
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
                                              style: TextStyle(color: Colors.white,
                                                fontSize: 14.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all(color:Colors.white), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                          child:FlatButton(
                                            color:Colors.blue,
                                            onPressed: () {
                                              print('Refreshing Data...');
                                              setState(() {
                                                refreshingData = true;
                                              });
                                              getTotalSaleAndWalkinsForDate();
                                              getBillsForDate();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Refresh',
                                                style: TextStyle(color: Colors.white,
                                                fontSize: 14.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                Expanded(
                                  flex:2,
                                  child: Row(
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
                                              totalWalkinsAsString,
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
                                ),
                                Expanded(
                                  flex:2,
                                  child: Row(children: <Widget>[
                                    Expanded(
                                        child: Container(
                                        height:30.0,
                                        child:Text(
                                          'Last Updated at:',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.blue,
                                            fontSize: 14.0,
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
                                          lastUpdateTimeStampAsString,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.blue,
                                            fontSize: 14.0,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold
                                          ),
                                        )
                                        ),
                                    ),

                                  ],),
                                ),
                                Expanded(
                                  flex:30,
                                  child: ListView(
                                    children: <Widget>[
                                                Divider(
                                                  height: 5.0,
                                                ),
                                                Column(
                                                  children: billWidgetList,
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                              ],
                                            ),
                                ),
                              ],
              ),
//      bottomNavigationBar: BottomNavigationBar(
//          items: [
//            BottomNavigationBarItem(
//                icon: Icon(Icons.arrow_back), title: Text('GO BACK')),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.home), title: Text('HOME'))
//          ],
//          onTap: (index) {
//            switch (index) {
//              case 0:
//                Navigator.of(context).pop();
//                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                  return ShowTerminalWiseSalePosition();
//                }));
//                break;
//              case 1:
//                Navigator.of(context).pop();
//                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                  return ShowHomePage();
//                }));
//                break;
//            }
//          }),
      ));
      else
      return
        WillPopScope(
        onWillPop:(){
      Navigator.of(context).pop();
      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
        return ShowTerminalWiseSalePosition();
      }));
      return;
    },
    child:   Scaffold(
        resizeToAvoidBottomPadding: true,
    appBar: AppBar(
          title: const Text(
            'BILLS',
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
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
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
              Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
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
      body: Container(
        color: Colors.white,
        child: Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Getting Bills....."),
            ],
          ),
        ),
      )
      ));
    }
}