import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:kiranawala_admin/pages/search-product-by-name.dart';

import 'ask-carry-bag.dart';
import 'show-final-bill.dart';




class NilaPointOfSale extends StatefulWidget {
  @override
  _NilaPointOfSaleState createState() => _NilaPointOfSaleState();
}

class _NilaPointOfSaleState extends State<NilaPointOfSale> {

  String barCodeToSearch = '';
  bool retrievingData = false;
  
  List<ProductStockPosition> barCodeSearchResults = [];
  
  String customerMobileNumber = '';

  String barCodeSearchMessage = '';
  double productStockPosition = 0.0;

  
  String successSoundPath = "barcode-scan-success-short.mp3";
  double price = 0.0;

  int productCode;
  String productName;
  double productPrice;
  String productCategory;
  String productBrand;
  int productBilledQty;
  double productBillAmount;

    Future scan() async {
    retrievingData = true;
    try{
        barCodeToSearch = await BarcodeScanner.scan();    
        AudioCache player = new AudioCache();
        player.play(successSoundPath);
          
        setState(() { retrievingData = true;  });
                              
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

                    addProductToCart(
                      int.parse(product['productcode'].toString()), 
                      product['barcode'].toString(), 
                      product['title'].toString(), 
                      double.parse(product['price'].toString()), 
                      product['category'].toString(), 
                      product['brand'].toString(), 
                      1, 
                      double.parse(product['price'].toString())
                      );


                    
                  });

