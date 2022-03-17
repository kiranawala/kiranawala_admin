import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-home.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-select-brand-no-return.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-select-products.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-select-store-brand-no-return.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-brand-sale-results.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-daily-sale-between-dates-select-store.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-by-date.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-by-sku.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-by-terminal.dart';


class SalePositionShowDailySaleBetweenDates extends StatefulWidget {
  @override
  _SalePositionShowDailySaleBetweenDatesState createState() =>
      _SalePositionShowDailySaleBetweenDatesState();
}

class _SalePositionShowDailySaleBetweenDatesState extends State<SalePositionShowDailySaleBetweenDates> {

  List<String> productCodes = List<String>();


  int walkinsForSelectedPeriod = 0;
  double saleForSelectedPeriod = 0;
  double cashSaleForSelectedPeriod = 0;
  double bankCardSaleForSelectedPeriod = 0;
  double cardSaleForSelectedPeriod = 0;
  double upiSaleForSelectedPeriod = 0;
  double eWalletSaleForSelectedPeriod = 0;
  double foodCardSaleForSelectedPeriod = 0;

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
  }

  void getTerminalSalePosition(String storeTerminal, String year, String month, String day){
    print('Retrieving Sale Position For Terminal ' + storeTerminal.toString() + 'For ' + year+month+day);
    FirebaseDatabase
        .instance
        .reference()
        .child('storeTerminals')
        .child(storeTerminal)
        .child('sales')
        .child(year)
        .child(month)
        .child(day)
        .once()
        .then((terminalSaleSnapshot) {
      if (terminalSaleSnapshot != null && terminalSaleSnapshot.value != null) {
//        print(terminalSaleSnapshot.value['totalSale']);
//        print(terminalSaleSnapshot.value['totalWalkins']);
        if (terminalSaleSnapshot.value['totalSale'] != null &&
            terminalSaleSnapshot.value['totalWalkins'] != null) {
//          print(saleDetailsPerTerminalByDate[storeTerminal]);
          if(saleDetailsPerTerminalByDate[storeTerminal] == null)
            {
//              print(storeTerminal);
              saleDetailsPerTerminalByDate[storeTerminal] = <String, dynamic>{
                year + month + day: <String, dynamic>{
                  'cashSale': (terminalSaleSnapshot.value['cashSale'] != null
                      ? terminalSaleSnapshot.value['cashSale']
                      : 0),
                  'bankCardSale': (terminalSaleSnapshot.value['bankCardSale'] !=
                      null ? terminalSaleSnapshot.value['bankCardSale'] : 0),
                  'upiSale': (terminalSaleSnapshot.value['upiSale'] != null
                      ? terminalSaleSnapshot.value['upiSale']
                      : 0),
                  'foodCardSale': (terminalSaleSnapshot.value['foodCardSale'] !=
                      null ? terminalSaleSnapshot.value['foodCardSale'] : 0),
                  'eWalletSale': (terminalSaleSnapshot.value['eWalletSale'] !=
                      null ? terminalSaleSnapshot.value['eWalletSale'] : 0),
                  'totalSale': (terminalSaleSnapshot.value['totalSale'] != null
                      ? terminalSaleSnapshot.value['totalSale']
                      : 0),
                  'totalWalkins': (terminalSaleSnapshot.value['totalWalkins'] !=
                      null ? terminalSaleSnapshot.value['totalWalkins'] : 0),
                }
              };
//              print(saleDetailsPerTerminalByDate);
              processedCount = processedCount + 1;
            }
          else
            {
              saleDetailsPerTerminalByDate[storeTerminal][year + month + day] = <String, dynamic>{
                  'cashSale': (terminalSaleSnapshot.value['cashSale'] != null
                      ? terminalSaleSnapshot.value['cashSale']
                      : 0),
                  'bankCardSale': (terminalSaleSnapshot.value['bankCardSale'] !=
                      null ? terminalSaleSnapshot.value['bankCardSale'] : 0),
                  'upiSale': (terminalSaleSnapshot.value['upiSale'] != null
                      ? terminalSaleSnapshot.value['upiSale']
                      : 0),
                  'foodCardSale': (terminalSaleSnapshot.value['foodCardSale'] !=
                      null ? terminalSaleSnapshot.value['foodCardSale'] : 0),
                  'eWalletSale': (terminalSaleSnapshot.value['eWalletSale'] !=
                      null ? terminalSaleSnapshot.value['eWalletSale'] : 0),
                  'totalSale': (terminalSaleSnapshot.value['totalSale'] != null
                      ? terminalSaleSnapshot.value['totalSale']
                      : 0),
                  'totalWalkins': (terminalSaleSnapshot.value['totalWalkins'] !=
                      null ? terminalSaleSnapshot.value['totalWalkins'] : 0),
              };
//              print(saleDetailsPerTerminalByDate);
              processedCount = processedCount + 1;

            }
        }
          else {
          if(saleDetailsPerTerminalByDate[storeTerminal] == null)
          {
            saleDetailsPerTerminalByDate[storeTerminal] = <String, dynamic>{
              year + month + day: <String, dynamic>{
                'cashSale': 0,
                'bankCardSale': 0,
                'foodCardSale': 0,
                'eWalletSale': 0,
                'upiSale':0,
                'totalSale': 0,
                'totalWalkins': 0,
              }
            };
            processedCount = processedCount + 1;

          }
          else
          {
            saleDetailsPerTerminalByDate[storeTerminal][year + month + day] = <String, dynamic>{
              'cashSale': 0,
              'bankCardSale': 0,
              'foodCardSale': 0,
              'eWalletSale': 0,
              'upiSale':0,
              'totalSale': 0,
              'totalWalkins': 0,
            };
            processedCount = processedCount + 1;

          }
        }
      }
      else {
        if(saleDetailsPerTerminalByDate[storeTerminal] == null)
        {
          saleDetailsPerTerminalByDate[storeTerminal] = <String, dynamic>{
            year + month + day: <String, dynamic>{
              'cashSale': 0,
              'bankCardSale': 0,
              'foodCardSale': 0,
              'eWalletSale': 0,
              'upiSale':0,
              'totalSale': 0,
              'totalWalkins': 0,
            }
          };
          processedCount = processedCount + 1;

        }
        else
        {
          saleDetailsPerTerminalByDate[storeTerminal][year + month + day] = <String, dynamic>{
            'cashSale': 0,
            'bankCardSale': 0,
            'foodCardSale': 0,
            'eWalletSale': 0,
            'upiSale':0,
            'totalSale': 0,
            'totalWalkins': 0,
          };
          processedCount = processedCount + 1;

        }
      }
      print(saleDetailsPerTerminalByDate);
      print(processCount.toString());
      print(processedCount.toString());
      if(processCount == processedCount)
        {
         storeIdTerminalMap[selectedStore].forEach((storeTerminal) {
           print(storeTerminal);
          print(saleDetailsPerTerminalByDate[storeTerminal]);
           saleDetailsPerTerminalByDate[storeTerminal].forEach((String key, dynamic value){
             print(key);
             print(value);
             saleForSelectedPeriod = saleForSelectedPeriod + double.parse(value['totalSale'].toString());
             cashSaleForSelectedPeriod = cashSaleForSelectedPeriod + double.parse(value['cashSale'].toString());
             bankCardSaleForSelectedPeriod = bankCardSaleForSelectedPeriod + double.parse(value['bankCardSale'].toString());
             foodCardSaleForSelectedPeriod = foodCardSaleForSelectedPeriod + double.parse(value['foodCardSale'].toString());

             eWalletSaleForSelectedPeriod = eWalletSaleForSelectedPeriod + double.parse(value['eWalletSale'].toString());
             upiSaleForSelectedPeriod = upiSaleForSelectedPeriod + double.parse(value['upiSale'].toString());
             walkinsForSelectedPeriod = walkinsForSelectedPeriod + int.parse(value['totalWalkins'].toString());

           });
         });

         print(saleForSelectedPeriod.toString());
         print(cashSaleForSelectedPeriod.toString());
         print(bankCardSaleForSelectedPeriod.toString());
         print(foodCardSaleForSelectedPeriod.toString());
         print(eWalletSaleForSelectedPeriod.toString());
         print(upiSaleForSelectedPeriod.toString());
         print(walkinsForSelectedPeriod.toString());

          retrievingSalePosition = false;
          if(this.mounted)
            {
              setState(() {});
            }

        }
    });



//          billsAtTerminalForSelectedDate[storeTerminal] = terminalSaleSnapshot.value['bills'];
//          totalSaleForSelectedDate = totalSaleForSelectedDate
//              + double.parse(terminalSaleSnapshot.value['totalSale'].toString());
//          print(totalSaleForSelectedDate);
//
//          salePositionAtTerminal[storeTerminal] = double.parse(terminalSaleSnapshot.value['totalSale'].toString());
//          walkinsAtTerminal[storeTerminal] = int.parse(terminalSaleSnapshot.value['totalWalkins'].toString());
//
//          totalWalkinsForSelectedDate = totalWalkinsForSelectedDate +
//              int.parse(terminalSaleSnapshot.value['totalWalkins'].toString());
//          if( terminalSaleSnapshot.value['cashSale'] != null)
//            cashSale = cashSale + double.parse(terminalSaleSnapshot.value['cashSale'].toString());
//
//          if( terminalSaleSnapshot.value['bankCardSale'] != null)
//            cardSale = cardSale + double.parse(terminalSaleSnapshot.value['bankCardSale'].toString());
//
//          if( terminalSaleSnapshot.value['upiSale'] != null)
//            upiSale = upiSale + double.parse(terminalSaleSnapshot.value['upiSale'].toString());
//
//          if( terminalSaleSnapshot.value['eWalletSale'] != null)
//            eWalletSale = eWalletSale + double.parse(terminalSaleSnapshot.value['eWalletSale'].toString());
//
//          if( terminalSaleSnapshot.value['foodCardSale'] != null)
//            foodCardSale = foodCardSale + double.parse(terminalSaleSnapshot.value['foodCardSale'].toString());
//        }
//        else
//        {
//          saleDetailsAtTerminal[storeTerminal] = <String, dynamic> {
//            'cashSale':0,
//            'bankCardSale':0,
//            'upiSale':0,
//            'foodCardSale':0,
//            'eWalletSale':0,
//            'totalSale':0,
//            'totalWalkins':0,
//          };
//        }
//      }
//      else
//      {
//        saleDetailsAtTerminal[storeTerminal] = <String, dynamic> {
//          'cashSale':0,
//          'bankCardSale':0,
//          'upiSale':0,
//          'foodCardSale':0,
//          'eWalletSale':0,
//          'totalSale':0,
//          'totalWalkins':0,
//        };
//      }
//      print(saleDetailsAtTerminal[storeTerminal]);
//      terminalsProcessed = terminalsProcessed + 1;
//      processCount = processCount + 1;
//      if(terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] != null){
//        terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] = terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] + 1;
//      }
//      else
//      {
//        terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] = 1;
//      }
//      if(terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] == terminalsAvailableAtStore[posTerminalToStoreIdMap[storeTerminal]] )
//      {
//        isStoreProcessed[posTerminalToStoreIdMap[storeTerminal]] = true;
//        print('All Terminals processed at Store:' + posTerminalToStoreIdMap[storeTerminal]);
//        storeIdTerminalMap[posTerminalToStoreIdMap[storeTerminal]].forEach((terminal) {
//          if(salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]] != null)
//            salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]] = double.parse(salePositionAtTerminal[terminal].toString()) + double.parse(salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]].toString());
//          else
//            salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]] = double.parse(salePositionAtTerminal[terminal].toString());
//        });
////        print(salePositionAtStore);
//        print(salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]]);
//        storesProcessed = storesProcessed + 1;
//        print('Stores Processed:' + storesProcessed.toString());
//        print('Stores To Be Processed:' + storeCount.toString());
//        if(storesProcessed == storeCount)
//        {
//          print('All Stores Processed successfully');
//          storeSalePositionAvailable = true;
//          retrievingSalePosition = false;
//          if(this.mounted)
//            {
//              setState(() {});
//            }
//
//        }
//      }
//      print('Store Id:' + posTerminalToStoreIdMap[storeTerminal].toString());
//      print('Store Terminal:' + storeTerminal.toString());
//      print('Terminals Processed At Store:' + terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]].toString());
//      print('Terminals Available At Store:' + terminalsAvailableAtStore[posTerminalToStoreIdMap[storeTerminal]].toString());
//      if(terminalsProcessed == terminalCount)
//      {
//        storeSalePositionAvailable = true;
//        retrievingStoreSalePosition = false;
//        print(salePositionAtStore);
//        if(this.mounted)
//          setState(() {
//          });
//      }
//    });

  }

  void getStoreSalePostion(String year, String month, String day)
  {
    storeSalePositionAvailable = false;
    retrievingStoreSalePosition = true;
    terminalCount = storeTerminals.length;
    terminalsProcessed = 0;
    totalSaleForSelectedDate = 0;
    totalWalkinsForSelectedDate = 0;
    cashSale = 0;
    cardSale = 0;
    upiSale = 0;
    eWalletSale = 0;
    foodCardSale = 0;

    storesProcessed = 0;
    storeTerminals.forEach((storeTerminal){
      print('Calling getTerminalSalePosition For Terminal ' + storeTerminal.toString());
      terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] = 0;
      salePositionAtTerminal[storeTerminal] = 0;
      salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]] = 0;
      getTerminalSalePosition(storeTerminal, year, month, day);
    });
  }

