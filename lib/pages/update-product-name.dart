import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/barcode-manual-search.dart';

class UpdateProductName extends StatefulWidget {
  @override
  _UpdateProductNameState createState() => _UpdateProductNameState();
}

class _UpdateProductNameState extends State<UpdateProductName> {
  String updatedProductName = '';
  String updatedProductNameHint = 'NEW PRODUCT NAME';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('UPDATE PRODUCT NAME')),
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
              child: Text(productToUpdate.productName)
            ),
            Expanded(
              child: Text(productToUpdate.productPrice.toString())
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: updatedProductNameHint,
                ),
                keyboardType: TextInputType.text,
                autofocus: true,
                onChanged: (value){
                  updatedProductName = value;
                },
              ),
            ),
            Expanded(
              child: RaisedButton(
                color:Colors.blue,
                onPressed: (){
                  if(updatedProductName.length == 0 || updatedProductName == '')
                  {
                    setState(() {
                      updatedProductNameHint = 'INVALID NAME';
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
                        'title':updatedProductName.toString()
                      }).then((value){
                        print('Product Name Updated Successfully!!');
                        productToUpdate.productName = updatedProductName;
                        barCodeSearchResults[productToUpdateIndex] = productToUpdate;
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return BarCodeManualSearch();
                        }));
                      })
                      .catchError((onError){
                        setState(() {
                          updatedProductNameHint='NETWORK ERROR';
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