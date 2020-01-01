import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/ShowOrders.dart';
import 'package:kiranawala_admin/pages/ShowSelectedCategoryProducts.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';
import 'package:kiranawala_admin/main.dart';

class ShowCategoryWiseSalePosition extends StatefulWidget {
  @override
  _ShowCategoryWiseSalePositionState createState() => _ShowCategoryWiseSalePositionState();
}

class _ShowCategoryWiseSalePositionState extends State<ShowCategoryWiseSalePosition> {
  // Map<dynamic, dynamic> categoryList = {};
  Map<dynamic,dynamic> categorySalePositionMap = {};
  // List<Map> categoryWiseSale = [];
  List<String> categoryList = [];
  List<String> productList = [];
  
  bool refreshingData = false;
  String lastUpdatedTimeStampAsString = '';
  


List<dynamic> billList = [];
List<Widget> categorySaleWidgetList = [];

  getTotalSaleAndWalkinsForDate(){

    print('getting Fresh Data');
    salePerTerminal = [];
      FirebaseDatabase.instance.
          reference().
          child('storeTerminals').
          child(selectedPOSTerminal).
          child('sales').
          child(year).
          child(month).
          child(day).
          child('totalSale').
          once().
          then((totalSaleSnapshot){
            if (totalSaleSnapshot != null && totalSaleSnapshot.value != null) {         
              FirebaseDatabase.instance.
                reference().
                child('storeTerminals').
                child(selectedPOSTerminal).
                child('sales').
                child(year).
                child(month).
                child(day).
                child('totalWalkins').
                once().
                then((totalWalkinsSnapshot){
                  if (totalWalkinsSnapshot != null && totalWalkinsSnapshot.value != null) {     
                    totalSale = double.parse(totalSaleSnapshot.value.toString());
                    totalSaleAsString = totalSale.toStringAsFixed(0);

                    totalWalkins = totalWalkinsSnapshot.value;
                    totalWalkinsAsString = totalWalkins.toStringAsFixed(0);
                    setState(() {
                      print(totalSaleAsString);
                      print(totalWalkinsAsString);
                    });
                  }
                });
            }
          });
           setState(() {
            print(totalSaleAsString);
            print(totalWalkinsAsString);
            });
  }

  getCategorySalePositionForDate()
  {
    categorySaleWidgetList = [];
    categoryList = [];
    FirebaseDatabase.instance
      .reference()
      .child('storeTerminals')
      .child(selectedPOSTerminal)
      .child('sales')
      .child(year)
      .child(month)
      .child(day)
      .child('categorySalePosition')
      .once()
      .then((snapshot){
        if(snapshot != null && snapshot.value != null)
        {
          print(snapshot.value);
          print(snapshot.value.length);          
          Map<dynamic,dynamic> categorySalePositionMap = snapshot.value;
          categorySalePositionMap.forEach((key,value){
            // print(value);
            print(key);
            categoryList.add(key);
          });
          print(categoryList);
          categoryList.sort((b,a){return categorySalePositionMap[a]['totalSale'].compareTo(categorySalePositionMap[b]['totalSale']);});
          print(categoryList);
          categoryList.forEach((category){
             categorySaleWidgetList.add(
              InkWell(
                onTap:(){  
                  productListForSelectedCategory = [];
                  print('category tapped.');
                  print(category);
                  print(productList);
                  print(productSalePositionMap);
                  print(productSalePositionMap.length);

                  productSalePositionMap.forEach((key,value){
                    print(key);
                    print(value);
                    if(value['productDetails'] != null && value['productDetails']['productCategory'] == category)
                    {
                      productListForSelectedCategory.add(key);
                    }
                  });
                  print(productListForSelectedCategory);
                  Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context){
                    return ShowSelectedCategoryProducts();
                  }));
                            // showDialog(
                            //               context: context,
                            //               builder: (context)
                            //               {
                            //                 if(productListForSelectedCategory.length > 0)
                            //                   return AlertDialog(
                            //                       title:Text(
                            //                         'PRODUCTS IN ' + category,
                            //                         style:TextStyle(
                            //                                         color:Colors.black,
                            //                                         fontFamily: "Montserrat",
                            //                                         fontWeight: FontWeight.bold,
                            //                                         fontSize: 12.0
                            //                                       )
                            //                         ),
                            //                       content: Container(
                            //                           child:ListView.builder(
                            //                             itemCount: productListForSelectedCategory.length,
                            //                             itemBuilder: (BuildContext context, int index){
                            //                               return Row(children: <Widget>[
                            //                                 Expanded(
                            //                                   flex:9,
                            //                                   child: Text(
                            //                                     productSalePositionMap[productListForSelectedCategory[index]]['productDetails']['productName'],
                            //                                      style:TextStyle(
                            //                                       color: Colors.blue,
                            //                                       fontFamily: 'Montserrat',
                            //                                       fontSize:14.0,
                            //                                       )
                            //                                   ),
                            //                                 ),
                            //                                 Expanded(
                            //                                   flex:1,
                            //                                   child: Text(
                            //                                     productSalePositionMap[productListForSelectedCategory[index]]['salePosition'].toString(),
                            //                                      style:TextStyle(
                            //                                       color: Colors.blue,
                            //                                       fontFamily: 'Montserrat',
                            //                                       fontSize:14.0,
                            //                                       )
                            //                                   ),
                            //                                 ),
                            //                               ],);
                            //                             },
                            //                           ),                                                                                                       
                            //                     ),
                            //                   );
                            //                 else
                            //                   return AlertDialog(
                            //                       title:Text(
                            //                         'PRODUCTS IN ' + category,
                            //                         style:TextStyle(
                            //                                         color:Colors.black,
                            //                                         fontFamily: "Montserrat",
                            //                                         fontWeight: FontWeight.bold,
                            //                                         fontSize: 12.0
                            //                                       )
                            //                         ),
                            //                       content: Container(
                            //                         alignment: Alignment.center,
                            //                         child:Text(
                            //                           'NO PRODUCTS IN ' + category,
                            //                           style:TextStyle(
                            //                                         color:Colors.red,
                            //                                         fontFamily: "Montserrat",
                            //                                         fontWeight: FontWeight.bold,
                            //                                         fontSize: 14.0
                            //                                       )
                            //                         ),
                            //                       )
                            //                   );           
                            //               }                                
                            //             );                
                },
                child: Container(
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
                            category,
                            textAlign: TextAlign.right,
                          )
                        )
                    ),
                    Expanded(
                      flex:4,      
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Text(
                          categorySalePositionMap[category]['totalSale'].toString(),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),                   
                  ],
            ),
                ),
              ),
            );
          });
          
          setState(() {   
            refreshingData = false;   
            lastUpdatedTimeStampAsString = DateFormat('yyyyMMMdd:hhmmss').format(DateTime.now()).toString();      
          });             
        }      
      });
  }

