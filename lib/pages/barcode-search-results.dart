import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/search-barcode.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';

bool refreshing = false;

class BarCodeSearchResults extends StatefulWidget {
  @override
  _BarCodeSearchResultsState createState() => _BarCodeSearchResultsState();
}

class _BarCodeSearchResultsState extends State<BarCodeSearchResults> {

  void removeProductFromFirebase(int productId)
  {
    setState(() {
      refreshing = true;
    });
    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child('KIRANAWALA_MASTER')
        .child('products')
        .child(productId.toString())
        .update(<String, dynamic>{
      'status': 'inactive',
      'deactivatedOn': DateTime.now().toString()
    }).then((value) {
      print('Product Removed Successfully!!');
    }).catchError((dynamic onError){
      print('NETWORK ERROR');
    });
    barCodeSearchResultsMap.remove(productId);
    if(barCodeToSearch.length > 0){
      barCodeSearchResults = List<ProductBasicDetails>();
      barCodeSearchResultsMap.forEach((key, value) {
        barCodeSearchResults.add(value);
      });
      if(barCodeSearchResults.length > 0)
      {
        setState(() {
          refreshing = false;
        });
      }
      else
      {
        refreshing = false;
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
          return SearchBarCode();
        }));
      }
    }
    else{
      refreshing = false;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    barCodeSearchResults = [];
    barCodeSearchResultsMap.forEach((key, value) {
      barCodeSearchResults.add(value);
      print(key);
      print(value.productID);
    });
    print(barCodeSearchResults);

    if(refreshing)
      return Container(
        color: Colors.white,
        child: Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
            ],
          ),
        ),
      );
    else

    if(barCodeSearchResults.length > 0)
      return
        WillPopScope(
            onWillPop:(){
              setState(() {
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return SearchBarCode();
                    }));
              });

              return;
            },
            child:Scaffold(
                appBar:AppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon:Icon(Icons.keyboard_backspace),
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                          builder:(BuildContext context){
                            return SearchBarCode();
                          }));
                    },
                  ),
                  title:Text(
                    'Search Results',
                    style:TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                    ),
                  ),
                  centerTitle: true,
                ),

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
                                fontSize: 20.0
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
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              padding: EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.blueGrey),
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))
                                              ),
                                              height: 400.0,
                                              child: Column(children: <Widget>[
                                                Expanded(
                                                  flex:16,
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        flex:6,
                                                        child: Column(
                                                          children: <Widget>[
                                                    Expanded(
                                                      flex:2,
                                                      child: Container(
                                                        width:MediaQuery.of(context).size.width,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: RaisedButton(
                                                            onPressed:(){
//                                                              productToUpdate = barCodeSearchResults[index];
//                                                              productToUpdateIndex = index;
//                                                              Navigator.of(context).pop();
//                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
//                                                                return UpdateProductDetails();
//                                                              }));
                                                            },
                                                            child: Text(
                                                              barCodeSearchResults[index].productID.toString(),
                                                              style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20.0
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                            Expanded(
                                                              flex:2,
                                                              child: Container(
                                                                width:MediaQuery.of(context).size.width,
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: RaisedButton(
                                                                    onPressed:(){
//                                                              productToUpdate = barCodeSearchResults[index];
//                                                              productToUpdateIndex = index;
//                                                              Navigator.of(context).pop();
//                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
//                                                                return UpdateProductDetails();
//                                                              }));
                                                                    },
                                                                    child: Text(
                                                                      barCodeSearchResults[index].productBarCode.toString(),
                                                                      style:TextStyle(
                                                                          fontFamily: 'Montserrat',
                                                                          fontWeight: FontWeight.bold,
                                                                          fontSize: 20.0
                                                                      ),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
//                                              Expanded(
//                                                flex:3,
//                                                child: Column(
//                                                  children: <Widget>[
//                                                    Expanded(
//                                                      flex:2,
//                                                      child: Padding(
//                                                        padding: const EdgeInsets.all(8.0),
//                                                        child: RaisedButton(
//                                                          highlightColor:Colors.blue,
//                                                          onPressed:(){
//                                                            setState(() {
//                                                              refreshing = true;
//                                                            });
//                                                            productToUpdate = barCodeSearchResults[index];
//                                                            barCodeToSearch = productToUpdate.productBarCode;
//                                                            removeProductFromFirebase(barCodeSearchResults[index].productID);
//                                                          },
//                                                          child:Text('DELETE')
//                                                        ),
//                                                      ),
//                                                    ),
//                                                    Expanded(
//                                                      flex:2,
//                                                      child: Padding(
//                                                        padding: const EdgeInsets.all(8.0),
//                                                        child: RaisedButton(
//                                                            onPressed:(){
//                                                              productToUpdate = barCodeSearchResults[index];
//                                                              productToUpdateIndex = index;
//                                                              Navigator.of(context).pop();
//                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
//                                                                return UpdateProductDetails();
//                                                              }));
//                                                            },
//                                                            child:Text('UPDATE')
//                                                        ),
//                                                      ),
//                                                    )
//                                                  ],
//                                                ),
//                                              )

                                                    ],
                                                  ),
                                                ),

                                                Expanded(
                                                    flex:16,
                                                    child: Container(
                                                      width:MediaQuery.of(context).size.width,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: RaisedButton(
                                                          onPressed: (){
                                                          },
                                                          child: Text(
                                                            barCodeSearchResults[index].productName.toString(),
                                                            textAlign: TextAlign.center,
                                                            style:TextStyle(
                                                              // backgroundColor: Colors.blue,
                                                              color:Colors.green,
                                                              fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20.0,
                                                            ),
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                ),
                                                Expanded(
                                                  flex:8,
                                                  child: Container(
                                                    width:MediaQuery.of(context).size.width,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RaisedButton(
                                                        onPressed:(){

                                                        },
                                                        child: Text(
                                                          'Rs.'+ barCodeSearchResults[index].productPrice.toString() +'/-',
                                                          style:TextStyle(
                                                              fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20.0
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Expanded(
                                                  flex:8,
                                                  child: Container(
                                                    width:MediaQuery.of(context).size.width,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RaisedButton(
                                                          onPressed:(){

                                                          },
                                                          child:
                                                          Text(
                                                            barCodeSearchResults[index].productCategory,
                                                            style:TextStyle(
                                                                fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20.0
                                                            ),
                                                            textAlign: TextAlign.right,
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:8,
                                                  child: Container(
                                                    width:MediaQuery.of(context).size.width,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RaisedButton(
                                                          onPressed:(){
                                                          },
                                                          child:
                                                          Text(
                                                            barCodeSearchResults[index].productBrand,
                                                            style:TextStyle(
                                                                fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20.0
                                                            ),
                                                            textAlign: TextAlign.right,
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:8,
                                                  child: Container(
                                                    width:MediaQuery.of(context).size.width,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RaisedButton(
                                                          onPressed:(){
                                                          },
                                                          child:
                                                          Text(
                                                            (barCodeSearchResults[index].productStatus != null)?barCodeSearchResults[index].productStatus:'N/A',
                                                            style:TextStyle(
                                                                fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20.0
                                                            ),
                                                            textAlign: TextAlign.right,
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:8,
                                                  child: Container(
                                                    width:MediaQuery.of(context).size.width,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RaisedButton(
                                                          onPressed:(){
                                                          },
                                                          child:
                                                          Text(
                                                            (barCodeSearchResults[index].productParentStore != null)?barCodeSearchResults[index].productParentStore:'N/A',
                                                            style:TextStyle(
                                                                fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20.0
                                                            ),
                                                            textAlign: TextAlign.right,
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:8,
                                                  child: Container(
                                                    width:MediaQuery.of(context).size.width,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RaisedButton(
                                                          onPressed:(){
                                                          },
                                                          child:
                                                          Text(
                                                            (barCodeSearchResults[index].productCreationTimeStamp != null)?barCodeSearchResults[index].productCreationTimeStamp:'N/A',
                                                            style:TextStyle(
                                                                fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20.0
                                                            ),
                                                            textAlign: TextAlign.right,
                                                          )
                                                      ),
                                                    ),
                                                  ),
                                                ),
//                                        Expanded(
//                                          flex:8,
//                                          child:Row(
//                                            children: <Widget>[
//                                              Expanded(
//                                                flex:4,
//                                                child: Container(
//                                                  width:MediaQuery.of(context).size.width,
//                                                  child: Padding(
//                                                    padding: const EdgeInsets.all(8.0),
//                                                    child: Text(
//                                                      'IN',
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 20.0
//                                                      ),
//                                                      textAlign: TextAlign.center,
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
//                                              Expanded(
//                                                flex:4,
//                                                child: Container(
//                                                  width:MediaQuery.of(context).size.width,
//                                                  child: Padding(
//                                                    padding: const EdgeInsets.all(8.0),
//                                                    child: Text(
//                                                      'OUT',
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 20.0
//                                                      ),
//                                                      textAlign: TextAlign.center,
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
//                                              Expanded(
//                                                flex:4,
//                                                child: Container(
//                                                  width:MediaQuery.of(context).size.width,
//                                                  child: Padding(
//                                                    padding: const EdgeInsets.all(8.0),
//                                                    child: Text(
//                                                      'STOCK',
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 20.0
//                                                      ),
//                                                      textAlign: TextAlign.center,
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
//                                            ],
//                                          ),
//                                        ),
//                                              Expanded(
//                                                flex:8,
//                                                child:Row(
//                                                  children: <Widget>[
//                                                    Expanded(
//                                                      flex:4,
//                                                      child: Container(
//                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                                                        width:MediaQuery.of(context).size.width,
//                                                        child: RaisedButton(
//                                                          onPressed:(){
//                                                            double x = (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]:0;
////                                                              Navigator.of(context).pop();
//                                                            if(x>0)
//                                                              {
//                                                            productCode = barCodeSearchResults[index].productID;
//                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
//                                                                return ProductStockInwardHistory();
//                                                              }));
//                                                            }
//                                                          },
//                                                          child: Padding(
//                                                            padding: const EdgeInsets.all(8.0),
//                                                            child: Text(
//                                                                (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID].toString():'0',
//                                                              style:TextStyle(
//                                                                  fontFamily: 'Montserrat',
//                                                                  fontWeight: FontWeight.bold,
//                                                                  fontSize: 20.0
//                                                              ),
//                                                              textAlign: TextAlign.center,
//                                                            ),
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    ),
//                                                    Expanded(
//                                                      flex:4,
//                                                      child: Container(
//                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                                                        width:MediaQuery.of(context).size.width,
//                                                        child: RaisedButton(
//                                                          onPressed:(){
//                                                            double x = (productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID]:0;
//                                                            if(x > 0){
////                                                              Navigator.of(context).pop();
//                                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder: (BuildContext context){
//                                                                return ProductStockOutwardHistory();
//                                                              }));
//                                                            }
//                                                          },
//                                                          child: Padding(
//                                                            padding: const EdgeInsets.all(8.0),
//                                                            child: Text(
//                                                                (productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID].toString():'0',
//                                                              style:TextStyle(
//                                                                  fontFamily: 'Montserrat',
//                                                                  fontWeight: FontWeight.bold,
//                                                                  fontSize: 20.0
//                                                              ),
//                                                              textAlign: TextAlign.center,
//                                                            ),
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    ),
////                                                    Expanded(
////                                                      flex:4,
////                                                      child: Container(
////                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
////                                                        width:MediaQuery.of(context).size.width,
////                                                        child: Padding(
////                                                          padding: const EdgeInsets.all(8.0),
////                                                          child: Text(
////                                                            productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID].toString(),
////                                                            style:TextStyle(
////                                                                fontFamily: 'Montserrat',
////                                                                fontWeight: FontWeight.bold,
////                                                                fontSize: 20.0
////                                                            ),
////                                                            textAlign: TextAlign.center,
////                                                          ),
////                                                        ),
////                                                      ),
////                                                    ),
//                                                    Expanded(
//                                                      flex:4,
//                                                      child: Container(
//                                                        decoration: BoxDecoration(color:Colors.grey[300],borderRadius: BorderRadius.all(Radius.circular(5.0))),
//                                                        width:MediaQuery.of(context).size.width,
//                                                        child: Padding(
//                                                          padding: const EdgeInsets.all(8.0),
//                                                          child: Text(
//                                                            ((
//                                            (productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]!=null)?productStockInwardTotalQtyMap[barCodeSearchResults[index].productID]:0)
//                                            - ((productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID] != null)?productStockOutwardTotalQtyMap[barCodeSearchResults[index].productID]:0)).toString(),
//                                                            style:TextStyle(
//                                                                fontFamily: 'Montserrat',
//                                                                fontWeight: FontWeight.bold,
//                                                                fontSize: 20.0
//                                                            ),
//                                                            textAlign: TextAlign.center,
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ],
//                                                )
//                                              )
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
            ));
    else
      return
        WillPopScope(
            onWillPop:(){
              setState(() {
                Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                    builder:(BuildContext context){
                      return SearchBarCode();
                    }));
              });

              return;
            },
            child: Scaffold(
                appBar:AppBar(
                  automaticallyImplyLeading: false,
                  title:Text('SEARCH RESULTS'),
                  centerTitle: true,
                  leading: IconButton(
                      icon:Icon(Icons.keyboard_backspace),
                      onPressed:(){
                        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                          return SearchBarCode();
                        }));
                      }
                  ),
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      barCodeToSearch,
                      style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                    ),
                    Text(
                      'PRODUCT NOT IN SYSTEM',
                      style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                    ),
                  ],
                )
            ));
  }
}