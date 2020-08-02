import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/multi-store-stock-position.dart';
import 'package:kiranawala_admin/pages/search-barcode.dart';
class RequestBarCodeObsolete extends StatefulWidget {
  @override
  _RequestBarCodeObsoleteState createState() => _RequestBarCodeObsoleteState();
}
class _RequestBarCodeObsoleteState extends State<RequestBarCodeObsolete> {
  String barCode = '';
  String productCode = '';
  List<ProductBasicDetails> products = List<ProductBasicDetails>();
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context){
              return SearchBarCode();
            }
          )
        );
        return;
      },
    child:
      Scaffold(
          appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading:IconButton(
                icon:Icon(Icons.keyboard_backspace),
                onPressed: (){
                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
                    return SearchBarCode();
                  }));
                },
              )
          ),
          body:Container(
              width:MediaQuery.of(context).size.width,
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    keyboardType: TextInputType.text,
                    style:TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight:FontWeight.bold,
                      fontSize: 24.0,
                      color:Colors.black,
                    ),
                    autofocus: true,
                    textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    cursorWidth: 8.0,
                    decoration: InputDecoration(
                        hintText: 'BARCODE',
                        hintStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold)),
                    onChanged: (value) {
                      barCode = value;
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                        color:Colors.blue,
                        onPressed:(){
                          FirebaseDatabase
                              .instance
                              .reference()
                              .child('stores')
                              .child('KIRANAWALA_MASTER')
                              .child('products')
                              .orderByChild('barcode')
                              .equalTo(barCode)
                              .once()
                              .then((barCodeSnapshot){
                                if(barCodeSnapshot != null && barCodeSnapshot.value != null)
                                  {
                                    print(barCodeSnapshot.value);
                                    print(barCodeSnapshot.value.length);
                                    if(barCodeSnapshot.value.length >= 1)
                                      {
                                        barCodeSnapshot.value.forEach((dynamic key, dynamic value){
                                          products.add(ProductBasicDetails(
                                            value['title'].toString(),
                                            double.parse(value['price'].toString()),
                                            int.parse(value['productcode'].toString()),
                                            value['barcode'].toString(),
                                            value['imageurl'].toString(),
                                            value['category'].toString(),
                                            value['brand'].toString(),
                                          ));
                                        });
                                      }
                                  }
                                print(products);
                                Navigator.of(context).pop(products);
                          });

                        },
                        child:Text('CONFIRM',
                            style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight:FontWeight.bold,
                              fontSize: 24.0,
                              color:Colors.white,
                            ))
                    ),
                  )
                ],
              )

          )
      ));
  }
}
