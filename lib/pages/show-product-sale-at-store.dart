import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart';
//import 'package:kiranawala_admin/pages/multi-store-stock-position.dart';
import 'package:kiranawala_admin/pages/select-products.dart';
import 'package:kiranawala_admin/pages/select-store-no-return.dart';
import 'package:kiranawala_admin/pages/select-store.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';
import 'package:kiranawala_admin/pages/show-product-sale-by-date.dart';


String startDate = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days:-1)));
String endDate = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days:-1)));
DateTime startDateAsDateTime = DateTime.now().add(Duration(days:-1));
DateTime endDateAsDateTime = DateTime.now().add(Duration(days:-1));
Map<String, double> saleByDate = Map<String, double>();


class ShowProductSalePosition extends StatefulWidget {
  @override
  _ShowProductSalePositionState createState() =>
      _ShowProductSalePositionState();
}

class _ShowProductSalePositionState extends State<ShowProductSalePosition> {

  String barCode = 'SELECT PRODUCT';
  List<String> productCodes = List<String>();

  int dayCount = 0;
  int daysProcessed = 0;
  Map<String, int> daysProcessedForProductcode = Map<String, int>();
  double totalSaleForSelectedPeriod = 0;
  double averageSaleForSelectedPeriod = 0;
  Map<String, double> totalSaleForSelectedPeriodForProductCode = Map<String, double>();
  Map<String, double> averageSaleForSelectedPeriodForProductCode = Map<String, double>();
  Map<String, bool> productCodesProcessed = Map<String, bool>();
  bool allProductCodesProcessed = false;
  int productCodesProcessedCount  = 0;
  List<ProductBasicDetails> products = List<ProductBasicDetails>();
  String productName = 'SELECT PRODUCT';


  void lookUpProduct() {
    Navigator.of(context).pop();
    Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          return ProductLookUp ();
        }));
//    print(products);
//    if (products.length > 0) {
//      products.forEach((product){
//        productName = product.productName;
//      });
//      setState(() {
//        print('Finished retrieving products');
//        print('Product Name is ' + productName);
//      });
//    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    String startDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
//    String endDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    print(startDate);
    print(endDate);