@override
  void initState()
  {
    super.initState(); 
    print('ShowCategoryWiseSalePosition:');
    // print(terminalsAtStore);
    // print(isStoreAdmin);
    // print(mobileNumber);
    getProductSalePositionForDate();
    getTotalSaleAndWalkinsForDate();
    getCategorySalePositionForDate();

    
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
    //                         categoryWiseSale.add({'category':category,'totalSale':details['totalSale']}); 
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
    
    refreshingCategoryWiseSales = true;
    // getFreshData();
  }

  getProductSalePositionForDate()
  {
    productList = [];
    FirebaseDatabase.instance
      .reference()
      .child('storeTerminals')
      .child(selectedPOSTerminal)
      .child('sales')
      .child(year)
      .child(month)
      .child(day)
      .child('productSalePosition')
      .once()
      .then((snapshot){
        if(snapshot != null && snapshot.value != null)
        {
          print(snapshot.value);
          print(snapshot.value.length);          
          productSalePositionMap = snapshot.value;
          productSalePositionMap.forEach((key,value){
            // print(value);
            print(key);
            productList.add(key);
          });
          print(productList);
          productList.sort((b,a){return productSalePositionMap[a]['salePosition'].compareTo(productSalePositionMap[b]['salePosition']);});
          print(productList);         
        }      
      });
  }


  void orderBySaleValue()
  {
      categoryList = [];
      categorySalePositionMap.forEach((key,value){
        categoryList.add(key);
      });
      print(categoryList);
      categoryList.sort((a, b){
                                return categorySalePositionMap[a]['totalSale'].compareTo(categorySalePositionMap[b]['totalSale']);
                              });
      print(categoryList);
      setState(() {
            refreshingData = false;   
            lastUpdatedTimeStampAsString = DateFormat('yyyyMMMdd:hhmmss').format(DateTime.now()).toString();
      });
  }

  @override
  Widget build(BuildContext context) {             
        return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: const Text(
            'CATEGORY-WISE DAILY SALES',
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
                                                                      print('change $date');
                                                                    }, 
                                                                    onConfirm: (date) {
                                                                      selectedSaleDate = DateFormat('yyyy-MM-dd').format(date);
                                                                      year = selectedSaleDate.substring(0,4);
                                                                      month = selectedSaleDate.substring(5,7);
                                                                      day = selectedSaleDate.substring(8,10);
                                                                      print(date);
                                                                      print(selectedSaleDate);
                                                                      print(year);
                                                                      print(month);
                                                                      print(day);                                            
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
                                            print('Refreshing Data...');                                              
                                            setState(() {
                                              refreshingData = true;
                                            });
                                            getTotalSaleAndWalkinsForDate();
                                            getCategorySalePositionForDate();              
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
                                                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                        height: 30.0,
                                        child:Text(
                                            'Rs.' + totalSaleAsString + '/-',
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
                                            totalWalkinsAsString,
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
                                Row(children: <Widget>[
                                  Expanded(
                                      child: Container(
                                      height:30.0,
                                      child:Text(
                                        'Last Updated at:',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blue,
                                          fontSize: 12.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                      ),
                                  ),
                                  Expanded(
                                      child: Container(
                                      height:30.0,
                                      child:Text(
                                        lastUpdatedTimeStampAsString,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.blue,
                                          fontSize: 12.0,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                      ),
                                  ),

                                ],),
            Expanded(
              flex:50,
              child: Container(
                                  height:400.0,
                                  child: Align(
                                  alignment: Alignment.center,
                                  child:ListView(
                                    children: <Widget>[
                                                Divider(
                                                  height: 5.0,
                                                ),
                                                Column(
                                                  children: categorySaleWidgetList,
                                                ),                             
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                              ],
                                            ),
                              )
                            ),
            ),                
          ]         
      )
    )
  );
  }
}