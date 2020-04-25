import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/ShowBillsForDate.dart';
import 'package:kiranawala_admin/pages/ShowCategoryWiseSalePositionStreamBuilder.dart';
import 'package:kiranawala_admin/pages/ShowOrders.dart';
import 'package:kiranawala_admin/pages/ShowProductWiseSalePositionStreamBuilder.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kiranawala_admin/main.dart';

class ShowTerminalWiseSalePosition extends StatefulWidget {
  @override
  _ShowTerminalWiseSalePositionState createState() => _ShowTerminalWiseSalePositionState();
}

class _ShowTerminalWiseSalePositionState extends State<ShowTerminalWiseSalePosition> {

@override
  void initState()
  {
    super.initState(); 
    // print('ShowTerminalWiseSalePosition:');
    // print(terminalsAtStore);
    // print(isStoreAdmin);
    // print(mobileNumber);

    // terminalsAtStore.forEach((storeTerminal){
    //     salePerTerminal.add(
    //                         Container(
    //                           child:Row(children: <Widget>[
    //                             Text(storeTerminal),
    //                             Text('0.0'),
    //                             Text('0'),
                                
    //                           ],)
    //                         ));                    
    // });
    
    refreshingTerminalWiseSales = true;
    // getFreshData();
  }

  @override
  Widget build(BuildContext context) {         
      // print(salePerTerminal);
      if(isStoreAdmin)
      {
        return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: const Text(
            'TERMINAL-WISE DAILY SALES',
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShowOrders()));
            },
            child: ListTile(
              title: Text('Online Orders'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),
          Divider(),   
            Divider(),
          InkWell(
            onTap: () {
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
      body:
        Column(children: <Widget>[
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
                                              // print('change $date');
                                            }, 
                                            onConfirm: (date) {
                                              selectedSaleDate = DateFormat('yyyy-MM-dd').format(date);
                                              year = selectedSaleDate.substring(0,4);
                                              month = selectedSaleDate.substring(5,7);
                                              day = selectedSaleDate.substring(8,10);
                                              // print(date);
                                              // print(selectedSaleDate);
                                              // print(year);
                                              // print(month);
                                              // print(day);                                            
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
                    // print('Refreshing Data...');                                              
                    setState(() {
                      refreshingTerminalWiseSales = true;
                    });
                    // getFreshData();
                    
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
        // Container(
        //   height: 20.0,
        //   child:Text('SALE POSITION')
        //   ),
        Container(
          height:300.0,
          child: 
          Container(
          child: Align(
            alignment: Alignment.center,
            child: ListView.builder(
                      itemCount: terminalsAtStore.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print(index);
                        // print(terminalsAtStore[index]);                        
                        return new StreamBuilder(
                          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data != null &&
                                  snapshot.data.snapshot.value != null) {
                                    // print(snapshot.data.snapshot.value);
                                    Map<dynamic,dynamic> map = snapshot.data.snapshot.value;
                                    if(map.containsKey('totalSale') && map.containsKey('totalWalkins'))
                                    {
                                      // print(map['totalSale'].toString());
                                      // print(map['totalWalkins'].toString());

                                      totalSaleForTheSelectedDateAsString = map['totalSale'].toStringAsFixed(0);
                                      totalWalkinsForTheSelectedDateAsString = map['totalWalkins'].toString();
                                    }                               

                                return 
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child:FlatButton(
                                      color:Colors.blue,
                                      textColor: Colors.white,
                                      onPressed: (){
                                        selectedPOSTerminal = terminalsAtStore[index];  
                                         showDialog(
                                          context: context,
                                          builder: (context)
                                          {
                                              return AlertDialog(
                                                  // title:Text(
                                                  //   'SALE ANALYSIS OPTIONS',
                                                  //   style:TextStyle(
                                                  //                   color:Colors.black,
                                                  //                   fontFamily: "Montserrat",
                                                  //                   fontWeight: FontWeight.bold,
                                                  //                   fontSize: 12.0
                                                  //                 )
                                                  //   ),
                                                  // title: Text('verifyOTP: OTP Verfication Status!!'),
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[                                                    
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            width:MediaQuery.of(context).size.width,
                                                            child: FlatButton(
                                                              color:Colors.blue,
                                                              child: Text(
                                                                'CATEGORIES',
                                                                style:TextStyle(
                                                                  color: Colors.white,
                                                                  fontFamily: 'Montserrat',
                                                                  fontSize:14.0,
                                                                  )
                                                                ),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                      return ShowCategoryWiseSalePosition();
                                                                    }));
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            width:MediaQuery.of(context).size.width,
                                                            child: FlatButton(
                                                              color:Colors.blue,
                                                              child: Text(
                                                                'PRODUCTS',
                                                                style:TextStyle(
                                                                  color: Colors.white,
                                                                  fontFamily: 'Montserrat',
                                                                  fontSize:14.0,
                                                                )
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                      return ShowProductWiseSalePosition();
                                                                    }));
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            width:MediaQuery.of(context).size.width,
                                                            child: FlatButton(
                                                              color:Colors.blue,
                                                              child: Text(
                                                                'BILLS',
                                                                style:TextStyle(
                                                                    color: Colors.white,
                                                                    fontFamily: 'Montserrat',
                                                                    fontSize:14.0,
                                                                )
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                      return ShowBillsForDate();
                                                                    }));
                                                              },
                                                            ),
                                                          ),
                                                        ])
                                                    ],
                                                  ),
                                                  
                                                  
                                                  
                                                  
                                                  // const Text('CHOOSE AN OPTION:', 
                                                  //                 style:TextStyle(
                                                  //                   color:Colors.black,
                                                  //                   fontFamily: "Montserrat",
                                                  //                   fontWeight: FontWeight.bold,
                                                  //                   fontSize: 12.0
                                                  //                 )),
                                                  // actions:<Widget>[ 
                                                  //   FlatButton(
                                                  //     child: Text('CATEGORIES'),
                                                  //     onPressed: () {
                                                  //       Navigator.of(context).pop();
                                                  //         Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  //             return ShowTerminalWiseSalePosition();
                                                  //           }));
                                                  //     },
                                                  //   ),
                                                  //    FlatButton(
                                                  //     child: Text('PRODUCTS'),
                                                  //     onPressed: () {
                                                  //       Navigator.of(context).pop();
                                                  //         Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  //             return ShowTerminalWiseSalePosition();
                                                  //           }));
                                                  //     },
                                                  //   ),
                                                  //    FlatButton(
                                                  //     child: Text('BILLS'),
                                                  //     onPressed: () {
                                                  //       Navigator.of(context).pop();
                                                  //         Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                  //             return ShowTerminalWiseSalePosition();
                                                  //           }));
                                                  //     },
                                                  //   ),
                                                  // ],
                                                );
                                          }                                
                                        );                                      
                                        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> 
                                        //     ShowBillsForDate()
                                        // ));
                                      },
                                      child:Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex:8,
                                              child: Container(child: Text(
                                              posTerminalStoreNameMapping[terminalsAtStore[index]],
                                              style:TextStyle(color:Colors.white),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                          Expanded(
                                            flex:4,
                                              child: Container(child: Text(
                                              totalSaleForTheSelectedDateAsString,
                                              style:TextStyle(color:Colors.white),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                          Expanded(
                                            flex:4,
                                              child: Container(child: Text(
                                              totalWalkinsForTheSelectedDateAsString,
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                        ],                                          
                                      )
                                    ),  
                                  ) ;
                              } else {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Dialog(
                                    child: new Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        new CircularProgressIndicator(),
                                        new Text("Loading Bills....."),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Dialog(
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      new CircularProgressIndicator(),
                                      new Text("Loading Bills....."),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                      stream:                        
                      FirebaseDatabase.instance
                        .reference()
                        .child('storeTerminals')
                        .child(terminalsAtStore[index])
                        .child('sales')
                        .child(year)
                        .child(month)
                        .child(day)
                        .onValue,
                        );
                      },                      
                    )
      ),
    )
    ),
    ])
 );
  }
 else
 {
  return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: const Text(
            'TERMINAL-WISE DAILY SALES',
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShowOrders()));
            },
            child: ListTile(
              title: Text('Online Orders'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),
          Divider(),   
            Divider(),
          InkWell(
            onTap: () {
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
      body: 
          Container(
          height:300.0,
          child: 
          Container(
          child: Align(
            alignment: Alignment.center,
            // child: Text('Not Admin!!.Please contact 9849494143.' + isStoreAdmin.toString() + terminalsAtStore.length.toString())
            child: Text('Not Admin!!.Please contact 9849494143.')
          )
        )
          )
  );
}
  }
}