//    selectedStore = stores[0];
  }

  void getProductSalePositionForDateForProductCode(String productCode, String terminal, String year, String month, String day){
    FirebaseDatabase
        .instance
        .reference()
        .child('storeTerminals')
        .child(terminal)
        .child('sales')
        .child(year)
        .child(month)
        .child(day)
        .child('productSalePosition')
        .child(productCode)
        .child('salePosition')
        .once()
        .then((productSalePositionSnapshot) {
      if (productSalePositionSnapshot != null &&
          productSalePositionSnapshot.value != null) {
        if(totalSaleForSelectedPeriodForProductCode[productCode]!= null){
          totalSaleForSelectedPeriodForProductCode[productCode] = totalSaleForSelectedPeriodForProductCode[productCode] + productSalePositionSnapshot.value;
          saleByDate[day+month+year] = double.parse(productSalePositionSnapshot.value.toString());
        }
        else{
          totalSaleForSelectedPeriodForProductCode[productCode] = double.parse(productSalePositionSnapshot.value.toString());
        }

        print('Sale Position For ' + productCode + ' @ ' + terminal + ' on ' + day + '/' + month +'/' + year +' is ' + productSalePositionSnapshot.value.toString());
      }
      daysProcessedForProductcode[productCode] = (daysProcessedForProductcode[productCode] != null)? (daysProcessedForProductcode[productCode] + 1):1;
      print('Days Processed So Far:' + daysProcessedForProductcode[productCode].toString());
      print('Total Sale So Far:' + totalSaleForSelectedPeriodForProductCode[productCode].toString());
      if(daysProcessedForProductcode[productCode] == dayCount){
        productCodesProcessedCount = productCodesProcessedCount + 1;
        if(productCodesProcessedCount == productCodes.length)
          {
            allProductCodesProcessed = true;
            productCodes.forEach((element) {
              print(totalSaleForSelectedPeriodForProductCode[element]);
              totalSaleForSelectedPeriod = totalSaleForSelectedPeriod + totalSaleForSelectedPeriodForProductCode[element];
              averageSaleForSelectedPeriod = totalSaleForSelectedPeriod / dayCount;
              setState(() {

              });
            });
//            averageSaleForSelectedPeriod = totalSaleForSelectedPeriod / dayCount;
          }

        print('Sale Position Retrieved For All Dates');
//        if(totalSaleForSelectedPeriodForProductCode[productCode] != null)
//        {
//          averageSaleForSelectedPeriodForProductCode[productCode] = (totalSaleForSelectedPeriodForProductCode[productCode]/dayCount);
//        }
//        else
//          {
//            averageSaleForSelectedPeriodForProductCode[productCode] = 0;
//          }
        setState(() {
            print(saleByDate);
        });
      }
    });
  }

  void getProductSalePositionForDateForProductCodes(List<String> productCodes, String year, String month, String day){
    terminalsAtStore[selectedStore].forEach((terminal) {
      productCodes.forEach((String productCode)
      {
        print(productCode);
        print(year + month + day);
        daysProcessedForProductcode[productCode] = 0;
        totalSaleForSelectedPeriodForProductCode[productCode]= 0;
        averageSaleForSelectedPeriodForProductCode[productCode] = 0;
        getProductSalePositionForDateForProductCode(productCode, terminal, year, month, day);
      }
      );
    });


  }

  @override
  Widget build(BuildContext context) {
    print('building view');
    print(productName);
//    print(products);
    productCodes = [];
    print(barCodeSearchResultsMap);
    barCodeSearchResultsMap.forEach((key, value) {
      productName = value.productName;
      productCodes.add(value.productID.toString());
    });
    print(productCodes);


    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
//        Navigator.of(context).push<dynamic>(
//          MaterialPageRoute<dynamic>(
//            builder:((BuildContext context){
//              return ShowHomePage();
//            }
//          )
//        ),
          return;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:Text(
            'PRODUCT SEARCH',
            style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize:24.0,
              fontWeight: FontWeight.bold,
              color:Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed:(){
              Navigator.of(context).pop();
            }
          ),
        ),
        body: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width:MediaQuery.of(context).size.width,
                    padding:EdgeInsets.all(8.0),
                    child:
                    RaisedButton(
                        color:Colors.blue,
                        onPressed:(){
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>
                            (MaterialPageRoute<dynamic>(
                            builder: (BuildContext context){
                              return SelectStoreNoReturn();
                            }
                          )
                          );
                        },
                        child:getTextWidget(selectedStore, 24, Colors.white)
                    )
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex:2,
                      child: getTextWidget('FROM:', 24.0, Colors.black)),
                    Expanded(
                      flex:4,
                      child:RaisedButton(
                      color:Colors.grey,
                      onPressed:(){
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2019, 11, 01),
                            maxTime: DateTime.now().add(Duration(days: -1)),
                            onChanged: (date) {
                              print('change $date');
                            },
                            onConfirm: (date) {
                              startDateAsDateTime = date;
                              startDate = DateFormat('dd-MM-yyyy').format(date);
                              print(startDate);
                              setState(() {});
                            },
                            currentTime: DateTime.now().add(Duration(days: -1)), locale: LocaleType.en);
                      },
                      child: getTextWidget(startDate, 24.0, Colors.white)
                    )
                        ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex:2,
                        child: getTextWidget('TO:', 24.0, Colors.black)),
                    Expanded(
                      flex:4,
                    child:RaisedButton(
                      color:Colors.grey,
                      onPressed:(){
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2019, 11, 01),
                            maxTime: DateTime.now().add(Duration(days: -1)),
                            onChanged: (date) {
                              print('change $date');
                            },
                            onConfirm: (date) {
                              endDate = DateFormat('dd-MM-yyyy').format(date);
                              endDateAsDateTime = date;
                              print(endDate);
                              setState(() {});
                            },
                            currentTime: DateTime.now().add(Duration(days: -1)), locale: LocaleType.en);
                      },
                      child: getTextWidget(endDate, 24.0, Colors.white),)
                    )
                  ],
                ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8.0),
                  child:
                    RaisedButton(
                      color:Colors.grey,
                      onPressed: (){
//                    products = [];
                        lookUpProduct();
                      },
                      child:Text(productName,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color:Colors.white,
                        ),
                        textAlign:TextAlign.center,
                        maxLines: 3,
                      )
                    )
                ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  padding:EdgeInsets.all(8.0),
                  child:
                    RaisedButton(
                      color:Colors.blue,
                      onPressed:(){
                        productCodesProcessedCount = 0;
                        allProductCodesProcessed = false;
                        totalSaleForSelectedPeriodForProductCode = Map<String, double>();
                        totalSaleForSelectedPeriod = 0;
                        averageSaleForSelectedPeriod = 0;
                        daysProcessedForProductcode = Map<String, int>();
                        if(productCodes.length != 0)
                          {
                            dayCount = endDateAsDateTime.difference(startDateAsDateTime).inDays + 1;
                            setState(() {
                              print(dayCount);

                            });
//                        daysProcessed = 0;
//                        totalSaleForSelectedPeriod = 0;

                            for(int i = 0; i < endDateAsDateTime.difference(startDateAsDateTime).inDays + 1; ++i)
                            {
                              print(startDateAsDateTime.add(Duration(days:i)).toString());
                              var dateAsString_ddMMyyyy = DateFormat('ddMMyyyy').format(startDateAsDateTime.add(Duration(days:i)));
                              print(dateAsString_ddMMyyyy);
                              var year = dateAsString_ddMMyyyy.substring(4,8);
                              var month = dateAsString_ddMMyyyy.substring(2,4);
                              var day = dateAsString_ddMMyyyy.substring(0,2);
                              getProductSalePositionForDateForProductCodes(productCodes, 'POS_4', year, month, day);
                              print('year:' + year);
                              print('month:' + month);
                              print('day:' + day);
//                        FirebaseDatabase
//                          .instance
//                          .reference()
//                          .child('storeTerminals')
//                          .child('POS_4')
//                          .child('sales')
//                          .child(year)
//                          .child(month)
//                          .child(day)
//                          .child('productSalePosition')
//                          .child('272790025683')
//                          .child('salePosition')
//                          .once()
//                          .then((productSalePositionSnapshot){
//                            if(productSalePositionSnapshot != null && productSalePositionSnapshot.value != null){
//                              print(productSalePositionSnapshot.value);
//                            }
//                        });
                            }
                          }

                      },
                      child:getTextWidget('PROCEED', 24, Colors.white)
                    )
                ),
