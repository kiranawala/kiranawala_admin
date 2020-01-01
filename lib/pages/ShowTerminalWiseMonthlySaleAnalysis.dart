import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/ShowBillsForDate.dart';
import 'package:kiranawala_admin/pages/ShowOrders.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kiranawala_admin/main.dart';

class ShowTerminalWiseMonthlySaleAnalysis extends StatefulWidget {
  @override
  _ShowTerminalWiseMonthlySaleAnalysisState createState() => _ShowTerminalWiseMonthlySaleAnalysisState();
}

class _ShowTerminalWiseMonthlySaleAnalysisState extends State<ShowTerminalWiseMonthlySaleAnalysis> {

@override
  void initState()
  {
    super.initState(); 
    print('ShowTerminalWiseSaleAnalysis:');

    terminalsAtStore.forEach((storeTerminal){
        salePerTerminal.add(
                            Container(
                              child:Row(children: <Widget>[
                                Text(storeTerminal),
                                Text('0.0'),
                                Text('0'),
                                
                              ],)
                            ));                    
    });
    
    refreshingTerminalWiseSales = true;
    // getFreshData();
  }

  @override
  Widget build(BuildContext context) {         
      print(salePerTerminal);
        return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: const Text(
            'MONTHLY SALES ANALYSIS',
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
        // Container(
        //   height: 20.0,
        //   child:Text('SALE Analysis')
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
                        print(index);
                        print(terminalsAtStore[index]);                        
                        return new StreamBuilder(
                          builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data != null &&
                                  snapshot.data.snapshot.value != null) {
                                    print(snapshot.data.snapshot.value);
                                    Map<dynamic,dynamic> map = snapshot.data.snapshot.value;
                                    if(map.containsKey('totalSale') && map.containsKey('totalWalkins') && map.containsKey('workingDays'))
                                    {
                                      print(map['totalSale'].toString());
                                      print(map['totalWalkins'].toString());
                                      print(map['workingDays'].toString());

                                      totalSaleForTheSelectedMonthAsString = map['totalSale'].toStringAsFixed(2);
                                      totalWalkinsForTheSelectedMonthAsString = map['totalWalkins'].toString();
                                      totalWorkingDaysForTheSelectedMonthAsString = map['workingDays'].toString();

                                      totalSaleForTheSelectedMonth = double.parse(totalSaleForTheSelectedMonthAsString);
                                      totalWalkinsForTheSelectedMonth = int.parse(totalWalkinsForTheSelectedMonthAsString);
                                      totalWorkingDaysForTheSelectedMonth = int.parse(totalWorkingDaysForTheSelectedMonthAsString);

                                      averageDailySaleForTheSelectedMonthAsString = (totalSaleForTheSelectedMonth / totalWorkingDaysForTheSelectedMonth).toStringAsFixed(0);
                                      averageDailyWalkinsForTheSelectedMonthAsString = (totalWalkinsForTheSelectedMonth / totalWorkingDaysForTheSelectedMonth).toStringAsFixed(0);

                                      
                                    }                               

                                return                                   
                                  Container(
                                    margin: EdgeInsets.all(8.0),
                                    color:Colors.blue,
                                    child: Column(children: <Widget>[  
                                    Container(
                                      color:Colors.blue,
                                      child: Text(
                                          posTerminalStoreNameMapping[terminalsAtStore[index]],
                                          style:TextStyle(color:Colors.white, fontSize: 16),
                                          textAlign: TextAlign.left,),
                                        ),
                                    Container(
                                      color:Colors.blue,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex:6,
                                              child: Container(child: Text(
                                              totalSaleForTheSelectedMonthAsString,
                                              style:TextStyle(color:Colors.white, fontSize: 14),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                          Expanded(
                                            flex:2,
                                              child: Container(child: Text(
                                              totalWalkinsForTheSelectedMonthAsString,
                                               style:TextStyle(color:Colors.white, fontSize: 14),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                          Expanded(
                                            flex:2  ,
                                              child: Container(child: Text(
                                              totalWorkingDaysForTheSelectedMonthAsString,
                                              style:TextStyle(color:Colors.white, fontSize: 14),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                          Expanded(
                                            flex:2  ,
                                              child: Container(child: Text(
                                              averageDailySaleForTheSelectedMonthAsString,
                                              style:TextStyle(color:Colors.white, fontSize: 14),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                          Expanded(
                                            flex:2  ,
                                              child: Container(child: Text(
                                              averageDailyWalkinsForTheSelectedMonthAsString,
                                              style:TextStyle(color:Colors.white, fontSize: 14),
                                              textAlign: TextAlign.right,),
                                            ),
                                          ),
                                        ],                                          
                                      ),
                                    ),
                                    ]
                                    ),
                                  ) ;
                              } else {
                                return CircularProgressIndicator();
                              }
                            } else {
                              return CircularProgressIndicator();
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
}