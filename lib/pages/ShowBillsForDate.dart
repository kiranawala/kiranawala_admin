import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/ShowBilledProducts.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'ShowTerminalWiseSalePositionStreamBuilder.dart';

class ShowBillsForDate extends StatefulWidget {
  @override
  _ShowBillsForDateState createState() => _ShowBillsForDateState();
}

List<String> orderIds = new List<String>();
List<dynamic> billList = [];
List<Widget> billWidgetList = [];
bool refreshingData = false;
String totalSaleAsString = '00.00';
String totalWalkinsAsString = '0';
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


  getTotalSaleAndWalkinsForDate(){

    print('getting Fresh Data');
    salePerTerminal = [];
      FirebaseDatabase.instance.
          reference().
          child('storeTerminals').
          child(selectedPOSTerminal).
          child('sales').
          child(year).
          child(month).
          child(day).
          child('totalSale').
          once().
          then((totalSaleSnapshot){
            if (totalSaleSnapshot != null && totalSaleSnapshot.value != null) {         
              FirebaseDatabase.instance.
                reference().
                child('storeTerminals').
                child(selectedPOSTerminal).
                child('sales').
                child(year).
                child(month).
                child(day).
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


  getBillsForDate()
  {
    billWidgetList = [];
    billList = [];
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
      .orderByChild('billTime')
      .once()
      .then((snapshot){
        if(snapshot != null && snapshot.value != null)
        {
          print(snapshot.value);
          print(snapshot.value.length);          
          Map<dynamic,dynamic> map = snapshot.value;
          map.forEach((key,value){
            // print(value);
            print(key);
            billList.add({
              'billTime':value['billTime'],
              'billAmount':value['billAmount'],
              'productCount':value['productCount'],
              'itemCount':value['itemCount']
            });
          });
          print(billList);
          billList.sort((a,b){return b['billTime'].compareTo(a['billTime']);});
          print(billList);
          billList.forEach((bill){
             billWidgetList.add(

              InkWell(
                onTap:(){
                  selectedBillTime = bill['billTime'];
                  selectedBillProductCount = int.parse(bill['productCount'].toString());
                  selectedBillItemCount = double.parse(bill['itemCount'].toString());
                  selectedBillAmount = double.parse(bill['billAmount'].toString());
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>
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
            // lastUpdateTimeStampAsString = DateTime.now().toString();
            lastUpdateTimeStampAsString = DateFormat('yyyyMMMdd:hhmmss').format(DateTime.now()).toString();
            // int lastUpdateTimeStamp = DateTime.now().millisecondsSinceEpoch;
            // lastUpdateTimeStampAsString = lastUpdateTimeStamp.toString();
          });             
        }      
      });
  }
  @override
  Widget build(BuildContext context) {

    if(!refreshingData)
    return Scaffold(
        resizeToAvoidBottomPadding: true,
    appBar: AppBar(
          title: Text(
            posTerminalStoreNameMapping[selectedPOSTerminal],
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
              body:Column(
                              children: <Widget>[
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
                                                                      selectedSaleDate = DateFormat('yyyy-MM-dd').format(date);
                                                                      year = selectedSaleDate.substring(0,4);
                                                                      month = selectedSaleDate.substring(5,7);
                                                                      day = selectedSaleDate.substring(8,10);
                                                                      print(date);
                                                                      print(selectedSaleDate);
                                                                      print(year);
                                                                      print(month);
                                                                      print(day);                                            
                                                                      setState(() {});
                                                                    }, 
                                              currentTime: DateTime.now(), locale: LocaleType.en);
                                          },
                                          child: Text(
                                              selectedSaleDate.toUpperCase(),
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
                                            getBillsForDate();              
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
                                        lastUpdateTimeStampAsString,
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
                                Container(
                                  height:400.0,
                                  child: Align(
                                  alignment: Alignment.center,
                                  child:ListView(
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
                              )
                            ),
                              ],
              ),        
      );
      else       
      return Scaffold(
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
      );   
    }
}