                setState(() {    
                  retrievingData = false;                                
                });
              }
              else if(productMap.length > 1)
              {
                  productMap.forEach((code, product){                    
                    double productSalePositionTillDate = 0.0;
                    double productInventoryTillDate = 0.0;


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
                                  content:    
                                  Container(
                                    height: MediaQuery.of(context).size.height/2,
                                    child:ListView.builder(
                                      itemCount: barCodeSearchResults.length,
                                      itemBuilder:(BuildContext contex, int index){
                                        return ListTile(
                                          onTap: (){                                        
                                            print('Tapped on : ' + barCodeSearchResults[index].productPrice.toString());
                                            addProductToCart(
                                              int.parse(barCodeSearchResults[index].productID.toString()),
                                              barCodeSearchResults[index].productBarCode,
                                              barCodeSearchResults[index].productName.toString(),
                                              double.parse(barCodeSearchResults[index].productPrice.toString()),
                                              barCodeSearchResults[index].productCategory.toString(),
                                              barCodeSearchResults[index].productBrand.toString(),
                                              1,
                                              double.parse(barCodeSearchResults[index].productPrice.toString()),                                             
                                            );
                                            Navigator.of(context).pop();
                                            setState(() { });
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
                }     
                else
                {
                  showDialog(
                          context: context,
                          builder: (context)
                          {
                              return AlertDialog(                                  
                                  content:   
                                  Column(
                                    children: <Widget>[
                                      Expanded(
                                        child:Text(
                                                barCodeToSearch,
                                                style:TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold
                                                )
                                              ),
                                      ),
                                      Expanded(
                                        child: 
                                          TextField(
                                            autofocus: true,
                                            decoration: InputDecoration(
                                              hintText: 'Product Price',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize:16.0,
                                                fontWeight: FontWeight.bold
                                                )
                                            ),
                                            onChanged: (value){
                                              if(double.parse(value) > 0){
                                                price = double.parse(value);
                                              }
                                            },
                                          )
                                        ),                                                                             
                                    ],
                                  ), 
                                  
                                  actions: <Widget>[
                                    Row(children: <Widget>[                                                             
                                      FlatButton(
                                        child: Text('PROCEED'),
                                        onPressed: () {
                                          if(price > 0)
                                          {                                         

                                            addProductToCart(
                                              int.parse(barCodeToSearch), 
                                              barCodeToSearch, 
                                              barCodeToSearch, 
                                              price, 
                                              'NOCATEGORY', 
                                              'NOBRAND', 
                                              1, 
                                              price
                                              );                                            
                                          }
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                      ),
                                    ])
                                  ]
                              );
                    },
                  );                           
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
      appBar: AppBar(
        title:Text('KIRANAWALA-POS'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.delete,                
              ),
              onPressed: () {
                setState(() {
                  clearCart();  
                });               
              },
            ),
        ],
        
        ),

      body:Column(children: <Widget>[
Expanded(
  flex:4,
        child:Row(
          children: <Widget>[
            Expanded(              
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FlatButton(
                  color:Colors.blue,
                  child: Text('Scan Barcode',
                  style:TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0
                   )
                  ),
                  onPressed: scan        
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FlatButton(
                color:Colors.blue,
                child: Text('Enter Barcode',
                  style:TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0
                   )
                   ),
                onPressed: (){
                  showDialog(
                            context: context,
                            builder: (context)
                            {
                                return AlertDialog(
                                    content:    
                                    Container(
                                      height: 20.0,
                                      child:TextField(
                                        autofocus: true,
                                        onChanged: (value){
                                          if(value.length > 0){
                                            barCodeToSearch = value;
                                          }
                                        },
                                      )
                                      ),                                      
                                    actions: <Widget>[
                                      Row(children: <Widget>[                                                             
                                        FlatButton(
                                          child: Text('PROCEED'),
                                          onPressed: () {

                                            setState(() { retrievingData = true;  
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
                      addProductToCart(
                        int.parse(product['productcode'].toString()), 
                        product['barcode'].toString(),
                        product['title'].toString(), 
                        double.parse(product['price'].toString()), 
                        product['category'].toString(), 
                        product['brand'].toString(), 
                        1, 
                        double.parse(product['price'].toString())
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
                  Navigator.of(context).pop();
                }
                else
                {
                    productMap.forEach((code, product){                      
                      double productSalePositionTillDate = 0.0;
                      double productInventoryTillDate = 0.0;

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
                                              addProductToCart(
                                                int.parse(barCodeSearchResults[index].productID.toString()), 
                                                barCodeSearchResults[index].productBarCode, 
                                                barCodeSearchResults[index].productName.toString(), 
                                                double.parse(barCodeSearchResults[index].productPrice.toString()), 
                                                barCodeSearchResults[index].productCategory.toString(), 
                                                barCodeSearchResults[index].productBrand.toString(), 
                                                1, 
                                                double.parse(barCodeSearchResults[index].productPrice.toString())
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
                  }     
                  else
                  {
                    Navigator.of(context).pop();
                    showDialog(
                            context: context,
                            builder: (context)
                            {
                                return AlertDialog(
                                    title: Text('BARCODE NOT FOUND'),
                                    content:    
                                    Container(
                                      height: 20.0,
                                      child:Column(
                                        children:<Widget>[
                                          Expanded(                                          
                                            child: Text(
                                              barCodeToSearch,
                                              style:TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                               )
                                              ),
                                            ),
                                          Expanded(
                                            child: TextField(
                                              autofocus: true,
                                              onChanged: (value){
                                                if(double.parse(value) > 0){
                                                  price = double.parse(value);
                                                }
                                              },
                                            ),
                                          ),
                                        ]
                                      )
                                    ),                                      
                                    actions: <Widget>[
                                      Row(children: <Widget>[                                                             
                                        FlatButton(
                                          child: Text('PROCEED'),
                                          onPressed: () {
                                            cartProducts.add({
                                                              'productCode':int.parse(barCodeToSearch.toString()), 
                                                              'productBarCode': barCodeToSearch, 
                                                              'productName':barCodeToSearch,
                                                              'productPrice':price,                                                                                                                                             
                                                              'productCategory':'NOCATEGORY', 
                                                              'productBrand':'NOBRAND',
                                                              'productBilledQty':1,                                              
                                                              'productBillAmount':price,                                                                                                                    
                                                            });
                                                          Navigator.of(context).pop();
                                                          setState(() {});
                                          },
                                        ),
                                      ])
                                    ]
                                );
                      },
                    );                    
                  }
        });
      } 
                                          }
                                        )
                                      ])],
                            );
                            });
                            }),
            )
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: FlatButton(
                color:Colors.blue,
                child: Text('Search Name',
                  style:TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0
                   )),
                onPressed: (){
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                      return SearchProductByName();
                  }));
                }),
            )),              
          ],          
        )      
      ),
      Expanded(
        flex:20,
        child: ListView.builder(
          itemCount: cartEntries.length,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(                
                decoration: BoxDecoration(
                  border: Border.all(color:Colors.grey),                  
                  ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex:2,
                      child: Text(
                        (index + 1).toString()
                        )
                      ),
                    Expanded(
                      flex:8,
                      child: Text(
                        cartEntries[index].productName,
                        style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                    Expanded(
                      flex:3,
                      child: Text(
                        cartEntries[index].productPrice.toString(),
                        textAlign: TextAlign.right,
                        style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                        )
                      ),
                    Expanded(
                      flex:2,
                      child: Text(
                        cartEntries[index].productBilledQty.toString(),
                        textAlign: TextAlign.right,
                        style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                        )
                      ),
                    Expanded(
                      flex:3,
                      child: Text(
                        cartEntries[index].productBillAmount.toString(),
                        textAlign: TextAlign.right,
                        style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                        )
                      )
                  ],              
                ),
              ),
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
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  productCount.toString(),
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0
                  ),
                ),
              )
            ),
            Expanded(
              flex:2,
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(itemCount.toString(),
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0
                  ),
                ),
              )              
            ),
            Expanded(
              flex:2,
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cartTotal.toString(),
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0
                  ),
                ),
              )              
            )
          ],),
          Expanded(
            flex: 4,
           child: Container(
             width: MediaQuery.of(context).size.width,
             child: RaisedButton(
               color: Colors.blue,
              child:Text(
                'PROCEED',
                style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color:Colors.white,                  
                )

                ),
              onPressed: (){         
                if(!processingBill)
                {
                  if(cartEntries.length != 0)
                  {
                    processingBill = true;       
                   
                    DateTime now = DateTime.now();
                    String dateString  = DateFormat('yyyy-MM-dd').format(now);
                    selectedSaleStartDate = DateFormat('yyyy-MM-dd').format(now);
                    selectedSaleEndDate = DateFormat('yyyy-MM-dd').format(now);

                    String billYear = dateString.substring(0,4);
                    String billMonth = dateString.substring(5,7);
                    String billDay  = dateString.substring(8,10);
                    String billDate = billDay + billMonth + billYear;
                    print(billDate);                    

                    String billTime = DateFormat('HHmmss').format(DateTime.now()).toString();    
                    String posID = 'MPOS_2';
                    String billID = posID + '_' + billDate + '_' + billTime;
                    print(billID);
                    invoiceEntry = {
                      'billID':billID,
                      'billDate':billDate,
                      'billTime':billTime,
                      'storeID':'NILAS1',
                      'posID':'MPOS_2',
                      'productCount':productCount,
                      'itemCount':itemCount,
                      'billAmount':cartTotal,
                      'paymentType':'CASH',
                      'cardType':'CASH',
                      'billedProducts':cartProducts
                    };

                    processingBill = false;
                    if(!carryBagRequested)
                    {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                        return AskCarryBag();  
                      }));
                    }
                    else
                    {
                      Navigator.of(context).pop();
                       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                        return ShowFinalBill();
                      }));
                    }
                }
                }
              },
              ),
           ),
          ),
          ],),)

        ],
        )
    );        
  }
     
}

