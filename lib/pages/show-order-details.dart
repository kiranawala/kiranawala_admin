import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'check-if-admin.dart';
import 'show-online-orders.dart';

import 'package:url_launcher/url_launcher.dart';


class ShowOrderedProducts extends StatefulWidget {
  @override
  _ShowOrderedProductsState createState() => _ShowOrderedProductsState();
}

class _ShowOrderedProductsState extends State<ShowOrderedProducts> {
  bool orderedProductsAvailable = false;

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<dynamic> orderedProducts = List<dynamic>();

  @override
  void initState() {
    super.initState();

    print('ShowOrderedProducts:initState:');
    print(selectedOnlineOrderDetails);
    print(selectedOnlineOrderDetails['personalDetails']);

//    print('ShowOrderedProducts:initState:selectedOrderIndex:');
//    print(selectedOrderIndex);
//    print('ShowOrderedProducts:initState:selectedOrderIndex:orders:');
//    print(orders);
//    print('ShowOrderedProducts:initState:selectedOrderIndex:orderIds');
//    print(orderIds);

//    StringBuffer sb = new StringBuffer();
//    sb.write("First Name: \n");
//    sb.write("Last Name:\r\n");
//    sb.write("Contact Number:\n");
//    sb.write("\n");
//    sb.write("Full Address:\n");
//    sb.write("Locality:\n");
//    sb.write('Landmark:\n');
//
//    String text = sb.toString();
//    print(text);


//    print('ShowOrderedProducts:initState:selectedOrderDetails:');
//    setState(() {
//      selectedOrderDetails = orders[orderIds[selectedOrderIndex]];
//    });

//    print(selectedOrderDetails);


//    print('ShowOrderedProducts: Opening Whatsapp...');


//    print('ShowOrderedProducts:selectedOrderIndex:');
//    print(selectedOrderIndex);
//    print('ShowOrderedProducts:selectedOrderId:');
//    print(orderIds[selectedOrderIndex]);
//    print(orderIds[0]);
//    print(orderIds[1]);
//    print('ShowOrderedProducts:orderIds:');
//    print(orderIds[0]);
//    print(orders[orderIds[0]]);
//    print(orderIds[1]);
//    print(orders[orderIds[1]]);
//    print(orderIds[2]);
//    print(orders[orderIds[2]]);


    if (selectedOnlineOrderDetails['personalDetails'] != null
          && selectedOnlineOrderDetails['personalDetails']['firstName'] != null
          && selectedOnlineOrderDetails['personalDetails']['lastName'] != null
          && selectedOnlineOrderDetails['personalDetails']['mobileNumber'] != null
    ) {
        firstName = selectedOnlineOrderDetails['personalDetails']['firstName'];
        lastName = selectedOnlineOrderDetails['personalDetails']['lastName'];
        contactNumber = selectedOnlineOrderDetails['personalDetails']['mobileNumber'];
    }
    else
      {
        if (selectedOnlineOrderDetails['userID'] != null)
        {
          customerId = selectedOnlineOrderDetails['userID'];
          FirebaseDatabase
            .instance
            .reference()
            .child('users')
            .child(customerId)
            .child('customerDetails')
            .child('personalDetails')
            .once()
            .then((snapshot){
              print(snapshot);
              if(snapshot != null && snapshot.value != null)
                {
//                  print(snapshot.value);
//                  print(snapshot.value['firstName']);
                  setState(() {
                    firstName = snapshot.value['firstName'];
                    lastName = snapshot.value['lastName'];
                    contactNumber = snapshot.value['mobileNumber'];
                  });


//                  print(snapshot.value['lastName']);
//                  print(snapshot.value['mobileNumber']);
                }
          });
        }
      }


    if (selectedOnlineOrderDetails['shippingAddress'] != null) {
      fullAddress = selectedOnlineOrderDetails['shippingAddress']['fullAddress'];
      locality = selectedOnlineOrderDetails['shippingAddress']['locality'];
      landmark = selectedOnlineOrderDetails['shippingAddress']['landmark'];
    }

    if (selectedOnlineOrderDetails['requestedDeliveryDate'] != null) {
      requestedDeliveryDate = selectedOnlineOrderDetails['requestedDeliveryDate'];
    }

    if (selectedOnlineOrderDetails['orderCustomization'] != null && selectedOnlineOrderDetails['orderCustomization'] != '') {
      selectedOnlineOrderCustomization = selectedOnlineOrderDetails['orderCustomization'];
    }
    if (selectedOnlineOrderDetails['requestedDeliveryTime'] != null) {
      requestedDeliveryTime = selectedOnlineOrderDetails['requestedDeliveryTime'];
    }

    if (selectedOnlineOrderDetails['itemCount'] != null) {
      selectedOnlineOrderItemCount = double.parse(selectedOnlineOrderDetails['itemCount']);
    }

    if (selectedOnlineOrderDetails['productCount'] != null) {
      selectedOnlineOrderProductCount = int.parse(selectedOnlineOrderDetails['productCount']);
    }

//    print(fullAddress);
//    print(landmark);
//    print(locality);
//    print(orderCustomization);
//    print(requestedDeliveryTime);
//    print(requestedDeliveryDate);
//    print(selectedOnlineOrderItemCount);
//    print(selectedOnlineOrderItemCount);

//    print('ShowOrderedProducts:selectedOrder:orderedProducts');
//    print(selectedOrderDetails);
//    print(selectedOrderDetails['orderedProducts']);
//    print(selectedOrderDetails['orderedProducts']);
   orderedProducts = selectedOnlineOrderDetails['orderedProducts'];
    print(orderedProducts);
//    print(orderedProducts.length);

//    setState(() {
//
//    });

//    StringBuffer sb = new StringBuffer();
//    sb.write("First Name: " + firstName + "\n");
//    sb.write("Last Name:" + lastName + "\n");
//    sb.write("Contact Number:" + contactNumber + "\n");
//    sb.write("\n");
//    sb.write("Full Address:" +  fullAddress + "\n");
//    sb.write("Locality:" + locality + "\n");
//    sb.write("Landmark:" + landmark + "\n");
//    sb.write("Delivery Date:" + requestedDeliveryDate + "\n");
//    sb.write("Delivery Time:" + requestedDeliveryTime + "\n");
//    sb.write("Customization:" + orderCustomization + "\n");
//    sb.write("No. Of Products:" + selectedOnlineOrderProductCount.toString() + "\n");
//    sb.write("No. Of Items:" + selectedOnlineOrderItemCount.toString() + "\n");


//    print(orderedProducts);
//    print(orderedProducts.length);


    var productCount = 0;
    orderedProducts.forEach((dynamic orderedProduct){
//      print(orderedProduct);
      productCount = productCount + 1;
//      sb.write('PRODUCT ' + productCount.toString() + "\n");
//      sb.write('Name:' + orderedProduct['productName'] + "\n");
//      sb.write('Price:' + orderedProduct['productPrice'].toString() + "\n");
//      sb.write('Qty:' + orderedProduct['orderQty'].toString() + "\n");
//      + orderedProduct['productPrice'] + "\r" + orderedProduct['orderQty'] + "\n");
      print(orderedProduct['productName']);
      print(orderedProduct['productPrice']);
      print(orderedProduct['orderQty']);
    });
//
//    String text = sb.toString();
//    print(text);
//
//    var WHATSAPP_TEXT = "whatsapp://send?text=" + text;
//    WHATSAPP_URL_ONLINE_ORDER = Uri.encodeFull(WHATSAPP_TEXT);
////    + selectedOrderDetails.toString();
////    print(selectedOrderDetails.toString());
//    launchURL(encoded);

//    setState(() {
//      orderedProductsAvailable = true;
//    });
//    print('ShowOrderedProducts:selectedOrder:orderedProducts');
//    print(orderedProducts);
//    print('ShowOrderedProducts:shippingAddress:');
//    print(orders[selectedOrderIndex]['shippingAddress']);
//    print('ShowOrderedProducts:customerDetails:');
//    print(orders[selectedOrderIndex]['personalDetails']);
//    print('ShowOrderedProducts:orderedProducts:');
//    print(orders[selectedOrderIndex]['orderedProducts']);
//    print(selectedOrderDetails);
//    print('ShowOrderedProducts:orderDetails:orderedProducts');
//    print(selectedOrderDetails['orderedProducts']);
//    print('ShowOrderedProducts:orderDetails:shippingAddress');
//    print(selectedOrderDetails['shippingAddress']);
//    print('ShowOrderedProducts:orderDetails:personalDetails');
//    print(selectedOrderDetails['personalDetails']);
//    orderedProducts = selectedOrderDetails['orderedProducts'];
//    print('ShowOrderedProducts:orderDetails:orderedProducts:');
//    print(orderedProducts);
  }

