import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'ShowTerminalWiseSalePositionStreamBuilder.dart';
import 'check-if-admin.dart';
import 'show-admin-home-page.dart';



String saleAnalysisDate = '';
String saleAnalysisYear = '';
String saleAnalysisMonth = '';
String saleAnalysisDay = '';


String selectedOnlineOrderCustomization = 'N/A';
double selectedOnlineOrderItemCount = 0;
int selectedOnlineOrderProductCount = 0;
String WHATSAPP_URL_ONLINE_ORDER = "whatsapp://send?text=OnlineOrderDetails";

String onlineOrderDateYear;
String onlineOrderDateMonth;
String onlineOrderDateDay;
num onlineOrderCount = 0.0;
String selectedOnlineOrderDateAsDDMMYYYY = '';
String selectedOnlineStore = 'N/A';
String selectedOnlineSalePositionDateAsddMMyyyy = 'N/A';
String selectedOnlineSalePositionDay = 'N/A';
String selectedOnlineSalePositionMonth = 'N/A';
String selectedOnlineSalePositionYear = 'N/A';
String selectedOnlineSalePositionDate = 'N/A';


int onlineOrderProductCount = 0;
double onlineOrderItemCount = 0;
double onlineOrderAmount = 0;

Map<String, List> storeOnlineOrderIdsMap = new Map<String, List>();
Map<String, dynamic> orderMap = new Map<String, dynamic>();
Map<dynamic, dynamic> selectedOnlineOrderDetails = new Map<String, dynamic>();


class ShowOnlineSalePosition extends StatefulWidget {
  @override
  _ShowOnlineSalePositionState createState() => _ShowOnlineSalePositionState();
}

class _ShowOnlineSalePositionState extends State<ShowOnlineSalePosition> {
  DateTime date = DateTime.now();

  String store = '';
  String year = '';
  String month = '';
  String day = '';
  int storeCount = 0;
  int storesProcessed = 0;
  int storesAvailable = 0;
  bool retrievingOnlineSalePosition = false;

  void getOnlineOrderDetails(String store) {
    orderMap = new Map<String, dynamic>();
    print(store);
    print(selectedOnlineSalePositionDay);
    print(selectedOnlineSalePositionMonth);
    print(selectedOnlineSalePositionYear);
    print(inventoryNode);
    List<String> storeOrderIds = new List<String>();
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(inventoryNode)
        .child('onlineOrders')
        .child(selectedOnlineSalePositionYear)
        .child(selectedOnlineSalePositionMonth)
        .child(selectedOnlineSalePositionDay)
        .once()
        .then((snapshot) {
          print(snapshot);
      if (snapshot != null && snapshot.value != null) {
        Map<dynamic, dynamic> map = snapshot.value;
        map.forEach((dynamic key, dynamic value) {
          storeOrderIds.add(key.toString());
          orderMap[key.toString()] = value;
        });
        print('Order Count:' + orderMap.length.toString());
        if(this.mounted)
          {
            setState(() {

            });
          }
      } else {
        print('No Orders at the moment!!');
      }
    });
  }


  void retrieveOnlineSalePositionForSelectedDate()
  {
    getOnlineOrderDetails(inventoryNode);
  }

  @override
  void initState() {
    super.initState();
    print('ShowOnlineSalePosition:');


    DateTime now = DateTime.now();
    String salePositionDate  = DateFormat('dd-MM-yyyy').format(now);

    selectedOnlineSalePositionDay = salePositionDate.substring(0,2);
    selectedOnlineSalePositionMonth = salePositionDate.substring(3,5);
    selectedOnlineSalePositionYear  = salePositionDate.substring(6,10);

    print('ShowOnlineSalePosition:initState:year:' + salePositionDate );
    print('ShowOnlineSalePosition:initState:year:' + selectedOnlineSalePositionYear );
    print('ShowOnlineSalePosition:initState:month:' + selectedOnlineSalePositionMonth );
    print('ShowOnlineSalePosition:initState:day:' + selectedOnlineSalePositionDay );
    print('ShowOnlineSalePosition:initState:storeName:' + storeName );

    getOnlineOrderDetails(inventoryNode);
  }

