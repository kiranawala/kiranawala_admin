import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/ShowOrders.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';
import 'package:kiranawala_admin/main.dart';
import 'dart:async';
import 'package:queries/collections.dart';

class ShowProductWiseSalePosition extends StatefulWidget {
  @override
  _ShowProductWiseSalePositionState createState() => _ShowProductWiseSalePositionState();
}

class _ShowProductWiseSalePositionState extends State<ShowProductWiseSalePosition> {
  // Map<dynamic, dynamic> categoryList = {};
  Map<dynamic,dynamic> productSalePositionMap = {};
  // List<Map> ProductWiseSale = [];
  List<String> productList = [];
  Map<String, dynamic> productDetailsList = {};
  bool refreshingData = false;
  bool allOK = false;
  Widget allOKWidget;
  String lastUpdatedTimeStampAsString = '';
  Map<String,dynamic> productListPerDate = {};
  Map<String, dynamic> salePositionPerDate = {};
  List<Map> salePositionBetweenDates = [];
  bool processingData = false;
  bool processedData = false;
  int processedDates = 0;  
  int productCount = 0;
  double totalSaleValue = 0.0;

List<dynamic> billList = [];
List<Widget> productSaleWidgetList = [];
Map<String, bool> retrievedDates = {};

  // getTotalSaleAndWalkinsForDate(){

  //   print('getting Fresh Data');
  //   salePerTerminal = [];
  //     FirebaseDatabase.instance.
  //         reference().
  //         child('storeTerminals').
  //         child(selectedPOSTerminal).
  //         child('sales').
  //         child(year).
  //         child(month).
  //         child(day).
  //         child('totalSale').
  //         once().
  //         then((totalSaleSnapshot){
  //           if (totalSaleSnapshot != null && totalSaleSnapshot.value != null) {         
  //             FirebaseDatabase.instance.
  //               reference().
  //               child('storeTerminals').
  //               child(selectedPOSTerminal).
  //               child('sales').
  //               child(year).
  //               child(month).
  //               child(day).
  //               child('totalWalkins').
  //               once().
  //               then((totalWalkinsSnapshot){
  //                 if (totalWalkinsSnapshot != null && totalWalkinsSnapshot.value != null) {     
  //                   totalSale = double.parse(totalSaleSnapshot.value.toString());
  //                   totalSaleAsString = totalSale.toStringAsFixed(0);

  //                   totalWalkins = totalWalkinsSnapshot.value;
  //                   totalWalkinsAsString = totalWalkins.toStringAsFixed(0);
  //                   setState(() {
  //                     print(totalSaleAsString);
  //                     print(totalWalkinsAsString);
  //                   });
  //                 }
  //               });
  //           }
  //         });
  //          setState(() {
  //           print(totalSaleAsString);
  //           print(totalWalkinsAsString);
  //           });
  // }

  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  DateTime startDate =  DateTime(int.parse(selectedSaleStartDate.substring(0,4)), int.parse(selectedSaleStartDate.substring(5,7)), int.parse(selectedSaleStartDate.substring(8,10)));
  DateTime endDate =  DateTime(int.parse(selectedSaleEndDate.substring(0,4)), int.parse(selectedSaleEndDate.substring(5,7)), int.parse(selectedSaleEndDate.substring(8,10)));
  List<DateTime> days;

  Future<dynamic> getSalePositionForDate(String year, String month, String dom) async
  {
    retrievedDates[year+month+dom] = false;
    FirebaseDatabase.instance
                      .reference()
                      .child('storeTerminals')
                      .child('POS_1')
                      .child('sales')
                      .child(year)
                      .child(month)
                      .child(dom)
                      .child('productSalePosition')
                      .once()
                      .then((snapshot){
                        if(snapshot != null && snapshot.value != null)
                        {
                          retrievedDates[year+month+dom] = true;
                          print('data retrieved successfully for ' + year + month + dom);
                          productListPerDate[year+month+dom] = snapshot.value;
                          print(snapshot.value);
                          // print(snapshot.value.length);
                          return snapshot.value;
                        }
                        else
                        {
                          print('data could not be retrieved for ' + year + month + dom);
                          return false;
                        }
                        // 
                      })
                      .catchError((onError){
                        print('data could not be retrieved for ' + year + month + dom);
                        return false;
                      });
  }

