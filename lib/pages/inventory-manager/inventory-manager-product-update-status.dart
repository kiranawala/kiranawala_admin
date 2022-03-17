import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup-results.dart';
import '../show-admin-home-page.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

class ProductUpdateStatus extends StatefulWidget {
  @override
  _ProductUpdateStatusState createState() => _ProductUpdateStatusState();
}

class _ProductUpdateStatusState extends State<ProductUpdateStatus> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(barCodeSearchResultsMap[skuToUpdate].productStatus.toUpperCase() == 'ACTIVE')
      selectedStatus = 'INACTIVE';
    else
      selectedStatus = 'ACTIVE';
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:(){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context){
              return ProductLookupResults();
            }
          )
        );
        return;
      },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title:Text(
              'CHANGE PRODUCT STATUS',
              style:TextStyle(
                fontFamily: 'Montserrat',
                fontWeight:FontWeight.bold,
                fontSize:18.0,
                color:Colors.white
              )
            ),
            leading: IconButton(
              icon:Icon(Icons.keyboard_backspace),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context){
                          return ProductLookupResults();
                        }
                    )
                );
              },
            ),
          ),
          body:
          Column(
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
                ),
              ),
              Container(
                width:MediaQuery.of(context).size.width,
                child: Text('\u20B9 ' + barCodeSearchResultsMap[skuToUpdate].productPrice.toString(),
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
                          child:Text('CHANGE STATUS',
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
                                    barCodeSearchResultsMap[skuToUpdate].productStatus.toString(),
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
                                        if(selectedStatus == 'ACTIVE')
                                        {
                                          setState(() {
                                            selectedStatus = 'INACTIVE';
                                          });
                                        }
                                        else
                                        {
                                          setState(() {
                                            selectedStatus = 'ACTIVE';
                                          });
                                        }
                                    },
                                    child:
                                    Text(
                                        selectedStatus,
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
                        List<int> skusAlreadyAvailable = List<int>();
                        fullProductBasicDetailsMap.forEach((key, value) {
                          if (value.productBarCode.toString() == barCodeSearchResultsMap[skuToUpdate].productBarCode.toString()) {
                            skusAlreadyAvailable.add(value.productID);
                          }
                        });
                        print(skusAlreadyAvailable);

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
                            .child(productNode)
                            .child('products')
                            .child(skuToUpdate.toString())
                            .update(<String, String>{
                          'productStatus':selectedStatus.toString(),
                        }
                        ).then((value){
                          print('STATUS UPDATE SUCCESSFUL:' + skuToUpdate.toString());
                          productUpdateStatus = 'SUCCESS';
                          barCodeSearchResultsMap[skuToUpdate].productStatus = selectedStatus;

                          if(selectedStatus == 'ACTIVE')
                            {
                              skusAlreadyAvailable.forEach((sku) {
                                if(sku != skuToUpdate)
                                  {
                                    fullProductBasicDetailsMap[sku].productStatus = 'INACTIVE';
                                    if(barCodeSearchResultsMap.containsKey(sku)){
                                      barCodeSearchResultsMap[sku].productStatus = 'INACTIVE';
                                    }
                                    FirebaseDatabase
                                        .instance
                                        .reference()
                                        .child('stores')
                                        .child(productNode)
                                        .child('products')
                                        .child(sku.toString())
                                        .child('productStatus')
                                        .set('INACTIVE');
                                  }
                              });
                            }
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
        ));
  }
}
