import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';
import 'package:kiranawala_admin/pages/retrieve-product-outward-for-date.dart';
import 'ShowBillsForDate.dart';
import 'ShowCategoryWiseSalePositionStreamBuilder.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'ShowProductWiseSalePositionStreamBuilder-original.dart';
import 'package:kiranawala_admin/main.dart';
//import 'check-if-admin.dart';

class ShowTerminalWiseSalePosition extends StatefulWidget {
  @override
  _ShowTerminalWiseSalePositionState createState() => _ShowTerminalWiseSalePositionState();
}

class _ShowTerminalWiseSalePositionState extends State<ShowTerminalWiseSalePosition> {

@override
  void initState()
  {
    super.initState();
//    print('ShowTerminalWiseSalePosition:initState:year:' + year );
//    print('ShowTerminalWiseSalePosition:initState:month:' + month );
//    print('ShowTerminalWiseSalePosition:initState:day:' + day );
//
//    DateTime now = DateTime.now();
//    String dateString  = DateFormat('dd-MM-yyyy').format(now);
//
//    day = dateString.substring(0,2);
//    month = dateString.substring(3,5);
//    year  = dateString.substring(6,10);
//
//    print('ShowTerminalWiseSalePosition:initState:year:' + year );
//    print('ShowTerminalWiseSalePosition:initState:month:' + month );
//    print('ShowTerminalWiseSalePosition:initState:day:' + day );
//    print('ShowTerminalWiseSalePosition:initState:storeName:' + storeName );
//
//    selectedSaleDate = DateFormat('dd-MM-yyyy').format(now);
    storeTerminals_List.clear();
    storeTerminals_List.add('POS_11');
    print(storeTerminals_List);
    refreshingTerminalWiseSales = true;
  }

