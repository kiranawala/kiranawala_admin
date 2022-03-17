import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
//import 'check-if-admin.dart';
//import 'app-mode-selection.dart';
//import 'request-number-value.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StockInwardSummary extends StatefulWidget {
  @override
  _StockInwardSummaryState createState() => _StockInwardSummaryState();
}

class _StockInwardSummaryState extends State<StockInwardSummary> {
  List<dynamic> stockInwardsProductList = List<dynamic>();
  Map<String,dynamic> stockInwardProductMap = Map<String,dynamic>();
  double stockInwardTotalQty = 0;
  double stockInwardTotalValue = 0;
  String stockInwardDate = '';
  List<String> duplicates = List<String>();
  bool loadingStockInwardSummaryForDate = false;

  void getStockInwardForDate()
  {
    stockInwardsProductList = List<dynamic>();
    stockInwardTotalQty = 0;
    stockInwardTotalValue = 0;
    setState(() {
      loadingStockInwardSummaryForDate = true;
    });
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_8')
        .child('stockInwards')
        .child(stockInwardDate)
        .once()
        .then((stockInwardsForDateSnapshot){
      print(stockInwardsForDateSnapshot.value);
      if(stockInwardsForDateSnapshot != null && stockInwardsForDateSnapshot.value != null)
      {
        stockInwardsForDateSnapshot.value.forEach((dynamic key, dynamic stockInwardProduct) {
          stockInwardsProductList.add(<String, dynamic>{
            'productCode': stockInwardProduct['productCode'],
            'productBarCode':stockInwardProduct['productBarCode'],
            'productName': stockInwardProduct['productName'],
            'productPrice': stockInwardProduct['productPrice'],
            'stockInwardQty': stockInwardProduct['stockInwardQty'],
          });
          stockInwardTotalQty = stockInwardTotalQty + double.parse(stockInwardProduct['stockInwardQty'].toString());
          stockInwardTotalValue = stockInwardTotalValue +
              (double.parse(stockInwardProduct['productPrice'].toString()) *
                  double.parse(stockInwardProduct['stockInwardQty'].toString()) );
        });

        print('No.Of Products:' + stockInwardsProductList.length.toString());
        print('Total No. Of Units:' + stockInwardTotalQty.toString());
        print('Total Value:' + stockInwardTotalValue.toString());
        print(stockInwardsProductList);
        setState(() {
          loadingStockInwardSummaryForDate = false;
        });
      }
      else
        {
          setState(() {
            loadingStockInwardSummaryForDate = false;
          });
        }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stockInwardTotalQty = 0;
    stockInwardTotalValue = 0;
    stockInwardDate = DateFormat('ddMMyyyy').format(DateTime.now()).toString();
    getStockInwardForDate();
  }

  @override
  Widget build(BuildContext context) {
    if(loadingStockInwardSummaryForDate) {
      return WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();
//            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                builder: (BuildContext context) {
//                  return CheckIfAdmin();
//                }));
            return;
          },
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text('STOCK INWARD SUMMARY',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )),
                leading: IconButton(
                  icon: Icon(Icons.keyboard_backspace),
                  onPressed: () {
                    Navigator.of(context).pop();
//                    Navigator.of(context).push<dynamic>(
//                        MaterialPageRoute<dynamic>(
//                            builder: (BuildContext context) {
//                              return CheckIfAdmin();
//                            }));
                  },
                ),
              ),
              body:Container(
                color: Colors.white,
                child: Dialog(
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new CircularProgressIndicator(),
                      new Text("Loading Inward Summary..."),
                    ],
                  ),
                ),
              )
          ));
    }
    else {
      return WillPopScope(
          onWillPop: () {
            Navigator.of(context).pop();
//            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
//                builder: (BuildContext context) {
//                  return CheckIfAdmin();
//                }));
            return;
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('STOCK INWARD SUMMARY',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  )),
              leading: IconButton(
                icon: Icon(Icons.keyboard_backspace),
                onPressed: () {
                  Navigator.of(context).pop();
//                  Navigator.of(context).push<dynamic>(
//                      MaterialPageRoute<dynamic>(
//                          builder: (BuildContext context) {
//                            return CheckIfAdmin();
//                          }));
                },
              ),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  4.0))),
                          height: 30.0,
                          child: FlatButton(
                            color: Colors.blueGrey,
                            onPressed: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2019, 11, 01),
                                  maxTime: DateTime.now(),
                                  onChanged: (date) {},
                                  onConfirm: (date) {
                                    stockInwardDate =
                                        DateFormat('ddMMyyyy').format(date);
                                    getStockInwardForDate();
                                    setState(() {});
                                  },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: Text(
                              stockInwardDate.toUpperCase(),
                              style: TextStyle(color: Colors.amberAccent,
                                  fontSize: 20.0,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 20,
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Container(

                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 12,
                                child: Text(
                                    stockInwardsProductList[index]['productName']
                                        .toString()
                                        .toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0)
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                    stockInwardsProductList[index]['productPrice']
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0)
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                    stockInwardsProductList[index]['stockInwardQty']
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0)
                                ),
                              ),
                            ],
                          )
                      );
                    },
                    itemCount: stockInwardsProductList.length,),
                ),
                Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                                height: 30.0,
                                color: Colors.blueGrey,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(child: Text('PRODUCTS:' +
                                        stockInwardsProductList.length
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.amberAccent,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0))),
                                    Expanded(child: Text('UNITS:' +
                                        stockInwardTotalQty.toString(),
                                        style: TextStyle(
                                            color: Colors.amberAccent,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0))),
                                    Expanded(child: Text('VALUE:' +
                                        stockInwardTotalValue.toString(),
                                        style: TextStyle(
                                            color: Colors.amberAccent,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0)))
                                  ],
                                )
                            )
                        )
                      ],
                    )
                )
              ],
            ),
          ));
    }
  }
}
