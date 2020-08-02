import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/multi-store-stock-position.dart';
import 'package:kiranawala_admin/pages/reset-store.dart';
import 'package:kiranawala_admin/pages/search-barcode.dart';
import 'package:kiranawala_admin/pages/select-store.dart';
import 'package:kiranawala_admin/pages/show-product-sale.dart';
import 'package:kiranawala_admin/pages/show-sale-position-home.dart';
//import 'package:kiranawala_admin/pages/store-stock-position.dart';

import 'show-lyrics.dart';
import 'show-sinima-home-page.dart';

bool storeLoading = true;
bool storeLoaded = false;
bool storeLoadingSuccessful = false;
bool fullProductMapAvailable = false;


class ProductBasicDetails {
  String productName;
  int productID;
  String productBarCode;
  num productPrice;
  String productImageURL;
  String productCategory;
  String productBrand;
  String productStatus;
  String productParentStore;
  String productCreationTimeStamp;


  ProductBasicDetails(
      String productName,
      num productPrice,
      int productID,
      String productBarCode,
      String productImageURL,
      String productCategory,
      String productBrand,
      String productStatus,
    String productParentStore,
    String productCreationTimeStamp
      ) {
    this.productName = productName;
    this.productPrice = productPrice;
    this.productID = productID;
    this.productBarCode = productBarCode;
    this.productImageURL = productImageURL;
    this.productCategory = productCategory;
    this.productBrand = productBrand;
    this.productStatus = productStatus;
    this.productParentStore = productParentStore;
    this.productCreationTimeStamp = productCreationTimeStamp;
  }
}

List<ProductBasicDetails> barCodeSearchResults = new List();
String barCodeToSearch = '';

Map<int, ProductBasicDetails> barCodeSearchResultsMap = new Map();
Map<int, ProductBasicDetails> productMap = new Map();


Map<int, ProductBasicDetails> fullProductMap = new Map();
List<ProductBasicDetails> fullProductList = new List();

class ShowHomePage extends StatefulWidget {
  @override
  _ShowHomePageState createState() => _ShowHomePageState();
}

class _ShowHomePageState extends State<ShowHomePage> {
  void initState()
  {
    super.initState();

    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_MASTER')
        .child('products')
        .once()
        .then((snapshot){
      if(snapshot != null && snapshot.value != null) {
        snapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
          if(productSnapshot['title'] != null && productSnapshot['title'] != ''){

            ProductBasicDetails product = ProductBasicDetails(
                productSnapshot['title'],
                double.parse(productSnapshot['price'].toString()),
                int.parse(productCode.toString()),
                productSnapshot['barcode'].toString(),
                (productSnapshot['imageurl'] != null)
                    ? productSnapshot['imageurl']
                    : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
                productSnapshot['category'],
                productSnapshot['brand'],
                (productSnapshot['productStatus'] != null)
                    ? productSnapshot['productStatus']
                    : 'N/A',
                (productSnapshot['productParent'] != null)
                    ? productSnapshot['productParent']
                    : 'N/A',
                (productSnapshot['productCreationTimeStamp'] != null)
                    ? productSnapshot['productCreationTimeStamp']
                    : 'N/A'
            );
            fullProductMap[int.parse(productCode.toString())]= product;
            fullProductList.add(product);
          }
        });

        fullProductMapAvailable = true;

        print('Full Product Map :' +
            fullProductMap.length.toString());

        print('Full Product List :' +
            fullProductList.length.toString());


        if (this.mounted) {
          setState(() {
            storeLoading = false;
            storeLoaded = true;
            storeLoadingSuccessful = true;
          });
        }
      }

    });

    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_MASTER')
        .child('products')
        .once()
        .then((productSnapshot){
      if(productSnapshot != null && productSnapshot.value != null ) {
        productSnapshot.value.forEach((dynamic productSnapshotKey,
            dynamic productSnapshotValue) {
          if (productSnapshotValue['stockInwards'] != null && productSnapshotValue['stockInwards']['invoices'] != null) {
            productCodes.add(int.parse(productSnapshotKey.toString()));
          }
        });
      }

      productCodes.forEach((int productCode) {
        FirebaseDatabase
            .instance
            .reference()
            .child('stores')
            .child('KIRANAWALA_MASTER')
            .child('products')
            .child(productCode.toString())
            .once()
            .then((productCodeSnapshot){
              if(productCodeSnapshot != null && productCodeSnapshot.value != null)
                {
                  FirebaseDatabase
                    .instance
                      .reference()
                      .child('stores')
                      .child('KIRANAWALA_STORE_8')
                      .child('products')
                      .child(productCode.toString())
                      .child('basicDetails')
                      .update(<String, dynamic>{
                        'productName':productCodeSnapshot.value['title'].toString(),
                        'productPrice':double.parse(productCodeSnapshot.value['price'].toString()),
                        'productCode':int.parse(productCodeSnapshot.value['productcode'].toString()),
                        'productBarcode':productCodeSnapshot.value['barcode'].toString(),
                        'productImageURL':productCodeSnapshot.value['imageurl'].toString(),
                        'productCategory':productCodeSnapshot.value['category'].toString(),
                        'productBrand':productCodeSnapshot.value['brand'].toString(),
                  });

                }
        });
      });
      print('Product Count to be processed:' + productCodes.length.toString());
//      productCodes.forEach((int productCode) {
//        getProductBasicDetails(productCode.toString());
//        getProductRecentStockInwardDetails(productCode);
//        getProductRecentStockOutwardDetails(productCode);
//      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
                child: Center(child: getTextWidget('ADMIN OPTIONS', 20.0, Colors.black))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color:Colors.blue,
              onPressed: (){
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                  return SelectStore();
                })).then((dynamic selectedStore){
                  if(selectedStore != null){
                    print(selectedStore.toString());
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ResetStore();
                      }
                    ));
                  }
                  else
                    {
                      print('GO BACK');
                    }
                });
              },
              child:Center(child: getTextWidget('RESET STORE', 20.0, Colors.white))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color:Colors.blue,
                onPressed: (){
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                    return SinimaHomePage();
                  }));
                },
                child:Center(child: getTextWidget('SINIMA', 20.0, Colors.white))
            ),
          ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: RaisedButton(
//                color:Colors.blue,
//                onPressed: (){
//                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                    return StoreStockPosition();
//                  }));
//                },
//                child:Center(child: getTextWidget('STOCK POSITION', 20.0, Colors.white))
//            ),
//          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color:Colors.blue,
                onPressed: (){
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                    return MultiStoreStockPosition();
                  }));
                },
                child:Center(child: getTextWidget('GROUP STOCK POSITION', 20.0, Colors.white))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color:Colors.blue,
                onPressed: (){
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                    return SearchBarCode();
                  }));
                },
                child:Center(child: getTextWidget('SEARCH BARCODE', 20.0, Colors.white))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                color:Colors.blue,
                onPressed: (){
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                    return ShowSalePositionHomePage();
                  }));
                },
                child:Center(child: getTextWidget('SALE POSITION', 20.0, Colors.white))
            ),
          ),
        ],
      ),
    );
  }
}