//  void getProductSalePositionForDateForProductCode(String productCode, String terminal, String year, String month, String day){
//    FirebaseDatabase
//        .instance
//        .reference()
//        .child('storeTerminals')
//        .child(terminal)
//        .child('sales')
//        .child(year)
//        .child(month)
//        .child(day)
//        .child('productSalePosition')
//        .child(productCode)
//        .child('salePosition')
//        .once()
//        .then((productSalePositionSnapshot) {
//      if (productSalePositionSnapshot != null &&
//          productSalePositionSnapshot.value != null) {
//
//        if(productSalePositionByDateAtTerminal[terminal] == null)
//        {
//          productSalePositionByDateAtTerminal[terminal] = <dynamic, dynamic>{
//            productCode:<dynamic, dynamic>{
//              day+month+year : double.parse(productSalePositionSnapshot.value.toString())
//            }
//          };
//        }
//        else
//        {
//          if(productSalePositionByDateAtTerminal[terminal][productCode] == null)
//          {
//            productSalePositionByDateAtTerminal[terminal][productCode] = <dynamic, dynamic>{
//              day+month+year : double.parse(productSalePositionSnapshot.value.toString())
//            };
//          }
//          else
//          {
//            productSalePositionByDateAtTerminal[terminal][productCode][day+month+year] = double.parse(productSalePositionSnapshot.value.toString());
//          }
//        }
//      }
//
//
//      if(daysProcessedForProductCodeAtTerminal[terminal] != null)
//      {
//        if(daysProcessedForProductCodeAtTerminal[terminal][productCode] != null)
//        {
//          daysProcessedForProductCodeAtTerminal[terminal][productCode] =
//              int.parse(daysProcessedForProductCodeAtTerminal[terminal][productCode].toString()) + 1;
//        }
//        else
//        {
//          daysProcessedForProductCodeAtTerminal[terminal][productCode] = 1;
//        }
//      }
//      else {
//        daysProcessedForProductCodeAtTerminal[terminal] = {
//          productCode : 1
//        };
//      }
//
//      if(daysProcessedForProductCodeAtTerminal[terminal][productCode] == dayCount){
//
//        if(terminalSalePosition[terminal] == null)
//        {
//          if(totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal] != null && totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode] != null)
//          {
//            terminalSalePosition[terminal] = totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode];
//          }
//        }
//        else
//        {
//          if(totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal] != null && totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode] != null)
//          {
//            terminalSalePosition[terminal] = terminalSalePosition[terminal] + totalSaleForSelectedPeriodForProductCodeAtTerminal[terminal][productCode];
//          }
//        }
//
//        processedCount = processedCount + dayCount;
//        if(processedCount == processCount){
//          print('productSalePositionByDateAtTerminal:');
//          print(productSalePositionByDateAtTerminal);
//          Navigator.of(context).push<dynamic>(
//              MaterialPageRoute<dynamic>(
//                  builder:(BuildContext context){
//                    return ShowBrandSaleResults();
//                  }
//              )
//          );
//
//          setState(() {
//            retrievingSalePosition = false;
//          });
//        }
//      }
//
//
//      if(daysProcessedForProductcode[productCode] == dayCount){
//        productCodesProcessedCount = productCodesProcessedCount + 1;
//        if(productCodesProcessedCount == productCodes.length)
//        {
//          allProductCodesProcessed = true;
//          productCodes.forEach((dynamic element) {
//            unitsSoldForSelectedPeriod = unitsSoldForSelectedPeriod + totalSaleForSelectedPeriodForProductCode[element];
//          });
//          averageUnitsSoldForSelectedPeriod = unitsSoldForSelectedPeriod / dayCount;
//        }
//
//        print('Sale Position Retrieved For All Dates');
//        setState(() {
//        });
//      }
//    });
//  }

