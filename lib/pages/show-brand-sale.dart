import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/select-brand-no-return.dart';
import 'package:kiranawala_admin/pages/select-products.dart';
import 'package:kiranawala_admin/pages/select-store-no-return.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';
import 'package:kiranawala_admin/pages/show-product-sale-by-date.dart';

import 'select-store-brand-no-return.dart';
import 'show-brand-sale-results.dart';
import 'show-product-sale-by-sku.dart';
import 'show-product-sale-by-terminal.dart';
import 'show-sale-position-home.dart';
class ShowBrandSalePosition extends StatefulWidget {
  @override
  _ShowBrandSalePositionState createState() =>
      _ShowBrandSalePositionState();
}

class _ShowBrandSalePositionState extends State<ShowBrandSalePosition> {

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


  bool allProductCodesProcessed = false;
  int productCodesProcessedCount  = 0;
  List<ProductBasicDetails> products = List<ProductBasicDetails>();

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
          print(productSalePosition);
          if(productSalePosition.length != 0 )
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
          return SelectProducts();
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedStore = 'KIRANAWALA_STORE_11';
    storeTerminalMap[selectedStore] = ['POS_11','POS_2'];
    print(selectedStore);
    print(storeTerminalMap[selectedStore]);
    print(barCodeSearchResultsMap);
  }

  void getProductSalePositionForDateForProductCode(String productCode, String terminal, String year, String month, String day){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child(selectedStore)
        .child('products')
        .child(productCode)
        .child('stockOutwards')
        .child(year)
        .child(month)
        .child(day)
        .child('stockOutwardTillDate')
        .once()
        .then((productSalePositionSnapshot) {
      if (productSalePositionSnapshot != null &&
          productSalePositionSnapshot.value != null) {

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

        processedCount = processedCount + dayCount;
        if(processedCount == processCount){
          print('productSalePositionByDateAtTerminal:');
          print(productSalePositionByDateAtTerminal);
          Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return ShowBrandSaleResults();
              }
            )
          );

          setState(() {
            retrievingSalePosition = false;
          });
        }
      }


      if(daysProcessedForProductcode[productCode] == dayCount){
        productCodesProcessedCount = productCodesProcessedCount + 1;
        if(productCodesProcessedCount == productCodes.length)
          {
            allProductCodesProcessed = true;
            productCodes.forEach((dynamic element) {
              unitsSoldForSelectedPeriod = unitsSoldForSelectedPeriod + totalSaleForSelectedPeriodForProductCode[element];
            });
            averageUnitsSoldForSelectedPeriod = unitsSoldForSelectedPeriod / dayCount;
          }

        print('Sale Position Retrieved For All Dates');
        setState(() {
        });
      }
    });
  }

  void getProductSalePositionForDateForProductCodes(List<String> productCodes, String terminal, String year, String month, String day){
    productCodes.forEach((String productCode)
        {
//          print(productCode);
//          print(year + month + day);
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
//    print(brandName);
    productCodes = [];
//    print(barCodeSearchResultsMap);
    barCodeSearchResultsMap.forEach((key, value) {
//      productName = value.productName;
      productCodes.add(value.productID.toString());
    });
    print(productCodes);

    if(retrievingSalePosition)
      {
        return
          Scaffold(
            appBar:
            AppBar(
              centerTitle: true,
              title:Text(
                  'BRAND SALE POSITION',
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize:24.0,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            body:
            Container(
              color: Colors.white,
              child: Dialog(
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        flex:2,
                        child: new CircularProgressIndicator()
                    ),
                    SizedBox(width:10.0),
                    Expanded(
                        flex:12,
                        child: Text("Retrieving Sale Position.....")
                    ),
                  ],
                ),
              ),
            ),
          );
      }
    else
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
            'BRAND SALE ANALYSIS',
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
                              return SelectStoreBrandNoReturn();
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
//                              print('change $date');
                            },
                            onConfirm: (date) {
                              startDateAsDateTime = date;
                              startDate = DateFormat('dd-MM-yyyy').format(date);
//                              print(startDate);
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
//                              print('change $date');
                            },
                            onConfirm: (date) {
                              endDate = DateFormat('dd-MM-yyyy').format(date);
                              endDateAsDateTime = date;
//                              print(endDate);
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
                        Navigator.of(context).pop();
                        Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return SelectProductBrand();
                            }
                          )
                        );
                      },
                      child:Text(brandName,
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
                        terminalCount = storeTerminalMap[selectedStore].length;
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

                        terminalSalePosition = Map<String, double>();
                        productSalePosition = Map<String, double>();
                        stockOutwardByDate = {};

                        if(productCodes.length != 0)
                          {
                            dayCount = endDateAsDateTime.difference(startDateAsDateTime).inDays + 1;
                            processCount = dayCount * productCodes.length * terminalCount;
//                            print('Process Count:' + processCount.toString());
                            setState(() {
                              print('Day Count:' + dayCount.toString());
                              retrievingSalePosition = true;
                            });

                            for(int i = 0; i < endDateAsDateTime.difference(startDateAsDateTime).inDays + 1; ++i)
                            {
                              print(startDateAsDateTime.add(Duration(days:i)).toString());
                              var dateAsString_ddMMyyyy = DateFormat('ddMMyyyy').format(startDateAsDateTime.add(Duration(days:i)));
                              print(dateAsString_ddMMyyyy);
                              var year = dateAsString_ddMMyyyy.substring(4,8);
                              var month = dateAsString_ddMMyyyy.substring(2,4);
                              var day = dateAsString_ddMMyyyy.substring(0,2);
                              storeTerminalMap[selectedStore].forEach((terminalElement) {
                                print(terminalElement);
                                getProductSalePositionForDateForProductCodes(productCodes, terminalElement, year, month, day);
                              });
                              print('year:' + year);
                              print('month:' + month);
                              print('day:' + day);
                            }
                          }

                      },
                      child:getTextWidget('PROCEED', 24, Colors.white)
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
//                Container(
//                width:MediaQuery.of(context).size.width,
//                padding: EdgeInsets.all(8.0),
//                child:
//                        Row(
//                          children: <Widget>[
//                            Expanded(
//                              flex:4,
//                                child: Text('Total Units Sold:',
//                                  style:TextStyle(
//                                      fontFamily: 'Montserrat',
//                                      fontSize: 24.0,
//                                      fontWeight: FontWeight.bold,
//                                      color:Colors.black
//                                  ),
//                                  textAlign: TextAlign.left,)),
//                            Expanded(
//                              flex:2,
//                                child:
//                                    totalSalePositionWidget()
//                            )
//                          ],
//                        ),
//                ),
//                Container(
//                  width:MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.all(8.0),
//                  child:
//                  Row(
//                    children: <Widget>[
//                      Expanded(
//                        flex:4,
//                          child: Text(
//                              'Average Units Sold:',
//                            style:TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontSize: 24.0,
//                                fontWeight: FontWeight.bold,
//                                color:Colors.black
//                            ),
//                            textAlign: TextAlign.left,)),
//                      Expanded(
//                        flex:2,
//                          child:
//                          averageSalePositionWidget()
//                      )
//                    ],
//                  ),
//                ),
//                Container(
//                  width:MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.all(8.0),
//                  child:
//                  Row(
//                    children: <Widget>[
//                      Expanded(
//                          flex:4,
//                          child: Text(
//                            'Total Sale Amount:',
//                            style:TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontSize: 24.0,
//                                fontWeight: FontWeight.bold,
//                                color:Colors.black
//                            ),
//                            textAlign: TextAlign.left,)),
//                      Expanded(
//                          flex:2,
//                          child:
//                          totalSaleAmountWidget()
//                      )
//                    ],
//                  ),
//                ),
//                Container(
//                  width:MediaQuery.of(context).size.width,
//                  padding: EdgeInsets.all(8.0),
//                  child:
//                  Row(
//                    children: <Widget>[
//                      Expanded(
//                          flex:4,
//                          child: Text(
//                            'Average Sale Amount:',
//                            style:TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontSize: 24.0,
//                                fontWeight: FontWeight.bold,
//                                color:Colors.black
//                            ),
//                            textAlign: TextAlign.left,)),
//                      Expanded(
//                          flex:2,
//                          child:
//                          averageSaleAmountWidget()
//                      )
//                    ],
//                  ),
//                ),
              ],
            )),
      ),
    );
  }
}