  @override
  Widget build(BuildContext context) {
    if (!retrievingOnlineSalePosition) {
      return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
        body: Column(
          children:<Widget>[
            //            Text('Order Details'),
            Expanded(
              flex:2,
              child: Container(
                decoration: BoxDecoration(border: Border.all(color:Colors.white), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                height: 30.0,
                child:FlatButton(
                  color:Colors.blueGrey,
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2019, 11, 01),
                        maxTime: DateTime.now(),
                        onChanged: (date) {
                          // print('change $date');
                        },
                        onConfirm: (date) {
                          selectedOnlineSalePositionDate = DateFormat('dd-MMM-yyyy').format(date);
                          selectedOnlineSalePositionDateAsddMMyyyy = DateFormat('ddMMyyyy').format(date);
                          selectedOnlineSalePositionDay = selectedOnlineSalePositionDateAsddMMyyyy.substring(0,2);
                          selectedOnlineSalePositionMonth = selectedOnlineSalePositionDateAsddMMyyyy.substring(2,4);
                          selectedOnlineSalePositionYear = selectedOnlineSalePositionDateAsddMMyyyy.substring(4,8);
                          print(date);
                          print(selectedOnlineSalePositionDate);
                          print(selectedOnlineSalePositionYear);
                          print(selectedOnlineSalePositionMonth);
                          print(selectedOnlineSalePositionDay);
                          retrieveOnlineSalePositionForSelectedDate();
                          setState(() {

                          });
                        },
                        currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    selectedOnlineSalePositionDate.toUpperCase(),
                    style: TextStyle(color: Colors.amberAccent,
                        fontSize: 20.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
              Expanded(
                flex:20,
                child: Text(orderMap.length.toString()),
              ),
    ],),
        bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.refresh), title: Text('REFRESH')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_back), title: Text('SALE POSITION')),

            ],
            onTap: (index) {
              switch (index) {
                case 1:
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                    return ShowTerminalWiseSalePosition();
                  }));
                  break;
                case 0:
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context) {
                    return ShowOnlineSalePosition();
                  }));
                  break;
              }
            }),
      );
    }
    else {
      return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
//        drawer: new Drawer(
//          child: new ListView(children: <Widget>[
//            Divider(),
//            InkWell(
//              onTap: () {
//                Navigator.pop(context);
//                Navigator.push<dynamic>(
//                    context,
//                    MaterialPageRoute<dynamic>(
//                        builder: (context) => ShowTerminalWiseSalePosition()));
//              },
//              child: ListTile(
//                title: Text('Terminal-Wise Sales'),
//                leading: Icon(Icons.person, color: Colors.green),
//              ),
//            ),
//            Divider(),
//            Divider(),
//            InkWell(
//              onTap: () {
//                Navigator.pop(context);
//                Navigator.push<dynamic>(context,
//                    MaterialPageRoute<dynamic>(builder: (context) => ShowOrderCount()));
//              },
//              child: ListTile(
//                title: Text('Order Count'),
//                leading: Icon(Icons.person, color: Colors.green),
//              ),
//            ),
//          ]),
//        ),
        body: Container(
          child: Align(
            alignment: Alignment.center,
            child:
            Text('Retrieving Online Orders....'),

          ),
        ),
//        bottomNavigationBar: BottomNavigationBar(
//            items: [
//              BottomNavigationBarItem(
//                  icon: Icon(Icons.arrow_back), title: Text('GO BACK')),
//              BottomNavigationBarItem(
//                  icon: Icon(Icons.home), title: Text('REFRESH'))
//            ],
//            onTap: (index) {
//              switch (index) {
//                case 0:
//                  Navigator.of(context).pop();
//                  Navigator.of(context)
//                      .push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context) {
//                    return ShowOnlineSalePosition();
//                  }));
//                  break;
//                case 1:
//                  Navigator.of(context).pop();
//                  Navigator.of(context)
//                      .push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context) {
//                    return ShowOrderCount();
//                  }));
//                  break;
//              }
//            }),
      );
    }
  }
}
