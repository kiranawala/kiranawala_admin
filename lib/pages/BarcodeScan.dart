import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/add-new-product-no-barcode.dart';
import 'package:kiranawala_admin/pages/barcode-manual-search.dart';
import 'package:kiranawala_admin/pages/create-duplicate-product.dart';
import 'package:kiranawala_admin/pages/update-product-brand.dart';
import 'package:kiranawala_admin/pages/update-product-category.dart';
import 'package:kiranawala_admin/pages/update-product-name.dart';
import 'package:kiranawala_admin/pages/update-product-price.dart';

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


  generateBarCode(String code)
  {  
    int checkSum = this.checkSum(code);
    return code + '' + checkSum.toString();
  }

  int checkSum(String productCode)
  {

    int sum = 0;

        int N1 = int.parse(productCode.substring(0,1));
        int N2 = int.parse(productCode.substring(1,2));
        int N3 = int.parse(productCode.substring(2,3));
        int N4 = int.parse(productCode.substring(3,4));
        int N5 = int.parse(productCode.substring(4,5));
        int N6 = int.parse(productCode.substring(5,6));
        int N7 = int.parse(productCode.substring(6,7));
        int N8 = int.parse(productCode.substring(7,8));
        int N9 = int.parse(productCode.substring(8,9));
        int N10 = int.parse(productCode.substring(9,10));
        int N11= int.parse(productCode.substring(10,11));
        int N12= int.parse(productCode.substring(11,12));

        sum = N1 + N2*3 + N3 + N4*3 + N5 + N6*3 + N7 + N8*3 + N9 + N10*3 + N11 + N12*3;

        double div = (sum * 1.0)/10;
        int ceilDiv = div.ceil();
        int checkSum = (ceilDiv * 10) - sum;        
        return checkSum;
}

  void getProductStockPositionForCategory(String category)
  {
    searchResults = [];
    FirebaseDatabase
      .instance
      .reference()
      .child('stores/KIRANAWALA_STORE_2')
      .child('products')
      .orderByChild('category')      
      .equalTo(category)
      .once()
      .then((snapshot){
        if(snapshot != null && snapshot.value != null)
        {
          print(snapshot.value);
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

            if(productInventoryTillDateMap[productCode] != null)
            {
              productInventoryTillDate = double.parse(productInventoryTillDateMap[productCode].toString());
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
                                    double.parse(product['stockPosition'].toString()), 
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
  }

  void getProductStockPositionForBrand(String brand)
  {
    searchResults = [];
    FirebaseDatabase
      .instance
      .reference()
      .child('stores/KIRANAWALA_STORE_2')
      .child('products')
      .orderByChild('brand')      
      .equalTo(brand)
      .once()
      .then((snapshot){
        if(snapshot != null && snapshot.value != null)
        {
          print(snapshot.value);
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
                                    double.parse(product['stockposition'].toString()),
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
  }

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
                                  content:    
                                  Container(
                                    height: MediaQuery.of(context).size.height/2,
                                    child: Column(children: <Widget>[
                                            Expanded(
                                              flex:4,
                                              child: 
                                              FlatButton(
                                                color:Colors.white,
                                                onPressed: (){ 
                                                  productToUpdate = stringSearchResults[index];
                                                  productToUpdateIndex = index;
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                                    return UpdateProductName();
                                                  }));                                                                                                                                                         
                                                },
                                                  child: Text(
                                                  'CHANGE NAME',
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
                                              Expanded(
                                              flex:4,
                                              child: 
                                              FlatButton(
                                                color:Colors.white,
                                                onPressed: (){                                                                                                                  productToUpdate = barCodeSearchResults[index];
                                                  productToUpdate = stringSearchResults[index];
                                                  productToUpdateIndex = index;   
                                                  Navigator.of(context).pop();
                                                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                                    return UpdateProductPrice();
                                                  }));                                                                                                                                                        
                                                },
                                                  child: Text(
                                                  'CHANGE PRICE',
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
                                               Expanded(
                                              flex:4,
                                              child: 
                                              FlatButton(
                                                color:Colors.white,
                                                onPressed: (){                                                                                                      productToUpdate = barCodeSearchResults[index];
                                                  productToDuplicate = stringSearchResults[index];   
                                                  Navigator.of(context).pop();
                                                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                                    return CreateDuplicateProduct();
                                                  }));                                                                                                                                                        
                                                },
                                                  child: Text(
                                                  'ADD DUPLICATE',
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
                                              Expanded(
                                                flex:4,
                                                child: 
                                                FlatButton(
                                                  color:Colors.white,
                                                  onPressed: (){ 
                                                    productToUpdate = stringSearchResults[index];
                                                    productToUpdateIndex = index;   
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                                      return UpdateProductBrand();
                                                    }));                                                                                                                                                           
                                                  },
                                                    child: Text(
                                                    'CHANGE BRAND',
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
                                                                                                                      Expanded(
                                                flex:4,
                                                child: 
                                                FlatButton(
                                                  color:Colors.white,
                                                  onPressed: (){    
                                                    productToUpdate = stringSearchResults[index];
                                                    productToUpdateIndex = index;   
                                                    Navigator.of(context).pop();    
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                                      return UpdateProductCategory();
                                                    }));                                                                                                                                                    
                                                  },
                                                    child: Text(
                                                    'CHANGE CATEGORY',
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
                                      ),
                                      
                                  actions: <Widget>[
                                      Row(children: <Widget>[                                                             
                                        FlatButton(
                                          child: Text('GO BACK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();                                                
                                          },
                                        ),
                                        ]
                                      )
                                  ]
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
                                              stringSearchResults[index].productCategory,
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
                                              stringSearchResults[index].productBrand,
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
                              Expanded(
                              flex:16,                          
                                child: Container(
                                  alignment: Alignment.center,
                                  width:MediaQuery.of(context).size.width,
                                  child:Image.network(stringSearchResults[index].productImageURL.toString(),
                                        fit: BoxFit.contain,),
                                ),
                              ),                                                                                                                  
                          ])
                   )
                );
            }),
                )
                ),
          
                            
                                ]                                
                              ),
                            ),                                                                                                                    
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