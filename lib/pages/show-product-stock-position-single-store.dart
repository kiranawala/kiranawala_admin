import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
//import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/select-products.dart';
import 'package:kiranawala_admin/pages/select-store-no-return.dart';
//import 'package:kiranawala_admin/pages/show-home-page.dart';
import 'package:kiranawala_admin/pages/show-product-sale-by-date.dart';

import 'check-if-admin.dart';
import 'show-sale-position-home.dart';

import 'show-product-sale-by-sku.dart';
import 'show-product-sale-by-terminal.dart';
import 'show-admin-home-page.dart';

class ShowProductStockPositionSingleStore extends StatefulWidget {
  @override
  _ShowProductStockPositionSingleStoreState createState() =>
      _ShowProductStockPositionSingleStoreState();
}

class _ShowProductStockPositionSingleStoreState extends State<ShowProductStockPositionSingleStore> {

  String barCode = 'SELECT PRODUCT';
  List<String> productCodes = List<String>();

  int stockInwardDayCount = 0;
  int dayCount = 0;
  int daysProcessed = 0;
  int terminalsProcessed = 0;
  int terminalCount = 0;
  Map<String, int> daysProcessedForProductcode = Map<String, int>();

  double unitsSoldForSelectedPeriod = 0;
  double averageUnitsSoldForSelectedPeriod = 0;

  double saleAmountForSelectedPeriod = 0;
  double averageSaleAmountForSelectedPeriod = 0;

  Map<String, double> totalSaleForSelectedPeriodForProductCode = Map<String, double>();
  var totalSaleForSelectedPeriodForProductCodeAtTerminal = <dynamic, dynamic>{};
  var daysProcessedForProductCodeAtTerminal = <dynamic,dynamic>{};
  var stockInwardDaysProcessedForProductCode = <dynamic, dynamic>{};

  Map<String, double> averageSaleForSelectedPeriodForProductCode = Map<String, double>();

  Map<String, bool> productCodesProcessed = Map<String, bool>();
  Map<dynamic, dynamic> productCodesProcessedAtTerminal = Map<dynamic, dynamic>();

  Map<dynamic, dynamic> productSalePositionAtTerminal = Map<dynamic, dynamic>();
  var productSalePositionByDateAtTerminal = <dynamic, dynamic>{};
  var productStockInwardByDate = <dynamic, dynamic>{};


  bool allStockInwardProductCodesProcessed = false;
  int stockInwardProductCodesProcessedCount  = 0;

  bool allProductCodesProcessed = false;
  int productCodesProcessedCount  = 0;
  List<ProductBasicDetails> products = List<ProductBasicDetails>();
  String productName = 'SELECT PRODUCT';
  String productCode;

  Map<String, double> totalSaleAtTerminal = Map<String, double>();
  int stockOutwardProcessCount = 0;
  int stockInwardProcessCount = 0;
  int stockOutwardProcessedCount = 0;
  int stockInwardProcessedCount = 0;


  bool retrievingStockOutward = false;
  bool retrievingStockInward = false;


