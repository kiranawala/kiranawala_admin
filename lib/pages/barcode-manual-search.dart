import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/update-product-brand.dart';
import 'package:kiranawala_admin/pages/update-product-category.dart';
import 'package:kiranawala_admin/pages/update-product-name.dart';
import 'package:kiranawala_admin/pages/update-product-price.dart';
import 'package:kiranawala_admin/pages/create-duplicate-product.dart';
import 'add-new-product-barcode.dart';

class BarCodeManualSearch extends StatefulWidget {
  @override
  _BarCodeManualEntryState createState() => _BarCodeManualEntryState();
}

class _BarCodeManualEntryState extends State<BarCodeManualSearch> {
  String barCodeSearchMessage = '';
  double productStockPosition = 0.0;
  bool retrievingData = false;


  Future scan() async {
    retrievingData = true;
    try{
        barCodeToSearch = await BarcodeScanner.scan();      
         setState(() {
                                retrievingData = true;  
                              });
                              
                                barCodeSearchResults = [];
                                if (barCodeToSearch.length == 0) 
                                {                           
                                  setState(() {
                                    this.barCodeSearchMessage = 'CANNOT PROCEED WITHOUT BARCODE';
                                  });
                                }
                                else
                                {
                                    FirebaseDatabase
                                      .instance
                                      .reference()
                                      .child('stores')
                                      .child('KIRANAWALA_STORE_2')
                                      .child('products')
                                      .orderByChild('barcode')
                                      .equalTo(barCodeToSearch.toLowerCase())
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
                                          // double productStockPosition = 0.0;

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

                                          barCodeSearchResults.add(new ProductStockPosition(
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
                                        barCodeSearchResults.sort((a,b){
                                                                  return a.productName.compareTo(b.productName);
                                                                });
                                        print(barCodeSearchResults);
                                        print(barCodeSearchResults.length);
                                        setState(() {    
                                          retrievingData = false;                                
                                        });
                                        // Navigator.of(context).pop();                 
                                      }     
                                      else
                                      {
                                        /////BARCODE NOT AVAILABLE IN THE SYSTEM
                                        ///ADD IT TO THE SYSTEM TO PROCEED FURTHER
                                        ///
                                        ///
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                          return AddNewProduct();
                                        }));                                   
                                      }
                              });
                            }         

    } on PlatformException catch(e){
      if(e.code == BarcodeScanner.CameraAccessDenied)
      {
        setState(() {
          barCodeSearchMessage = 'Permission issue';
          print('Permissions issue');
          retrievingData = false;
        });
      }
      else
      {
        setState(() {
          
          retrievingData = false;                
          barCodeSearchMessage = '$e';  
          print('scan cancelled');
        });        
      }
    }
    on FormatException {      
      setState(() {
        retrievingData = false;
        barCodeSearchMessage = 'scan cancelled...';
        print('scan cancelled');
      });
    }
    catch(e){           
      setState(() {
        retrievingData = false;
        barCodeSearchMessage = '$e';
        print(e.toString());
      });
    }
  }

  Widget barcodeManualSearchBar()
  {
    if(retrievingData)
    {
      return 
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
                child: Text("Generating next product code.....")
              ),
            ],
          ),
        ));
    }
    else
    {
      return 
        Row(
          children: <Widget>[
            Expanded(
              flex:2,
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                color: Colors.blue,
                onPressed: scan                
              )
            ),
          Expanded(
          flex:10,
          child: TextField(
          autofocus: true,
          onChanged:(value){
            barCodeToSearch = value;
          },
          // decoration: InputDecoration(
          //           hintText: "ENTER BARCODE HERE",
          //           icon: Icon(Icons.camera_alt),
          //         ),
          keyboardType: TextInputType.number,
          ),
        ),
        Expanded(
          flex:4,
          child: RaisedButton(
            color:Colors.blue,
            child:Text('GO',
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'
                  )
                ),
            onPressed: (){
                              setState(() {
                                retrievingData = true;  
                              });
                              
                                barCodeSearchResults = [];
                                if (barCodeToSearch.length == 0) 
                                {                           
                                  setState(() {
                                    this.barCodeSearchMessage = 'CANNOT PROCEED WITHOUT BARCODE';
                                  });
                                }
                                else
                                {
                                    FirebaseDatabase
                                      .instance
                                      .reference()
                                      .child('stores')
                                      .child('KIRANAWALA_STORE_2')
                                      .child('products')
                                      .orderByChild('barcode')
                                      .equalTo(barCodeToSearch.toLowerCase())
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
                                          // double productStockPosition = 0.0;

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

                                          barCodeSearchResults.add(new ProductStockPosition(
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
                                        barCodeSearchResults.sort((a,b){
                                                                  return a.productName.compareTo(b.productName);
                                                                });
                                        print(barCodeSearchResults);
                                        print(barCodeSearchResults.length);
                                        setState(() {    
                                          retrievingData = false;                                
                                        });
                                        // Navigator.of(context).pop();                 
                                      }     
                                      else
                                      {
                                        /////BARCODE NOT AVAILABLE IN THE SYSTEM
                                        ///ADD IT TO THE SYSTEM TO PROCEED FURTHER
                                        ///
                                        ///
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                          return AddNewProduct();
                                        }));                                   
                                      }
                              });
                            }
            },
          ),
        )
      ],
    );
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text('BarCode Manual Search')),
      body:new Container(        
        child:Column(
          children: <Widget>[
            Expanded(
              flex:2,
              child: barcodeManualSearchBar(),)  ,          
            
          // Expanded(
          //   flex:2,
          //             child: Text(barCodeSearchMessage,
          //   ),
          // ),
          // Expanded(
          //   flex:2,
          //             child: FlatButton(
          //     color:Colors.blue,
          //     onPressed: (){
          //                           barCodeSearchResults = [];
          //                           if (barCodeToSearch.length == 0) {                           
          //                             setState(() {
          //                               this.barCodeSearchMessage = 'CANNOT PROCEED WITHOUT BARCODE';
          //                             });
          //                           }
          //                           else
          //                           {
          //                               FirebaseDatabase
          //                                 .instance
          //                                 .reference()
          //                                 .child('stores')
          //                                 .child('KIRANAWALA_STORE_2')
          //                                 .child('products')
          //                                 .orderByChild('barcode')
          //                                 .equalTo(barCodeToSearch.toLowerCase())
          //                                 .once()
          //                                 .then((DataSnapshot snapshot){
          //                                   print(snapshot.value);
          //                                   if(snapshot != null && snapshot.value != null)
          //                                   {    
          //                                   Map<dynamic, dynamic> productMap = snapshot.value;
          //                                   productMap.forEach((code, product){
          //                                     int productCode = int.parse(code.toString());
          //                                     double productSalePositionTillDate = 0.0;
          //                                     double productInventoryTillDate = 0.0;
          //                                     // double productStockPosition = 0.0;

          //                                     if(productSalePositionTillDateMap[productCode] != null)
          //                                     {
          //                                       productSalePositionTillDate = double.parse(productSalePositionTillDateMap[productCode].toString());
          //                                     }    
          //                                     else
          //                                     {
          //                                       productSalePositionTillDateMap[productCode] = 0.0;
          //                                     }    

          //                                     if(productInventoryTillDateMap[productCode] != null)
          //                                     {
          //                                       productInventoryTillDate = double.parse(productInventoryTillDateMap[productCode].toString());
          //                                     }
          //                                     else
          //                                     {
          //                                       productInventoryTillDateMap[productCode] = 0.0;
          //                                     }

          //                                     productStockPosition = productInventoryTillDate - productSalePositionTillDate;

          //                                     barCodeSearchResults.add(new ProductStockPosition(
          //                                                             product['title'].toString(), 
          //                                                             double.parse(product['price'].toString()), 
          //                                                             int.parse(product['productcode'].toString()), 
          //                                                             product['barcode'].toString(), 
          //                                                             product['imageurl'].toString(), 
          //                                                             product['category'].toString(), 
          //                                                             product['brand'].toString(),
          //                                                             productInventoryTillDate,                                              
          //                                                             productSalePositionTillDate,                                              
          //                                                             double.parse(product['stockposition'].toString()), 
          //                                                           )
          //                                                       );
          //                                   });
          //                                   barCodeSearchResults.sort((a,b){
          //                                                             return a.productName.compareTo(b.productName);
          //                                                           });
          //                                   print(barCodeSearchResults);
          //                                   print(barCodeSearchResults.length);
          //                                   setState(() {    
          //                                     retrievingData = false;                                
          //                                   });
          //                                   // Navigator.of(context).pop();                 
          //                                 }     
          //                                 else
          //                                 {
          //                                   /////BARCODE NOT AVAILABLE IN THE SYSTEM
          //                                   ///ADD IT TO THE SYSTEM TO PROCEED FURTHER
          //                                   ///
          //                                   ///
          //                                   Navigator.of(context).pop();
          //                                   Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          //                                     return AddNewProduct();
          //                                   }));                                   
          //                                 }
          //                         });
          //                       }
          //     },
          //     child: Text('SEARCH BARCODE'),
          //     ),
          // ),
          Expanded(
            flex:2,
            child: Text('Products Found:' + barCodeSearchResults.length.toString() ),),
        Expanded(
          flex:20,
                  child: Container(
            child: 
            ListView.builder(    
              scrollDirection: Axis.vertical,    
              itemCount: barCodeSearchResults.length,
              itemBuilder: (BuildContext context, int index){
                return 
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
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
                                              flex:4,
                                              child: 
                                              FlatButton(
                                                color:Colors.white,
                                                onPressed: (){ 
                                                  productToUpdate = barCodeSearchResults[index];
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
                                                  productToUpdate = barCodeSearchResults[index];
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
                                                  productToDuplicate = barCodeSearchResults[index];   
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
                                                    productToUpdate = barCodeSearchResults[index];
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
                                                    productToUpdate = barCodeSearchResults[index];
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
                                  barCodeSearchResults[index].productName.toString(),
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
                                  'Rs.'+ barCodeSearchResults[index].productPrice.toString() +'/-',
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
                                              barCodeSearchResults[index].productID.toString(),
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
                                              barCodeSearchResults[index].productBarCode.toString(),
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
                                              barCodeSearchResults[index].productCategory,
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
                                              barCodeSearchResults[index].productBrand,
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
                                              barCodeSearchResults[index].productInventoryTillDate.toString(),
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
                                              barCodeSearchResults[index].productSalePositionTillDate.toString(),
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
                                              barCodeSearchResults[index].productStockPosition.toString(),
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
                                  child:Image.network(barCodeSearchResults[index].productImageURL.toString(),
                                        fit: BoxFit.contain,),
                                ),
                              ),                                                                                                                  
                          ])
                      )
                      );
              }
                  )
                  )
                  ) 
          ],
        )
        )
    );
  }
}