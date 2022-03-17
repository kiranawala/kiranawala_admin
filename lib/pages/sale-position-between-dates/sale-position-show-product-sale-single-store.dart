import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-select-products.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-select-store-no-return.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-by-date.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-by-sku.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-by-terminal.dart';
import 'package:kiranawala_admin/pages/show-sale-position-home.dart';

import '../show-admin-home-page.dart';

class ShowProductSalePositionSingleStore extends StatefulWidget {
  @override
  _ShowProductSalePositionSingleStoreState createState() =>
      _ShowProductSalePositionSingleStoreState();
}

class _ShowProductSalePositionSingleStoreState extends State<ShowProductSalePositionSingleStore> {

  String barCode = 'SELECT PRODUCT';
  List<String> productCodes = List<String>();

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

  Map<String, double> averageSaleForSelectedPeriodForProductCode = Map<String, double>();

  Map<String, bool> productCodesProcessed = Map<String, bool>();
  Map<dynamic, dynamic> productCodesProcessedAtTerminal = Map<dynamic, dynamic>();

  Map<dynamic, dynamic> productSalePositionAtTerminal = Map<dynamic, dynamic>();
  var productSalePositionByDateAtTerminal = <dynamic, dynamic>{};


  bool allProductCodesProcessed = false;
  int productCodesProcessedCount  = 0;
  List<ProductBasicDetails> products = List<ProductBasicDetails>();
  String productName = 'SELECT PRODUCT';

  Map<String, double> totalSaleAtTerminal = Map<String, double>();
  int processCount = 0;
  int processedCount = 0;

  bool retrievingSalePosition = false;


  Widget totalSalePositionWidget(){

    if(retrievingSalePosition)
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

    if(retrievingSalePosition)
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

    if(retrievingSalePosition)
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

    if(retrievingSalePosition)
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
    print('ShowProductSalePositionSingleStore:initState:');
    print('ShowProductSalePositionSingleStore:initState:stores:' + stores.toString());
    print('ShowProductSalePositionSingleStore:initState:' + storeTerminals.toString());

//    print(startDate);
//    print(endDate);
//  barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
//  barCodeSearchResults = List<ProductBasicDetails>();
//  productName = '';
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

        if(stockOutwardByDate[day+month+year] != null)
          stockOutwardByDate[day+month+year] = stockOutwardByDate[day+month+year]
              + double.parse(productSalePositionSnapshot.value.toString());
        else
          stockOutwardByDate[day+month+year] = double.parse(productSalePositionSnapshot.value.toString());

        if(totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal]!= null){
          totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal] = {
            productCode: double.parse(totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode].toString())
                            + double.parse(productSalePositionSnapshot.value.toString())
          };
        }
        else{
          totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal] = {
            productCode:double.parse(productSalePositionSnapshot.value.toString()),
          };
