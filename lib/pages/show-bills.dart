import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';
import 'package:kiranawala_admin/pages/show-billed-products.dart';

class ShowBills extends StatefulWidget {
  @override
  _ShowBillsState createState() => _ShowBillsState();
}

class _ShowBillsState extends State<ShowBills> {

  Map<dynamic, dynamic> allBillsMap = Map<dynamic, dynamic>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeTerminals.forEach((element) {
      print(billsAtTerminalForSelectedDate[element]);
      if(billsAtTerminalForSelectedDate[element] != null)
        {
          billsAtTerminalForSelectedDate[element].forEach((dynamic key, dynamic value) {
            allBillsMap[key] = value;
          });
        }
    });
    print(allBillsMap);
  }

  @override
  Widget build(BuildContext context) {

    List<dynamic> bills = allBillsMap.values.toList();
    bills.sort((dynamic a,dynamic b){return b['billTime'].compareTo(a['billTime']);});

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
      child:Scaffold(
        appBar:AppBar(
          automaticallyImplyLeading: false,
          centerTitle:  true,
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
        body:Container(
          width:MediaQuery.of(context).size.width,
          child:ListView.builder(
            itemBuilder:(BuildContext context, int index){
                return RaisedButton(
                  onPressed: (){
                    billedProducts = bills[index]['billedProducts'];
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                        builder:(BuildContext context){
                          return ShowBilledProducts();
                        }
                      )
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                            bills[index]['billTime'].toString(),
                            style:TextStyle(
                              fontFamily: 'Verdana',
                              fontSize: 20.0,
//                                  fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          )
                      ),
                      Expanded(
                          child: Text(
                              bills[index]['posID'].toString(),
                            style:TextStyle(
                              fontFamily: 'Verdana',
                              fontSize: 20.0,
//                                  fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          )
                      ),
                      Expanded(
                          child: Text(
                              double.parse(bills[index]['billAmount'].toString()).toStringAsFixed(0),
                            style:TextStyle(
                              fontFamily: 'Verdana',
                              fontSize: 20.0,
                              color: Colors.black
//                                  fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          )),
                      Expanded(child: Text(bills[index]['productCount'].toString(),
                        style:TextStyle(
                          fontFamily: 'Verdana',
                          fontSize: 20.0,
//                              fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,)),
                      Expanded(child: Text(bills[index]['itemCount'].toString(),
                        style:TextStyle(
                          fontFamily: 'Verdana',
                          fontSize: 20.0,
//                              fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,)),
                    ],
                  ),
                );
            },
            itemCount:bills.length
          )
        )
      )
    );
  }
}
