import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-category-sale-single-store.dart';

class SelectProductCategory extends StatefulWidget {
  @override
  _SelectProductCategoryState createState() => _SelectProductCategoryState();
}

class _SelectProductCategoryState extends State<SelectProductCategory> {

  @override
  void initState() {
    // TODO: implement initState
      categorySearchResults = productCategories;
  }
  @override
  Widget build(BuildContext context) {
    if(retrievingCategories)
      return
        Scaffold(
          appBar:
          AppBar(
            title:Text(
                'Change Product Category',
                style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize:12.0,
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          body:
          Container(
            color: Colors.white,
            child: Dialog(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      flex:2,
                      child: new CircularProgressIndicator()
                  ),
                  SizedBox(width:10.0),
                  Expanded(
                      flex:12,
                      child: Text("Retrieving Categories,",
                          style:TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:12.0,
                            fontWeight: FontWeight.bold,
                          )
                      )
                  ),
                ],
              ),
            ),
          ),
        );
    else
      return
        Scaffold(appBar:
        AppBar(
          centerTitle: true,
          title:Text(
              'SELECT CATEGORY',
              style:TextStyle(
                fontFamily: 'Montserrat',
                fontSize:24.0,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
            body:Column(
                children:<Widget>[

                  Expanded(
                    flex:2,
                    child: TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: 'Search Category...',
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize:24.0,
                              fontWeight: FontWeight.bold,
                              color:Colors.black
                          )
                      ),
                      onChanged: (value){
//                        print(value);
                        if(value.isNotEmpty)
                        {
                          categorySearchResults = [];
                          productCategories.forEach((category){
                            if(category.toLowerCase().contains(value.toLowerCase()))
                            {
                              categorySearchResults.add(category);
                            }
                          });
                          setState(() {

                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex:20,
                    child: Container(
                      // decoration: BoxDecoration(color: Colors.purple),
                      child: ListView.builder(
                        itemCount:categorySearchResults.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FlatButton(
                              color:Colors.blue,
                              child: Text(categorySearchResults[index],
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:24.0,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.white
                                  )),
                              onPressed: (){
                                categoryName = categorySearchResults[index];
                                barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
                                barCodeSearchResults = List<ProductBasicDetails>();

//                                  setState(() {
//                                    searchingBarCode = true;
//                                    barCodeSearchResults = List<ProductBasicDetails>();
//                                    barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
//                                  });

                                FirebaseDatabase.instance
                                    .reference()
                                    .child('stores')
                                    .child('KIRANAWALA_STORE_11')
                                    .child('products')
                                    .orderByChild('category')
                                    .equalTo(categoryName)
                                    .once()
                                    .then((DataSnapshot snapshot) {
                                  print(snapshot.value);
                                  if (snapshot != null && snapshot.value != null) {
                                    Map<dynamic, dynamic> productDetailsMap = snapshot.value;
                                    if (productDetailsMap.length == 1) {
                                      print(productDetailsMap.length);
                                      productDetailsMap.forEach((dynamic code, dynamic product) {

                                        var productBasicDetails = new ProductBasicDetails(
                                            product['title'].toString(),
                                            double.parse(product['price'].toString()),
                                            int.parse(product['productcode'].toString()),
                                            product['barcode'].toString(),
                                            product['imageurl'].toString(),
                                            product['category'].toString(),
                                            product['brand'].toString(),
                                            (product['productStatus'] != null)
                                                ? product['productStatus']
                                                : 'INACTIVE',
                                            (product['productParent'] != null)
                                                ? product['productParent']
                                                : 'N/A',
                                            (product['productCreationTimeStamp'] != null)
                                                ? product['productCreationTimeStamp']
                                                : 'N/A'
                                        );

                                        barCodeSearchResultsMap[int.parse(code.toString())] = productBasicDetails;
                                      });
                                      print(barCodeSearchResultsMap);
                                    } else if (productDetailsMap.length > 1) {
                                      productDetailsMap.forEach((dynamic code, dynamic product) {

                                        var productBasicDetails = new ProductBasicDetails(
                                            product['title'].toString(),
                                            double.parse(product['price'].toString()),
                                            int.parse(product['productcode'].toString()),
                                            product['barcode'].toString(),
                                            product['imageurl'].toString(),
                                            product['category'].toString(),
                                            product['brand'].toString(),
                                            (product['productStatus'] != null)
                                                ? product['productStatus']
                                                : 'INACTIVE',
                                            (product['productParent'] != null)
                                                ? product['productParent']
                                                : 'N/A',
                                            (product['productCreationTimeStamp'] != null)
                                                ? product['productCreationTimeStamp']
                                                : 'N/A'
                                        );

                                        barCodeSearchResultsMap[int.parse(code.toString())] = productBasicDetails;
                                      });

                                      print(barCodeSearchResultsMap);
                                    }
                                  }
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push<dynamic>(
                                      MaterialPageRoute<dynamic>(
                                          builder: (BuildContext context){
                                            return ShowCategorySalePositionSingleStore();
                                          }
                                      )
                                  );
                                });
//                                Navigator.of(context).pop();
//                                Navigator.of(context).push<dynamic>(
//                                  MaterialPageRoute<dynamic>(
//                                    builder: (BuildContext context){
//                                      return ShowBrandSalePosition();
//                                    }
//                                  )
//                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ]
              //  DropdownButton(
              //     hint: Text('Select Brand'), // Not necessary for Option 1
              //     value: selectedBrand,
              //     onChanged: (newValue) {
              //       setState(() {
              //         selectedBrand = newValue;
              //       });
              //     },
              //     underline: Container(
              //             height: 2,
              //             color: Colors.deepPurpleAccent,
              //           ),
              //     items: brands.map((Brand brand) {
              //       return DropdownMenuItem(
              //         child: new Text(brand.brandName),
              //         value: brand,
              //       );
              //     }).toList(),
              //   ),
            )
        );
  }
}