void addProductToCart(
                        int productCode, 
                        String productBarCode, 
                        String productName, 
                        double productPrice, 
                        String productCategory, 
                        String productBrand, 
                        double productBilledQty, 
                        double productBillAmount 
                        )
  {
    if(productCodeCartEntryMap.containsKey(productCode))
    {
      CartEntry cartEntry = productCodeCartEntryMap[productCode];
      cartEntry.productBilledQty = cartEntry.productBilledQty + 1;
      cartEntry.productBillAmount = cartEntry.productBillAmount + cartEntry.productPrice;

      productCodeCartEntryMap[productCode] = cartEntry;
      itemCount = itemCount + 1;
      cartTotal = cartTotal + productPrice;

    }
    else
    {
      CartEntry cartEntry = new CartEntry(
                                  productCode,
                                  productBarCode,
                                  productName,
                                  productPrice,
                                  productCategory,
                                  productBrand,
                                  productBilledQty,
                                  productBillAmount
                                  );
      productCodeCartEntryMap[productCode] = cartEntry;
      productCount = productCount + 1;
      itemCount = itemCount + 1;
      cartTotal = cartTotal + productPrice;

      cartEntries.clear();
      productCodeCartEntryMap.forEach((code, entry){
        cartEntries.add(entry);
      });

      // cartProducts.add({
      //                     'productCode':productCode, 
      //                     'productBarCode': productBarCode,
      //                     'productName':productName,
      //                     'productPrice':productPrice,                                                                                                                                             
      //                     'productCategory':productCategory, 
      //                     'productBrand':productBrand,
      //                     'productBilledQty':productBilledQty,                                              
      //                     'productBillAmount':productBillAmount,                                                                                                                    
      //                   });

  }
  }

  void clearCart()
  {
      productCodeCartEntryMap.clear();
      cartEntries.clear();
      cartTotal = 0.0;
      itemCount = 0.0;
      productCount = 0;      
  }  