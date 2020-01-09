import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/barcode-manual-search.dart';

class UpdateProductPrice extends StatefulWidget {
  @override
  _UpdateProductPriceState createState() => _UpdateProductPriceState();
}

class _UpdateProductPriceState extends State<UpdateProductPrice> {
  String updatedProductPrice = '';
  String updatedProductPriceHint = 'NEW PRODUCT PRICE';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('UPDATE PRODUCT PRICE')),
      body: Container(
        alignment: Alignment.center,
        child:Column(
          children: <Widget>[
            Expanded(
              child: Text(productToUpdate.productID.toString())
            ),
            Expanded(
              child: Text(productToUpdate.productBarCode)
            ),
            Expanded(
              child: Text(productToUpdate.productPrice.toString())
            ),
            Expanded(
              child: Text(productToUpdate.productPrice.toString())
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: updatedProductPriceHint,
                ),
                keyboardType: TextInputType.text,
                autofocus: true,
                onChanged: (value){
                  updatedProductPrice = value;
                },
              ),
            ),
            Expanded(
              child: RaisedButton(
                color:Colors.blue,
                onPressed: (){
                  if(updatedProductPrice.length == 0 || updatedProductPrice == '')
                  {
                    setState(() {
                      updatedProductPriceHint = 'INVALID Price';
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
                      .child(productToUpdate.productID.toString())
                      .update({                        
                        'price':updatedProductPrice.toString()
                      }).then((value){
                        print('Product Price Updated Successfully!!');
                        productToUpdate.productPrice = double.parse(updatedProductPrice);
                        barCodeSearchResults[productToUpdateIndex] = productToUpdate;
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return BarCodeManualSearch();
                        }));
                      })
                      .catchError((onError){
                        setState(() {
                          updatedProductPriceHint='NETWORK ERROR';
                        });                        
                      });
                  }
                },
                child:Text('UPDATE'),
              )
            ),
          ],)
      )      
    );
  }
}