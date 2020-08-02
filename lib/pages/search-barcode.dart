import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/barcode-search-results.dart';

import 'request-barcode-obsolete.dart';
import 'show-home-page.dart';
import 'dart:math';


class SearchBarCode extends StatefulWidget {
  @override
  _SearchBarCodeState createState() => _SearchBarCodeState();
}

class _SearchBarCodeState extends State<SearchBarCode> {

  String barCodeToSearch = '';
  bool retrievingProductDetails = false;

  Future getBarCode() async {
    barCodeToSearch = await Navigator.of(context).push<dynamic>(
        MaterialPageRoute<dynamic>(builder: (BuildContext context) {
          return RequestBarCodeObsolete ();
        }));
    print(barCodeToSearch);
    if (barCodeToSearch.length > 0) {
      getProductDetails();
    }
  }

  void getProductDetails()
  {
    setState(() {
      retrievingProductDetails = true;
      barCodeSearchResultsMap = {};
    });

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_MASTER')
        .child('products')
        .orderByChild('milliSecondsSinceEpoch')
        .startAt(1595474232962680/1000)
//        .equalTo(barCodeToSearch.toLowerCase())
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
      if (snapshot != null && snapshot.value != null) {
        Map<dynamic, dynamic> productDetailsMap = snapshot.value;
        if (productDetailsMap.length == 1) {
          print(productDetailsMap.length);
          productDetailsMap.forEach((dynamic code, dynamic product) {
            if(product['status'] == null )
            {
              barCodeSearchResultsMap[int.parse(product['productcode'].toString())] =
               ProductBasicDetails(
                product['title'].toString(),
                double.parse(product['price'].toString()),
                int.parse(product['productcode'].toString()),
                product['barcode'].toString(),
                product['imageurl'].toString(),
                product['category'].toString(),
                product['brand'].toString(),
                  (product['status'] != null)?product['status'].toString():'N/A',
                  (product['parentStore'] != null)?product['parentStore'].toString():'N/A',
                  (product['creationTimeStamp'] != null)?product['creationTimeStamp'].toString():'N/A'
              );
//              if(product['creationTimeStamp'] != null){
////                  DateTime date = DateTime.now();
//                DateTime date1 = DateTime.parse(product['creationTimeStamp'].toString());
//
////                today = DateFormat('dd-MM-yyyy').format(date);
//                DateTime date2 = DateTime.parse('2020-07-23 00:00:00.000');
//
//
//
//                if( date1.compareTo(date2) > 0)
//                {
//                  print('ADDED TODAY:' + product['barcode'].toString());
//                }
//              }
            }
            else
            {
              if(product['status'] == 'active')
              {
                barCodeSearchResultsMap[int.parse(product['productcode'].toString())] =
                 ProductBasicDetails(
                  product['title'].toString(),
                  double.parse(product['price'].toString()),
                  int.parse(product['productcode'].toString()),
                  product['barcode'].toString(),
                  product['imageurl'].toString(),
                  product['category'].toString(),
                  product['brand'].toString(),
                    (product['status'] != null)?product['status'].toString():'N/A',
                    (product['parentStore'] != null)?product['parentStore'].toString():'N/A',
                    (product['creationTimeStamp'] != null)?product['creationTimeStamp'].toString():'N/A'
                );
//                if(product['creationTimeStamp'] != null){
////                  DateTime date = DateTime.now();
//                  DateTime date1 = DateTime.parse(product['creationTimeStamp'].toString());
//
////                today = DateFormat('dd-MM-yyyy').format(date);
//                  DateTime date2 = DateTime.parse('2020-07-23 00:00:00.000');
//
//
//
//                  if( date1.compareTo(date2) > 0)
//                  {
//                    print('ADDED TODAY:' + product['barcode'].toString());
//                  }
//                }
              }
            }
//            barCodeSearchResults.add(new ProductBasicDetails(
//              product['title'].toString(),
//              double.parse(product['price'].toString()),
//              int.parse(product['productcode'].toString()),
//              product['barcode'].toString(),
//              product['imageurl'].toString(),
//              product['category'].toString(),
//              product['brand'].toString(),
//            ));
          });
          print('BarCode Search Resuts:');
          print(barCodeSearchResultsMap);
          print(barCodeSearchResultsMap.length.toString());
          if(barCodeSearchResultsMap.length > 0)
            {
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) {
                        return BarCodeSearchResults();
                      }));
            }
          else
            {
              setState(() {
                retrievingProductDetails = false;
              });
            }
        } else if (productDetailsMap.length > 1) {
          productDetailsMap.forEach((dynamic code, dynamic product) {

//            barCodeSearchResults.add(new ProductBasicDetails(
//              product['title'].toString(),
//              double.parse(product['price'].toString()),
//              int.parse(product['productcode'].toString()),
//              product['barcode'].toString(),
//              product['imageurl'].toString(),
//              product['category'].toString(),
//              product['brand'].toString(),
//            ));

            if(product['status'] == null )
            {
              barCodeSearchResultsMap[int.parse(product['productcode'].toString())] =
               ProductBasicDetails(
                product['title'].toString(),
                double.parse(product['price'].toString()),
                int.parse(product['productcode'].toString()),
                product['barcode'].toString(),
                product['imageurl'].toString(),
                product['category'].toString(),
                product['brand'].toString(),
                   (product['status'] != null)?product['status'].toString():'N/A',
                   (product['parentStore'] != null)?product['parentStore'].toString():'N/A',
                   (product['creationTimeStamp'] != null)?product['creationTimeStamp'].toString():'N/A'
              );
//              if(product['creationTimeStamp'] != null){
////                  DateTime date = DateTime.now();
//                DateTime date1 = DateTime.parse(product['creationTimeStamp'].toString());
//
////                today = DateFormat('dd-MM-yyyy').format(date);
//                DateTime date2 = DateTime.parse('2020-07-23 00:00:00.000');
//
//
//
//                if( date1.compareTo(date2) > 0)
//                {
//                  print('ADDED TODAY:' + product['barcode'].toString());
//                }
//              }
            }
            else
            {
              if(product['status'] == 'active')
              {
                barCodeSearchResultsMap[int.parse(product['productcode'].toString())] =
                    ProductBasicDetails(
                  product['title'].toString(),
                  double.parse(product['price'].toString()),
                  int.parse(product['productcode'].toString()),
                  product['barcode'].toString(),
                  product['imageurl'].toString(),
                  product['category'].toString(),
                  product['brand'].toString(),
                    (product['status'] != null)?product['status'].toString():'N/A',
                    (product['parentStore'] != null)?product['parentStore'].toString():'N/A',
                    (product['creationTimeStamp'] != null)?product['creationTimeStamp'].toString():'N/A'
                );
//                if(product['creationTimeStamp'] != null){
////                  DateTime date = DateTime.now();
//                  DateTime productCreationDate = DateTime.parse(product['creationTimeStamp'].toString());
//
////                today = DateFormat('dd-MM-yyyy').format(date);
//                  DateTime selectedDate = DateTime.parse('2020-07-23 00:00:00.000');
//
//
//
//                  if( productCreationDate.compareTo(selectedDate) >= 0)
//                  {
//                    print('ADDED TODAY:' + product['barcode'].toString());
//                  }
//                }
              }
            }
          });
          barCodeSearchResults.sort((a, b) {
            return a.productName.compareTo(b.productName);
          });
          print(barCodeSearchResultsMap);
          if(barCodeSearchResultsMap.length > 0){
            setState(() {
              retrievingProductDetails = false;
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) {
                        return BarCodeSearchResults();
                      }));
            });

          }
          else
          {
            setState(() {
              retrievingProductDetails = false;
            });
          }
        }
      } else {
        setState(() {
          retrievingProductDetails = false;
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) {
                    return BarCodeSearchResults();
                  }));
        });

        print(barCodeToSearch + ':product not in system');
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//   getBarCode();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getTextWidget(barCodeToSearch, 20, Colors.black),
          RaisedButton(
            onPressed:
            (){
              getBarCode();
            },
            child:Text('ENTER BARCODE')
          )
        ],

      )
    );
  }
}
