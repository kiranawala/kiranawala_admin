import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';
import 'show-order-details.dart';
import 'check-if-admin.dart';

class ShowOnlineOrders extends StatefulWidget {
  @override
  _ShowOnlineOrdersState createState() => _ShowOnlineOrdersState();
}

List<String> onlineOrderIds = new List();

class _ShowOnlineOrdersState extends State<ShowOnlineOrders> {

  @override
  void initState() {
    super.initState();
    onlineOrderIds = orderMap.keys.toList();
    print(onlineOrderIds);
  }

  @override
  Widget build(BuildContext context) {
//    if(!processingStores)
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return ShowAdminHomePage();
                }
            )
        );
        return;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'ONLINE ORDERS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return ShowAdminHomePage();
                  }
                )
              );
            },
          )
        ),

        body: Container(
          child: Align(
              alignment: Alignment.center,
              child:
                    ListView.builder(
                    itemBuilder: (BuildContext context, int index) {

                    var onlineOrderDetails = new Map<dynamic, dynamic>();
                    onlineOrderDetails = orderMap[onlineOrderIds[index]];

                                        Text(onlineOrderIds[index].toString());


                      if (onlineOrderDetails['personalDetails'] != null) {
                        if(onlineOrderDetails['personalDetails']['firstName'] != null)
                          firstName = onlineOrderDetails['personalDetails']['firstName'];
                        if(onlineOrderDetails['personalDetails']['lastName'] != null)
                          lastName = onlineOrderDetails['personalDetails']['lastName'];
                        if(onlineOrderDetails['personalDetails']['mobileNumber'] != null)
                          mobileNumber = onlineOrderDetails['personalDetails']['mobileNumber'];
                      }

                      if (onlineOrderDetails['shippingAddress'] != null) {
                        if(onlineOrderDetails['shippingAddress']['fullAddress'] != null)
                          fullAddress = onlineOrderDetails['shippingAddress']['fullAddress'];
                        if(onlineOrderDetails['shippingAddress']['locality'] != null)
                          locality = onlineOrderDetails['shippingAddress']['locality'];
                        if(onlineOrderDetails['shippingAddress']['landmark'] != null)
                          landmark = onlineOrderDetails['shippingAddress']['landmark'];
                      }

                      if (onlineOrderDetails['requesetdDeliveryDate'] != null) {
                        requestedDeliveryDate =
                        onlineOrderDetails['requesetdDeliveryDate'];
                      }
                      if (onlineOrderDetails['requestedDeliveryTime'] != null) {
                        requestedDeliveryTime =
                        onlineOrderDetails['requestedDeliveryTime'];
                      }

                      if (onlineOrderDetails['orderDate'] != null) {
                        orderDate = onlineOrderDetails['orderDate'];
                      }

                      if (onlineOrderDetails['orderTime'] != null) {
                        orderTime = onlineOrderDetails['orderTime'];
                      }

                      if (onlineOrderDetails['orderAmount'] != null) {
                        onlineOrderAmount = double.parse(onlineOrderDetails['orderAmount'].toString());
                      }

                      if (onlineOrderDetails['productCount'] != null) {
                        onlineOrderProductCount = int.parse(onlineOrderDetails['productCount'].toString());
                      }

                      if (onlineOrderDetails['itemCount'] != null) {
                        onlineOrderItemCount = double.parse(onlineOrderDetails['itemCount'].toString());
                      }

                      return

                      Container(
                        width:MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(2.0)
                          ),
                          border:Border.all(color:Colors.black)
                        ),
                        child: FlatButton(
//                        color: Colors.orangeAccent,
                            onPressed: () {
                              selectedOnlineOrderDetails = orderMap[onlineOrderIds[index]];
                              print(selectedOnlineOrderDetails);
                              Navigator.pop(context);
                              Navigator.push<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                      builder: (context) => ShowOrderedProducts()));
                            },
                            child: Column(children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: Text(

                                          orderDate.toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.0,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        orderTime
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        onlineOrderAmount.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        onlineOrderProductCount.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        onlineOrderItemCount.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        requestedDeliveryDate.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        requestedDeliveryTime.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 6,
                                      child: Text(
                                        locality.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ],
                              ),
                            ])),
                      );
                  },
                  itemCount: onlineOrderIds.length,
                  ),
        ),
        ),
      ),
    );
  }
}