//            Container(
//              width:MediaQuery.of(context).size.width,
//              padding: EdgeInsets.all(8.0),
//              child:Text(productName,
//                style: TextStyle(
//                  fontSize: 20.0,
//                  fontFamily: 'Montserrat',
//                  fontWeight: FontWeight.bold,
//                  color:Colors.black,
//                ),
//                textAlign:TextAlign.center,
//                maxLines: 3,
//              )
//            ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8.0),
                  child:
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex:4,
                            child: Text('Days:',
                              style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color:Colors.black
                            ),
                              textAlign: TextAlign.left,)),
                        Expanded(
                          flex:2,
                            child: Text(dayCount.toString(),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.right,))
                      ],
                    ),
                ),
                Container(
                width:MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(8.0),
                child:
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex:4,
                                child: Text('Total Units Sold:',
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.black
                                  ),
                                  textAlign: TextAlign.left,)),
                            Expanded(
                              flex:2,
                                child: RaisedButton(
                                  onPressed: (){
                                    Navigator.of(context).push<dynamic>(
                                        MaterialPageRoute<dynamic>(
                                      builder:(BuildContext context){
                                        return ShowProductSaleByDate();
                                      }
                                    ));
                                  },
                                  child: Text(totalSaleForSelectedPeriod.toString(),
                                    style:TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black
                                    ),
                                    textAlign: TextAlign.right,),
                                ))
                          ],
                        ),
                ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(8.0),
                  child:
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex:4,
                          child: Text(
                              'Daily Average:',
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color:Colors.black
                            ),
                            textAlign: TextAlign.left,)),
                      Expanded(
                        flex:2,
                          child: Text(
                            averageSaleForSelectedPeriod.toStringAsFixed(0),
                            style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color:Colors.black
                            ),
                            textAlign: TextAlign.right,))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
