import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/add-new-product-no-barcode.dart';
import 'package:kiranawala_admin/pages/barcode-manual-search.dart';

class BarcodeScan extends StatefulWidget {
  @override
  _BarcodeScanState createState() => _BarcodeScanState();
}

class _BarcodeScanState extends State<BarcodeScan> {
  // String barcode = "";  
  bool productsAvailable = false;
  List<Map> fullProductList = [];
  Map productsMap = {};
  String scanStatus = '';
  Map scannedProduct = {};

  int productCode = 0;
  String productName = '';
  String productCategory = '';
  String productBrand = '';
  double productPrice = 0.0;
  double productStockPosition = 0.0;
  String productImageURL = '';
  String productBarcode = '';

  String barcodeMessage = '';
  String searchString = '';

  String updatedStockPosition = '0';
  String receivedStock = '0';
  String updateStockPositionMessage = 'CANNOT BE ZERO';
  String receivedStockMessage = 'CANNOT BE ZERO';

  List<ProductStockPosition> searchResults = new List();
  List<ProductStockPosition> productsForBrand = new List();
  bool retrievingData = false;

  String newProductName = '';
  String newProductNameMessage = '';
  String newProductPrice = '';
  String newProductPriceMessage = '';
  int nextProductCode = 0;

  @override 
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {   
    if(retrievingData)
      return Scaffold(
        appBar: AppBar(
        title:Text('PRODUCT FINDER'),
        centerTitle: true,
      ),
      body: 
      Container(
        color: Colors.white,
        child: Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Getting Products....."),
            ],
          ),
        ),
      )
      );
    else
      return Scaffold(
        appBar: AppBar(
          title:Text('Code Scanner'),
          centerTitle: true,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
            //   Expanded(
            //     flex:2,              
            //     child:Container(
            //       alignment: Alignment.center,
            //       padding: EdgeInsets.all(4.0),
            //       child: RaisedButton(
            //         color:Colors.green,
            //         textColor:Colors.white,
            //         splashColor: Colors.blueGrey,
            //         onPressed: scan,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,                  
            //           children: <Widget>[
            //             Column(
            //               children: <Widget>[
            //                 Text('SCAN BARCODE', style:TextStyle(fontSize:12.0),),
            //               ],
            //             )    
            //         ],),
            //         ),
            //   )
            // ),

////START/////////////////////////////////////////ENTER BARCODE TO SEARCH///////////////////////////////////////////
                Expanded(
                  flex:2,
                  child:Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    child: RaisedButton(
                      color:Colors.green,
                      textColor:Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return BarCodeManualSearch();
                        }));                      
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,                  
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('SEARCH BARCODE', style:TextStyle(fontSize:12.0),),
                            ],
                          )    
                      ],),
                      ),
                  )
                ),
/////FINISH////////////////////////////////////////////ENTER BARCODE TO SEARCH///////////////////////////////////////////
////START////ADD PRODUCT WITH NO BARCODE/////////////////////////////////////////////////////////////////////////////////
                Expanded(
                  flex:2,
                  child:Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(4.0),
                    child: RaisedButton(
                      color:Colors.green,
                      textColor:Colors.white,
                      splashColor: Colors.blueGrey,
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return AddNewProductNoBarcode();
                        }));                      
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,                  
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('ADD PRODUCT WITH NO BARCODE', style:TextStyle(fontSize:12.0),),
                            ],
                          )    
                      ],),
                      ),
                  )
                ),
