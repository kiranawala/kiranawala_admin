import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-store-stock-position.dart';
import 'add-new-stock-in-product-with-barcode.dart';

class StockInProductSearch extends StatefulWidget {
  @override
  _StockInProductSearchState createState() => _StockInProductSearchState();
}

class _StockInProductSearchState extends State<StockInProductSearch> {

  @override
  Widget build(BuildContext context) {

    if(barCodeSearchResults.length > 0)
    return Scaffold(
        appBar:AppBar(
          title:Text(
              'Search Results',
            style:TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24.0
            ),
          ),
        centerTitle: true,),

        body:Container(
            child:Column(
              children: <Widget>[
          Expanded(
            flex:2,
            child: Text(
              'Products Found:' + barCodeSearchResults.length.toString(),
              style:TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24.0
              ),
            ),
          ),
                Expanded(
                    flex:20,
                    child: Container(
                        child:
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: barCodeSearchResults.length,
                            itemBuilder: (BuildContext context, int index){
                              return
                                GestureDetector(
                                  onTap: (){
                                    stockInProductToUpdate = barCodeSearchResults[index];
                                    stockInwardDetailsProductToUpdate = stockInwardDetailsMap[stockInProductToUpdate.productID];
                                    Navigator.of(context).pop('yes');
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blueGrey),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0))
                                      ),
                                      height: 200.0,
                                      child: Column(children: <Widget>[
                                        Expanded(
                                          flex:8,
                                          child: Container(
                                            width:MediaQuery.of(context).size.width,
                                            child: Text(
                                              barCodeSearchResults[index].productID.toString(),
                                              style:TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24.0
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex:8,
                                          child: Container(
                                            width:MediaQuery.of(context).size.width,
                                            child: Text(
                                              barCodeSearchResults[index].productBarCode.toString(),
                                              style:TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24.0
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex:8,
                                            child: Container(
                                              width:MediaQuery.of(context).size.width,
                                              child: Text(
                                                  barCodeSearchResults[index].productName.toString(),
                                                  textAlign: TextAlign.center,
                                                  style:TextStyle(
                                                    // backgroundColor: Colors.blue,
                                                      color:Colors.black,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24.0,
                                                  ),
//                                                maxLines: 3,
                                              ),
                                            )
                                          ),
                                        Expanded(
                                          flex:8,
                                          child: Container(
                                            width:MediaQuery.of(context).size.width,
                                            child: Text(
                                                'Rs.'+ barCodeSearchResults[index].productPrice.toString() +'/-',
                                                style:TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24.0,
                                                    color:Colors.green
                                                ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),

//                                          Expanded(
//                                            flex:8,
//                                            child: Container(
//                                              width:MediaQuery.of(context).size.width,
//                                              child: Padding(
//                                                padding: const EdgeInsets.all(8.0),
//                                                child: Text(
//                                                  barCodeSearchResults[index].productCategory,
//                                                  style:TextStyle(
//                                                      fontFamily: 'Montserrat',
//                                                      fontWeight: FontWeight.bold,
//                                                      fontSize: 24.0
//                                                  ),
//                                                  textAlign: TextAlign.center,
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                          Expanded(
//                                            flex:8,
//                                            child: Container(
//                                              width:MediaQuery.of(context).size.width,
//                                              child: Padding(
//                                                padding: const EdgeInsets.all(8.0),
//                                                child: Text(
//                                                  barCodeSearchResults[index].productBrand,
//                                                  style:TextStyle(
//                                                      fontFamily: 'Montserrat',
//                                                      fontWeight: FontWeight.bold,
//                                                      fontSize: 24.0
//                                                  ),
//                                                  textAlign: TextAlign.center,
//                                                ),
//                                              ),
//                                            ),
//                                          ),
//                                          Expanded(
//                                            flex:8,
//                                            child: Container(
//                                              width:MediaQuery.of(context).size.width,
//                                              child: Padding(
//                                                padding: const EdgeInsets.all(8.0),
//                                                child: Text(
//                                                  barCodeSearchResults[index].productStockPosition.toString(),
//                                                  style:TextStyle(
//                                                      fontFamily: 'Montserrat',
//                                                      fontWeight: FontWeight.bold,
//                                                      fontSize: 24.0
//                                                  ),
//                                                  textAlign: TextAlign.right,
//                                                ),
//                                              ),
//                                            ),
//                                          ),
                                      ])
                                  ),
                                );
                            }
                        )
                    )
                )
              ],
            )
        )
    );
    else
      return Scaffold(
          appBar:AppBar(title:Text('SEARCH RESULTS')),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                barCodeToSearch,
                style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0
                ),
              ),
              Text(
                'PRODUCT NOT IN SYSTEM',
                style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0
                ),
              ),
              Container(
                width:MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color:Colors.blue,
                    onPressed:(){
//                      Navigator.of(context).pop();
//                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                        return AddNewStockInwardProduct();
//                      }));
                    },
                    child:Text('ADD PRODUCT',
                      style:TextStyle(
                          color:Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0
                      ),
                    )
                  )

              )
            ],
          )
      );
  }
}