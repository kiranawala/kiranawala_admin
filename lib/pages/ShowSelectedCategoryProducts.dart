import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart' as prefix0;
import 'package:kiranawala_admin/pages/ShowOrders.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';
import 'package:kiranawala_admin/main.dart';

class ShowSelectedCategoryProducts extends StatefulWidget {
  @override
  _ShowSelectedCategoryProductsState createState() => _ShowSelectedCategoryProductsState();
}

class _ShowSelectedCategoryProductsState extends State<ShowSelectedCategoryProducts> {
  // Map<dynamic, dynamic> categoryList = {};
  Map<dynamic,dynamic> categorySalePositionMap = {};
  // List<Map> categoryWiseSale = [];
  List<String> categoryList = [];
  List<String> productList = [];
  // List<String> productListForSelectedCategory = [];
  bool refreshingData = false;
  String lastUpdatedTimeStampAsString = '';
  // Map<dynamic,dynamic> productSalePositionMap = {};


List<dynamic> billList = [];
List<Widget> categorySaleWidgetList = [];

@override
void initState(){
  super.initState();
  print(prefix0.productListForSelectedCategory);
  print(prefix0.productListForSelectedCategory.length);
  print(prefix0.productSalePositionMap);
  print(prefix0.productSalePositionMap.length);
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
      ListView.builder(
        itemCount: productListForSelectedCategory.length,
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
            child: Row(
              children: <Widget>[
                Expanded(
                  flex:9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      productSalePositionMap[productListForSelectedCategory[index]]['productDetails']['productName'],
                      style:TextStyle(
                        color:Colors.black,
                        fontFamily: 'Montserrat',
                        fontSize: 12.0
                      ),
                    ),
                  ),           
                ),
                Expanded(
                  flex:1,
                  child: Text(productSalePositionMap[productListForSelectedCategory[index]]['salePosition'].toString(),
                    style:TextStyle(
                      color:Colors.black,
                      fontFamily: 'Montserrat',
                      fontSize: 12.0
                    ),
                  ),           
                )              
              ],
            ),
          );
        },
      )    
  );
  }
}