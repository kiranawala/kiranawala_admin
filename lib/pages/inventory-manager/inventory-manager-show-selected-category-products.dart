import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-name-lookup.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-options.dart';


List<ProductBasicDetails> categoryProducts = List<ProductBasicDetails>();
List<ProductBasicDetails> searchResults = List<ProductBasicDetails>();
int searchResultsIndex = 0;


class InventoryManagerSelectedCategoryProducts extends StatefulWidget {
  @override
  _InventoryManagerSelectedCategoryProductsState createState() =>
      _InventoryManagerSelectedCategoryProductsState();
}

class _InventoryManagerSelectedCategoryProductsState
    extends State<InventoryManagerSelectedCategoryProducts> {
  _InventoryManagerSelectedCategoryProductsState() : super();

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
      getProductStockOutwardTillDateForProductCode(productCode, terminal);
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

  void getProductStockInwardTillDateForProductCodes(List<String> productCodes){
    productCodes.forEach((String productCode)
    {
      print(productCode);
      daysProcessedForProductcode[productCode] = 0;
      totalSaleForSelectedPeriodForProductCode[productCode]= 0;
      averageSaleForSelectedPeriodForProductCode[productCode] = 0;
      getProductStockInwardTillDateForProductCode(productCode);
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
    // parentKey = GlobalKey<_SearchAppBarRecipeState>();
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
                            return InventoryManagerProductNameLookUp();
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
//                        return InventoryManagerProductNameLookUp();
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
          body:Container(
            child:LinearProgressIndicator()
          )
        );
          }
    else
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
                        return InventoryManagerProductNameLookUp();
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
//                        return InventoryManagerProductNameLookUp();
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
//                                        Navigator.of(context).pop();
                                        return InventoryManagerProductUpdateOptions();
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
                            height: 300,
                            child: Row(
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
//                                    Expanded(
//                                      flex: 2,
//                                      child: Container(
//                                        child: Text(
//                                              categoryProducts[index]
//                                                  .productID
//                                                  .toString(),
//                                          style: TextStyle(
//                                              color: Colors.black,
//                                              fontSize: 12.0,
//                                              fontWeight: FontWeight.bold,
//                                              fontFamily: "Montserrat"),
//                                        ),
//                                      ),
//                                    ),
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
                                      child: Container(
                                        child: Text(
                                            (salePositionForProductCode[barCodeSearchResults[index].productID.toString()] != null?salePositionForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
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
                                      child: Container(
                                        child: Text(
                                          (stockInwardForProductCode[barCodeSearchResults[index].productID.toString()] != null?stockInwardForProductCode[barCodeSearchResults[index].productID.toString()].toString():'0'),
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
                                      child: Container(
                                        child: Text(
                                          stockPosition.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Montserrat"),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        );
                      })

    );
  }
}

class ShowCartOptions extends StatefulWidget {
  ShowCartOptions({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _ShowCartOptionsState createState() => _ShowCartOptionsState();
}

class _ShowCartOptionsState extends State<ShowCartOptions> {
  int qtyInCart;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qtyInCart = (cartProductMap.containsKey(
        categoryProducts[widget.index].productID.toString()))
        ? cartProductMap[categoryProducts[widget.index].productID]
        .qtyInCart
        : 0;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[

          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            height: MediaQuery.of(context).size.height/2,
            child: Column(children: <Widget>[
              Expanded(
                flex:2,
                child: Text(
                  categoryProducts[widget.index].productName.toUpperCase(),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "PRICE: \u20B9" +
                      categoryProducts[widget.index].productPrice.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
              Expanded(
                flex:2,
                child: Row(
                  children: <Widget>[

                    Expanded(
                      flex:2,
                      child: Text(
                        "QTY:" + qtyInCart.toString(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat"),
                      ),
                    ),

                    Expanded(
                      flex:2,
                      child: Text(
                        "TOTAL: \u20B9" + (categoryProducts[widget.index].productPrice * qtyInCart).toString(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex:10,
                  child:
                  Center(
                      child: Image.network(categoryProducts[widget.index].productImageURL,
                      )
                  )
              ),


              Expanded(
                flex:4,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  height: 120.0,
                  child: Row(children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Icon(Icons.remove),
                          onPressed: () {
                            CartProduct cartProduct;
                            if (cartProductMap.containsKey(
                                categoryProducts[widget.index].productID.toString())) {
                              cartProduct =
                              cartProductMap[categoryProducts[widget.index].productID];
                              cartProduct.qtyInCart = cartProduct.qtyInCart - 1;
                              itemCount = itemCount - 1;
                              cartTotal = cartTotal - cartProduct.productPrice;
                              if (cartProduct.qtyInCart == 0) {
                                productCount = productCount - 1;
                                cartProductMap.remove(
                                    categoryProducts[widget.index].productID.toString());
                              } else {
                                cartProductMap[categoryProducts[widget.index].productID.toString()] =
                                    cartProduct;
                              }
                              setState(() {
                                qtyInCart = cartProduct.qtyInCart;
                              });
                            }
                            cartProducts.clear();
                            for (int i = 0; i < cartProductMap.length; i++) {
                              cartProducts.add(cartProductMap.values.elementAt(i));
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: RaisedButton(
                              color: Colors.blue,
                              child: Icon(Icons.delete),
                              onPressed: (){
                                CartProduct cartProduct;
                                if (cartProductMap.containsKey(
                                    categoryProducts[widget.index].productID.toString())) {
                                  cartProduct =
                                  cartProductMap[categoryProducts[widget.index].productID];
                                  itemCount = itemCount - cartProduct.qtyInCart;
                                  cartTotal = cartTotal - cartProduct.productPrice * cartProduct.qtyInCart;
                                  cartProduct.qtyInCart = 0;
                                  productCount = productCount - 1;
                                  cartProductMap.remove(
                                      categoryProducts[widget.index].productID.toString());
                                  setState(() {
                                    qtyInCart = cartProduct.qtyInCart;
                                  });
                                }

                                cartProducts.clear();
                                for (int i = 0; i < cartProductMap.length; i++) {
                                  cartProducts.add(cartProductMap.values.elementAt(i));
                                }

                              },
                            )
                        )
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: RaisedButton(
                          color: Colors.blue,
                          child: Icon(Icons.add),
                          onPressed: () {
                            CartProduct cartProduct;
                            if (cartProductMap.containsKey(
                                categoryProducts[widget.index].productID.toString())) {
                              cartProduct =
                              cartProductMap[categoryProducts[widget.index].productID];
                              cartProduct.qtyInCart = cartProduct.qtyInCart + 1;
                              itemCount = itemCount + 1;
                              cartTotal = cartTotal + cartProduct.productPrice;
                              cartProductMap[categoryProducts[widget.index].productID.toString()] =
                                  cartProduct;
                              setState(() {
                                qtyInCart = cartProduct.qtyInCart;
                              });
                            } else {
                              setState(() {
                                qtyInCart = 1;
                              });
                              productCount = productCount + 1;
                              itemCount = itemCount + 1;
                              cartProduct = CartProduct(
                                  categoryProducts[widget.index].productName.toString(),
                                  categoryProducts[widget.index].productID.toString(),
                                  categoryProducts[widget.index].productBarCode.toString(),
                                  categoryProducts[widget.index].productPrice,
                                  categoryProducts[widget.index].productImageURL,
                                  1);
                              cartTotal = cartTotal + cartProduct.productPrice;
                              cartProductMap[categoryProducts[widget.index]
                                  .productID
                                  .toString()] = cartProduct;
                            }
                            cartProducts.clear();
                            for (int i = 0; i < cartProductMap.length; i++) {
                              cartProducts.add(cartProductMap.values.elementAt(i));
                            }
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Expanded(
                flex:2,
                child:
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: RaisedButton(
                    color:Colors.blue,
                    child:Center(
                      child:Text('DONE',
                          style:TextStyle(
                            fontSize:20.0,
                            fontFamily:'Montserrat',
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    onPressed: () => {
                      Navigator.of(context).pop()
                    },
                  ),
                ),
              )

            ]),
          ),


        ],
      ),
    );
  }
}