  Widget totalSalePositionWidget(){

    if(retrievingStockOutward)
      {
        return
          RaisedButton(
            onPressed: (){
            },
            child: CircularProgressIndicator()
          );
      }
        else
          {
            return RaisedButton(
              onPressed: (){
                if(stockOutwardByDate.length != 0 )
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder:(BuildContext context){
                          return ShowProductSaleByDate();
                        }
                    ));
              },
              child: Text(unitsSoldForSelectedPeriod.toStringAsFixed(0),
                style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color:Colors.black
                ),
                textAlign: TextAlign.right,),
            );
          }

  }

  Widget averageSalePositionWidget(){

    if(retrievingStockOutward)
    {
      return
        RaisedButton(
            onPressed: (){

            },
            child: CircularProgressIndicator()
        );
    }
    else
    {
      return RaisedButton(
        onPressed: (){
          print(terminalSalePosition);
          if(terminalSalePosition.length != 0 )
            Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return ShowProductSaleByTerminal();
                    }
                ));
        },
        child: Text(averageUnitsSoldForSelectedPeriod.toStringAsFixed(0),
          style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color:Colors.black
          ),
          textAlign: TextAlign.right,),
      );
    }

  }

  Widget totalSaleAmountWidget(){

    if(retrievingStockOutward)
    {
      return
        RaisedButton(
            onPressed: (){

            },
            child: CircularProgressIndicator()
        );
    }
    else
    {
      return RaisedButton(
        onPressed: (){
          print(terminalSalePosition);
          if(terminalSalePosition.length != 0 )
            Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return ShowProductSaleByProductCode();
                    }
                ));
        },
        child: Text(saleAmountForSelectedPeriod.toStringAsFixed(0),
          style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color:Colors.black
          ),
          textAlign: TextAlign.right,),
      );
    }

  }

  Widget averageSaleAmountWidget(){

    if(retrievingStockOutward)
    {
      return
        RaisedButton(
            onPressed: (){
            },
            child: CircularProgressIndicator()
        );
    }
    else
    {
      return RaisedButton(
        onPressed: (){
        },
        child: Text(averageSaleAmountForSelectedPeriod.toStringAsFixed(0),
          style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color:Colors.black
          ),
          textAlign: TextAlign.right,),
      );
    }

  }

  void lookUpProduct() {
    Navigator.of(context).pop();
    Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          return SelectProducts ();
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedStore = 'KIRANAWALA_STORE_11';
    storeIdTerminalMap[selectedStore] = ['POS_11','POS_2'];
    productCode = '272790025683';
//    getProductStockInwardForDateForProductCodes(productCodes, '2021', '01', '19');
//    getProductStockInwardForDateForProductCodes(productCodes, '2021', '01', '20');


//    print(startDate);
//    print(endDate);
//  barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
//  barCodeSearchResults = List<ProductBasicDetails>();
//  productName = '';
  }

  void getProductStockInwardForDateForProductCode(String productCode, String year, String month, String day){
    print('Stock Inward:' + productCode);
    print('Stock Inward:' + year + month + day);
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(productCode)
        .child('stockInwards')
        .child(year)
        .child(month)
        .child(day)
        .child('stockInwardTillDate')
        .once()
        .then((productStockInwardSnapshot) {
          print(productStockInwardSnapshot);
      if (productStockInwardSnapshot != null &&
          productStockInwardSnapshot.value != null) {
        print(productStockInwardSnapshot.value);

        if(stockInwardByDate[day+month+year] != null)
          {
            stockInwardByDate[day+month+year] = stockInwardByDate[day+month+year] + double.parse(productStockInwardSnapshot.value.toString());
          }
        else
          {
            stockInwardByDate[day+month+year] = double.parse(productStockInwardSnapshot.value.toString());
          }
        print(stockInwardByDate);
      }

      stockInwardProcessedCount = stockInwardProcessedCount + 1;

      if(stockInwardProcessedCount == stockInwardProcessCount){
        print('STOCK INWARD: Processed at all terminals successfully!!');

        print(stockInwardByDate);

        setState(() {
          retrievingStockInward = false;
        });
      }
    });
  }

  void getProductStockInwardForDateForProductCodes(List<String> productCodes, String year, String month, String day){
    productCodes.forEach((String productCode)
    {
      print('Stock Inward:' + productCode);
      print('Stock Inward:' + year + month + day);
      daysProcessedForProductcode[productCode] = 0;
      totalSaleForSelectedPeriodForProductCode[productCode]= 0;
      averageSaleForSelectedPeriodForProductCode[productCode] = 0;
      getProductStockInwardForDateForProductCode(productCode, year, month, day);
    }
    );

  }


  void getProductStockOutwardForDateForProductCode(String productCode, String terminal, String year, String month, String day){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child(selectedStore)
        .child('products')
        .child(productCode)
        .child('stockOutwards')
        .child(terminal)
        .child(year)
        .child(month)
        .child(day)
        .child('stockOutwardTillDate')
        .once()
        .then((productSalePositionSnapshot) {
      if (productSalePositionSnapshot != null &&
          productSalePositionSnapshot.value != null) {
        if (stockOutwardByDate[day + month + year] != null)
          stockOutwardByDate[day + month + year] = stockOutwardByDate[day + month + year]
              + double.parse(productSalePositionSnapshot.value.toString());
        else
          stockOutwardByDate[day + month + year] =
              double.parse(productSalePositionSnapshot.value.toString());
      }
      stockOutwardProcessedCount = stockOutwardProcessedCount + 1;


      print('Stock Outward Processed Count:' +
          stockOutwardProcessedCount.toString());
      print('Stock Outward Process Count:' + stockOutwardProcessCount.toString());
      if (stockOutwardProcessedCount == stockOutwardProcessCount) {
        print('Stock Outward at all terminals processed successfully!!');
        setState(() {
          retrievingStockOutward = false;
          print(stockOutwardByDate);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
//    print('building view');
//    print(productName);
//    print(barCodeSearchResultsMap);
//    barCodeSearchResultsMap.forEach((key, value) {
//      productName = value.productName;
//      productCodes.add(value.productID.toString());
//    });


    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return ShowSalePositionHomePage();
                }
            )
        );
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
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ShowSalePositionHomePage();
                      }
                  )
              );
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
                        child:Text(selectedStore,
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize:24,
                                color:Colors.white,
                              fontWeight: FontWeight.bold
                            )
                        )
                    )
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex:2,
                      child: Text('FROM:',
                        style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:24,
                            color:Colors.black,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Expanded(
                      flex:4,
                      child:RaisedButton(
                      color:Colors.grey,
                      onPressed:(){
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2019, 11, 01),
                            maxTime: DateTime.now().add(Duration(days: 0)),
                            onChanged: (date) {
                              print('change $date');
                            },
                            onConfirm: (date) {
                              startDateAsDateTime = date;
                              startDate = DateFormat('dd-MM-yyyy').format(date);
                              print(startDate);
                              setState(() {});
                            },
                            currentTime: DateTime.now().add(Duration(days: 0)), locale: LocaleType.en);
                      },
                      child: Text(startDate,
                        style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:24,
                            color:Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                    ),
                        ),)
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex:2,
                        child: Text('TO:',
                          style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize:24,
                              color:Colors.black,
                              fontWeight: FontWeight.bold
                          )),),
                    Expanded(
                      flex:4,
                    child:RaisedButton(
                      color:Colors.grey,
                      onPressed:(){
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(2019, 11, 01),
                            maxTime: DateTime.now().add(Duration(days: 0)),
                            onChanged: (date) {
                              print('change $date');
                            },
                            onConfirm: (date) {
                              endDate = DateFormat('dd-MM-yyyy').format(date);
                              endDateAsDateTime = date;
                              print(endDate);
                              setState(() {});
                            },
                            currentTime: DateTime.now().add(Duration(days: 0)), locale: LocaleType.en);
                      },
                      child: Text(endDate,
                        style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:24,
                            color:Colors.white,
                            fontWeight: FontWeight.bold
                        ),)
                    ))
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
                        print('Product Code:');
                        terminalsProcessed = 0;