  @override
  Widget build(BuildContext context) {
    print('Build:OrderedProducts:');
    print(orderedProducts);
//    if(orderedProductsAvailable) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return ShowOnlineOrders();
                }
            )
        );
        return;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.share),
//            onPressed: (){
//              launchURL(WHATSAPP_URL_ONLINE_ORDER);
//              // FlutterOpenWhatsapp.sendSingleMessage("+919849494143", billAsString);
//            },
//          )
//        ],
        centerTitle: true,
          title: const Text(
            'ORDER DETAILS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return ShowOnlineOrders();
                  }
                )
              );
            }
          ),
        ),
//      drawer: new Drawer(
//        child: new ListView(children: <Widget>[
//          Divider(),
//          InkWell(
//            onTap: () {
//              Navigator.pop(context);
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) => ShowTerminalWiseSalePosition()));
//            },
//            child: ListTile(
//              title: Text('Terminal-Wise Sales'),
//              leading: Icon(Icons.person, color: Colors.green),
//            ),
//          ),
//          Divider(),
//          Divider(),
//          InkWell(
//            onTap: () {
//              Navigator.pop(context);
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => ShowOrderCount()));
//            },
//            child: ListTile(
//              title: Text('Order Count'),
//              leading: Icon(Icons.person, color: Colors.green),
//            ),
//          ),
//        ]),
//      ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width:MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:Colors.black
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0)
                      )
                  ),
                  child: Text('CUSTOMER DETAILS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            Text(firstName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),),
            Text(lastName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),),
            Text(contactNumber,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),),
            Container(
              width:MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(
                      color:Colors.black
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0)
                  )
              ),
              child: Text('SHIPPING ADDRESS',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(fullAddress,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),),
            Text(locality,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),),
            Text(landmark,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),),
                Container(
                  width:MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:Colors.black
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0)
                      )
                  ),
                  child: Text('ORDER DETAILS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('Delivery Date:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                    Expanded(
                      child: Text(requestedDeliveryDate,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                  ],
                ),
               Row(
                 children: <Widget>[
                   Expanded(
                     child: Text('Delivery Time:',
                       style: TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                         fontFamily: "Montserrat",
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                   Expanded(
                     child: Text(requestedDeliveryTime,
                       style: TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                         fontFamily: "Montserrat",
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text('Order Customization:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                  Expanded(
                    child: Text(selectedOnlineOrderCustomization,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ],
              ),

               Row(
                 children: <Widget>[
                   Expanded(
                     child: Text('No. Of. Products:',
                       style: TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                         fontFamily: "Montserrat",
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                   Expanded(
                     child: Text(selectedOnlineOrderProductCount.toString(),
                       style: TextStyle(
                         color: Colors.black,
                         fontSize: 14.0,
                         fontFamily: "Montserrat",
                         fontWeight: FontWeight.bold,
                       ),),
                   ),
                 ],
               ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('No. Of. Items:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                    Expanded(
                      child: Text(selectedOnlineOrderItemCount.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                  ],
                ),

                Container(
                  width:MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:Colors.black
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0)
                      )
                  ),
                  child: Text('ORDERED PRODUCTS',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          child: Text(
                            orderedProducts[i]['productName'],
                            maxLines: 2,
                      style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.bold,
                    ),
                          ),
                          flex: 7,
                        ),
                        new Expanded(
                          child: Text(
                            '\u20B9' +
                                orderedProducts[i]['productPrice'].toString(),
                            maxLines: 2,
                style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                ),
                          ),
                          flex: 2,
                        ),
                        new Expanded(
                          child: Text(
                            orderedProducts[i]['orderQty'].toString(),
                            maxLines: 2,
                style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ));
              },
              itemCount: orderedProducts.length,
            ),
            ),
        ]
        ),
        )
      ),
    );
  }
}