//  void getProductSalePositionForDateForProductCodes(List<String> productCodes, String terminal, String year, String month, String day){
//    productCodes.forEach((String productCode)
//    {
////          print(productCode);
////          print(year + month + day);
//      daysProcessedForProductcode[productCode] = 0;
//      totalSaleForSelectedPeriodForProductCode[productCode]= 0;
//      averageSaleForSelectedPeriodForProductCode[productCode] = 0;
//      getProductSalePositionForDateForProductCode(productCode, terminal, year, month, day);
//    }
//    );
//
//  }

  @override
  Widget build(BuildContext context) {
//    productCodes = [];
//    barCodeSearchResultsMap.forEach((key, value) {
//      productCodes.add(value.productID.toString());
//    });

    if(retrievingSalePosition)
    {
      return
        WillPopScope(
          onWillPop:(){
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return SalePositionShowDailySaleBetweenDates();
                    }
                )
            );
            return;
          },

          child: Scaffold(
            appBar:
            AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading:IconButton(
                icon :Icon(Icons.keyboard_backspace),
                onPressed:(){
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return SalePositionShowDailySaleBetweenDates();
                      }
                    )
                  );
                }
              ),
              title:Text(
                  'DAILY SALE ANALYSIS',
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
              'DAILY SALE ANALYSIS',
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
                                  return SalePositionShowDailySaleBetweenDateSelectStore();
                                }
                            )
                            );
                          },
                          child:Text(selectedStore,
                              style:TextStyle(
                                  fontSize:24.0,
                                  color:Colors.white,fontFamily: 'Montserrat', fontWeight:FontWeight.bold)
                          )
                      )
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex:2,
                          child: Text('FROM:',
                              style:TextStyle(
                                  fontSize: 24.0,
                                  color:Colors.black,fontFamily: 'Montserrat', fontWeight:FontWeight.bold)
                          )),
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
                                    },
                                    onConfirm: (date) {
                                      startDateAsDateTime = date;
                                      startDate = DateFormat('dd-MM-yyyy').format(date);
                                      setState(() {});
                                    },
                                    currentTime: DateTime.now().add(Duration(days: -1)), locale: LocaleType.en);
                              },
                              child: Text(startDate,
                                  style:TextStyle(
                                      fontSize:24.0,
                                      color:Colors.white,fontFamily: 'Montserrat', fontWeight:FontWeight.bold))
                          )
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex:2,
                          child: Text('TO:',
                              style:TextStyle(

                                  fontSize:24.0,
                                  color:Colors.black,fontFamily: 'Montserrat', fontWeight:FontWeight.bold))),
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
                                  },
                                  onConfirm: (date) {
                                    endDate = DateFormat('dd-MM-yyyy').format(date);
                                    endDateAsDateTime = date;
                                    setState(() {});
                                  },
                                  currentTime: DateTime.now().add(Duration(days: -1)), locale: LocaleType.en);
                            },
                            child: Text(endDate,
                                style:TextStyle(fontSize:24.0,color: Colors.white,fontFamily: 'Montserrat', fontWeight:FontWeight.bold)),)
                      )
                    ],
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

                            terminalSalePosition = Map<String, double>();
                            productSalePosition = Map<String, double>();
                            stockOutwardByDate = {};
                            saleDetailsPerTerminalByDate = Map<String, dynamic>();

