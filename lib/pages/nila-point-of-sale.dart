import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audio_cache.dart';

class CartEntry {
    int productCode;
    String productBarCode;
    String productName;
    double productPrice;
    String productCategory;
    String productBrand;
    double productBilledQty;
    double productBillAmount;

    CartEntry(
      int productcode, 
      String productbarcode, 
      String productname,
      double productprice,
      String productcategory,
      String productbrand,
      double productbilledqty,
      double productbillamount ){
        this.productCode = productcode;
        this.productBarCode = productbarcode;
        this.productName = productname;
        this.productPrice = productprice;
        this.productCategory = productcategory;
        this.productBrand = productbrand;
        this.productBilledQty = productbilledqty;
        this.productBillAmount = productbillamount;
    }
}

class InvoiceEntry {
    String billID;
    String billDate;
    String billTime;
    String storeID;
    String posID;
    int productCount;
    double itemCount;
    double billAmount;
    List<CartEntry> billedProducts;
    String paymentType;
    String cardType;
    InvoiceEntry(
                String billID,
                String billdate,
                String billtime,
                String storeid,
                String posid,
                int productcount,
                double itemcount,
                double billamount,
                String paymentType,
                String cardType,
                List<CartEntry> billedProducts)
                {
                    this.billID = billID;
                    this.billDate = billdate;
                    this.billTime = billtime;
                    this.storeID = storeid;
                    this.posID = posid;
                    this.productCount = productcount;
                    this.itemCount = itemcount;
                    this.billAmount = billamount;
                    this.billedProducts = billedProducts;
                    this.paymentType = paymentType;
                    this.cardType = cardType;
                }
}


class NilaPointOfSale extends StatefulWidget {
  @override
  _NilaPointOfSaleState createState() => _NilaPointOfSaleState();
}

class _NilaPointOfSaleState extends State<NilaPointOfSale> {

  String barCodeToSearch = '';
  bool retrievingData = false;
  bool processingBill = false;
  List<ProductStockPosition> barCodeSearchResults = [];
  List<dynamic> cartProducts = [];

  String barCodeSearchMessage = '';
  double productStockPosition = 0.0;

  double cartTotal = 0.0;
  int productCount = 0;
  double itemCount = 0.0;
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
                    double productSalePositionTillDate = 0.0;
                    double productInventoryTillDate = 0.0;
                    // double productStockPosition = 0.0;

                    productCount = productCount + 1;
                    itemCount = itemCount + 1;
                    cartTotal = cartTotal + double.parse(product['price'].toString());


