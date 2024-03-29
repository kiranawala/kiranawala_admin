import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-results.dart';

import '../show-admin-home-page.dart';


class SelectProductBrand extends StatefulWidget {
  @override
  _SelectProductBrandState createState() => _SelectProductBrandState();
}

class _SelectProductBrandState extends State<SelectProductBrand> {

  @override
  void initState() {
    // TODO: implement initState
    brandSearchResults = List<String>();
    brandSearchResults = productBrands;
  }
  @override
  Widget build(BuildContext context) {
//    if(retrievingBrands)
//      return
//        Scaffold(
//          appBar:
//          AppBar(
//            title:Text(
//                'Change Product Brand',
//                style:TextStyle(
//                  fontFamily: 'Montserrat',
//                  fontSize:12.0,
//                  fontWeight: FontWeight.bold,
//                )
//            ),
//          ),
//          body:
//          Container(
//            color: Colors.white,
//            child: Dialog(
//              child: new Row(
//                mainAxisSize: MainAxisSize.min,
//                children: [
//                  Expanded(
//                      flex:2,
//                      child: new CircularProgressIndicator()
//                  ),
//                  SizedBox(width:10.0),
//                  Expanded(
//                      flex:12,
//                      child: Text("Retrieving Brands,",
//                          style:TextStyle(
//                            fontFamily: 'Montserrat',
//                            fontSize:12.0,
//                            fontWeight: FontWeight.bold,
//                          )
//                      )
//                  ),
//                ],
//              ),
//            ),
//          ),
//        );
//    else
      return
        Scaffold(appBar:
        AppBar(
          centerTitle: true,
          title:Text(
              'SELECT BRAND',
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
                          hintText: 'Search Brand...',
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
                          brandSearchResults = [];
                          productBrands.forEach((brand){
                            if(brand.toLowerCase().contains(value.toLowerCase()))
                            {
                              brandSearchResults.add(brand);
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
                        itemCount:brandSearchResults.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FlatButton(
                              color:Colors.blue,
                              child: Text(brandSearchResults[index],
                                  style:TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize:24.0,
                                      fontWeight: FontWeight.bold,
                                      color:Colors.white
                                  )),
                              onPressed: (){
                                selectedBrand = brandSearchResults[index];
                                barCodeSearchResultsMap = Map<int, ProductBasicDetails>();
                                barCodeSearchResults = List<ProductBasicDetails>();
                                fullProductBasicDetailsMap.forEach((key, value) {
                                  if(value.productBrand == selectedBrand){
                                    barCodeSearchResultsMap[key] = value;
                                    barCodeSearchResults.add(value);
                                  }
                                });
                                print(selectedBrand);
                                print(barCodeSearchResults.length.toString());
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