//
                              dayCount = endDateAsDateTime.difference(startDateAsDateTime).inDays + 1;
                              processCount = dayCount * terminalCount;
                              setState(() {
                                print('Day Count:' + dayCount.toString());
                                print('Process Count' + processedCount.toString());
                                retrievingSalePosition = true;
                              });

                              walkinsForSelectedPeriod = 0;
                             saleForSelectedPeriod = 0;
                             cashSaleForSelectedPeriod = 0;
                             bankCardSaleForSelectedPeriod = 0;
                             cardSaleForSelectedPeriod = 0;
                             upiSaleForSelectedPeriod = 0;
                             eWalletSaleForSelectedPeriod = 0;
                             foodCardSaleForSelectedPeriod = 0;

                            storesProcessed = 0;
                            storeIdTerminalMap[selectedStore].forEach((storeTerminal) {
                              print('Calling getTerminalSalePosition For Terminal ' + storeTerminal.toString());
                              terminalsProcessedAtStore[posTerminalToStoreIdMap[storeTerminal]] = 0;
                              salePositionAtTerminal[storeTerminal] = 0;
                              salePositionAtStore[posTerminalToStoreIdMap[storeTerminal]] = 0;
                            });

                              for(int i = 0; i < endDateAsDateTime.difference(startDateAsDateTime).inDays + 1; ++i)
                              {
                                var dateAsString_ddMMyyyy = DateFormat('ddMMyyyy').format(startDateAsDateTime.add(Duration(days:i)));
                                var year = dateAsString_ddMMyyyy.substring(4,8);
                                var month = dateAsString_ddMMyyyy.substring(2,4);
                                var day = dateAsString_ddMMyyyy.substring(0,2);
//                                getStoreSalePostion(year, month, day);

                                storeIdTerminalMap[selectedStore].forEach((storeTerminal) {
                                  print('Calling getTerminalSalePosition For Terminal ' + storeTerminal.toString());
                                  getTerminalSalePosition(storeTerminal, year, month, day);
                                });
                              }
