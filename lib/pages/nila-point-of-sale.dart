import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:flutter/services.dart';
import 'package:kiranawala_admin/main.dart';

class NilaPointOfSale extends StatefulWidget {
  @override
  _NilaPointOfSaleState createState() => _NilaPointOfSaleState();
}

class _NilaPointOfSaleState extends State<NilaPointOfSale> {

  String barCodeToSearch = '';
  bool retrievingData = false;
  List<ProductStockPosition> barCodeSearchResults = [];
  List<ProductStockPosition> cartProducts = [];

  String barCodeSearchMessage = '';
  double productStockPosition = 0.0;

  double cartTotal = 0.0;
  int productCount = 0;
  double itemCount = 0.0;

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
                                        if(productMap.length == 1)
                                        {
                                          productMap.forEach((code, product){
                                            double productSalePositionTillDate = 0.0;
                                            double productInventoryTillDate = 0.0;
                                            // double productStockPosition = 0.0;

                                            productCount = productCount + 1;
                                            itemCount = itemCount + 1;
                                            cartTotal = cartTotal + double.parse(product['price'].toString());


                                            cartProducts.add(new ProductStockPosition(
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
                                      }
                                      else
                                      {
                                          productMap.forEach((code, product){
                                            // int productCode = int.parse(code.toString());
                                            double productSalePositionTillDate = 0.0;
                                            double productInventoryTillDate = 0.0;
                                            // double productStockPosition = 0.0;

                                            // productCount = productCount + 1;
                                            // itemCount = itemCount + 1;
                                            // cartTotal = cartTotal + double.parse(product['price'].toString());


                                            // if(productSalePositionTillDateMap[productCode] != null)
                                            // {
                                            //   productSalePositionTillDate = double.parse(productSalePositionTillDateMap[productCode].toString());
                                            // }    
                                            // else
                                            // {
                                            //   productSalePositionTillDateMap[productCode] = 0.0;
                                            // }    

                                            // if(productInventoryTillDateMap[productCode] != null)
                                            // {
                                            //   productInventoryTillDate = double.parse(productInventoryTillDateMap[productCode].toString());
                                            // }
                                            // else
                                            // {
                                            //   productInventoryTillDateMap[productCode] = 0.0;
                                            // }

                                            // productStockPosition = productInventoryTillDate - productSalePositionTillDate;

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

                                        showDialog(
                          context: context,
                          builder: (context)
                          {
                              return AlertDialog(
                                  // title: Text('verifyOTP: OTP Verfication Status!!'),
                                  content:    
                                  Container(
                                    height: MediaQuery.of(context).size.height/2,
                                    child:ListView.builder(
                                      itemCount: barCodeSearchResults.length,
                                      itemBuilder:(BuildContext contex, int index){
                                        return ListTile(
                                          onTap: (){                                        
                                            print('Tapped on : ' + barCodeSearchResults[index].productPrice.toString());
                                            productCount = productCount + 1;
                                            itemCount = itemCount + 1;
                                            cartTotal = cartTotal + barCodeSearchResults[index].productPrice;
                                            cartProducts.add(ProductStockPosition(
                                                                      barCodeSearchResults[index].productName.toString(), 
                                                                      double.parse(barCodeSearchResults[index].productPrice.toString()), 
                                                                      int.parse(barCodeSearchResults[index].productID.toString()), 
                                                                      barCodeSearchResults[index].productBarCode, 
                                                                      barCodeSearchResults[index].productImageURL.toString(), 
                                                                      barCodeSearchResults[index].productCategory.toString(), 
                                                                      barCodeSearchResults[index].productBrand.toString(),
                                                                      0.0,                                              
                                                                      0.0,                                              
                                                                      0.0
                                                                    ),
                                                              );
                                                              Navigator.of(context).pop();
                                                              setState(() {
                                                                
                                                              });
                                          },
                                          title: Text(
                                            barCodeSearchResults[index].productPrice.toString()
                                            ),
                                          );
                                        }
                                      ),
                                    ),                                      
                                  actions: <Widget>[
                                    Row(children: <Widget>[                                                             
                                      FlatButton(
                                        child: Text('GO BACK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();                                                
                                        },
                                      ),
                                    ])
                                  ]
                              );
                    },
                  );
                                        

                                      }
                                        // Navigator.of(context).pop();                 
                                      }     
                                      else
                                      {
                                        /////BARCODE NOT AVAILABLE IN THE SYSTEM
                                        ///ADD IT TO THE SYSTEM TO PROCEED FURTHER
                                        ///
                                        ///
                                        Navigator.of(context).pop();
                                        // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                        //   return AddNewProduct();
                                        // }));                                   
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('KIRANAWALA-POS')),
      body:Column(children: <Widget>[
Expanded(
  flex:4,
        child:Center(
          child: FlatButton(
            color:Colors.blue,
            child: Text('Scan Product'),
            onPressed: scan        
          ),
        )      
      ),
      Expanded(
        flex:20,
        child: ListView.builder(
          itemCount: cartProducts.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              leading:Text(index.toString()),
              title:Text(cartProducts[index].productName),
              trailing: Text(cartProducts[index].productPrice.toString()),
            );
          },
        ),
      ),
        Expanded(
        flex:4,
        child: Column(children: <Widget>[
          Row(children: <Widget>[                        
            Expanded(
              flex:2,
              child: Text('PRODUCTS'),
            ),
            Expanded(
              flex:2,
              child: Text('ITEMS'),
            ),
            Expanded(
              flex:2,
              child: Text('TOTAL'),
            ),
          ]),
          Row(children: <Widget>[
            Expanded(
              flex:2,
              child:Text(productCount.toString())
            ),
            Expanded(
              flex:2,
              child:Text(itemCount.toString())              
            ),
            Expanded(
              flex:2,
              child:Text(cartTotal.toString())              
            )
          ],),
          ],),)

        ],
        )
    );        
  }
        
}