  @override
  Widget build(BuildContext context) {         
//      if(isStoreAdmin)
//      {
        return WillPopScope(

        onWillPop: (){
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
            return ShowHomePage();
          }));
          return;
        },
          child:Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                return ShowHomePage();
              }));
            }
          ),
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
      body:
        Column(children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
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
                                            },
                                            onConfirm: (date) {
                                              saleAnalysisDate = DateFormat('dd-MM-yyyy').format(date);
                                              saleAnalysisDay = saleAnalysisDate.substring(0,2);
                                              saleAnalysisMonth = saleAnalysisDate.substring(3,5);
                                              saleAnalysisYear = saleAnalysisDate.substring(6,10);
                                              setState(() {});
                                            },
                      currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                      saleAnalysisDate.toUpperCase(),
                      style: TextStyle(color: Colors.amberAccent,
                        fontSize: 20.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child:
          Container(
          child: Align(
            alignment: Alignment.center,
            child: ListView.builder(
                      itemCount: storeTerminals_List.length,
                      itemBuilder: (BuildContext context, int index) {
                        // print(index);
                        // print(terminalsAtStore[index]);
//                        print(storeTerminals_List[index]);
                        return new StreamBuilder(
                          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
//                            print(snapshot);
                            if (snapshot.hasData) {
                              if (snapshot.data != null &&
                                  snapshot.data.snapshot.value != null) {
                                    Map<dynamic,dynamic> map = snapshot.data.snapshot.value;
//                                    print(snapshot.data.snapshot.value);
                                    if(map.containsKey('totalSale') && map.containsKey('totalWalkins'))
                                    {
                                      if(map['totalSale'] is String)
                                        totalSaleForTheSelectedDateAsString = num.parse(map['totalSale']).toStringAsFixed(0);
                                      else
                                        totalSaleForTheSelectedDateAsString = map['totalSale'].toStringAsFixed(0);
                                      totalWalkinsForTheSelectedDateAsString = map['totalWalkins'].toString();
                                    }

                                return
                                  Container(

                                    padding: const EdgeInsets.all(8.0),
                                    child:FlatButton(
                                      color:Colors.amberAccent,
                                      textColor: Colors.white,
                                      onPressed: (){
                                        selectedPOSTerminal = storeTerminals_List[index];
                                         showDialog<dynamic>(
                                          context: context,
                                          builder: (context)
                                          {
                                              return AlertDialog(
                                                  content: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                            width:MediaQuery.of(context).size.width,
                                                            child: FlatButton(
                                                              color:Colors.amberAccent,
                                                              child: Text(
                                                                'CATEGORIES',
                                                                style:TextStyle(
                                                                  color: Colors.black,
                                                                  fontFamily: 'Montserrat',
                                                                  fontSize:14.0,
                                                                  )
                                                                ),
                                                              onPressed: () {
                                                                storeName = posTerminalToStoreName[storeTerminals_List[index]];
                                                                print(storeName);
                                                                Navigator.of(context).pop();
                                                                  Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) {
                                                                      return ShowCategoryWiseSalePosition();
                                                                    }));
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            width:MediaQuery.of(context).size.width,
                                                            child: FlatButton(
                                                              color:Colors.amberAccent,
                                                              child: Text(
                                                                'BILLS',
                                                                style:TextStyle(
                                                                    color: Colors.black,
                                                                    fontFamily: 'Montserrat',
                                                                    fontSize:14.0,
                                                                )
                                                              ),
                                                              onPressed: () {
//                                                                storeName = posTerminalToStoreName[storeTerminals_List[index]];
                                                              storeName = 'JUSTGROCERY';
                                                                print(storeName);
                                                                Navigator.of(context).pop();
                                                                  Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) {
                                                                      return ShowBillsForDate();
                                                                    }));
                                                              },
                                                            ),
                                                          ),
                                                          Container(
                                                            width:MediaQuery.of(context).size.width,
                                                            child: FlatButton(
                                                              color:Colors.amberAccent,
                                                              child: Text(
                                                                  'PRODUCTS',
                                                                  style:TextStyle(
                                                                    color: Colors.black,
                                                                    fontFamily: 'Montserrat',
                                                                    fontSize:14.0,
                                                                  )
                                                              ),
                                                              onPressed: () {
                                                                storeName = posTerminalToStoreName[storeTerminals_List[index]];
                                                                print(storeName);
                                                                Navigator.of(context).pop();
                                                                Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) {
                                                                  return ShowProductWiseSalePosition();
                                                                }));
                                                              },
                                                            ),
                                                          ),
                                                        ])
                                                    ],
                                                  ),
                                                );
                                          }
                                        );

                                      },
                                      child:Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex:8,
                                              child: Container(
                                                child: Text(
//                                                  storeName.toUpperCase(),
                                                'JUSTGROCERY',
//                                                posTerminalStoreNameMapping[storeTerminals_List[index]].toString().toUpperCase(),
                                              style:TextStyle(fontFamily:'Montserrat',fontSize:12.0,color:Colors.black,fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,),
                                            ),
                                          ),
                                          Expanded(
                                            flex:4,
                                            child: Container(child: Text(
                                              storeTerminals_List[index].toUpperCase(),
                                              style:TextStyle(fontFamily:'Montserrat',fontSize:12.0,color:Colors.black,fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                          Expanded(
                                            flex:4,
                                              child: Container(child: Text(
                                              totalSaleForTheSelectedDateAsString,
                                                style:TextStyle(fontFamily:'Montserrat',fontSize:14.0,color:Colors.black,fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                          Expanded(
                                            flex:4,
                                              child: Container(child: Text(
                                              totalWalkinsForTheSelectedDateAsString,
                                                style:TextStyle(fontFamily:'Montserrat',fontSize:12.0,color:Colors.black,fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                  ) ;
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    color: Colors.white,
                                    child:FlatButton(
                                        color:Colors.amberAccent,
                                        textColor: Colors.white,
                                        onPressed: (){},
                                        child:Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex:8,
                                              child: Container(
                                                child: Text(
                                                  posTerminalToStoreName[storeTerminals_List[index].toString()],
//                                                  storeName.toUpperCase(),
//                                                  posTerminalStoreNameMapping[storeTerminals_List[index]].toString().toUpperCase(),
                                                  style:TextStyle(fontFamily:'Montserrat',fontSize:12.0,color:Colors.black,fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.left,),
                                              ),
                                            ),
                                            Expanded(
                                              flex:4,
                                              child: Container(child: Text(
                                                storeTerminals_List[index].toUpperCase(),
                                                style:TextStyle(fontFamily:'Montserrat',fontSize:12.0,color:Colors.black,fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.right,),
                                              ),
                                            ),
                                            Expanded(
                                              flex:4,
                                              child: Container(child: Text(
                                                '0',
                                                style:TextStyle(fontFamily:'Montserrat',fontSize:12.0,color:Colors.black,fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.right,),
                                              ),
                                            ),
                                            Expanded(
                                              flex:4,
                                              child: Container(child: Text(
                                                '0',
                                                style:TextStyle(fontFamily:'Montserrat',fontSize:12.0,color:Colors.black,fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.right,),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child:FlatButton(
                                    color:Colors.amberAccent,
                                    textColor: Colors.white,
                                    onPressed: (){},
                                    child:Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex:8,
                                          child: Container(
                                            child: Text(
//                                              storeName.toUpperCase(),
                                              posTerminalStoreNameMapping[storeTerminals_List[index]].toString().toUpperCase(),
                                              style:TextStyle(fontFamily:'Montserrat',fontSize:12.0,color:Colors.black,fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,),
                                          ),
                                        ),
//                                        Expanded(
//                                          flex:4,
//                                          child: Container(child: Text(
//                                            storeTerminals_List[index].toUpperCase(),
//                                            style:TextStyle(color:Colors.black,fontWeight: FontWeight.bold),
//                                            textAlign: TextAlign.right,),
//                                          ),
//                                        ),
                                        Expanded(
                                          flex:4,
                                          child: Container(child: Text(
                                            '0',
                                            style:TextStyle(fontFamily:'Montserrat',fontSize:14.0,color:Colors.black,fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.right,),
                                          ),
                                        ),
                                        Expanded(
                                          flex:4,
                                          child: Container(child: Text(
                                            '0',
                                            style:TextStyle(fontFamily:'Montserrat',fontSize:12.0,color:Colors.black,fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.right,),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                ),
                              );
                            }
                          },
                      stream:
                      FirebaseDatabase.instance
                        .reference()
                        .child('storeTerminals')
                        .child(storeTerminals_List[index])
                        .child('sales')
                        .child(saleAnalysisYear)
                        .child(saleAnalysisMonth)
                        .child(saleAnalysisDay)
                        .onValue,
                        );
                      },
                    )
      ),
    )
    ),
    ]),
//          bottomNavigationBar: BottomNavigationBar(
//              items: [
//                BottomNavigationBarItem(
//                    icon: Icon(Icons.refresh), title: Text('REFRESH')),
//                BottomNavigationBarItem(
//                    icon: Icon(Icons.home), title: Text('ONLINE ORDERS'))
//              ],
//              onTap: (index) {
//                switch (index) {
//                  case 0:
//                    Navigator.of(context).pop();
//                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                      return ShowTerminalWiseSalePosition();
//                    }));
//                    break;
//                  case 1:
//                    Navigator.of(context).pop();
//                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                      return ShowOnlineSalePosition();
//                    }));
//                    break;
//                }
//              }),
              ));
//  }
// else
// {
//  return WillPopScope(
//    onWillPop: (){
//      Navigator.of(context).pop();
//      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//        return CheckIfAdmin();
//      }));
//      return;
//    },
//    child:Scaffold(
//        resizeToAvoidBottomPadding: true,
//        appBar: AppBar(
//          title: const Text(
//            'TERMINAL-WISE DAILY SALES',
//            style: TextStyle(
//              color: Colors.white,
//              fontSize: 14.0,
//              fontFamily: "Montserrat",
//              fontWeight: FontWeight.bold,
//            ),
//          ),
//        ),
//      body:
//          Container(
//          height:300.0,
//          child:
//          Container(
//          child: Align(
//            alignment: Alignment.center,
//            child: Text('Not Admin!!.Please contact 9849494143.')
//          )
//        )
//          )
//  ));
//}
  }
}