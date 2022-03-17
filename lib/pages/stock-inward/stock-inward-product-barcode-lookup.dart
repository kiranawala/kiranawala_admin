import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-home-page.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-results-index-list.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-product-lookup-results.dart';
import 'package:kiranawala_admin/pages/stock-inward/stock-inward-show-all-categories.dart';


//List<ProductBasicDetails> barCodeSearchResults = List<ProductBasicDetails>();
List<ProductBasicDetails> products = List<ProductBasicDetails>();
String selectedProductName = '';
int selectedProductCode = 0;

class StockInwardProductBarcodeLookUp extends StatefulWidget {
  @override
  _StockInwardProductBarcodeLookUpState createState() => _StockInwardProductBarcodeLookUpState();
}

class _StockInwardProductBarcodeLookUpState extends State<StockInwardProductBarcodeLookUp> {

  @override
  void initState() {
    super.initState();

    barCodeSearchResults = List<ProductBasicDetails>();
    barCodeSearchResultsMap = Map<int,ProductBasicDetails>();
    barCodeSearchResultsMap = activeProductBasicDetailsMap;
    activeProductBasicDetailsMap.forEach((key, value) {
      barCodeSearchResults.add(value);
    });
    barCodeSearchResults.sort((a,b){
      return (
          a.productBarCode.compareTo(b.productBarCode)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
      return
        Scaffold(
          appBar:
        AppBar(
          automaticallyImplyLeading:  false,
          centerTitle: true,
          leading:IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context){
                    return StockInwardShowAllCategories();
                  }
                )
              );
            },
          ),
          title:Text(
              'PRODUCT SEARCH',
              style:TextStyle(
                fontFamily: 'Montserrat',
                fontSize:14.0,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
            body:Column(
                children:<Widget>[
                              Expanded(
                                flex:2,
                                child:Container(
                                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                                  child: TextField(
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize:24.0,
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black
                                    ),
                                    autofocus: true,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: InputDecoration(
                                        hintText: 'Search Product by Barcode ...',
                                        hintStyle: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:16.0,
                                            fontWeight: FontWeight.bold,
                                            color:Colors.black
                                        )
                                    ),
                                    onChanged: (value){
                                      print(value);
                                      if(value.isNotEmpty)
                                      {
                                        barCodeSearchResults = [];
                                        activeProductBasicDetailsList.forEach((product){
                                          if(product.productBarCode.toLowerCase().compareTo(value.toLowerCase()) == 0)
                                          {
                                            barCodeSearchResults.add(product);
                                            barCodeSearchResultsMap[product.productID] = product;
                                          }
                                        });

                                      }
                                      else{
                                        barCodeSearchResults = activeProductBasicDetailsList;
                                      }
                                      setState(() {

                                      });
                                    },
                                  ),
                                ),

                              ),
            Expanded(
              flex:18,
              child: ListView.builder(
                  itemCount: barCodeSearchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                      Container(
                        padding: EdgeInsets.all(8.0),
                        color:Colors.white,
                        child: RaisedButton(
                          onPressed: ()
                          {
                            print('Product Selected');
                            skuToUpdate =
                                barCodeSearchResults[index].productID;
                            Future<void> future =  showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return BottomSheet(
                                      onClosing: () {
                                      },
                                      builder: (BuildContext context) {
                                        return null;
//                                        return StockInwardProductUpdateOptions();
                                      });
                                });
                            future.then((void value) => {
                              setState((){})
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(color: Colors.blueGrey[100])),
                            height: 120,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: new Stack(
                                    children: <Widget>[
                                      new Container(
                                        //margin: new EdgeInsets.only(left: 46.0),
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: new Color(0xFFFFFFFF),
                                          borderRadius:
                                          new BorderRadius.circular(8.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                barCodeSearchResults[index]
                                                    .productImageURL),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Column(children: <Widget>[
                                    Center(
                                      child: Text(
                                        barCodeSearchResults[index]
                                            .productName
                                            .toUpperCase(),
                                        maxLines: 3,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Montserrat"),
                                      ),
                                    ),
                                    Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 12,
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  "\u20B9" +
                                                      barCodeSearchResults[index]
                                                          .productPrice.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Montserrat"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 12,
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  barCodeSearchResults[index]
                                                      .productStatus.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Montserrat"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                    Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 12,
                                            child: Container(
                                              child: Center(
                                                child: Text(
                                                  barCodeSearchResults[index]
                                                      .productBarCode.toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: "Montserrat"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  }),
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