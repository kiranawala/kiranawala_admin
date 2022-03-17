import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
//import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/select-products.dart';
import 'package:kiranawala_admin/pages/select-store-no-return.dart';
//import 'package:kiranawala_admin/pages/show-home-page.dart';
import 'package:kiranawala_admin/pages/show-product-sale-by-date.dart';

Map<String,double> stockInwardByDate = Map<String, double>();
Map<String, double> stockOutwardByDate = Map<String, double>();
Map<String, double> terminalSalePosition = Map<String, double>();
Map<String,double> productSalePosition = Map<String, double>();

String selectedStore = '';
Map<String, List<String>> storeIdTerminalMap = Map<String, List<String>>();
String startDate = DateFormat('dd-MMM-yyyy').format(DateTime.now().add(Duration(days:-1)));
String endDate = DateFormat('dd-MMM-yyyy').format(DateTime.now().add(Duration(days:-1)));
DateTime startDateAsDateTime = DateTime.now().add(Duration(days:-1));
DateTime endDateAsDateTime = DateTime.now().add(Duration(days:-1));
double stockInwardTillDate = 0.0;
double stockOutwardTillDate = 0.0;



class RetrieveStockInwardOutwardBetweenDates extends StatefulWidget {
  @override
  _RetrieveStockInwardOutwardBetweenDatesState createState() =>
      _RetrieveStockInwardOutwardBetweenDatesState();
}

class _RetrieveStockInwardOutwardBetweenDatesState extends State<RetrieveStockInwardOutwardBetweenDates> {

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
//                      return ShowProductSaleByTerminal();
                    return null;
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
//                      return ShowProductSaleByProductCode();
                    return null;
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

  void getProductStockInwardForDateForProductCode(String year, String month, String day){
    print('Stock Inward:' + year + month + day);
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(skuToUpdate.toString())
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
        stockInwardByDate.forEach((key, value) {
          print(value);
          stockInwardTillDate = stockInwardTillDate + value;
        });
        print('Stock Inward Till Date:' + stockInwardTillDate.toString());

        setState(() {
          retrievingStockInward = false;
        });
      }
    });
  }


  void getProductStockOutwardForDateForProductCode(String terminal, String year, String month, String day){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child(selectedStore)
        .child('products')
        .child(skuToUpdate.toString())
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
        stockOutwardByDate.forEach((key, value) {
          print(value);
          stockOutwardTillDate = stockOutwardTillDate + value;
        });
        print('Stock Outward Till Date:' + stockOutwardTillDate.toString());
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
//                  return ShowSalePositionHomePage();
                return null;
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
//                        return ShowSalePositionHomePage();
                      return null;
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
              children: <Widget>[
                Expanded(
                  flex:2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:4,
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
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
                                  startDate = DateFormat('dd-MMM-yyyy').format(date);
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
                            ),
                        ),),
                      Expanded(
                          flex:4,
                          child:Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
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
                                        endDate = DateFormat('dd-MMM-yyyy').format(date);
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
                            ),
                          ))
                    ],
                  ),
                ),
                Expanded(
                  flex:2,
                  child: Container(
                    width:MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8.0),
                    child:
                     Text(barCodeSearchResultsMap[skuToUpdate].productName.toString(),
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color:Colors.black,
                          ),
                          textAlign:TextAlign.center,
                          maxLines: 3,
                        )
                  ),
                ),
                Expanded(
                  flex:2,
                  child: Row(
                    children:<Widget>[
                      Container(
                        width:MediaQuery.of(context).size.width,
                        child: RaisedButton(
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
                              stockInwardTillDate = 0.0;
                              stockOutwardTillDate = 0.0;
                              stockInwardProcessedCount = 0;

                              dayCount = endDateAsDateTime.difference(startDateAsDateTime).inDays + 1;
                              stockOutwardProcessCount = dayCount * storeIdTerminalMap[selectedStore].length;
                              stockInwardDayCount = endDateAsDateTime.difference(startDateAsDateTime).inDays + 1;
                              stockInwardProcessCount = dayCount;
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
                                getProductStockInwardForDateForProductCode(year, month, day);
                                storeIdTerminalMap[selectedStore].forEach((terminalElement) {
                                  print(terminalElement);
                                  getProductStockOutwardForDateForProductCode(terminalElement, year, month, day);
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
                        ),
                      ),
                    ]),
                ),
                Expanded(
                  flex:10,
                  child: Container(
                    child: ListView.builder(
                      itemCount: endDateAsDateTime.difference(startDateAsDateTime).inDays + 1,
                      itemBuilder: (BuildContext context , int index){
                        var stockInward = (stockInwardByDate[DateFormat('ddMMyyyy').format(startDateAsDateTime.add(Duration(days:index)))] != null?stockInwardByDate[DateFormat('ddMMyyyy').format(startDateAsDateTime.add(Duration(days:index)))]:0);
                        var stockOutward = (stockOutwardByDate[DateFormat('ddMMyyyy').format(startDateAsDateTime.add(Duration(days:index)))] != null?stockOutwardByDate[DateFormat('ddMMyyyy').format(startDateAsDateTime.add(Duration(days:index)))]:0);

                        return Row(
                          children: <Widget>[
                            Expanded(
                              flex:2,
                              child: Text(index.toString(),style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize:24,
                                  color:Colors.black,
                                  fontWeight: FontWeight.bold
                              )),
                            ),
                            Expanded(
                              flex:4,
                              child: Text(DateFormat('dd-MM-yyyy').format(startDateAsDateTime.add(Duration(days:index))),
                                  style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize:24,
                                  color:Colors.black,
                                  fontWeight: FontWeight.bold
                              )),
                            ),
                            Expanded(
                              flex:2,
                              child: Text(stockInward.toString(),
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:24,
                                      color:Colors.black,
                                      fontWeight: FontWeight.bold
                                  )),
                            ),
                            Expanded(
                              flex:2,
                              child: Text(stockOutward.toString(),
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:24,
                                      color:Colors.black,
                                      fontWeight: FontWeight.bold
                                  )),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex:1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:6,
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Stock Inward:',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize:24,
                                  color:Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                          flex:2,
                          child:Text(stockInwardTillDate.toString(),
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:24,
                                      color:Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                          ))
                    ],
                  ),
                ),
                Expanded(
                  flex:1,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:6,
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Stock Outward:',
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize:24,
                                color:Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                          flex:2,
                          child:Text(stockOutwardTillDate.toString(),
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize:24,
                                color:Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}
