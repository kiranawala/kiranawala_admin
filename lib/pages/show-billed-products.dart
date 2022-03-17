import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/show-bills.dart';

class ShowBilledProducts extends StatefulWidget {
  @override
  _ShowBilledProductsState createState() => _ShowBilledProductsState();
}

class _ShowBilledProductsState extends State<ShowBilledProducts> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(
//          MaterialPageRoute<dynamic>(
//            builder:(BuildContext context){
//              return ShowBills();
//            }
//          )
//        );
        return;
      },
      child:Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:  false,
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed:(){
              Navigator.of(context).pop();
//              Navigator.of(context).push<dynamic>(
//                MaterialPageRoute<dynamic>(
//                  builder:(BuildContext context){
//                    return ShowBills();
//                  }
//                )
//              );
            }
          )
        ),
        body:Container(
          width:MediaQuery.of(context).size.width,
          child:ListView.builder(
            itemBuilder: (BuildContext context, int index){
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.grey)
                ),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      flex:8,
                      child: Text(
                        billedProducts[index]['productName'].toString(),
                        style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize:20.0,
                        )
                      ),
                    ),
                    Expanded(
                      flex:2,
                      child: Text(
                          billedProducts[index]['productPrice'].toString(),
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:20.0,
                          )
                      ),
                    ),
                    Expanded(
                      flex:2,
                      child: Text(
                          billedProducts[index]['productBilledQty'].toString(),
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:20.0,
                          )
                      ),
                    ),
                  ],
                )
              );
            },
            itemCount: billedProducts.length,
          )
        )
      )
    );
  }
}