//          saleByDate[day+month+year] = double.parse(productSalePositionSnapshot.value.toString());
        }

        if(productSalePositionByDateAtTerminal[terminal] == null)
          {
            productSalePositionByDateAtTerminal[terminal] = <dynamic, dynamic>{
              productCode:<dynamic, dynamic>{
                day+month+year : double.parse(productSalePositionSnapshot.value.toString())
              }
            };
          }
        else
          {
            if(productSalePositionByDateAtTerminal[terminal][productCode] == null)
            {
              productSalePositionByDateAtTerminal[terminal][productCode] = <dynamic, dynamic>{
                day+month+year : double.parse(productSalePositionSnapshot.value.toString())
              };
            }
            else
              {
                productSalePositionByDateAtTerminal[terminal][productCode][day+month+year] = double.parse(productSalePositionSnapshot.value.toString());
              }
          }
      }


        if(daysProcessedForProductCodeAtTerminal[terminal] != null)
        {
          if(daysProcessedForProductCodeAtTerminal[terminal][productCode] != null)
            {
              daysProcessedForProductCodeAtTerminal[terminal][productCode] =
                  int.parse(daysProcessedForProductCodeAtTerminal[terminal][productCode].toString()) + 1;
            }
          else
            {
              daysProcessedForProductCodeAtTerminal[terminal][productCode] = 1;
            }
        }
      else {
        daysProcessedForProductCodeAtTerminal[terminal] = {
          productCode : 1
        };
      }

      if(daysProcessedForProductCodeAtTerminal[terminal][productCode] == dayCount){

        if(terminalSalePosition[terminal] == null)
          {
            if(totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal] != null && totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode] != null)
            {
              terminalSalePosition[terminal] = totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode];
            }
          }
        else
          {
            if(totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal] != null && totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode] != null)
            {
              terminalSalePosition[terminal] = terminalSalePosition[terminal] + totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode];
            }
          }

        if(productSalePosition[productCode] == null)
        {
          if(totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal] != null && totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode] != null)
          {
            productSalePosition[productCode] = totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode];
          }
      }
        else
        {
          if(totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal] != null && totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode] != null)
          {
            productSalePosition[productCode] = productSalePosition[productCode] + totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode];
          }
        }

        //Calculate total value of sale for the sku at this terminal
        if(totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal] != null && totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode] != null )
          {
            unitsSoldForSelectedPeriod = unitsSoldForSelectedPeriod + totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode];

            double productPrice = barCodeSearchResultsMap[int.parse(productCode)].productPrice;
            double unitsSold = totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode];
            double saleValue = productPrice * unitsSold ;

            print('Sale Value of SKU:' + productCode + ' @terminal ' + terminal + ' is ' + saleValue.toString()
                + ' for units sold: ' + unitsSold.toString() + '@' + productPrice.toString());

            saleAmountForSelectedPeriod = saleAmountForSelectedPeriod + saleValue;

            //

            if(productSalePositionAtTerminal[terminal] == null){
              productSalePositionAtTerminal[terminal] = <dynamic, dynamic>{
                productCode: totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode]
              };
            }
            else
              {
                productSalePositionAtTerminal[terminal][productCode] = totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode];
              }
          }

        processedCount = processedCount + dayCount;
        print('Processed Count:' + processedCount.toString());
        print('Process Count:' + processCount.toString());
        if(processedCount == processCount){
          print('All product codes processed at all terminals successfully!!');

          averageUnitsSoldForSelectedPeriod = unitsSoldForSelectedPeriod / dayCount;
          averageSaleAmountForSelectedPeriod = saleAmountForSelectedPeriod / dayCount;

          print('Total Units Sold For Selected Period:' + unitsSoldForSelectedPeriod.toString());
          print('Average Units Sold For Selected Period:' + averageUnitsSoldForSelectedPeriod.toString());
          print('Total Sale Amount For Selected Period:' + saleAmountForSelectedPeriod.toString());
          print('Average Sale Amount For Selected Period:' + averageSaleAmountForSelectedPeriod.toString());

          print(productSalePositionAtTerminal);
          print(productSalePositionByDateAtTerminal);
          print(terminalSalePosition);
          print(productSalePosition);

          setState(() {
            retrievingSalePosition = false;
          });
        }
      }

      print(productCodesProcessedAtTerminal);

      if(daysProcessedForProductcode[productCode] == dayCount){
        productCodesProcessedCount = productCodesProcessedCount + 1;
        if(productCodesProcessedCount == productCodes.length)
          {
            allProductCodesProcessed = true;
            productCodes.forEach((dynamic element) {
              print(totalSaleForSelectedPeriodForProductCode[element]);
              unitsSoldForSelectedPeriod = unitsSoldForSelectedPeriod + totalSaleForSelectedPeriodForProductCode[element];
            });
            averageUnitsSoldForSelectedPeriod = unitsSoldForSelectedPeriod / dayCount;
          }

        print('Sale Position Retrieved For All Dates');
        setState(() {
            print(stockOutwardByDate);
        });
      }
    });
  }

  void getProductSalePositionForDateForProductCodes(List<String> productCodes, String terminal, String year, String month, String day){
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

  }

  @override
  Widget build(BuildContext context) {
//    print('building view');
//    print(productName);
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
            'PRODUCT SALE ANALYSIS',
            style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize:18.0,
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
                        terminalsProcessed = 0;
                        terminalCount = storeIdTerminalMap[selectedStore].length;
                        productCodesProcessedCount = 0;
                        allProductCodesProcessed = false;
                        totalSaleForSelectedPeriodForProductCode = Map<String, double>();
                        daysProcessedForProductcode = Map<String, int>();

                        saleAmountForSelectedPeriod = 0;
                        averageSaleAmountForSelectedPeriod = 0;
                        unitsSoldForSelectedPeriod = 0;
                        averageUnitsSoldForSelectedPeriod = 0;
                        dayCount = 0;
                        processCount = 0;
                        processedCount = 0;
                        totalSaleForSelectedPeriodForProductCodeAtTerminal = Map<dynamic, dynamic>();
                        daysProcessedForProductCodeAtTerminal = Map<dynamic, dynamic>();
                        productSalePositionByDateAtTerminal = Map<dynamic, dynamic>();
                        retrievingSalePosition = true;
                        terminalSalePosition = Map<String, double>();
                        productSalePosition = Map<String, double>();
                        stockOutwardByDate = {};

                        if(productCodes.length != 0)
                          {
                            dayCount = endDateAsDateTime.difference(startDateAsDateTime).inDays + 1;
                            processCount = dayCount * productCodes.length * terminalCount;
//                            print('Process Count:' + processCount.toString());
                            setState(() {
//                              print('Day Count:' + dayCount.toString());
                            });

                            for(int i = 0; i < endDateAsDateTime.difference(startDateAsDateTime).inDays + 1; ++i)
                            {
//                              print(startDateAsDateTime.add(Duration(days:i)).toString());
                              var dateAsString_ddMMyyyy = DateFormat('ddMMyyyy').format(startDateAsDateTime.add(Duration(days:i)));
//                              print(dateAsString_ddMMyyyy);
                              var year = dateAsString_ddMMyyyy.substring(4,8);
                              var month = dateAsString_ddMMyyyy.substring(2,4);
                              var day = dateAsString_ddMMyyyy.substring(0,2);
                              storeIdTerminalMap[selectedStore].forEach((terminalElement) {
//                                print(terminalElement);
                                getProductSalePositionForDateForProductCodes(productCodes, terminalElement, year, month, day);
                              });
//                              print('year:' + year);
//                              print('month:' + month);
//                              print('day:' + day);
                            }
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