  Future<void> getSalePositionBetweenDates() async
  {
    DateTime startDate =  DateTime(int.parse(selectedSaleStartDate.substring(0,4)), int.parse(selectedSaleStartDate.substring(5,7)), int.parse(selectedSaleStartDate.substring(8,10)));
    DateTime endDate =  DateTime(int.parse(selectedSaleEndDate.substring(0,4)), int.parse(selectedSaleEndDate.substring(5,7)), int.parse(selectedSaleEndDate.substring(8,10)));
    List<DateTime> days = calculateDaysInterval(startDate, endDate);

    print('No. Of. days' + days.length.toString());   
    // print('Retrieval Status:' + productListPerDate.length.toString());
    salePositionBetweenDates = [];
    productListPerDate = {};
    salePositionPerDate = {};
    productDetailsList = {};
    totalSaleValue = 0.0;
    
    String year;
    String month;
    String dom;
    
    List<Future> futures = [];
    days.forEach((day){
        year = day.toString().substring(0,4);
        month = day.toString().substring(5,7);
        dom = day.toString().substring(8,10);
        print(year+month+dom);
      futures.add(FirebaseDatabase.instance
                      .reference()
                      .child('storeTerminals')
                      .child(selectedPOSTerminal)
                      .child('sales')
                      .child(year)
                      .child(month)
                      .child(dom)
                      .child('productSalePosition')
                      .once());
    });    
    int i = 0;
    Future.wait(futures).then((List<dynamic> responses){
      // print(responses.length);
      responses.forEach((response){        
        DataSnapshot snapshot = response;  
        if(snapshot!=null && snapshot.value!=null)
        {        
          productList = [];
          snapshot.value.forEach((key,value){
            productList.add(key);
            productDetailsList[key] = value;
            // print(key);
          });   
          productListPerDate[i.toString()] = productList;
          salePositionPerDate[i.toString()] = snapshot.value;
          i=i+1;
        }
      });     

      List<String> fullProductList = [];

      productListPerDate.forEach((key,value){
        // print(key);
        // print(value);
        // print(value.length);
        fullProductList = fullProductList + value;
        var result = new Collection(fullProductList).distinct();
        // print(result.toList());
        fullProductList = result.toList();
        // print(fullProductList.length);
      });

      // salePositionPerDate.forEach((key,value){
      //   print(key);
      //   print(value.length);
      // });

      fullProductList.forEach((f){
        double finalSalePosition = 0.0;
        salePositionPerDate.forEach((key, value){
          Map<dynamic, dynamic> salePosition = value;          
          if(salePosition.containsKey(f))
          {            
            finalSalePosition = finalSalePosition + salePosition[f]['salePosition'];
          }
        });    
        print(f);    
        print(finalSalePosition);
        salePositionBetweenDates.add({
                                        'productName': productDetailsList[f]['productDetails']['productName'],
                                        'salePosition':finalSalePosition,
                                        'saleValue':productDetailsList[f]['productDetails']['productPrice'] * finalSalePosition
                                    });
        totalSaleValue = totalSaleValue + productDetailsList[f]['productDetails']['productPrice'] * finalSalePosition;        
        // salePositionBetweenDates[productDetailsList[f]['productDetails']['productName']] = finalSalePosition;
      });      

      print(totalSaleValue);

            salePositionBetweenDates.sort((a, b){
                                return b['saleValue'].compareTo(a['saleValue']);
                              });

      // salePositionBetweenDates.forEach((key, value){
      //   print(key + ' : ' + value.toStringAsFixed(2));
      // });

      // print(salePositionBetweenDates);
      setState(() {
        refreshingData = false;
        productCount = salePositionBetweenDates.length;
      });
   
    });                
  }
    