//                            }

                          },
                          child:Text('PROCEED',
                              style:TextStyle(fontSize:24.0,color: Colors.white, fontFamily: 'Montserrat', fontWeight:FontWeight.bold))
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
                  Container(
                    width:MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border:Border.all(color:Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                    child:
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex:3,
                            child: Text(
                              '',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.left,)),
                        Expanded(
                            flex:3,
                            child:
                            Text(
                              'TOTAL',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.right,)
                        ),
                        Expanded(
                            flex:3,
                            child:
                            Text(
                              'AVERAGE',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.right,)
                        )
                      ],
                    ),
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child:
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex:3,
                            child: Text(
                              'Walkins:',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.left,)),
                        Expanded(
                            flex:3,
                            child:
                            Text(
                              walkinsForSelectedPeriod.toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.right,)
                        ),
                        Expanded(
                            flex:3,
                            child:
                            Text(
                              (walkinsForSelectedPeriod / dayCount).toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.right,)
                        )
                      ],
                    ),
                  ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(4.0),
                  child:
                  Row(
                    children: <Widget>[
                      Expanded(
                          flex:2,
                          child: Text(
                            'Sale:',
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color:Colors.black
                            ),
                            textAlign: TextAlign.left,)),
//                      Expanded(
//                          flex:1,
//                          child:
//                          Text(
//                            '\u20B9',
//                            style:TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontSize: 12.0,
//                                fontWeight: FontWeight.bold,
//                                color:Colors.black
//                            ),
//                            textAlign: TextAlign.right,)
//                      ),
                      Expanded(
                          flex:2,
                          child:
                          Text(
                              '\u20B9'+saleForSelectedPeriod.toStringAsFixed(0),
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color:Colors.deepOrange
                            ),
                            textAlign: TextAlign.right,)
                      ),