//                        terminalCount = storeIdTerminalMap[selectedStore].length;
                        terminalCount = 1;
                        productCodesProcessedCount = 0;
                        allProductCodesProcessed = false;
                        totalSaleForSelectedPeriodForProductCode = Map<String, double>();
                        daysProcessedForProductcode = Map<String, int>();

                        saleAmountForSelectedPeriod = 0;
                        averageSaleAmountForSelectedPeriod = 0;
                        unitsSoldForSelectedPeriod = 0;
                        averageUnitsSoldForSelectedPeriod = 0;
                        dayCount = 0;
                        stockOutwardProcessCount = 0;
                        stockOutwardProcessedCount = 0;
                        totalSaleForSelectedPeriodForProductCodeAtTerminal = Map<dynamic, dynamic>();
                        daysProcessedForProductCodeAtTerminal = Map<dynamic, dynamic>();
                        productSalePositionByDateAtTerminal = Map<dynamic, dynamic>();
                        retrievingStockOutward = true;
                        terminalSalePosition = Map<String, double>();
                        productSalePosition = Map<String, double>();
                        stockOutwardByDate = {};
                        stockInwardByDate = {};

                            dayCount = endDateAsDateTime.difference(startDateAsDateTime).inDays + 1;
                            stockOutwardProcessCount = dayCount * storeIdTerminalMap[selectedStore].length;
                            stockInwardDayCount = endDateAsDateTime.difference(startDateAsDateTime).inDays + 1;
                            stockInwardProcessCount = dayCount * productCodes.length;
                            print('Stock Outward Process Count:' + stockOutwardProcessCount.toString());
                            setState(() {
                              print('Stock Outward Day Count:' + dayCount.toString());
                            });

                            for(int i = 0; i < endDateAsDateTime.difference(startDateAsDateTime).inDays + 1; ++i)
                            {
                              print(startDateAsDateTime.add(Duration(days:i)).toString());
                              var dateAsString_ddMMyyyy = DateFormat('ddMMyyyy').format(startDateAsDateTime.add(Duration(days:i)));
                              print(dateAsString_ddMMyyyy);
                              var year = dateAsString_ddMMyyyy.substring(4,8);
                              var month = dateAsString_ddMMyyyy.substring(2,4);
                              var day = dateAsString_ddMMyyyy.substring(0,2);
                              print('Calling getProductStockInwardForDateForProductCodes for:' + year + month + day);
                              getProductStockInwardForDateForProductCodes(['272790025683'], year, month, day);
                              storeIdTerminalMap[selectedStore].forEach((terminalElement) {
                                print(terminalElement);
                                getProductStockOutwardForDateForProductCode(productCode, terminalElement, year, month, day);
                              });
                              print('year:' + year);
                              print('month:' + month);
                              print('day:' + day);
                            }
                        },
                      child:Text('PROCEED',
                          style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize:24,
                              color:Colors.white,
                              fontWeight: FontWeight.bold
                          )
                      )
                    )
                ),
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
                                child:
                                    totalSalePositionWidget()
                            )
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
                              'Average Units Sold:',
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color:Colors.black
                            ),
                            textAlign: TextAlign.left,)),
                      Expanded(
                        flex:2,
                          child:
                          averageSalePositionWidget()
                      )
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
                            'Total Sale Amount:',
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color:Colors.black
                            ),
                            textAlign: TextAlign.left,)),
                      Expanded(
                          flex:2,
                          child:
                          totalSaleAmountWidget()
                      )
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
                            'Average Sale Amount:',
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color:Colors.black
                            ),
                            textAlign: TextAlign.left,)),
                      Expanded(
                          flex:2,
                          child:
                          averageSaleAmountWidget()
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