  getProductSalePositionForDate()
  {

    print('getProductSalePositionForDate()');

    DateTime startDate =  DateTime(int.parse(selectedSaleStartDate.substring(0,4)), int.parse(selectedSaleStartDate.substring(5,7)), int.parse(selectedSaleStartDate.substring(8,10)));
    DateTime endDate =  DateTime(int.parse(selectedSaleEndDate.substring(0,4)), int.parse(selectedSaleEndDate.substring(5,7)), int.parse(selectedSaleEndDate.substring(8,10)));
    List<DateTime> days = calculateDaysInterval(startDate, endDate);

    print('No. Of. days' + days.length.toString());

    days.forEach((day){
      print(day);
    });    

    String year;
    String month;
    String dom;


    // var promises = [];
    // days.forEach((day){
      
    //   promises.push(    )

    // });

    productSaleWidgetList = [];
    productList = [];

    // Widget x = Column(children: <Widget>[
    //     // Container(
    //     //   height: 20.0,
    //     //   child:Text('SALE Analysis')
    //     //   ),
    //     Container(
    //       height:300.0,
    //       child: 
    //       Container(
    //       child: Align(
    //         alignment: Alignment.center,
    //         child: ListView.builder(
    //                   itemCount: days.length,
    //                   itemBuilder: (BuildContext context, int index) {
    //                     print(index);
    //                     print(days[index]);  

    //                     String year = days[index].toString().substring(0,4);
    //                     String month = days[index].toString().substring(5,7);
    //                     String day = days[index].toString().substring(8,10);

    //                     print(year);
    //                     print(month);
    //                     print(day);
                        
    //                     return new StreamBuilder(
    //                       builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
    //                         if (snapshot.hasData) {
    //                           if (snapshot.data != null &&
    //                               snapshot.data.snapshot.value != null) {

    //                                 print(snapshot.data.snapshot.value.length);
                                    // Map<dynamic,dynamic> map = snapshot.data.snapshot.value;
                                    // if(map.containsKey('totalSale') && map.containsKey('totalWalkins') && map.containsKey('workingDays'))
                                    // {
                                    //   print(map['totalSale'].toString());
                                    //   print(map['totalWalkins'].toString());
                                    //   print(map['workingDays'].toString());

                                    //   totalSaleForTheSelectedMonthAsString = map['totalSale'].toStringAsFixed(2);
                                    //   totalWalkinsForTheSelectedMonthAsString = map['totalWalkins'].toString();
                                    //   totalWorkingDaysForTheSelectedMonthAsString = map['workingDays'].toString();

                                    //   totalSaleForTheSelectedMonth = double.parse(totalSaleForTheSelectedMonthAsString);
                                    //   totalWalkinsForTheSelectedMonth = int.parse(totalWalkinsForTheSelectedMonthAsString);
                                    //   totalWorkingDaysForTheSelectedMonth = int.parse(totalWorkingDaysForTheSelectedMonthAsString);

                                    //   averageDailySaleForTheSelectedMonthAsString = (totalSaleForTheSelectedMonth / totalWorkingDaysForTheSelectedMonth).toStringAsFixed(0);
                                    //   averageDailyWalkinsForTheSelectedMonthAsString = (totalWalkinsForTheSelectedMonth / totalWorkingDaysForTheSelectedMonth).toStringAsFixed(0);

                                      
                                    // }                               

                                // return         
                                // Container(
                                //   color:Colors.white,
                                //   margin: EdgeInsets.all(8.0),
                                //   child:Text('No. Of Products for DAY ' + index.toString() + ' ' + days[index].toString() + ' : ' + snapshot.data.snapshot.value.length.toString())
                                //   );
                                  // Container(
                                  //   margin: EdgeInsets.all(8.0),
                                  //   color:Colors.blue,
                                  //   child: Column(children: <Widget>[  
                                  //   Container(
                                  //     color:Colors.blue,
                                  //     child: Text(
                                  //         posTerminalStoreNameMapping[terminalsAtStore[index]],
                                  //         style:TextStyle(color:Colors.white, fontSize: 16),
                                  //         textAlign: TextAlign.left,),
                                  //       ),
                                  //   Container(
                                  //     color:Colors.blue,
                                  //     child: Row(
                                  //       children: <Widget>[
                                  //         Expanded(
                                  //           flex:6,
                                  //             child: Container(child: Text(
                                  //             totalSaleForTheSelectedMonthAsString,
                                  //             style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           flex:2,
                                  //             child: Container(child: Text(
                                  //             totalWalkinsForTheSelectedMonthAsString,
                                  //              style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           flex:2  ,
                                  //             child: Container(child: Text(
                                  //             totalWorkingDaysForTheSelectedMonthAsString,
                                  //             style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           flex:2  ,
                                  //             child: Container(child: Text(
                                  //             averageDailySaleForTheSelectedMonthAsString,
                                  //             style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           flex:2  ,
                                  //             child: Container(child: Text(
                                  //             averageDailyWalkinsForTheSelectedMonthAsString,
                                  //             style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //       ],                                          
                                  //     ),
                                  //   ),
                                  //   ]
                                  //   ),
                                  // ) ;
    //                           } else {
    //                             return CircularProgressIndicator();
    //                           }
    //                         } else {
    //                           return CircularProgressIndicator();
    //                         }
    //                       },
    //                   stream:                        
    //                   FirebaseDatabase.instance
    //                     .reference()
    //                     .child('storeTerminals')
    //                     .child(selectedPOSTerminal)
    //                     .child('sales')
    //                     .child(year)
    //                     .child(month)
    //                     .child(day)
    //                     .child('productSalePosition')
    //                     .onValue,
    //                     );
    //                   },                      
    //                 )
    //   ),
    // )
    // ),
    // ]);
  }

@override
  void initState() 
    {
    super.initState(); 
    // print('ShowProductWiseSalePosition:');
    // print(terminalsAtStore);
    // print(isStoreAdmin);
    // print(mobileNumber);
    List<String> array1 = ["John", "Bob", "Fred", "June", "Tom"];
    List<String> array2 = ["House", "Flat", "Bungalow", "John"];

    

    List<String> list = array1 + array2;
    var result = new Collection(list).distinct();
    print(result.toList());
    getSalePositionBetweenDates();
    
    // getTotalSaleAndWalkinsForDate();
    // getProductSalePositionForDate();    

    
    // FirebaseDatabase.instance
    //                   .reference()
    //                   .child('storeTerminals')
    //                   .child('POS_1')
    //                   .child('sales')
    //                   .child(year)
    //                   .child(month)
    //                   .child(day)
    //                   .child('categorySalePosition')
    //                   .once()
    //                   .then((categorySalePosition){
    //                     if(categorySalePosition != null && categorySalePosition.value != null)
    //                     {
    //                       print(categorySalePosition.value);
    //                       categoryList = categorySalePosition.value;
    //                       categoryList.forEach((category, details){
    //                         print(category + ' ' + details['totalSale'].toString());
    //                         ProductWiseSale.add({'category':category,'totalSale':details['totalSale']}); 
    //                       });
    //                       print(categoryList);                          
    //                     }
    //                     setState(() {
                          
    //                     });
    //                   });
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
    
    refreshingProductWiseSales = true;
    // getFreshData();
  }