                    cartProducts.add({
                                      'productCode':int.parse(product['productcode'].toString()),
                                      'productBarCode':product['barcode'].toString(),
                                      'productName':product['title'].toString(), 
                                      'productPrice':product['price'].toString(), 
                                      'productCategory':product['category'].toString(), 
                                      'productBrand':product['brand'].toString(),
                                      'productBilledQty':"1",
                                      'productBillAmount':product['price'].toString() 
                                    }
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
                                            cartProducts.add({
                                                              'productCode': int.parse(barCodeSearchResults[index].productID.toString()), 
                                                              'productBarCode': barCodeSearchResults[index].productBarCode, 
                                                              'productName': barCodeSearchResults[index].productName.toString(), 
                                                              'productPrice': barCodeSearchResults[index].productPrice.toString(),                                                                       
                                                              'productCategory':barCodeSearchResults[index].productCategory.toString(), 
                                                              'productBrand':barCodeSearchResults[index].productBrand.toString(),
                                                              'productBilledQty':"1",
                                                              'productBillAmount':barCodeSearchResults[index].productPrice.toString()
                                                            });
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
                  showDialog(
                          context: context,
                          builder: (context)
                          {
                              return AlertDialog(
                                  // title: Text('verifyOTP: OTP Verfication Status!!'),
                                  content:    
                                  Container(
                                    height: 20.0,
                                    child:TextField(
                                      autofocus: true,
                                      onChanged: (value){
                                        if(double.parse(value) > 0){
                                          price = double.parse(value);
                                        }
                                      },
                                    )
                                    ),                                      
                                  actions: <Widget>[
                                    Row(children: <Widget>[                                                             
                                      FlatButton(
                                        child: Text('PROCEED'),
                                        onPressed: () {
                                           productCount = productCount + 1;
                                          itemCount = itemCount + 1;
                                          cartTotal = cartTotal + price;

                                          cartProducts.add({
                                                            'productCode':barCodeToSearch, 
                                                            'productBarCode':barCodeToSearch,
                                                            'productName':barCodeToSearch,                                                                      
                                                            'productPrice':price.toString(),                                                                       
                                                            'productCategory':'NOCATEGORY', 
                                                            'productBrand':'NOBRAND',
                                                            'productBilledQty':"1",
                                                            'productBillAmount':price.toString() 
                                                          });
                                                              Navigator.of(context).pop();
                                                              setState(() {
                                                                
                                                              });
                                        },
                                      ),
                                    ])
                                  ]
                              );
                    },
                  );
                  // Navigator.of(context).pop();
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
        child:Row(
          children: <Widget>[
            Expanded(              
              child: FlatButton(
                color:Colors.blue,
                child: Text('Scan Barcode'),
                onPressed: scan        
              ),
            ),
          Expanded(
            child: FlatButton(
              color:Colors.blue,
              child: Text('Enter Barcode'),
              onPressed: (){
                showDialog(
                          context: context,
                          builder: (context)
                          {
                              return AlertDialog(
                                  // title: Text('verifyOTP: OTP Verfication Status!!'),
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
                    double productSalePositionTillDate = 0.0;
                    double productInventoryTillDate = 0.0;
                    // double productStockPosition = 0.0;

                    productCount = productCount + 1;
                    itemCount = itemCount + 1;
                    cartTotal = cartTotal + double.parse(product['price'].toString());


                    cartProducts.add({
                                      'productCode':int.parse(product['productcode'].toString()), 
                                      'productBarCode':product['barcode'].toString(), 
                                      'productName':      product['title'].toString(), 
                                      'productPrice':double.parse(product['price'].toString()), 
                                      'productCategory':product['category'].toString(), 
                                      'productBrand':product['brand'].toString(),
                                      'productBilledQty':1,
                                      'productBillAmount':double.parse(product['price'].toString()),                                             
                                    });
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
                                            cartProducts.add({
                                                              'productCode':int.parse(barCodeSearchResults[index].productID.toString()),       
                                                              'productBarCode':barCodeSearchResults[index].productBarCode, 
                                                              'productName':barCodeSearchResults[index].productName.toString(), 
                                                              'productPrice':double.parse(barCodeSearchResults[index].productPrice.toString()),                                                                                                                                             
                                                              'productCategory':barCodeSearchResults[index].productCategory.toString(), 
                                                              'productBrand':barCodeSearchResults[index].productBrand.toString(),
                                                              'productBilledQty':1,                                              
                                                              'productBillAmount':double.parse(barCodeSearchResults[index].productPrice.toString()),
                                                              });
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
                                           productCount = productCount + 1;
                                          itemCount = itemCount + 1;
                                          cartTotal = cartTotal + price;

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
                                                              setState(() {
                                                                
                                                              });
                                        },
                                      ),
                                    ])
                                  ]
                              );
                    },
                  );
                  // Navigator.of(context).pop();
                  // Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                  //   return AddNewProduct();
                  // }));                                   
                }
        });
      } 
                                        }
                                      )
                                    ])],
                          );
                          });
                          })
            ),
          Expanded(
            child: FlatButton(
              color:Colors.blue,
              child: Text('Search Name'),
              onPressed: scan        
            ),
          ),
          ],
          
        )      
      ),
      Expanded(
        flex:20,
        child: ListView.builder(
          itemCount: cartProducts.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              leading:Text(index.toString()),
              title:Text(cartProducts[index]['productName']),
              trailing: Text(cartProducts[index]['productPrice'].toString()),
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
          Row(children: <Widget>[
            Expanded(
             child: RaisedButton(
              child:Text('SAVE BILL'),
              onPressed: (){         
                if(!processingBill)
                {
                  if(cartProducts.length != 0)
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

                    //                     this.dateString = new Date().toDateString();
                    // this.billMonth = this.dateString.slice(4,7);
                    // this.billDay = this.dateString.slice(8,10);
                    // this.billYear = this.dateString.slice(11,15);
                    // var billMonthNumber = month_names[this.billMonth.toUpperCase()];
                    // this.billDate = this.billDay+billMonthNumber+this.billYear;

                    String billTime = DateFormat('HHmmss').format(DateTime.now()).toString();    
                    String posID = 'MPOS_2';
                    String billID = posID + '_' + billDate + '_' + billTime;
                    print(billID);
                    var invoiceEntry = {
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

                    FirebaseDatabase
                      .instance
                      .reference()
                      .child('storeTerminals')
                      .child('MPOS_2')
                      .child('sales')
                      .child(billYear)
                      .child(billMonth)
                      .child(billDay)
                      .child('bills')
                      .child(billID)
                      .update(invoiceEntry);
                  // .update({
                  //   'billAmount':cartTotal.toString(),
                  //   'billDate':billDate,
                  //   'billTime':billTime,
                  //   'billID':billID,
                  //   'posID':posID,
                  //   'itemCount':itemCount.toString(),
                  //   'productCount':productCount.toString(),
                  //   'storeID':'NILAS_1',
                  //   'cardType':'CASH',
                  //   'paymentType':'CASH',
                  //   'billedProducts':cartProducts
                  // });

                  FirebaseDatabase
                  .instance
                  .reference()
                  .child('storeTerminals')
                  .child('MPOS_2')
                  .child('sales')
                  .child(billYear)
                  .child(billMonth)
                  .child(billDay)
                  .child('totalSale')
                  .once()
                  .then((snapshot){
                    double totalSale = 0.0;
                    if(snapshot != null && snapshot.value != null)
                    {
                      print(snapshot.value.toString());
                      totalSale = double.parse(snapshot.value.toString());
                      print('Total Sale Before:' + totalSale.toString());
                    }
                    
                    double updatedTotalSale = totalSale + invoiceEntry['billAmount'];  
                    print('Updated Sale:' + updatedTotalSale.toString());

                    FirebaseDatabase
                      .instance
                      .reference()
                      .child('storeTerminals')
                      .child('MPOS_2')
                      .child('sales')
                      .child(billYear)
                      .child(billMonth)
                      .child(billDay)
                      .update({
                        'totalSale': updatedTotalSale
                        });
    //             String billHour = timeString.substring(0,2);
    //             String billMinutes = timeString.substring(2,4);
    //             String billSeconds = timeString. substring(4,6);  



    // this.timeString = new Date().toTimeString();
    // this.billHour = this.timeString.slice(0,2);
    // this.billMinute =  this.timeString.slice(3,5);
    // this.billSecond = this.timeString.slice(6,8);
    // this.billTime = this.billHour+this.billMinute+this.billSecond;

    // this.posID = localStorage.getItem('firebasePOSId');
    // this.billID = this.posID +'_'+this.billDate;                  
                });

                cartProducts.clear();
                cartTotal = 0.0;
                itemCount = 0.0;
                productCount = 0;
                setState(() {
                 processingBill = false; 
                });
                }
                }
              },
              ),
            ),
          ],),
          ],),)

        ],
        )
    );        
  }
        
}