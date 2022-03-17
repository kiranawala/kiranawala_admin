import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-category-brand.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-request-price.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-status.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-lookup-image.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-request-name.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-update-discount.dart';

class ProductUpdateOptions extends StatefulWidget {
  @override
  _ProductUpdateOptionsState createState() => _ProductUpdateOptionsState();
}

class _ProductUpdateOptionsState extends State<ProductUpdateOptions> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(skuToUpdate);
    print(barCodeSearchResultsMap.length.toString());
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return ProductLookupResults();
            }
          )
        );
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle:  true,
          title:Text('UPDATE OPTIONS',
            style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize:18.0,
              fontWeight:FontWeight.bold,
              color:Colors.white,
            )
          ),
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ProductLookupResults();
                      }
                  )
              );
            }
          )
        ),
        body: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(8.0),
                width:MediaQuery.of(context).size.width,
                child: Text(
                  barCodeSearchResultsMap[skuToUpdate].productName.toString(),
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                width:MediaQuery.of(context).size.width,
                child: Text(
                  barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                width:MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color:Colors.blue,
                  onPressed:(){
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return ProductUpdateRequestName();
                            }
                        )
                    );
                  },
                  child: Text(
                    'CHANGE NAME',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                width:MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color:Colors.blue,
                  onPressed:(){
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return ProductUpdateRequestPrice();
                            }
                        )
                    );
                  },
                  child: Text(
                    'CHANGE PRICE/CREATE DUPLICATE',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.all(8.0),
              width:MediaQuery.of(context).size.width,
              child: RaisedButton(
                color:Colors.blue,
                onPressed:(){
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ProductUpdateCategoryBrand();
                      }
                    )
                  );
                },
                child: Text(
                  'CHANGE CATEGORY/BRAND',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat"),
                ),
              ),
            ),
        Container(
                padding:EdgeInsets.all(8.0),
                width:MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color:Colors.blue,
                  onPressed:(){
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return ProductUpdateStatus();
                            }
                        )
                    );
                  },


                  child: Text(
                    'CHANGE PRODUCT STATUS IN STORE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),
                  ),
                ),
              ),
              Container(
                padding:EdgeInsets.all(8.0),
                width:MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color:Colors.blue,
                  onPressed:(){
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return InventoryManagerUpdateProductLookupImage();
                            }
                        )
                    );
                  },


                  child: Text(
                    'CHANGE PRODUCT IMAGE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),
                  ),
                ),
              ),
              Container(
                padding:EdgeInsets.all(8.0),
                width:MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color:Colors.blue,
                  onPressed:(){
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return InventoryManagerChangeDiscount();
                            }
                        )
                    );
                  },


                  child: Text(
                    'CHANGE DISCOUNT DETAILS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}