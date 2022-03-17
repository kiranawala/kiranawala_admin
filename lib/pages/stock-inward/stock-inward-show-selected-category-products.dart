import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-cart-options.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-show-cart-products.dart';


List<ProductBasicDetails> categoryProducts = List<ProductBasicDetails>();
List<ProductBasicDetails> searchResults = List<ProductBasicDetails>();
int searchResultsIndex = 0;


class StockInwardSelectedCategoryProducts extends StatefulWidget {
  @override
  _StockInwardSelectedCategoryProductsState createState() =>
      _StockInwardSelectedCategoryProductsState();
}

class _StockInwardSelectedCategoryProductsState
    extends State<StockInwardSelectedCategoryProducts> {
  _StockInwardSelectedCategoryProductsState() : super();

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
  Map<String, int> terminalsProcessedForProductCode = Map<String, int>();

  var totalSaleForSelectedPeriodForProductCodeAtTerminal = <dynamic, dynamic>{};
  var daysProcessedForProductCodeAtTerminal = <dynamic,dynamic>{};

  Map<String, double> averageSaleForSelectedPeriodForProductCode = Map<String, double>();

  Map<String, bool> productCodesProcessed = Map<String, bool>();
  Map<dynamic, dynamic> productCodesProcessedAtTerminal = Map<dynamic, dynamic>();

  Map<dynamic, dynamic> productSalePositionAtTerminal = Map<dynamic, dynamic>();
//  Map<String, double> salePositionForProductCode = Map<String, double>();
//  Map<String, double> stockInwardForProductCode = Map<String, double>();


  bool allProductCodesProcessed = false;
  int productCodesProcessedCount  = 0;
  List<ProductBasicDetails> products = List<ProductBasicDetails>();

  Map<String, double> totalSaleAtTerminal = Map<String, double>();
  int processCount = 0;
  int processedCount = 0;
  int stockInwardProcessCount = 0;
  int stockInwardProcessedCount = 0;

  bool retrievingStockInward = false;
  bool retrievingStockOutward = false;

  List<String> storeTerminals = List<String>();


  void getProductStockOutwardDetailsTillDateForProductCode(String productCode, String terminal){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(productCode)
        .child('stockOutwards')
        .child(terminal)
        .once()
        .then((productSalePositionSnapshot) {
      print(productSalePositionSnapshot);
      if (productSalePositionSnapshot != null &&
          productSalePositionSnapshot.value != null) {
        if (productSalePositionSnapshot.value['stockOutwardTillDate'] != null
            &&
            productSalePositionSnapshot.value['recentStockOutwardQty'] != null
            &&
            productSalePositionSnapshot.value['recentStockOutwardDate'] != null
            && productSalePositionSnapshot.value['recentStockOutwardTime'] !=
                null) {
          recentStockOutwardDateForProductCode[productCode] =
              productSalePositionSnapshot.value['recentStockOutwardDate']
                  .toString();
          recentStockOutwardTimeForProductCode[productCode] =
              productSalePositionSnapshot.value['recentStockOutwardTime']
                  .toString();
          recentStockOutwardQtyForProductCode[productCode] = double.parse(
              productSalePositionSnapshot.value['recentStockOutwardQty']
                  .toString());

          print(recentStockOutwardDateForProductCode[productCode]);
          print(recentStockOutwardTimeForProductCode[productCode]);
          print(recentStockOutwardQtyForProductCode[productCode]);

          if (salePositionForProductCode[productCode] == null) {
            salePositionForProductCode[productCode] =
                double.parse(
                    productSalePositionSnapshot.value['stockOutwardTillDate']
                        .toString());
          }
          else {
            salePositionForProductCode[productCode] =
                salePositionForProductCode[productCode] + double.parse(
                    productSalePositionSnapshot.value['stockOutwardTillDate']
                        .toString());
          }
        }
      }

        if(terminalsProcessedForProductCode[productCode] == null)
        {
          terminalsProcessedForProductCode[productCode] = 1;
        }
        else
        {
          terminalsProcessedForProductCode[productCode] = terminalsProcessedForProductCode[productCode] + 1;
        }

        if(terminalsProcessedForProductCode[productCode] != null)
        {
          if(terminalsProcessedForProductCode[productCode] == storeTerminals.length)
          {
            print('All terminals processed successfully for productCode:' + productCode);
          }
        }

          processedCount = processedCount + 1;

          if(processedCount == processCount){
            print('salePositionForProductCode:');
            print(salePositionForProductCode);
//          Navigator.of(context).push<dynamic>(
//              MaterialPageRoute<dynamic>(
//                  builder:(BuildContext context){
//                    return ShowCategorySaleResults();
//                  }
//              )
//          );

            setState(() {
              print('Processed all Terminals Successfully');
              retrievingStockOutward = false;
            });
          }
        });
  }

  void getProductStockOutwardTillDateForProductCode(String productCode, String terminal){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(productCode)
        .child('stockOutwards')
        .child(terminal)
        .child('stockOutwardTillDate')
        .once()
        .then((productSalePositionSnapshot) {
      print(productSalePositionSnapshot);
      if (productSalePositionSnapshot != null &&
          productSalePositionSnapshot.value != null) {

        if(salePositionForProductCode[productCode] == null)
        {
          salePositionForProductCode[productCode] =
            double.parse(productSalePositionSnapshot.value.toString());
          if(terminalsProcessedForProductCode[productCode] == null)
            {
              terminalsProcessedForProductCode[productCode] = 1;
            }
          else
            {
              terminalsProcessedForProductCode[productCode] = terminalsProcessedForProductCode[productCode] + 1;
            }
        }
        else
        {
          salePositionForProductCode[productCode] =
              salePositionForProductCode[productCode] + productSalePositionSnapshot.value;
        }
      }


      if(terminalsProcessedForProductCode[productCode] != null)
      {
        if(terminalsProcessedForProductCode[productCode] == storeTerminals.length)
        {
           print('All terminals processed successfully for productCode:' + productCode);
        }
      }

      processedCount = processedCount + 1;

        if(processedCount == processCount){
          print('salePositionForProductCode:');
          print(salePositionForProductCode);
//          Navigator.of(context).push<dynamic>(
//              MaterialPageRoute<dynamic>(
//                  builder:(BuildContext context){
//                    return ShowCategorySaleResults();
//                  }
//              )
//          );

          setState(() {
            print('Processed all Terminals Successfully');
            retrievingStockOutward = false;
          });
        }
    });
  }

  void getProductStockOutwardTillDateForProductCodes(List<String> productCodes, String terminal){
    productCodes.forEach((String productCode)
    {
          print(productCode);
          print(terminal);
      daysProcessedForProductcode[productCode] = 0;
      totalSaleForSelectedPeriodForProductCode[productCode]= 0;
      averageSaleForSelectedPeriodForProductCode[productCode] = 0;
      getProductStockOutwardDetailsTillDateForProductCode(productCode, terminal);
    }
    );
  }

  void getProductStockInwardTillDateForProductCode(String productCode){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(productCode)
        .child('stockInwards')
        .child('stockInwardTillDate')
        .once()
        .then((productStockInwardSnapshot) {
      print(productStockInwardSnapshot);
      if (productStockInwardSnapshot != null &&
          productStockInwardSnapshot.value != null) {

        if(stockInwardForProductCode[productCode] == null)
        {
          stockInwardForProductCode[productCode] =
              double.parse(productStockInwardSnapshot.value.toString());
        }
      }
      stockInwardProcessedCount = stockInwardProcessedCount + 1;

      if(stockInwardProcessedCount == stockInwardProcessCount){
        print('stockInwardForProductCode:');
        print(stockInwardForProductCode);
//          Navigator.of(context).push<dynamic>(
//              MaterialPageRoute<dynamic>(
//                  builder:(BuildContext context){
//                    return ShowCategorySaleResults();
//                  }
//              )
//          );

        setState(() {
          print('Processed all SKUs Successfully');
          retrievingStockInward = false;
        });
      }
    });
  }


  void getProductStockInwardDetailsForProductCode(String productCode){
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_11')
        .child('products')
        .child(productCode)
        .child('stockInwards')
        .once()
        .then((productStockInwardSnapshot) {
      print(productStockInwardSnapshot);
      if (productStockInwardSnapshot != null &&
          productStockInwardSnapshot.value != null) {
        if(productStockInwardSnapshot.value['stockInwardTillDate'] != null
            && productStockInwardSnapshot.value['recentStockInwardDate'] != null
            && productStockInwardSnapshot.value['recentStockInwardTime'] != null
            && productStockInwardSnapshot.value['recentStockInwardQty'] != null
        )
        {
          recentStockInwardDateForProductCode[productCode] = productStockInwardSnapshot.value['recentStockInwardDate'].toString();
          recentStockInwardTimeForProductCode[productCode] = productStockInwardSnapshot.value['recentStockInwardTime'].toString();
          recentStockInwardQtyForProductCode[productCode] = double.parse(productStockInwardSnapshot.value['recentStockInwardQty'].toString());

          print(recentStockInwardDateForProductCode[productCode]);
          print(recentStockInwardTimeForProductCode[productCode]);
          print(recentStockInwardQtyForProductCode[productCode]);

          if(stockInwardForProductCode[productCode] == null)
          {
            stockInwardForProductCode[productCode] =
                double.parse(productStockInwardSnapshot.value['stockInwardTillDate'].toString());
          }
          stockInwardProcessedCount = stockInwardProcessedCount + 1;

          if(stockInwardProcessedCount == stockInwardProcessCount){
            print('stockInwardForProductCode:');
            print(stockInwardForProductCode);

            setState(() {
              print('Processed all SKUs Successfully');
              retrievingStockInward = false;
            });
          }
        }
      }

    });
  }

  void getProductStockInwardTillDateForProductCodes(List<String> productCodes){
    productCodes.forEach((String productCode)
    {
      print(productCode);
      daysProcessedForProductcode[productCode] = 0;
      totalSaleForSelectedPeriodForProductCode[productCode]= 0;
      averageSaleForSelectedPeriodForProductCode[productCode] = 0;
      getProductStockInwardDetailsForProductCode(productCode);
    }
    );
  }



  @override
  void initState() {
    super.initState();
    retrievingStockInward = true;
    retrievingStockOutward = true;
//    print(selectedCategory);
//
//    barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
//    lookupMap = Map<int,ProductBasicDetails>();
//
//    activeProductBasicDetailsList.forEach((element) {
//      if(element.productCategory == selectedCategory)
//        {
//          barCodeSearchResultsMap[element.productID] = element;
//          lookupMap[element.productID] = element;
//        }
//    });
//
    barCodeSearchResults = List<ProductBasicDetails>();
//    lookupList = List<ProductBasicDetails>();
//
    List<String> productCodes = List<String>();
    barCodeSearchResultsMap.forEach((key, value) {
      print(value);
      productCodes.add(key.toString());
      barCodeSearchResults.add(value);
    });
    print(productCodes);
    print(barCodeSearchResultsMap);
    print(barCodeSearchResults);

    barCodeSearchResults.sort((a,b){
                                    return (
                                        a.productName.compareTo(b.productName)
                                    );
                                  });

    storeTerminals = ['POS_2','POS_11'];

    terminalsProcessed = 0;
    terminalCount = storeTerminals.length;
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

    stockInwardProcessCount = 0;
    stockInwardProcessedCount = 0;
    salePositionForProductCode = Map<String, double>();
    stockInwardForProductCode = Map<String, double>();


    if(productCodes.length != 0) {
      dayCount = 1;
      processCount = dayCount * productCodes.length * terminalCount;
      stockInwardProcessCount = dayCount * productCodes.length;
      print('Process Count:' + processCount.toString());
      setState(() {
        print('Day Count:' + dayCount.toString());
        retrievingStockOutward = true;
        retrievingStockInward = true;
      });
      getProductStockInwardTillDateForProductCodes(productCodes);

      storeTerminals.forEach((terminalElement) {
        print(terminalElement);
        getProductStockOutwardTillDateForProductCodes(
            productCodes, terminalElement);
      });
    }
  }

  Widget onTapImage(BuildContext context, String imageUrl) {
    return Center(child: Image.network(imageUrl));
  }

  @override
  Widget build(BuildContext context) {
    if(retrievingStockInward && retrievingStockOutward)
      {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
//            Navigator.push<dynamic>(context,
//                MaterialPageRoute<dynamic>(builder: (BuildContext context) {
//                  return StoreHomeCategories();
//                }));
              },
            ),
            title: Center(
              child: Text(
                selectedCategory,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            actions: <Widget>[
              //Adding the search widget in AppBar
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: () {


//              barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
//              lookupMap = Map<int,ProductBasicDetails>();
//              barCodeSearchResultsMap = activeProductBasicDetailsMap;
//              lookupMap = activeProductBasicDetailsMap;
                  barCodeSearchResults = List<ProductBasicDetails>();
                  lookupList = List<ProductBasicDetails>();

                  barCodeSearchResultsMap.forEach((key, value) {
                    barCodeSearchResults.add(value);
                    lookupList.add(value);
                  });
//              barCodeSearchResults.sort((a,b){
//                return (
//                    a.productName.compareTo(b.productName)
//                );
//              });
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context){
                            return StockInwardProductNameLookUp();
                          }
                      )
                  );

//              barCodeSearchResults = categoryProducts;
//              barCodeSearchResults.sort((a,b){
//                return (
//                    a.productName.compareTo(b.productName)
//                );
//              });
//              lookupList = categoryProducts;
//              Navigator.of(context).pop();
//              Navigator.of(context).push<dynamic>(
//                  MaterialPageRoute<dynamic>(
//                      builder: (BuildContext context){
//                        return StockInwardProductNameLookUp();
//                      }
//                  )
//              );
//              Navigator.of(context).pop();
//              Navigator.of(context).push<dynamic>(
//                  MaterialPageRoute<dynamic>(
//                      builder:(BuildContext context){
//                        return CategoryPageStringSearchResults();
//                      }
//                  )
//              );
                },
              ),
            ],
          ),
          body:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              LinearProgressIndicator(),
              Text('Retrieving stock details.....')
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.blue,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket, color: Colors.white),
                title: Text(
//                'Products:' +
                  productCount.toString() + '/' +
//                    '\n' +
//                    'Items:' +
                      itemCount.toString(),
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                title: Text(
                  '\u20B9' + cartTotal.toString() + '/-',
//                    + '\n' + 'CHECKOUT',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 1:
                  if (cartTotal > 0) {
                    CircularProgressIndicator();
                    Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) {
                      return StockInwardShowCartProducts();
                    }));
                  }
                  break;
                case 0:
                  if (cartTotal > 0) {
                    CircularProgressIndicator();
                    Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) {
                      return StockInwardShowCartProducts();
                    }));
                  }
                  break;
              }
            },
          ),

        );
      }
    else
      {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
//            Navigator.push<dynamic>(context,
//                MaterialPageRoute<dynamic>(builder: (BuildContext context) {
//                  return StoreHomeCategories();
//                }));
              },
            ),
            title: Center(
              child: Text(
                selectedCategory,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
            actions: <Widget>[
              //Adding the search widget in AppBar
              IconButton(
                tooltip: 'Search',
                icon: const Icon(Icons.search),
                onPressed: () {

//              barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
//              lookupMap = Map<int,ProductBasicDetails>();
//              barCodeSearchResultsMap = activeProductBasicDetailsMap;
//              lookupMap = activeProductBasicDetailsMap;
                  barCodeSearchResults = List<ProductBasicDetails>();
                  lookupList = List<ProductBasicDetails>();

                  barCodeSearchResultsMap.forEach((key, value) {
                    barCodeSearchResults.add(value);
                    lookupList.add(value);
                  });
//              barCodeSearchResults.sort((a,b){
//                return (
//                    a.productName.compareTo(b.productName)
//                );
//              });
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                      MaterialPageRoute<dynamic>(
                          builder: (BuildContext context){
                            return StockInwardProductNameLookUp();
                          }
                      )
                  );

//              barCodeSearchResults = categoryProducts;
//              barCodeSearchResults.sort((a,b){
//                return (
//                    a.productName.compareTo(b.productName)
//                );
//              });
//              lookupList = categoryProducts;
//              Navigator.of(context).pop();
//              Navigator.of(context).push<dynamic>(
//                  MaterialPageRoute<dynamic>(
//                      builder: (BuildContext context){
//                        return StockInwardProductNameLookUp();
//                      }
//                  )
//              );
//              Navigator.of(context).pop();
//              Navigator.of(context).push<dynamic>(
//                  MaterialPageRoute<dynamic>(
//                      builder:(BuildContext context){
//                        return CategoryPageStringSearchResults();
//                      }
//                  )
//              );
                },
              ),
            ],
          ),
          body: ListView.builder(
              itemCount: barCodeSearchResults.length,
              itemBuilder: (BuildContext context, int index) {
                print(salePositionForProductCode);
                print(barCodeSearchResults[index].productID);
                print(salePositionForProductCode[barCodeSearchResults[index].productID.toString()]);

                var stockOutward = (salePositionForProductCode[barCodeSearchResults[index].productID.toString()] != null?salePositionForProductCode[barCodeSearchResults[index].productID.toString()]:0);
                var stockInward =  (stockInwardForProductCode[barCodeSearchResults[index].productID.toString()] != null?stockInwardForProductCode[barCodeSearchResults[index].productID.toString()]:0);
                var stockPosition = stockInward - stockOutward;



                return GestureDetector(
                  onTap: () {
                    print('Product Selected');
                    skuToUpdate =
                        barCodeSearchResults[index].productID;
                    Future<void> future =  showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return BottomSheet(
                              onClosing: () {
                              },
                              builder: (BuildContext context) {
                                return StockInwardCartOptions(index:index);
//                                        Navigator.of(context).pop();
//                                        return StockInwardProductUpdateOptions();
                              });
                        });
                    future.then((void value) => {
                      setState((){})
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(color: Colors.blueGrey[100])),
                    height: 600,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: Container(
                            //margin: new EdgeInsets.only(left: 46.0),
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: new Color(0xFFFFFFFF),
                              borderRadius:
                              new BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: NetworkImage(
                                    barCodeSearchResults[index]
                                        .productImageURL),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(children: <Widget>[
                            Expanded(
                              flex:4,
                              child: Text(
                                barCodeSearchResults[index]
                                    .productName
                                    .toUpperCase(),
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Text(
                                  "\u20B9" +
                                      barCodeSearchResults[index]
                                          .productPrice
                                          .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat"),
                                ),
                              ),
                            ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text(
                                          barCodeSearchResults[index]
                                                  .productID
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat"),
                                        ),
                                      ),
                                    ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Text(
                                  barCodeSearchResults[index]
                                      .productBarCode
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat"),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Text(
                                  barCodeSearchResults[index]
                                      .productStatus
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat"),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child:Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex:8,
                                      child: Container(
                                        child: Text(
                                          'STOCK POSITION:',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Montserrat",
                                          ),

                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex:2,
                                      child: Container(
                                        child: Text(
                                          stockPosition.toString(),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat"),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            Expanded(
                                flex: 2,
                                child:Row(
                                    children:[
                                      Expanded(
                                        flex:8,
                                        child: Container(
                                          child: Text(
                                            'INWARD TILL DATE:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          child: Text(
                                            (stockInwardForProductCode[barCodeSearchResults[index].productID.toString()] != null?stockInwardForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                            Expanded(
                                flex: 2,
                                child:Row(
                                    children:[
                                      Expanded(
                                        flex:8,
                                        child: Container(
                                          child: Text(
                                            'OUTWARD TILL DATE:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          child: Text(
                                            (salePositionForProductCode[barCodeSearchResults[index].productID.toString()] != null?salePositionForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                            Expanded(
                                flex: 2,
                                child:Row(
                                    children:[
                                      Expanded(
                                        flex:8,
                                        child: Container(
                                          child: Text(
                                            'RECENT INWARD DATE:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          child: Text(
                                            (recentStockInwardDateForProductCode[barCodeSearchResults[index].productID.toString()] != null?recentStockInwardDateForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                            Expanded(
                                flex: 2,
                                child:Row(
                                    children:[
                                      Expanded(
                                        flex:8,
                                        child: Container(
                                          child: Text(
                                            'RECENT INWARD TIME:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          child: Text(
                                            (recentStockInwardTimeForProductCode[barCodeSearchResults[index].productID.toString()] != null?recentStockInwardTimeForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                            Expanded(
                                flex: 2,
                                child:Row(
                                    children:[
                                      Expanded(
                                        flex:8,
                                        child: Container(
                                          child: Text(
                                            'RECENT INWARD QTY:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          child: Text(
                                            (recentStockInwardQtyForProductCode[barCodeSearchResults[index].productID.toString()] != null?recentStockInwardQtyForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                            Expanded(
                                flex: 2,
                                child:Row(
                                    children:[
                                      Expanded(
                                        flex:8,
                                        child: Container(
                                          child: Text(
                                            'RECENT OUTWARD QTY:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          child: Text(
                                            (recentStockOutwardQtyForProductCode[barCodeSearchResults[index].productID.toString()] != null?recentStockOutwardQtyForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                            Expanded(
                                flex: 2,
                                child:Row(
                                    children:[
                                      Expanded(
                                        flex:8,
                                        child: Container(
                                          child: Text(
                                            'RECENT OUTWARD DATE:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          child: Text(
                                            (recentStockOutwardDateForProductCode[barCodeSearchResults[index].productID.toString()] != null?recentStockOutwardDateForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                            Expanded(
                                flex: 2,
                                child:Row(
                                    children:[
                                      Expanded(
                                        flex:8,
                                        child: Container(
                                          child: Text(
                                            'RECENT OUTWARD TIME:',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex:2,
                                        child: Container(
                                          child: Text(
                                            (recentStockOutwardTimeForProductCode[barCodeSearchResults[index].productID.toString()] != null?recentStockOutwardTimeForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Montserrat"),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                    ]
                                )
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.blue,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket, color: Colors.white),
                title: Text(
//                'Products:' +
                  productCount.toString() + '/' +
//                    '\n' +
//                    'Items:' +
                      itemCount.toString(),
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                title: Text(
                  '\u20B9' + cartTotal.toString() + '/-',
//                    + '\n' + 'CHECKOUT',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 1:
                  if (cartTotal > 0) {
                    CircularProgressIndicator();
                    Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) {
                      return StockInwardShowCartProducts();
                    }));
                  }
                  break;
                case 0:
                  if (cartTotal > 0) {
                    CircularProgressIndicator();
                    Navigator.push<dynamic>(context, MaterialPageRoute<dynamic>(builder: (context) {
                      return StockInwardShowCartProducts();
                    }));
                  }
                  break;
              }
            },
          ),

        );
      }
  }
}