import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/request-date.dart';
import 'package:kiranawala_admin/pages/show-product-sale.dart';
import 'pages/show-home-page.dart';

Widget getTextWidget(String text, double fontSize, Color color){
  return Text(text,
    style:TextStyle(
      fontFamily: 'Montserrat',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color:color
    ),
    textAlign: TextAlign.center,
  );
}

List<String> stores = [
  'S-MART GROUP',
  'S-MART I',
  'S-MART II',
  'S-MART III',
  'S-MART IV',
  'S-MART V',
  'S-MART VI',
  'S-MART VII',
];

Map<String, List<String>> storeTerminalMap = {
  'S-MART GROUP':['POS_4','POS_3','POS_2','POS_5','POS_6','POS_7','POS_8'],
  'S-MART I':['POS_4'],
  'S-MART II':['POS_3'],
  'S-MART III':['POS_2'],
  'S-MART IV':['POS_6'],
  'S-MART V':['POS_7'],
  'S-MART VI':['POS_5'],
  'S-MART VII':['POS_8','POS_9'],
};

String selectedStore = stores[0];
bool storeResetSuccessful = true;

void main(){
 runApp(
   new MaterialApp(
     theme: ThemeData(fontFamily: 'Kohinoor-Boldx'),
    debugShowCheckedModeBanner: false,
//    home:ShowProductSalePosition(),
    home: ShowHomePage(),
  ));
}




