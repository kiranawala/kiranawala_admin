import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/request-stock-inward-qty.dart';
import 'package:kiranawala_admin/pages/stock-in-manager-online.dart';
import 'package:kiranawala_admin/pages/store-stock-position.dart';

bool refreshing = false;

class StockInwardProductSearchResults extends StatefulWidget {
  @override
  _StockInwardProductSearchResultsState createState() => _StockInwardProductSearchResultsState();
}

class _StockInwardProductSearchResultsState extends State<StockInwardProductSearchResults> {

  @override
  Widget build(BuildContext context) {
    if(barCodeSearchResults.length > 0)
      {
        return
          WillPopScope(
            onWillPop:(){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return StockInManagerOnline();
                  }));
              return;
            },
            child: Scaffold(
                appBar:AppBar(
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon:Icon(Icons.keyboard_backspace),
                    onPressed: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                          builder:(BuildContext context){
                            return StockInManagerOnline();
                          }));
                    },
                  ),
                  title:Text(
                    'STOCK INWARD',
                    style:TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0
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
                                fontSize: 24.0
                            ),
                          ),
                        ),
                        Expanded(
                            flex:20,
                            child: Container(
                                padding: EdgeInsets.all(8.0),
//                        decoration: BoxDecoration(
//                            border: Border.all(color: Colors.blueGrey),
//                            borderRadius: BorderRadius.all(Radius.circular(5.0))
//                        ),
                                child:
                                ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: barCodeSearchResults.length,
                                    itemBuilder: (BuildContext context, int index){
                                      return
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0.0,8.0,0.0,8.0),
                                          child: RaisedButton(
                                            onPressed: (){
                                              stockInProductToUpdate = barCodeSearchResults[index];
                                                Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                                                  return RequestStockInwardQty();
                                                }));
                                            },
                                            child: Container(
                                                width:MediaQuery.of(context).size.width,
                                                child:
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      child:
                                                      Text(barCodeSearchResults[index].productName.toString(),
                                                        style:TextStyle(
                                                          fontFamily: 'Montserrat',
                                                          fontWeight:FontWeight.bold,
                                                          fontSize: 20.0,
                                                          color:Colors.black,
                                                        ),),
                                                    ),
                                                    Container(
                                                      child:Text('\u20B9' + barCodeSearchResults[index].productPrice.toString() + '/-',
                                                        style:TextStyle(
                                                          fontFamily: 'Montserrat',
                                                          fontWeight:FontWeight.bold,
                                                          fontSize: 20.0,
                                                          color:Colors.black,
                                                        ),),
                                                    ),
                                                    Container(
                                                      child:Row(
                                                          children:<Widget>[
                                                            Expanded(
                                                              child: Text('SKU:',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 12.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                            Expanded(
                                                              child: Text(barCodeSearchResults[index].productID.toString(),
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                    Container(
                                                      child:Row(
                                                          children:<Widget>[
                                                            Expanded(
                                                              child: Text('BarCode:',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 12.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                            Expanded(
                                                              child: Text(barCodeSearchResults[index].productBarCode.toString(),
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                    Container(
                                                      child:Row(
                                                          children:<Widget>[
                                                            Expanded(
                                                              child: Text('Total Inward:',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 12.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                (recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID] != null)?
                                                                (recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID].stockInwardQtyTillDate.toString()):
                                                                'N/A',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                    Container(
                                                      child:Row(
                                                          children:<Widget>[
                                                            Expanded(
                                                              child: Text('Recent Inward:',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 12.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                (recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID] != null)?
                                                                (recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID].recentStockInwardQty.toString()):
                                                                'N/A',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                    Container(
                                                      child:Row(
                                                          children:<Widget>[
                                                            Expanded(
                                                              child: Text('Recent Inward Date:',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 12.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                (recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID] != null)?
                                                                (recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID].recentStockInwardDate.toString()):
                                                                'N/A',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                    Container(
                                                      child:Row(
                                                          children:<Widget>[
                                                            Expanded(
                                                              child: Text('Recent Inward Time:',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 12.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                (recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID] != null)?
                                                                recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID].recentStockInwardTime.toString():
                                                                'N/A',
                                                                style:TextStyle(
                                                                  fontFamily: 'Montserrat',
                                                                  fontWeight:FontWeight.bold,
                                                                  fontSize: 20.0,
                                                                  color:Colors.black,
                                                                ),),
                                                            ),
                                                          ]
                                                      ),
                                                    ),
                                                  ],
                                                )

                                            ),
                                          ),
                                        );
//                                        Padding(
//                                          padding: const EdgeInsets.all(8.0),
//                                          child: RaisedButton(
//                                            onPressed: (){
//                                              print(barCodeSearchResults[index].productID.toString());
//                                              stockInProductToUpdate = barCodeSearchResults[index];
//                                              Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                                                return RequestStockInwardQty();
//                                              }));
//                                            },
//                                            child:Container(
//                                                height: 300.0,
//                                                child: Column(children: <Widget>[
//                                                  Expanded(
//                                                    flex:8,
//                                                    child: Text(
//                                                      barCodeSearchResults[index].productID.toString(),
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 20.0
//                                                      ),
//                                                      textAlign: TextAlign.center,
//                                                    ),
//                                                  ),
//                                                  Expanded(
//                                                    flex:8,
//                                                    child: Text(
//                                                      barCodeSearchResults[index].productBarCode.toString(),
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 20.0
//                                                      ),
//                                                      textAlign: TextAlign.center,
//                                                    ),
//                                                  ),
//                                                  Expanded(
//                                                      flex:16,
//                                                      child: Text(
//                                                        barCodeSearchResults[index].productName.toString(),
//                                                        textAlign: TextAlign.center,
//                                                        style:TextStyle(
//                                                          // backgroundColor: Colors.blue,
//                                                          color:Colors.green,
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 24.0,
//                                                        ),
//                                                        maxLines: 3,
//                                                      )
//                                                  ),
//                                                  Expanded(
//                                                    flex:8,
//                                                    child: Text(
//                                                      'Rs.'+ barCodeSearchResults[index].productPrice.toString() +'/-',
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 24.0
//                                                      ),
//                                                      textAlign: TextAlign.center,
//                                                    ),
//                                                  ),
//
//                                                  Expanded(
//                                                    flex:8,
//                                                    child: Text(
//                                                      barCodeSearchResults[index].productCategory,
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 24.0
//                                                      ),
//                                                      textAlign: TextAlign.right,
//                                                    ),
//                                                  ),
//                                                  Expanded(
//                                                    flex:8,
//                                                    child: Text(
//                                                      barCodeSearchResults[index].productBrand,
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 24.0
//                                                      ),
//                                                      textAlign: TextAlign.right,
//                                                    ),
//                                                  ),
//                                                  Expanded(
//                                                    flex:8,
//                                                    child: Text(
//                                                      recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID].recentStockInwardDate,
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 24.0
//                                                      ),
//                                                      textAlign: TextAlign.right,
//                                                    ),
//                                                  ),
//                                                  Expanded(
//                                                    flex:8,
//                                                    child: Text(
//                                                      recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID].recentStockInwardTime,
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 24.0
//                                                      ),
//                                                      textAlign: TextAlign.right,
//                                                    ),
//                                                  ),
//                                                  Expanded(
//                                                    flex:8,
//                                                    child: Text(
//                                                      recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID].recentStockInwardQty.toString(),
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 24.0
//                                                      ),
//                                                      textAlign: TextAlign.right,
//                                                    ),
//                                                  ),
//                                                  Expanded(
//                                                    flex:8,
//                                                    child: Text(
//                                                      recentProductStockInwardDetailsMap[barCodeSearchResults[index].productID].stockInwardQtyTillDate.toString(),
//                                                      style:TextStyle(
//                                                          fontFamily: 'Montserrat',
//                                                          fontWeight: FontWeight.bold,
//                                                          fontSize: 24.0
//                                                      ),
//                                                      textAlign: TextAlign.right,
//                                                    ),
//                                                  ),
//
//                                                ])
//                                            ),
//                                          ),
//                                        );
//                                Padding(
//                                  padding: const EdgeInsets.all(8.0),
//                                  child: InkWell(
//                                    onTap: (){
//                                      print(barCodeSearchResults[index].productID);
//                                    },
//                                    child:
//                                  ),
//                                );
                                    }
                                )
                            )
                        )
                      ],
                    )
                )
            ),
          );
      }
    else
      {
        return    WillPopScope(
          onWillPop:(){
            Navigator.of(context).pop();
            Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return StockInManagerOnline();
                }));
            return;
          },
          child: Scaffold(
              appBar:AppBar(
                automaticallyImplyLeading: false,
                title:Text('STOCK INWARD'),
                centerTitle: true,
                leading: IconButton(
                    icon:Icon(Icons.keyboard_backspace),
                    onPressed:(){
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return StockInManagerOnline();
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
                      child: FlatButton(
                          color:Colors.blue,
                          onPressed:(){
//                          Navigator.of(context).pop();
//                          Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                            return AddNewProduct();
//                          }));
                          },
                          child:Text('CONTACT STORE ADMIN',
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
          ),
        );
      }
    }

}