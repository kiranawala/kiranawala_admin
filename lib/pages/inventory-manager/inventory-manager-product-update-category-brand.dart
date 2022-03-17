import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-update-options.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-select-brand.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-update-product-select-category.dart';

//import '../show-admin-home-page.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

class ProductUpdateCategoryBrand extends StatefulWidget {
  @override
  _ProductUpdateCategoryBrandState createState() => _ProductUpdateCategoryBrandState();
}

class _ProductUpdateCategoryBrandState extends State<ProductUpdateCategoryBrand> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCategory = barCodeSearchResultsMap[skuToUpdate].productCategory;
    selectedBrand = barCodeSearchResultsMap[skuToUpdate].productBrand;
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: (){
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return ProductUpdateOptions();
              }
            )
          );
          return;
        },
        child: Scaffold(appBar:
        AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ProductUpdateOptions();
                      }
                  )
              );
            }
          ),
          title:Text(
              'CHANGE CATEGORY/BRAND',
              style:TextStyle(
                fontFamily: 'Montserrat',
                fontSize:18.0,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
            body:Column(
              crossAxisAlignment:  CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Container(
                    width:MediaQuery.of(context).size.width,
                    child: Text(barCodeSearchResultsMap[skuToUpdate].productName.toString(),
                      maxLines: 3,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
    Container(
    width:MediaQuery.of(context).size.width,
    child: Text('\u20B9 ' + barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
    maxLines: 3,
    style: TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    fontSize: 24.0,
    color: Colors.black,
    ),
        textAlign: TextAlign.center,
    ),
    ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color:Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Column(
                        crossAxisAlignment:  CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
              Container(
                    child:Text('CHANGE CATEGORY',
                        style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:24.0,
                            fontWeight: FontWeight.bold,
                            color:Colors.black
                        )
                    )
              ),
              Row(
                    children:<Widget>[
                      Expanded(
                        flex:2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'FROM',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize:24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              )
                          ),
                        ),
                      ),
                      Expanded(
                        flex:6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              barCodeSearchResultsMap[skuToUpdate].productCategory.toString(),
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize:24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              )
                          ),
                        ),
                      ),
                    ]),
              Row(
                    children:<Widget>[
                      Expanded(
                        flex:2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'TO',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize:24.0,
                                  fontWeight: FontWeight.bold,
                                  color:Colors.black
                              )
                          ),
                        ),
                      ),
                      Expanded(
                        flex:6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              onPressed:(){
                                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                                  return UpdateProductSelectCategory();
                                })).then((dynamic value){
                                  if(value != null)
                                  {
                                    setState(() {
                                      selectedCategory = value.toString();
                                    });
                                  }
                                });
                              },
                              child:
                              Text(
                                  selectedCategory,
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:24.0,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.black
                                  )
                              )
                          ),
                        ),
                      ),
                    ]
              ),
              ]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color:Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    ),
                    child: Column(
                        crossAxisAlignment:  CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:<Widget>[
                          Container(
                              child:Text('CHANGE BRAND',
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:24.0,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.black
                                  )
                              )
                          ),
                          Row(
                              children:<Widget>[
                                Expanded(
                                  flex:2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'FROM',
                                        style:TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:24.0,
                                            fontWeight: FontWeight.bold,
                                            color:Colors.black
                                        )
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex:6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        barCodeSearchResultsMap[skuToUpdate].productBrand.toString(),
                                        style:TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:24.0,
                                            fontWeight: FontWeight.bold,
                                            color:Colors.black
                                        )
                                    ),
                                  ),
                                ),
                              ]),
                          Row(
                              children:<Widget>[
                                Expanded(
                                  flex:2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'TO',
                                        style:TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:24.0,
                                            fontWeight: FontWeight.bold,
                                            color:Colors.black
                                        )
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex:6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                        onPressed:(){
                                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                                            return UpdateProductSelectBrand();
                                          })).then((dynamic value){
                                            if(value != null)
                                            {
                                              setState(() {
                                                selectedBrand = value.toString();
                                              });
                                            }
                                          });
                                        },
                                        child:
                                        Text(
                                            selectedBrand,
                                            style:TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize:24.0,
                                                fontWeight: FontWeight.bold,
                                                color:Colors.black
                                            )
                                        )
                                    ),
                                  ),
                                ),
                              ]
                          ),
                        ]),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width,
                    child:RaisedButton(
                      color:Colors.blue,
                      onPressed:(){
                        print(skuToUpdate.toString());
                        print(productNode);
                        print(barCodeSearchResultsMap[skuToUpdate].productCategory.toString());
                        print(selectedCategory.toString());
                        print(barCodeSearchResultsMap[skuToUpdate].productBrand.toString());
                        print(selectedBrand.toString());
                        FirebaseDatabase
                            .instance
                            .reference()
                            .child('stores')
                            .child('KIRANAWALA_STORE_11')
                            .child('products')
                            .child(skuToUpdate.toString())
                            .update(<String, String>{
                          'category':selectedCategory.toString(),
                          'brand':selectedBrand.toString()
                          }
                        ).then((value){
                          print('CATEGORY/BRAND UPDATE SUCCESSFUL:' + skuToUpdate.toString());
                          productUpdateStatus = 'SUCCESS';
                          barCodeSearchResultsMap[skuToUpdate].productCategory = selectedCategory;
                          barCodeSearchResultsMap[skuToUpdate].productBrand = selectedBrand;
                          Navigator.of(context).pop();
                          Navigator.of(context).push<dynamic>(
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context){
                                return ProductLookupResults();
                              }
                            )
                          );
                        }).catchError((dynamic error){
                          productUpdateStatus = 'FAILURE';
                          print('CATEGORY/BRAND UPDATE FAILED:' + skuToUpdate.toString());
                        });
                      },
                      child:Text('CONFIRM',
                          style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize:24.0,
                              fontWeight: FontWeight.bold,
                              color:Colors.white
                          ))
                    )
                  )
              ])
            ),
      );
  }
}