////FINISH////ADD PRODUCT WITH NO BARCODE////
////START////SEARCH PRODUCT BY NAME////
                Expanded(
                flex:2,
              child:Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(4.0),
                  child: RaisedButton(
                    color:Colors.green,
                    textColor:Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: (){
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: Text('SEARCH STRING'),
                            content: Container(
                              height: MediaQuery.of(context).size.height/2,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex:2,
                                    child: TextField(                            
                                      autofocus: true,
                                      onChanged: (value) {
                                        this.searchString = value;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex:2,
                                      child: Text(barcodeMessage,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 12.0,
                                            color: Colors.blue)),
                                  ),
                                ]
                              ),
                            ),
                            // contentPadding: EdgeInsets.all(10),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Go Back!!',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12.0,
                                        color: Colors.blue)),
                                onPressed: () {                           
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Done'),
                                onPressed: () {
                                  if (searchString.length < 0) {                           
                                    setState(() {
                                      barcodeMessage = 'at least 4 characters please!!';
                                    });
                                  }
                                  else
                                  {
                                    try
                                    {
                                      scanStatus = barCodeToSearch + ' is not in the system';

                                      searchResults = [];

                                      allProducts.forEach((product){
                                        if(product.productName.toLowerCase().contains(searchString.toLowerCase()))
                                        {

                                          int productCode = 0;
                                          double productInventoryTillDate = 0.0;
                                          double productSalePositionTillDate = 0.0;
                                          double productStockPosition = 0.0;
                                          productCode = int.parse(product.productID.toString());
                                          productBarcode = product.productBarCode.toString();
                                          productName = product.productName.toString();                                    
                                          productPrice = double.parse(product.productPrice.toString());                                    
                                          productCategory = product.productCategory.toString();                                    
                                          productBrand = product.productBrand.toString();                                    
                                          productImageURL = product.productImageURL.toString();                                    

                                          if(productSalePositionTillDateMap[productCode] != null)
                                          {
                                            productSalePositionTillDate = double.parse(productSalePositionTillDateMap[productCode].toString());
                                          }        
                                          else
                                          {
                                            productSalePositionTillDateMap[productCode] = 0.0;
                                          }

                                          if(productInventoryTillDateMap[productCode] != null)
                                          {
                                            productInventoryTillDate = double.parse(productInventoryTillDateMap[productCode].toString());
                                          }
                                          else
                                          {
                                            productInventoryTillDateMap[productCode] = 0.0;
                                          }

                                          productStockPosition = productInventoryTillDate - productSalePositionTillDate;

                                          stringSearchResults.add(new ProductStockPosition(
                                              product.productName.toString(), 
                                              double.parse(product.productPrice.toString()), 
                                              int.parse(product.productID.toString()), 
                                              product.productBarCode.toString(), 
                                              product.productImageURL.toString(), 
                                              product.productCategory.toString(), 
                                              product.productBrand.toString(),
                                              productInventoryTillDate,                                              
                                              productSalePositionTillDate,                                              
                                              productStockPosition
                                              // double.parse(product.productStockPosition.toString()), 
                                            )
                                          );
                                        } 
                                      });

                                      if(stringSearchResults.length > 0){
                                        
                                      }
                                      stringSearchResults.sort((a,b){
                                        return a.productName.compareTo(b.productName);
                                      });

                                      print(stringSearchResults);
                                      print(stringSearchResults.length);
                                      setState(() {                                    
                                      });

                                      Navigator.of(context).pop();                                      
                                    } on PlatformException catch(e){
                                        setState(() {
                                          barCodeToSearch = 'Unknown error: $e';  
                                        });                           
                                      }                      
                                      catch(e){
                                        setState(() {
                                          barCodeToSearch = 'Unknown error:$e';
                                        });
                                      }
                                  }
                                })
                            ],
                          );
                        }
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,                  
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text('SEARCH BY NAME', style:TextStyle(fontSize:12.0),),
                          ],
                        )    
                    ],),
                    ),
                )
                ),
