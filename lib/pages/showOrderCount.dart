import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/ShowOrders.dart';

import '../main.dart';
import 'ShowTerminalWiseSalePositionStreamBuilder.dart';

class OrderedProduct{
  num orderQty;
  String productCode;
  String productBarCode;
  String productImageURL;
  String productName;
  num productPrice;
}

class ShippingAddress {
  String fullAddress;
  String landmark;
  String locality;
}


class OrderDetails{
String itemCount;
String orderAmount;
String orderTime;
String orderDate;
String productCount;
List<OrderedProduct> orderedProducts;
ShippingAddress shippingAddress;
}

class ShowOrderCount extends StatefulWidget {
  @override
  _ShowOrderCountState createState() => _ShowOrderCountState();
}

class _ShowOrderCountState extends State<ShowOrderCount> {

String year;
String month;
String day;
num orderCount = 0.0;
String fetchStatus = 'Fetching Orders....';
  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    selectedOrderDate = DateFormat('ddMMMyyyy').format(now);
     var maxDateForCalendar = DateFormat('yyyy-MM-dd').format(now);
    year = maxDateForCalendar.substring(0,4);
    month = maxDateForCalendar.substring(5,7);
    day = maxDateForCalendar.substring(8,10);
    

    // selectedOrderDate = '16Oct2019';
    print(selectedOrderDate);

      FirebaseDatabase.instance
        .reference()
        .child('orders')
        .orderByChild('orderDate')
        .equalTo(selectedOrderDate)
        .once()
        .then((snapshot) {
          // print(snapshot.value);
          print(snapshot.value.length);
          setState(() {
           orderCount = snapshot.value.length;
           fetchStatus = 'Orders:' + orderCount.toString();
          });
        });
  }
  @override
  Widget build(BuildContext context) {   
        return Scaffold(
            resizeToAvoidBottomPadding: true,
           appBar: AppBar(
          title: const Text(
            'ONLINE ORDERS',
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
                          ShowOrders()));
            },
            child: ListTile(
              title: Text('Orders'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),     
        ]),
      ),
            body:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
             FlatButton(
                onPressed: () {
                    DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(2019, 9, 28),
                                          maxTime: DateTime(int.parse(year), int.parse(month), int.parse(day)), 
                                          onChanged: (date) {
                                            print('change $date');
                                          }, 
                                          onConfirm: (date) {
                                            setState(() {
                                             fetchStatus = 'Fetching orders....';
                                            });
                                            // totalSaleSoFarToday = 0.0;
                                            // totalWalkins = 0;
                                            print(date);
                                            selectedOrderDate = DateFormat('ddMMMyyyy').format(date);
                                            print(selectedOrderDate);                                            
                                            totalOrdersForDate(selectedOrderDate);                                                                                    
                                          }, 
                                          currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text(
                    selectedOrderDate.toUpperCase(),
                    style: TextStyle(color: Colors.blue,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
              child: Container(
                child:Center(
                  child: Text(
                    fetchStatus  ,
                    style: TextStyle(color: Colors.blue,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),                
                    // orderCount.toString(),
                  ),)
            ,))
            ,
            RaisedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder:(context) {
                  return ShowOrders();
                }));
              },
              color: Colors.blue,
              child:Text(
                'SHOW ORDERS',
                style: TextStyle(color: Colors.white,
                      fontSize: 14.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
              )
            ,)
            ])
    );    
  }

  totalOrdersForDate(selectedOrderDate)
  {
     FirebaseDatabase.instance
        .reference()
        .child('orders')
        .orderByChild('orderDate')
        .equalTo(selectedOrderDate)
        .once()
        .then((snapshot) {
        if(snapshot != null && snapshot.value != null)
          orderCount = snapshot.value.length;          
        else
          orderCount = 0.0;
          
        setState(() {
          fetchStatus = 'Orders: ' + orderCount.toString();
          });
        });

  }
}