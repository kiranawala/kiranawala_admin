import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
//import 'show-online-sale-position.dart';
import 'ShowOrders.dart';
import 'show-home-page.dart';

import '../main.dart';
import 'show-online-orders.dart';
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


//String year;
//String month;
//String day;
//num orderCount = 0.0;
List<dynamic> orderList = new List<dynamic>();
String store;
String fetchStatus = 'Fetching Orders....';
  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    selectedOnlineOrderDate = DateFormat('ddMMMyyyy').format(now);
    selectedOnlineOrderDateAsDDMMYYYY = DateFormat('ddMMyyyy').format(now);
    var maxDateForCalendar = DateFormat('yyyy-MM-dd').format(now);
    onlineOrderDateDay = selectedOnlineOrderDateAsDDMMYYYY.substring(0,2);
    onlineOrderDateMonth = selectedOnlineOrderDateAsDDMMYYYY.substring(2,4);
    onlineOrderDateYear = selectedOnlineOrderDateAsDDMMYYYY.substring(4,8);
    

    // selectedOrderDate = '16Oct2019';
    print(selectedOnlineOrderDate);

    listOfManagedStores.forEach((managedStore){
      print(managedStore);
      store = managedStore.toString();
    });
    print(store);

    totalOrdersForDate(selectedOnlineOrderDate);

//      FirebaseDatabase.instance
//        .reference()
//        .child('stores')
//        .child(store)
//        .child('onlineOrders')
//        .child(year)
//        .child(month)
//        .child(day)
//        .once()
//        .then((snapshot) {
//            if(snapshot != null && snapshot.value != null){
//              List<dynamic> orderList = snapshot.value;
//              print(orderList);
//              orderCount = orderList.length;
//              setState(() {
//                orderCount = orderList.length;
//                fetchStatus = 'Orders:' + orderCount.toString();
//              });
//            }
//        });
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
                                          maxTime: DateTime(int.parse(onlineOrderDateYear), int.parse(onlineOrderDateMonth), int.parse(onlineOrderDateDay)),
                                          onChanged: (date) {
//                                            print('change $date');
                                          }, 
                                          onConfirm: (date) {
                                            setState(() {
                                             fetchStatus = 'Fetching orders....';
                                            });
                                            // totalSaleSoFarToday = 0.0;
                                            // totalWalkins = 0;
//                                            print(date);
                                            selectedOnlineOrderDate = DateFormat('ddMMMyyyy').format(date);
                                            selectedOnlineOrderDateAsDDMMYYYY = DateFormat('ddMMyyyy').format(date);
                                            onlineOrderDateDay = selectedOnlineOrderDateAsDDMMYYYY.substring(0,2);
                                            onlineOrderDateMonth = selectedOnlineOrderDateAsDDMMYYYY.substring(2,4);
                                            onlineOrderDateYear = selectedOnlineOrderDateAsDDMMYYYY.substring(4,8);

                                            print('ShowOrderCount:Build:onChangeDate:selectedOrderDateAsDDMMYYYY:' + selectedOnlineOrderDateAsDDMMYYYY);
                                            print('ShowOrderCount:Build:onChangeDate:year:' + onlineOrderDateYear);
                                            print('ShowOrderCount:Build:onChangeDate:month:' + onlineOrderDateMonth);
                                            print('ShowOrderCount:Build:onChangeDate:day:' + onlineOrderDateDay);

//                                            print(selectedOrderDate);
                                            totalOrdersForDate(selectedOnlineOrderDate);
                                          }, 
                                          currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text(
                  selectedOnlineOrderDate.toUpperCase(),
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
//                Navigator.push(context, MaterialPageRoute(builder:(context) {
//                  return ShowOnlineSalePosition();
//                }));
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
            ]),
          bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.arrow_back), title: Text('GO BACK')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), title: Text('SALE POSITION'))
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context){
                      return ShowHomePage();
                    }));
                    break;
                  case 1:
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context){
                      return ShowTerminalWiseSalePosition();
                    }));
                    break;
                }
              }),
    );    
  }

  totalOrdersForDate(selectedOrderDate)
  {
    print('ShowOrderCount:totalOrdersForDate:selectedOrderDate:' + selectedOnlineOrderDate);
    print('ShowOrderCount:totalOrdersForDate:year:' + onlineOrderDateYear);
    print('ShowOrderCount:totalOrdersForDate:month:' + onlineOrderDateMonth);
    print('ShowOrderCount:totalOrdersForDate:day:' + onlineOrderDateDay);

     FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(store)
        .child('onlineOrders')
        .child(onlineOrderDateYear)
        .child(onlineOrderDateMonth)
        .child(onlineOrderDateDay)
        .once()
        .then((snapshot) {
          if(snapshot != null && snapshot.value != null)
            onlineOrderCount = snapshot.value.length;
          else
            onlineOrderCount = 0.0;

        setState(() {
          fetchStatus = 'Orders: ' + onlineOrderCount.toString();
          });
        });

  }
}