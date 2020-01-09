import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/barcode-manual-search.dart';
import 'package:kiranawala_admin/pages/select-product-category.dart';

class UpdateProductCategory extends StatefulWidget {
  @override
  _UpdateProductCategoryState createState() => _UpdateProductCategoryState();
}

class _UpdateProductCategoryState extends State<UpdateProductCategory> {
  String updatedProductName = '';
  String updatedProductNameHint = 'NEW PRODUCT CATEGORY';
  @override
  void initState() {
    super.initState();
    selectedCategoryName = productToUpdate.productCategory.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('UPDATE PRODUCT CATEGORY')),
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
              child: Text(selectedCategoryName)
            ),
            Expanded(
              child: FlatButton(
                child:Text('Choose Category'),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                    return SelectProductCategory();
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
                        'category':selectedCategoryName.toString()
                      }).then((value){
                        print('Product Category Updated Successfully!!');
                        productToUpdate.productCategory = selectedCategoryName;
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