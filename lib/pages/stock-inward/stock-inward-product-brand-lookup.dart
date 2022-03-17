import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
//import 'package:kiranawala_admin/pages/stock-inward/stock-inward-check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-results.dart';
//import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-results.dart';


List<ProductBasicDetails> productSearchResults = List<ProductBasicDetails>();
List<ProductBasicDetails> products = List<ProductBasicDetails>();
String selectedProductName = '';
int selectedProductCode = 0;

class ProductBrandLookUp extends StatefulWidget {
  @override
  _ProductBrandLookUpState createState() => _ProductBrandLookUpState();
}

class _ProductBrandLookUpState extends State<ProductBrandLookUp> {

  @override
  void initState() {
    super.initState();
    productSearchResults = List<ProductBasicDetails>();
    products = List<ProductBasicDetails>();
    fullProductBasicDetailsMap.forEach((key, value) {
      products.add(value);
    });
    products.sort((a,b){
      return (
          a.productName.compareTo(b.productName)
      );
    });
    productSearchResults = products;
  }

  @override
  Widget build(BuildContext context) {
      return
        Scaffold(appBar:
        AppBar(
          title:Text(
              'Select Product',
              style:TextStyle(
                fontFamily: 'Montserrat',
                fontSize:12.0,
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
                          hintText: 'Search Product...',
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize:24.0,
                              fontWeight: FontWeight.bold,
                              color:Colors.black
                          )
                      ),
                      onChanged: (value){
                        print(value);
                        if(value.isNotEmpty)
                        {
                          productSearchResults = [];
                          products.forEach((product){
                            if(product.productName.toLowerCase().contains(value.toLowerCase()))
                            {
                              productSearchResults.add(product);
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
                        itemCount:productSearchResults.length,
                        itemBuilder: (BuildContext context, int index){
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(color:Colors.grey),
                                borderRadius: BorderRadius.all(Radius.circular(5.0))
                            ),
                            child: FlatButton(
                              color:Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    productSearchResults[index].productName,
                                    style: TextStyle(
                                        color:Colors.black,
                                        fontWeight:FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                        fontSize:14.0
                                    ),
                                  ),
                                  Text(
                                    productSearchResults[index].productPrice.toString(),
                                    style: TextStyle(
                                        color:Colors.black,
                                        fontWeight:FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                        fontSize:14.0
                                    ),
                                  ),
//                            Text(
//                              productSearchResults[index].productID.toString(),
//                              style: TextStyle(
//                                  color:Colors.black,
//                                  fontWeight:FontWeight.bold,
//                                  fontFamily: 'Montserrat',
//                                  fontSize:14.0
//                              ),
//                            ),0
                                ],
                              ),

                              onPressed: (){
                                barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
                                barCodeSearchResultsMap[productSearchResults[index].productID] = productSearchResults[index];

                                Navigator.of(context).pop();
                                Navigator.of(context).push<dynamic>(
                                    MaterialPageRoute<dynamic>(
                                        builder:(BuildContext context){
                                          return ProductLookupResults();
                                        }
                                    )
                                );
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