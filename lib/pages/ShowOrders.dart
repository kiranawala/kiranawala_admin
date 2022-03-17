import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'showOrderCount.dart';

import 'ShowTerminalWiseSalePositionStreamBuilder.dart';

class ShowOrders extends StatefulWidget {
  @override
  _ShowOrdersState createState() => _ShowOrdersState();
}

List<String> orderIds = new List<String>();

class _ShowOrdersState extends State<ShowOrders> {

  @override
  void initState() {
    super.initState();
    orderIds = [];
    FirebaseDatabase
      .instance
      .reference()
      .child('orders')
      .orderByChild('orderDate')
      .equalTo(selectedOnlineOrderDate)
      .once()
      .then((snapshot){
        if(snapshot != null && snapshot.value != null)
        {
          // print(snapshot.value);
          // print(snapshot.value.length);          
          Map<dynamic,dynamic> map = snapshot.value;
          map.forEach((key,value){
            // print(value);
            print(key);
          });
             
        }
        else
        {
          print('no orders!!');
        }
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
                          ShowOrderCount()));
            },
            child: ListTile(
              title: Text('Order Count'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),     
        ]),
      ),
        body:Container(
          child: Align(
            alignment: Alignment.center,
            child: new StreamBuilder(
              builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null &&
                      snapshot.data.snapshot.value != null) {
                        print(snapshot.data.snapshot.value);
                        Map<dynamic,dynamic> map = snapshot.data.snapshot.value;
                        map.forEach((key,value){
                          orderIds.add(key);
                          print('map.value:');
                          print(value);
                          print('map.key:');                          
                          print(key);
                        });
                        print('Before Sorting:orderIds:');
                        print(orderIds);
                        orderIds.sort((a,b){return b.compareTo(a);});
                        print('After Sorting:orderIds:');
                        print(orderIds);
                    // List<dynamic> orderIds = snapshot.data.snapshot.value;
                    print('map:OrderIds:See Below');
                    print(orderIds);
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        print('ListView.builder:' + orderIds[index]);
                        return new StreamBuilder(
                          builder: (BuildContext context,
                              AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data != null &&
                                  snapshot.data.snapshot.value != null && snapshot.data.snapshot.value['orderedProducts'] != null) {
                                //return Text(orderIds[index]);
                                Map<dynamic, dynamic> orderDetails = new Map();
                                orderDetails = snapshot.data.snapshot.value;
                                print('orderDetails:See Below');
                                print(orderDetails);
                                List<dynamic> orderedProducts =
                                    orderDetails['orderedProducts'];                                    
                                print('orderedProducts:See Below');
                                print(orderedProducts);

                                // if(orderDetails['shippingAddress'] != null){
                                //   Map<dynamic,dynamic> shippingAddress = orderDetails['shippingAddress'];
                                // }
                                
                                // print('shippingAddress:See Below');
                                // print(shippingAddress);

                                // print(shippingAddress['fullAddress']);
                                // print(shippingAddress['landmark']);
                                // print(shippingAddress['locality']);

                                print(orderDetails['orderDate']
                                              .toString()
                                              .toUpperCase());
                                print(orderDetails['orderAmount']);
                                print(orderDetails['itemCount']);
                                print(orderDetails['productCount']);

                                var firstName = '';
                                var lastName = '';
                                var mobileNumber = '';

                                var fullAddress = '';
                                var locality = '';
                                var landmark = '';

                                if(orderDetails['personalDetails'] != null)
                                {
                                  firstName = orderDetails['personalDetails']['firstName'];
                                  lastName = orderDetails['personalDetails']['lastName'];
                                  mobileNumber = orderDetails['personalDetails']['mobileNumber'];
                                }

                                if(orderDetails['shippingAddress'] != null){
                                  fullAddress = orderDetails['shippingAddress']['fullAddress'];
                                  locality = orderDetails['shippingAddress']['locality'];
                                  landmark = orderDetails['shippingAddress']['landmark'];
                                }

                                return ExpansionTile(
                                  //backgroundColor: Colors.amber,
                                  leading: Text(
                                      orderDetails['orderDate']
                                              .toString()
                                              .toUpperCase() +
                                          ' ' +
                                          orderDetails['orderTime'].toString(),
                                      style: TextStyle(fontSize: 14.0)),
                                  title: Text(
                                      "\u20B9" + orderDetails['orderAmount'],
                                      style: TextStyle(fontSize: 14.0)),
                                  children: [
                                     Divider(
                                      color: Colors.black,
                                      height: 5.0,
                                    ),
                                     Row(children: <Widget>[                                      
                                      new Expanded(
                                          child:
                                              Text(firstName),
                                          flex: 1)
                                    ]),
                                    Row(children: <Widget>[                                      
                                      new Expanded(
                                          child:
                                              Text(lastName),
                                          flex: 1)
                                    ]),
                                      Row(children: <Widget>[                                     
                                      new Expanded(
                                          child:
                                              Text(mobileNumber),
                                          flex: 1)
                                    ]),
                                     Divider(
                                      color: Colors.black,
                                      height: 5.0,
                                    ),
                                     Row(children: <Widget>[                                      
                                      new Expanded(
                                          child:
                                              Text(fullAddress),
                                          flex: 1)
                                    ]),
                                    Row(children: <Widget>[                                      
                                      new Expanded(
                                          child:
                                              Text(locality),
                                          flex: 1)
                                    ]),
                                      Row(children: <Widget>[                                     
                                      new Expanded(
                                          child:
                                              Text(landmark),
                                          flex: 1)
                                    ]),
                                     Divider(
                                      color: Colors.black,
                                      height: 5.0,
                                    ),
                                      Row(children: <Widget>[
                                      new Expanded(
                                        child: Text('ITEM(S):'),
                                        flex: 5,
                                      ),
                                      new Expanded(
                                          child:
                                              Text(orderDetails['itemCount']),
                                          flex: 5)
                                    ]),
                                    Row(children: <Widget>[
                                      new Expanded(
                                        child: Text('PRODUCT(S):'),
                                        flex: 5,
                                      ),
                                      new Expanded(
                                          child: Text(
                                              orderDetails['productCount']),
                                          flex: 5)
                                    ]),
                                      Row(children: <Widget>[
                                      new Expanded(
                                        child: Text('CUSTOMIZATION:'),
                                        flex: 5,
                                      ),
                                      new Expanded(
                                          child:
                                              Text(orderDetails['orderCustomization']),
                                          flex: 5)
                                    ]),
                                    Divider(
                                      color: Colors.black,
                                      height: 5.0,
                                    ),
                                    SizedBox(height: 15.0),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int i) {
                                        return Row(
                                          children: <Widget>[
                                            new Expanded(
                                              child: Text(
                                                orderedProducts[i]
                                                    ['productName'],
                                                maxLines: 2,
                                              ),
                                              flex: 7,
                                            ),
                                            new Expanded(
                                              child: Text(
                                                '\u20B9' +
                                                    orderedProducts[i]
                                                            ['productPrice']
                                                        .toString(),
                                                maxLines: 2,
                                              ),
                                              flex: 2,
                                            ),
                                            new Expanded(
                                              child: Text(
                                                orderedProducts[i]['orderQty']
                                                    .toString(),
                                                maxLines: 2,
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        );
                                      },
                                      itemCount: orderedProducts.length,
                                    ),
                                  ],
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                          stream: FirebaseDatabase.instance
                              .reference()
                              .child('orders')
                              .child(orderIds[index])
                              .onValue,
                        );
                      },
                      itemCount: orderIds.length,
                    );
                  } 
                    else {
                    return Container(
                      child: Text(
                        "NO ORDERS YET!!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                } else {
                  return Container(
                    child: Text(
                      "NO ORDERS YET!!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              },
              stream: FirebaseDatabase.instance
                  .reference()                                    
                  .child('orders')                  
                  .orderByChild('orderDate')
                  .equalTo(selectedOnlineOrderDate)
                  .onValue,
            ),
          ),
        ));
  }
}