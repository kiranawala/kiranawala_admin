import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/barcode-manual-search.dart';
import 'package:kiranawala_admin/pages/select-product-brand.dart';

class UpdateProductBrand extends StatefulWidget {
  @override
  _UpdateProductBrandState createState() => _UpdateProductBrandState();
}

class _UpdateProductBrandState extends State<UpdateProductBrand> {
  String updatedProductName = '';
  String updatedProductNameHint = 'NEW PRODUCT CATEGORY';
  @override
  void initState() {
    super.initState();
    selectedBrandName = productToUpdate.productBrand.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('UPDATE PRODUCT BRAND')),
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
              child: Text(productToUpdate.productBrand.toString())
            ),
             Expanded(
              child: Text(productToUpdate.productCategory.toString())
            ),
            Expanded(
              child: Text(selectedBrandName)
            ),
            Expanded(
              child: FlatButton(
                child:Text('Choose Brand'),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                    return SelectProductBrand();
                  }));
                },
              ),
            ),
            Expanded(
              child: RaisedButton(
                color:Colors.blue,
                onPressed: (){               
                    FirebaseDatabase
                      .instance
                      .reference()
                      .child('stores')
                      .child('KIRANAWALA_STORE_2')
                      .child('products')
                      .child(productToUpdate.productID.toString())
                      .update({                        
                        'brand':selectedBrandName.toString()
                      }).then((value){
                        print('Product Brand Updated Successfully!!');
                        productToUpdate.productBrand = selectedBrandName;
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
                },
                child:Text('UPDATE'),
              )
            ),
          ],)
      )      
    );
  }
}