//                      Expanded(
//                          flex:1,
//                          child:
//                          Text(
//                            '\u20B9',
//                            style:TextStyle(
//                                fontFamily: 'Montserrat',
//                                fontSize: 12.0,
//                                fontWeight: FontWeight.bold,
//                                color:Colors.black
//                            ),
//                            textAlign: TextAlign.right,)
//                      ),
                      Expanded(
                          flex:2,
                          child:
                          Text(
                            '\u20B9'+(saleForSelectedPeriod / dayCount).toStringAsFixed(0),
                            style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color:Colors.deepOrange
                            ),
                            textAlign: TextAlign.right,)
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
                            flex:2,
                            child: Text(
                                'Cash:',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.left,)),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),
                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+cashSaleForSelectedPeriod.toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        ),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),
                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+(cashSaleForSelectedPeriod / dayCount).toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        )
                      ],
                    ),
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child:
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex:2,
                            child: Text(
                              'Bank Card:',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.left,)),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),

                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+bankCardSaleForSelectedPeriod.toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        ),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),
                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+(bankCardSaleForSelectedPeriod / dayCount).toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        )
                      ],
                    ),
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child:
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex:2,
                            child: Text(
                              'UPI:',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.left,)),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),
                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+upiSaleForSelectedPeriod.toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        ),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),
                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+(upiSaleForSelectedPeriod / dayCount).toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        )
                      ],
                    ),
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child:
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex:2,
                            child: Text(
                              'Food Card:',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.left,)),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),
                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+foodCardSaleForSelectedPeriod.toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        ),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),
                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+(foodCardSaleForSelectedPeriod  / dayCount).toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        )
                      ],
                    ),
                  ),
                  Container(
                    width:MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(4.0),
                    child:
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex:2,
                            child: Text(
                              'eWallet:',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              ),
                              textAlign: TextAlign.left,)),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),
                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+eWalletSaleForSelectedPeriod.toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        ),
//                        Expanded(
//                            flex:1,
//                            child:
//                            Text(
//                              '\u20B9',
//                              style:TextStyle(
//                                  fontFamily: 'Montserrat',
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.bold,
//                                  color:Colors.black
//                              ),
//                              textAlign: TextAlign.right,)
//                        ),
                        Expanded(
                            flex:2,
                            child:
                            Text(
                              '\u20B9'+(eWalletSaleForSelectedPeriod / dayCount).toStringAsFixed(0),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.deepPurple
                              ),
                              textAlign: TextAlign.right,)
                        )
                      ],
                    ),
                  ),
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
