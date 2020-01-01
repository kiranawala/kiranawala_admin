import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarcodeEntry extends StatefulWidget {
  @override
  _BarcodeEntryState createState() => _BarcodeEntryState();
}

class _BarcodeEntryState extends State<BarcodeEntry> {
  String barcode = "";  
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

  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseDatabase
      .instance
      .reference()
      .child('stores')
      .child('KIRANAWALA_STORE_2')
      .child('products')
      .once()
      .then((DataSnapshot snapshot){
        print(snapshot.value);
        if(snapshot != null && snapshot.value != null)
        {         
          productsMap = snapshot.value;          
          productsMap.forEach((key, value){
            fullProductList.add(value);
          });            
          print(fullProductList.length);
          setState(() {
            productsAvailable = true;  
          });
          
        }        
      });
  }

  @override
  Widget build(BuildContext context) {
    if(!productsAvailable)
    return Scaffold(
      appBar: AppBar(
        title:Text('Code Scanner'),
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
              new Text("Loading Products....."),
            ],
          ),
        ),
      ));
    else
    return Scaffold(
      appBar: AppBar(
        title:Text('Code Scanner'),
        centerTitle: true,
      ),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child:RaisedButton(
                color:Colors.green,
                textColor:Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,                  
                  children: <Widget>[
                    // Icon(Icons.scanner,size: 40,),
                    // SizedBox(width: 10,),
                    Column(
                      children: <Widget>[
                        Text('SCAN BARCODE', style:TextStyle(fontSize:20.0),),
                      ],
                    )    
                ],),
                )
              ),
              Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child:RaisedButton(
                color:Colors.green,
                textColor:Colors.white,
                splashColor: Colors.blueGrey,
                onPressed: scan,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,                  
                  children: <Widget>[
                    // Icon(Icons.scanner,size: 40,),
                    // SizedBox(width: 10,),
                    Column(
                      children: <Widget>[
                        Text('ENTER BARCODE', style:TextStyle(fontSize:20.0),),
                      ],
                    )    
                ],),
                )
              ),
              Padding(
                padding:EdgeInsets.symmetric(horizontal: 4.0, vertical:4.0),
                child:
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('SKU :', textAlign: TextAlign.center,),
                        SizedBox(width: 10,),
                        Text(
                          productCode.toString(), 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0
                           ),
                          ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Name :', textAlign: TextAlign.center,),
                        SizedBox(width: 10,),
                        Text(
                          productName, 
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Price :', textAlign: TextAlign.center,),
                        SizedBox(width: 10,),
                        Text(
                          'Rs.' + productPrice.toStringAsFixed(2) + '/-', 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                           ),
                          ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Category :', textAlign: TextAlign.center,),
                        SizedBox(width: 10,),
                        Text(
                          productCategory.toString(), 
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0
                           ),
                          ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Brand :', textAlign: TextAlign.center,),
                        SizedBox(width: 10,),
                        Text(
                          productBrand.toString(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0
                           ), 
                          textAlign: TextAlign.center,),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Stock Position :', textAlign: TextAlign.center,),
                        SizedBox(width: 10,),
                        Text(productStockPosition.toString(),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0
                        ),
                        textAlign: TextAlign.center,),
                      ],
                    ),
                    Container(
                           height: 160.0,
                           child: new Stack(
                             children: <Widget>[
                               new Container(
                                 //margin: new EdgeInsets.only(left: 46.0),
                                 decoration: new BoxDecoration(
                                   shape: BoxShape.rectangle,
                                   color: new Color(0xFFFFFFFF),
                                   borderRadius:
                                       new BorderRadius.circular(8.0),
                                   image: DecorationImage(
                                     image: NetworkImage(
                                         productImageURL),
                                     fit: BoxFit.contain,
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),                    
                ],)
                )
          ],)
      )      
    );
  }

  Future scan() async {
    try{
      String barcode = await BarcodeScanner.scan();
      int productCode = 0;
      String productName = '';
      String productCategory = '';
      String productBrand = '';
      double productPrice = 0.0;
      double productStockPosition = 0.0;
      String productImageURL = '';

      // print(barcode);
      scanStatus = barcode + ' is not in the system';

      fullProductList.forEach((f){  
        // print(f['barcode']);
        if(f['barcode'] == barcode)
        {
          // print(f);
          print(f['productcode']);
          print(f['title']);
          print(f['price']);
          print(f['category']);
          print(f['brand']);
          print(f['stockposition']);
          print(f['imageurl']);



          productCode = int.parse(f['productcode'].toString());
          print('272727901166');
          productName = f['title'].toString();
          print(productName);
          productPrice = double.parse(f['price'].toString());
          print(productPrice);
          productCategory = f['category'].toString();
          print(productCategory);
          productBrand = f['brand'].toString();
          print(productBrand);
          productStockPosition = double.parse(f['stockposition'].toString());
          print(productStockPosition);
          productImageURL = f['imageurl'].toString();
          print(productImageURL);
          // print(f);
          // this.scannedProduct = f;
          scanStatus = barcode + ' is in the system';
          print(scanStatus);

        }
        
      });
    
      setState(() {
        this.barcode = barcode;      
        this.productCode = productCode;
        this.productName = productName;
        this.productPrice = productPrice;
        this.productCategory = productCategory;
        this.productBrand = productBrand;
        this.productImageURL = productImageURL;
        this.productStockPosition = productStockPosition;
      });
    } on PlatformException catch(e){
      if(e.code == BarcodeScanner.CameraAccessDenied)
      {
        setState(() {
          this.barcode = 'Camera Permission not granted';
        });
      }
      else
      {
        setState(() {
          this.barcode = 'Unknown error: $e';  
        });        
      }
    }
    on FormatException {
      setState(() {
        this.barcode = 'null (User returned using the back button before scanning anything. Result)';
      });
    }
    catch(e){
      setState(() {
        this.barcode = 'Unknown error:$e';
      });
    }
  }
}