////FINISH////SEARCH BY NAME////
                Expanded(
                  flex:24,
                child: new Container(
          child: 
          ListView.builder(    
            scrollDirection: Axis.vertical,    
            itemCount: stringSearchResults.length,
            itemBuilder: (BuildContext context, int index){
              return 
                GestureDetector(
                  onTap:(){
                    {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context)
                                                    {
                                                        return AlertDialog(
                                                            // title: Text('verifyOTP: OTP Verfication Status!!'),
                                                            content:    
                                                            Container(
                                                              height: MediaQuery.of(context).size.height/2,
                                                              child: Column(children: <Widget>[
                                                                Expanded(
                                                                  flex:1,
                                                                  child:Container(
                                                                    child: Row(
                                                                      children: <Widget>[   

                                                                        Expanded(
                                                                          flex:2,
                                                                          child: 
                                                                          Text(
                                                                            'SKU',
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ), 
                                                                        Expanded(
                                                                          flex:4,
                                                                          child: 
                                                                          Text(
                                                                            stringSearchResults[index].productID.toString(),
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ),
                                                                      ]),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child:Container(
                                                                    child: Row(
                                                                      children: <Widget>[   
                                                                        Expanded(
                                                                          flex:2,
                                                                          child: 
                                                                          Text(
                                                                            'BARCODE',
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ), 
                                                                        Expanded(
                                                                          flex:4,
                                                                          child: 
                                                                          Text(
                                                                            stringSearchResults[index].productBarCode.toString(),
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ),
                                                                      ]),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child:Container(
                                                                    child: Row(
                                                                      children: <Widget>[   

                                                                        Expanded(
                                                                          flex:2,
                                                                          child: 
                                                                          Text(
                                                                            'BRAND',
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ), 
                                                                        Expanded(
                                                                          flex:4,
                                                                          child: 
                                                                          FlatButton(
                                                                            color:Colors.white,
                                                                            onPressed: (){
                                                                              retrievingData = true;
                                                                              // getProductStockPositionForBrand(stringSearchResults[index].productCategory.toString());
                                                                            },
                                                                              child: Text(
                                                                              stringSearchResults[index].productBrand.toString(),
                                                                              style:TextStyle(
                                                                                color:Colors.blue,
                                                                                fontFamily: 'Montserrat',
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16.0
                                                                              ),
                                                                            textAlign: TextAlign.left,
                                                                              ),
                                                                          )
                                                                        ),
                                                                      ]),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child:Container(
                                                                    child: Row(
                                                                      children: <Widget>[   
                                                                        Expanded(
                                                                          flex:2,
                                                                          child: 
                                                                          Text(
                                                                            'CATEGORY',
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ), 
                                                                        Expanded(
                                                                          flex:4,
                                                                          child: 
                                                                          FlatButton(
                                                                            color:Colors.white,
                                                                            onPressed: (){
                                                                              retrievingData = true;
                                                                              // getProductStockPositionForCategory(stringSearchResults[index].productCategory.toString());
                                                                            },
                                                                              child: Text(
                                                                              stringSearchResults[index].productCategory.toString(),
                                                                              style:TextStyle(
                                                                                color:Colors.blue,
                                                                                fontFamily: 'Montserrat',
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16.0
                                                                              ),
                                                                            textAlign: TextAlign.left,
                                                                              ),
                                                                          )
                                                                        ),
                                                                      ]),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child:Container(
                                                                    child: Row(
                                                                      children: <Widget>[   

                                                                        Expanded(
                                                                          flex:2,
                                                                          child: 
                                                                          Text(
                                                                            'BOUGHT',
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ), 
                                                                        Expanded(
                                                                          flex:4,
                                                                          child: 
                                                                          Text(
                                                                            stringSearchResults[index].productInventoryTillDate.toString(),
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ),
                                                                      ]),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child:Container(
                                                                    child: Row(
                                                                      children: <Widget>[   

                                                                        Expanded(
                                                                          flex:2,
                                                                          child: 
                                                                          Text(
                                                                            'SOLD',
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ), 
                                                                        Expanded(
                                                                          flex:4,
                                                                          child: 
                                                                          Text(
                                                                            stringSearchResults[index].productSalePositionTillDate.toString(),
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ),
                                                                      ]),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex:1,
                                                                  child:Container(
                                                                    child: Row(
                                                                      children: <Widget>[   

                                                                        Expanded(
                                                                          flex:2,
                                                                          child: 
                                                                          Text(
                                                                            'STOCK',
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 12.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ), 
                                                                        Expanded(
                                                                          flex:4,
                                                                          child: 
                                                                          Text(
                                                                            stringSearchResults[index].productStockPosition.toString(),
                                                                            style:TextStyle(
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16.0
                                                                            ),
                                                                            textAlign: TextAlign.left,
                                                                          )
                                                                        ),
                                                                      ]),
                                                                  )
                                                                ), 
                                                              ]
                                                          ),
                                                            ),
                                                           actions: <Widget>[
                                                             Row(children: <Widget>[                                                             
                                                            FlatButton(
                                                              child: Text('Continue'),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();                                                
                                                              },
                                                            ),
                                                            FlatButton(
                                                            child: Text('Update'),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();   
                                                              ////////////////////////////////////////////////////////////////////////////////  
                                                              //////////////////////////UPDATE STOCK POSITON//////////////////////////////////
                                                              ////////////////////////////////////////////////////////////////////////////////
                                                              showDialog(                                                                
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  builder: (BuildContext context) {
                                                                    return new AlertDialog(
                                                                      title: Text('ENTER STOCK RECEIVED'),
                                                                      content: Container(
                                                                        height: 85,
                                                                        child: Column(children: [
                                                                          TextField(
                                                                            autofocus: true,
                                                                            onChanged: (value) {
                                                                              this.receivedStock = value;
                                                                            },
                                                                          ),
                                                                          Text(receivedStockMessage,
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Montserrat',
                                                                                  fontSize: 12.0,
                                                                                  color: Colors.blue)),
                                                                        ]),
                                                                      ),
                                                                      contentPadding: EdgeInsets.all(10),
                                                                      actions: <Widget>[
                                                                        FlatButton(
                                                                          child: Text('IGNORE',
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Montserrat',
                                                                                  fontSize: 12.0,
                                                                                  color: Colors.blue)),
                                                                          onPressed: () {                           
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                        FlatButton(
                                                                          child: Text('UPDATE'),
                                                                          onPressed: () {
                                                                            // searchResults = [];
                                                                            if (double.parse(receivedStock) < 1) {                           
                                                                              setState(() {
                                                                                barcodeMessage = 'CANNOT PROCEED WITHOUT STOCK POSITION';
                                                                              });
                                                                            }
                                                                            else
                                                                            {

                                                                              try
                                                                              {                                                                                
                                                                                print('Attempting to update product stock position');
                                                                                print(stringSearchResults[index].productID);
                                                                                print(productInventoryTillDateMap[stringSearchResults[index].productID]);
                                                                                print(receivedStock);

                                                                                productInventoryTillDateMap[stringSearchResults[index].productID] = productInventoryTillDateMap[searchResults[index].productID] + double.parse(receivedStock);

                                                                                FirebaseDatabase
                                                                                  .instance
                                                                                  .reference()
                                                                                  .child('stores')
                                                                                  .child('KIRANAWALA_STORE_2')
                                                                                  .child('inventory')
                                                                                  .child(stringSearchResults[index].productID.toString())
                                                                                  .update({'stockPosition':productInventoryTillDateMap[searchResults[index].productID].toString()})                                      
                                                                                  .then((value){
                                                                                    print('stock position updated successfully!!');
                                                                                 
                                                                                    stringSearchResults[index].productStockPosition = productInventoryTillDateMap[searchResults[index].productID];
                                                                                    stringSearchResults[index].productInventoryTillDate = productInventoryTillDateMap[searchResults[index].productID];                                                                                                                                                                         
                                                                                    Navigator.of(context).pop();
                                                                                    ////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                    ///////////////////////////////////STOCK/SALE POSITION UPDATED SUCCESSFULLY/////////////////////////                                                                                    
                                                                                    //////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                  })
                                                                                  .catchError((onError){
                                                                                    print('Stock Position could not be reset!!');  
                                                                                  });
                                                                              }                                                                                                                                                                                     
                                                                              on PlatformException catch(e)
                                                                              {
                                                                                setState(() {
                                                                                  this.updateStockPositionMessage = 'Unknown error: $e';  
                                                                                });                           
                                                                              }                      
                                                                              catch(e){
                                                                                setState(() {
                                                                                  this.updateStockPositionMessage = 'Unknown error:$e';
                                                                                });
                                                                              }
                                                                            }
                                                                          },
                                                                        )
                                                                      ],
                                                                    );
                                                                  }
                                                                );                                                                                             
                                                            },
                                                            ),
                                                            FlatButton(
                                                            child: Text('RESET'),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                  ////////////////////////////////////////////////////////////////////////////////  
                                                  //////////////////////////RESET STOCK POSITON//////////////////////////////////
                                                  ////////////////////////////////////////////////////////////////////////////////
                                                              showDialog(                                                                
                                                                  context: context,
                                                                  barrierDismissible: false,
                                                                  builder: (BuildContext context) {
                                                                    return new AlertDialog(
                                                                      title: Text('ENTER FINAL STOCK POSITION'),
                                                                      content: Container(
                                                                        height: 85,
                                                                        child: Column(children: [
                                                                          TextField(
                                                                            autofocus: true,
                                                                            onChanged: (value) {
                                                                              this.updatedStockPosition = value;
                                                                            },
                                                                          ),
                                                                          Text(updateStockPositionMessage,
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Montserrat',
                                                                                  fontSize: 12.0,
                                                                                  color: Colors.blue)),
                                                                        ]),
                                                                      ),
                                                                      contentPadding: EdgeInsets.all(10),
                                                                      actions: <Widget>[
                                                                        FlatButton(
                                                                          child: Text('IGNORE',
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Montserrat',
                                                                                  fontSize: 12.0,
                                                                                  color: Colors.blue)),
                                                                          onPressed: () {                           
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        ),
                                                                        FlatButton(
                                                                          child: Text('RESET'),
                                                                          onPressed: () {
                                                                            // searchResults = [];
                                                                            if (double.parse(updatedStockPosition) < 1) {                           
                                                                              setState(() {
                                                                                barcodeMessage = 'CANNOT PROCEED WITHOUT STOCK POSITION';
                                                                              });
                                                                            }
                                                                            else
                                                                            {
                                                                              try
                                                                              {
                                                                                scanStatus = barCodeToSearch + ' is not in the system';

                                                                                FirebaseDatabase
                                                                                  .instance
                                                                                  .reference()
                                                                                  .child('stores')
                                                                                  .child('KIRANAWALA_STORE_2')
                                                                                  .child('inventory')
                                                                                  .child(stringSearchResults[index].productID.toString())
                                                                                  .update({'stockPosition':updatedStockPosition})                                      
                                                                                  .then((value){
                                                                                    print('stock position updated successfully!!');

                                                                                    FirebaseDatabase
                                                                                      .instance
                                                                                      .reference()
                                                                                      .child('storeTerminals')
                                                                                      .child('POS_2')
                                                                                      .child('sales')
                                                                                      .child('productSalePosition')
                                                                                      .child(stringSearchResults[index].productID.toString())
                                                                                      .update({'salePosition':0})                                      
                                                                                      .then((value){
                                                                                        stringSearchResults[index].productStockPosition = double.parse(updatedStockPosition);
                                                                                        stringSearchResults[index].productSalePositionTillDate = 0;
                                                                                        stringSearchResults[index].productInventoryTillDate = double.parse(updatedStockPosition);
                                                                                        productSalePositionTillDateMap[stringSearchResults[index].productID] = 0;
                                                                                        productInventoryTillDateMap[stringSearchResults[index].productID] = double.parse(updatedStockPosition);                                                                                          
                                                                                        print('sale position updated successfully!!');
                                                                                        Navigator.of(context).pop();
                                                                                        showDialog(                                                                
                                                                                          context: context,
                                                                                          barrierDismissible: false,
                                                                                          builder: (BuildContext context) {
                                                                                            return new AlertDialog(
                                                                                              title: Text('STOCK POSITION RESET STATUS'),
                                                                                              content: Container(
                                                                                                height: 85,
                                                                                                child: Text(
                                                                                                  'Stock Position Reset Successfully.',
                                                                                                  style: TextStyle(
                                                                                                    fontFamily: 'Montserrat',
                                                                                                    fontSize: 12.0,
                                                                                                    color: Colors.blue
                                                                                                  )
                                                                                                ),
                                                                                              ),
                                                                                              contentPadding: EdgeInsets.all(10),
                                                                                              actions: <Widget>[                                                                      
                                                                                                FlatButton(
                                                                                                  child: Text('CONTINUE'),
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(context).pop();
                                                                                                      }                                                                                                                                                      
                                                                                                )
                                                                                              ],
                                                                                            );
                                                                                          }
                                                                                        );      
                                                                                      });                                                                                    
                                                                                    ////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                    ///////////////////////////////////STOCK/SALE POSITION RESET SUCCESSFULLY/////////////////////////                                                                                    
                                                                                    //////////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                  })
                                                                                  .catchError((onError){
                                                                                    print('Stock Position could not be reset!!');  
                                                                                  });
                                                                              }                                                                                                                                                                                     
                                                                              on PlatformException catch(e)
                                                                              {
                                                                                setState(() {
                                                                                  this.updateStockPositionMessage = 'Unknown error: $e';  
                                                                                });                           
                                                                              }                      
                                                                              catch(e){
                                                                                setState(() {
                                                                                  this.updateStockPositionMessage = 'Unknown error:$e';
                                                                                });
                                                                              }
                                                                            }
                                                                          },
                                                                        )
                                                                      ],
                                                                    );
                                                                  }
                                                                );                                                
                                                            },
                                                          ),
                                                           ]),
                                                          ],
                                                        );
                                                      },
                                                  );
                                      }
                  },

                  child: Container(   
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    height: 400.0,
                        child: Column(children: <Widget>[
                          Expanded(
                            flex:16,                          
                              child: Container(
                                alignment: Alignment.center,
                                width:MediaQuery.of(context).size.width,
                                child:Image.network(stringSearchResults[index].productImageURL.toString(),
                                      fit: BoxFit.contain,),
                              ),
                            ),
                          Expanded(
                            flex:4,
                            child: Container(
                              child: Text(
                                stringSearchResults[index].productName.toString(),
                                textAlign: TextAlign.center,
                                style:TextStyle(
                                  // backgroundColor: Colors.blue,
                                  color:Colors.green,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                                )
                              ),
                            )
                          ),
                          Expanded(
                            flex:2,
                            child: Container(                           
                              child: Text(
                                'Rs.'+ stringSearchResults[index].productPrice.toString() +'/-',
                                style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                                )
                              ),
                            ),
                          ),   
                          Expanded(
                            flex:2,
                            child: Container(                           
                              child: Row(
                                children:<Widget>[
                                  Expanded(
                                    child: Text(
                                            stringSearchResults[index].productID.toString(),
                                            style:TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                  ),
                                  Expanded(
                                    child: Text(
                                            stringSearchResults[index].productBarCode.toString(),
                                            style:TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                  )

                                ]                                
                              ),
                            ),
                          ), 
                          Expanded(
                            flex:2,
                            child: Container(                           
                              child: Row(
                                children:<Widget>[
                                  Expanded(
                                    child: Text(
                                            stringSearchResults[index].productInventoryTillDate.toString(),
                                            style:TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                  ),
                                  Expanded(
                                    child: Text(
                                            stringSearchResults[index].productSalePositionTillDate.toString(),
                                            style:TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                  ),
                                  Expanded(
                                    child: Text(
                                            stringSearchResults[index].productStockPosition.toString(),
                                            style:TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                  )
                                ]                                
                              ),
                            ),
                          ),                                                                                                                     
                        ])
                    ),
                );
                }
              )
            ),
          ),                          
        ]
      )
    )
  );
  
  }

  Future scan() async {
    retrievingData = true;
    searchResults = [];
    try{
      String barcode = await BarcodeScanner.scan();      

      scanStatus = barcode + ' is not in the system';

      FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_STORE_2')
        .child('products')
        .orderByChild('barcode')
        .equalTo(barcode.toLowerCase())
        .once()
        .then((DataSnapshot snapshot){
          print(snapshot.value);
          if(snapshot != null && snapshot.value != null)
          {    
           Map<dynamic, dynamic> productMap = snapshot.value;
          productMap.forEach((code, product){
            int productCode = int.parse(code.toString());
            double productSalePositionTillDate = 0.0;
            double productInventoryTillDate = 0.0;
            double productStockPosition = 0.0;

            if(productSalePositionTillDateMap[productCode] != null)
            {
              productSalePositionTillDate = double.parse(productSalePositionTillDateMap[productCode].toString());
            }        
            else
            {
              productSalePositionTillDateMap[productCode] = 0.0;
            }

            if(productInventoryTillDateMap[productCode] != null)
            {
              productInventoryTillDate = double.parse(productInventoryTillDateMap[productCode].toString());
            }
            else
            {
              productInventoryTillDateMap[productCode] = 0.0;
            }

            productStockPosition = productInventoryTillDate - productSalePositionTillDate;

            searchResults.add(new ProductStockPosition(
                                    product['title'].toString(), 
                                    double.parse(product['price'].toString()), 
                                    int.parse(product['productcode'].toString()), 
                                    product['barcode'].toString(), 
                                    product['imageurl'].toString(), 
                                    product['category'].toString(), 
                                    product['brand'].toString(),
                                    productInventoryTillDate,                                              
                                    productSalePositionTillDate,   
                                    productStockPosition,                                           
                                    // double.parse(product['stockposition'])
                                  )
                              );
          });
          searchResults.sort((a,b){
                                    return a.productName.compareTo(b.productName);
                                  });
          print(searchResults);
          print(searchResults.length);
          setState(() {    
            retrievingData = false;                                
          });
        }                                          
      });
    } on PlatformException catch(e){
      if(e.code == BarcodeScanner.CameraAccessDenied)
      {
        setState(() {
          barCodeToSearch = 'Camera Permission not granted';
        });
      }
      else
      {
        setState(() {
          barCodeToSearch = 'Unknown error: $e';  
        });        
      }
    }
    on FormatException {
      setState(() {
        barCodeToSearch = 'null (User returned using the back button before scanning anything. Result)';
      });
    }
    catch(e){
      setState(() {
        barCodeToSearch = 'Unknown error:$e';
      });
    }
  }
}