  // void orderBySaleValue()
  // {
  //     productList = [];
  //     productSalePositionMap.forEach((key,value){
  //       productList.add(key);
  //     });
  //     print(productList);
  //     productList.sort((a, b){
  //                               return productSalePositionMap[a]['salePosition'].compareTo(productSalePositionMap[b]['salePosition']);
  //                             });
  //     print(productList);
  //     setState(() {
  //           refreshingData = false;   
  //           lastUpdatedTimeStampAsString = DateFormat('yyyyMMMdd:hhmmss').format(DateTime.now()).toString();
  //     });
  // }

  @override
  Widget build(BuildContext context) {  
    DateTime startDate =  DateTime(int.parse(selectedSaleStartDate.substring(0,4)), int.parse(selectedSaleStartDate.substring(5,7)), int.parse(selectedSaleStartDate.substring(8,10)));
    DateTime endDate =  DateTime(int.parse(selectedSaleEndDate.substring(0,4)), int.parse(selectedSaleEndDate.substring(5,7)), int.parse(selectedSaleEndDate.substring(8,10)));
    List<DateTime> days = calculateDaysInterval(startDate, endDate);

    processedData = false;

    // print('No. Of. days' + days.length.toString());

    // days.forEach((day){
    //   print(day);
    // });    

    productSaleWidgetList = [];
    productList = [];
    // days = calculateDaysInterval(startDate, endDate);      
    if(refreshingData)
     return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: const Text(
            'PRODUCT-WISE DAILY SALES',
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
        color: Colors.white,
        child: Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading Products....."),
            ],
          ),
        ),
      )
     );
    else
        return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: const Text(
            'PRODUCT-WISE DAILY SALES',
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
        child:  
        Column(
          children:<Widget>[
                                Expanded(
                                  flex:1,
                                  child: Row(
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
                                                                        print('change $date');
                                                                      }, 
                                                                      onConfirm: (date) {
                                                                        selectedSaleStartDate = DateFormat('yyyy-MM-dd').format(date);
                                                                        year = selectedSaleStartDate.substring(0,4);
                                                                        month = selectedSaleStartDate.substring(5,7);
                                                                        day = selectedSaleStartDate.substring(8,10);
                                                                        // print(date);
                                                                        // print(selectedSaleStartDate);
                                                                        // print(year);
                                                                        // print(month);
                                                                        // print(day);                                            
                                                                        setState(() {});
                                                                      }, 
                                                currentTime: DateTime.now(), locale: LocaleType.en);
                                            },
                                            child: Text(
                                                selectedSaleStartDate.toUpperCase(),
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
                                          decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                          height: 30.0,
                                          child:FlatButton(
                                            onPressed: () {
                                                DatePicker.showDatePicker(context,
                                                                      showTitleActions: true,
                                                                      minTime: DateTime(2019, 11, 01),
                                                                      maxTime: DateTime.now(), 
                                                                      onChanged: (date) {
                                                                        print('change $date');
                                                                      }, 
                                                                      onConfirm: (date) {
                                                                        selectedSaleEndDate = DateFormat('yyyy-MM-dd').format(date);
                                                                        year = selectedSaleEndDate.substring(0,4);
                                                                        month = selectedSaleEndDate.substring(5,7);
                                                                        day = selectedSaleEndDate.substring(8,10);
                                                                        // print(date);
                                                                        // print(selectedSaleEndDate);
                                                                        // print(year);
                                                                        // print(month);
                                                                        // print(day);                                            
                                                                        setState(() {});
                                                                      }, 
                                                currentTime: DateTime.now(), locale: LocaleType.en);
                                            },
                                            child: Text(
                                                selectedSaleEndDate.toUpperCase(),
                                                style: TextStyle(color: Colors.blue,
                                                  fontSize: 14.0,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                ),
                                  Expanded(
                                    flex:1,
                                    child: Row(children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all(color:Colors.white), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                          height: 30.0,
                                          child:FlatButton(
                                            color:Colors.blue,
                                            onPressed: () {                    
                                              print('Refreshing Data...');                                              
                                              setState(() {
                                                refreshingData = true;
                                              });
                                              // getTotalSaleAndWalkinsForDate();
                                              // getProductSalePositionForDate(); 
                                              retrievedDates = {};
                                              getSalePositionBetweenDates();             
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
                                  ),
                                Expanded(
                                  flex:1,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                          height: 30.0,
                                          child:Text(
                                              'Rs.' + totalSaleValue.toString() + '/-',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.blue,
                                                fontSize: 14.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                          height: 30.0,
                                          child:Text(
                                              productCount.toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.blue,
                                                fontSize: 14.0,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   flex:1,
                                //   child: Row(children: <Widget>[
                                //     Expanded(
                                //         child: Container(
                                //         height:30.0,
                                //         child:Text(
                                //           'Last Updated at:',
                                //           textAlign: TextAlign.center,
                                //           style: TextStyle(color: Colors.blue,
                                //             fontSize: 12.0,
                                //             fontFamily: 'Montserrat',
                                //             fontWeight: FontWeight.bold
                                //           ),
                                //         )
                                //         ),
                                //     ),
                                //     Expanded(
                                //         child: Container(
                                //         height:30.0,
                                //         child:Text(
                                //           lastUpdatedTimeStampAsString,
                                //           textAlign: TextAlign.center,
                                //           style: TextStyle(color: Colors.blue,
                                //             fontSize: 12.0,
                                //             fontFamily: 'Montserrat',
                                //             fontWeight: FontWeight.bold
                                //           ),
                                //         )
                                //         ),
                                //     ),

                                //   ],),
                                // ),
            Expanded(
              flex:16,
              child: Container(
                height:300.0,
                child: 
                Container(
                child: Align(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: salePositionBetweenDates.length,
                    itemBuilder: (BuildContext context, int index){
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Row(children: <Widget>[
                          Expanded(
                            flex:8,
                            child:
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                Text(
                                  salePositionBetweenDates[index]['productName'],
                                  textAlign: TextAlign.right,
                                )
                              )
                          ),
                          Expanded(
                            flex:4,      
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:Text(
                                salePositionBetweenDates[index]['salePosition'].toString(),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),                   
                           Expanded(
                            flex:4,      
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:Text(
                                salePositionBetweenDates[index]['saleValue'].toString(),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),                   
                        ],
                  ),
                      );
                    },
                  ),
                )
                )
              )
            )
          ]
        )
      )
    );


            // child: ListView.builder(
            //           itemCount: days.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             print(index);
            //             print(days[index]);  

            //             String year = days[index].toString().substring(0,4);
            //             String month = days[index].toString().substring(5,7);
            //             String day = days[index].toString().substring(8,10);

            //             print(year);
            //             print(month);
            //             print(day);
            //             retrievedDates[days[index].toString().substring(0,10)] = false;
                        
            //             return new StreamBuilder(
            //               builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
            //                 if (snapshot.hasData) {
            //                   if (snapshot.data != null &&
            //                       snapshot.data.snapshot.value != null) {

            //                         print(snapshot.data.snapshot.value.length);
            //                         Map<dynamic,dynamic> map = snapshot.data.snapshot.value;
            //                         productList = [];
            //                         map.forEach((key,value){
            //                           productList.add(key);
            //                         });
            //                         productListPerDate[days[index].toString().substring(0,10)] = productList;
            //                         productList = [];
                                    
            //                         retrievedDates[days[index].toString().substring(0,10)] = true;
            //                         retrievedDates.forEach((key,value){
            //                           allOK = value;
            //                         });

            //                         if(allOK == true && !processingData && !processedData)
            //                         {
            //                           print(productListPerDate);
            //                           processingData = true;
            //                           print('Product Sale Position for all days retrieved successfully');
            //                           processingData = false;
            //                           processedData = true;
            //                           return Container(
            //                             height: 20.0,
            //                             color:Colors.green,
            //                             child: ListView.builder(
            //                               itemCount: days.length,
            //                               itemBuilder: (BuildContext context, int index){
            //                                 return Container(                                              
            //                                   height: 15.0,
            //                                   child:Text(
            //                                     days[index].toString().substring(0,10)
            //                                     )
            //                                   );
            //                               },
            //                             )
                                        // );
                                      // productListPerDate.forEach((key,value){                                                                        
                                      //   print(key);
                                      //   print(value);
                                      //   print(value.length);
                                      // });
                                   
                                    }
                                    // if(map.containsKey('totalSale') && map.containsKey('totalWalkins') && map.containsKey('workingDays'))
                                    // {
                                    //   print(map['totalSale'].toString());
                                    //   print(map['totalWalkins'].toString());
                                    //   print(map['workingDays'].toString());

                                    //   totalSaleForTheSelectedMonthAsString = map['totalSale'].toStringAsFixed(2);
                                    //   totalWalkinsForTheSelectedMonthAsString = map['totalWalkins'].toString();
                                    //   totalWorkingDaysForTheSelectedMonthAsString = map['workingDays'].toString();

                                    //   totalSaleForTheSelectedMonth = double.parse(totalSaleForTheSelectedMonthAsString);
                                    //   totalWalkinsForTheSelectedMonth = int.parse(totalWalkinsForTheSelectedMonthAsString);
                                    //   totalWorkingDaysForTheSelectedMonth = int.parse(totalWorkingDaysForTheSelectedMonthAsString);

                                    //   averageDailySaleForTheSelectedMonthAsString = (totalSaleForTheSelectedMonth / totalWorkingDaysForTheSelectedMonth).toStringAsFixed(0);
                                    //   averageDailyWalkinsForTheSelectedMonthAsString = (totalWalkinsForTheSelectedMonth / totalWorkingDaysForTheSelectedMonth).toStringAsFixed(0);

                                      
                                    // }                               

                                // return         
                                // Container(
                                //   color:Colors.white,
                                //   margin: EdgeInsets.all(8.0),
                                //   child:
                                //     Column(children:<Widget>[                                                                                                                                                          
                                //       allOKWidget
                                //     ] )
                                //   );
                                  // Container(
                                  //   margin: EdgeInsets.all(8.0),
                                  //   color:Colors.blue,
                                  //   child: Column(children: <Widget>[  
                                  //   Container(
                                  //     color:Colors.blue,
                                  //     child: Text(
                                  //         posTerminalStoreNameMapping[terminalsAtStore[index]],
                                  //         style:TextStyle(color:Colors.white, fontSize: 16),
                                  //         textAlign: TextAlign.left,),
                                  //       ),
                                  //   Container(
                                  //     color:Colors.blue,
                                  //     child: Row(
                                  //       children: <Widget>[
                                  //         Expanded(
                                  //           flex:6,
                                  //             child: Container(child: Text(
                                  //             totalSaleForTheSelectedMonthAsString,
                                  //             style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           flex:2,
                                  //             child: Container(child: Text(
                                  //             totalWalkinsForTheSelectedMonthAsString,
                                  //              style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           flex:2  ,
                                  //             child: Container(child: Text(
                                  //             totalWorkingDaysForTheSelectedMonthAsString,
                                  //             style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           flex:2  ,
                                  //             child: Container(child: Text(
                                  //             averageDailySaleForTheSelectedMonthAsString,
                                  //             style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //           flex:2  ,
                                  //             child: Container(child: Text(
                                  //             averageDailyWalkinsForTheSelectedMonthAsString,
                                  //             style:TextStyle(color:Colors.white, fontSize: 14),
                                  //             textAlign: TextAlign.right,),
                                  //           ),
                                  //         ),
                                  //       ],                                          
                                  //     ),
                                  //   ),
                                  //   ]
                                  //   ),
                                  // ) ;
                    //           } else {
                    //             return CircularProgressIndicator();
                    //           }
                    //         } else {
                    //           return CircularProgressIndicator();
                    //         }
                    //       },
                    //   stream:                        
                    //   FirebaseDatabase.instance
                    //     .reference()
                    //     .child('storeTerminals')
                    //     .child(selectedPOSTerminal)
                    //     .child('sales')
                    //     .child(year)
                    //     .child(month)
                    //     .child(day)
                    //     .child('productSalePosition')
                    //     .onValue,
                    //     );
                    //   },                      
                    // )
    //   ),
    // )
    // ),
    // ])
            // ),                
          // ]         
      // )
    // )
  
  }