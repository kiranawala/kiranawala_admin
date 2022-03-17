import 'package:flutter/material.dart';
//import 'package:kiranawala_admin/pages/stock-inward/stock-inward-check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup.dart';

import '../check-if-admin.dart';
import '../show-admin-home-page.dart';


class ProductLookUpSelectStore extends StatefulWidget {
  @override
  _ProductLookUpSelectStoreState createState() => _ProductLookUpSelectStoreState();
}

class _ProductLookUpSelectStoreState extends State<ProductLookUpSelectStore> {
  List<String> storeSearchResults = stores;
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: (){
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context){
                return ProductLookUp();
              }
            )
          );
          return;
        },
        child: Scaffold(
          appBar:
        AppBar(
          automaticallyImplyLeading: false,
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return ProductLookUp();
                  }
                )
              );
            }
          ),
          title:Text('SELECT STORE',
              style:TextStyle(
              fontSize:20.0,
              color:Colors.white),)
        ),
            body:Column(
                children:<Widget>[

                  Expanded(
                    flex:2,
                    child: TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: 'Search Store...',
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
                          storeSearchResults = [];
                          stores.forEach((x){
                            if(x.toLowerCase().contains(value.toLowerCase()))
                            {
                              storeSearchResults.add(x);
                              print(storeSearchResults);
                            }
                          });
                        }
                        else
                        {
                          storeSearchResults = stores;
                        }
                        setState(() {

                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex:20,
                    child: Container(
                      // decoration: BoxDecoration(color: Colors.purple),
                      child: ListView.builder(
                        itemCount:storeSearchResults.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: FlatButton(
                              color:Colors.blue,
                              child: Text(
                                storeSearchResults[index],
                                style: TextStyle(
                                    color:Colors.white,
                                    fontWeight:FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    fontSize:24.0
                                ),
                              ),
                              onPressed: (){
                                productLookupStore = storeSearchResults[index];
                                print('Seleced Store:' + productLookupStore);
                                Navigator.of(context).pop();
                                Navigator.of(context).push<dynamic>(
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context){
                                      return ProductLookUp();
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
        ),
      );  }
}
