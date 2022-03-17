import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';
import 'package:kiranawala_admin/pages/show-bills-for-selected-store.dart';
import 'package:kiranawala_admin/pages/show-sale-details-at-selected-store.dart';

class ShowDailySalePerStore extends StatefulWidget {
  @override
  _ShowDailySalePerStoreState createState() => _ShowDailySalePerStoreState();
}

class _ShowDailySalePerStoreState extends State<ShowDailySalePerStore> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stores.forEach((store)
    {
      print(store);
      double cashSale = 0;
      double bankCardSale = 0;
      double foodCardSale = 0;
      double upiSale = 0;
      double eWalletSale = 0;
      double totalSale = 0;
      int totalWalkins = 0;


        storeIdTerminalMap[store].forEach((terminal) {
          print(terminal);
          print(saleDetailsAtTerminal[terminal]);
          cashSale = cashSale + double.parse(saleDetailsAtTerminal[terminal]['cashSale'].toString());
          bankCardSale = bankCardSale + double.parse(saleDetailsAtTerminal[terminal]['bankCardSale'].toString());
          foodCardSale = foodCardSale + double.parse(saleDetailsAtTerminal[terminal]['foodCardSale'].toString());
          upiSale = upiSale + double.parse(saleDetailsAtTerminal[terminal]['upiSale'].toString());
          eWalletSale = eWalletSale + double.parse(saleDetailsAtTerminal[terminal]['eWalletSale'].toString());
          totalSale = totalSale + double.parse(saleDetailsAtTerminal[terminal]['totalSale'].toString());
          totalWalkins = totalWalkins + int.parse(saleDetailsAtTerminal[terminal]['totalWalkins'].toString());
        });
        saleDetailsAtStore[store] = {
          'cashSale':cashSale,
          'bankCardSale':bankCardSale,
          'foodCardSale':foodCardSale,
          'eWalletSale':eWalletSale,
          'upiSale':upiSale,
          'totalSale':totalSale,
          'totalWalkins':totalWalkins
        };
        print(saleDetailsAtStore);
      });


  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
                builder:(BuildContext context){
                  return ShowAdminHomePage();
                }
            )
        );
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed: (){
              Navigator.of(context).pop();
                Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                        builder:(BuildContext context){
                          return ShowAdminHomePage();
                        }
                    )
                );
            },
          ),
        ),
        body:

            Center(
              child: ListView.builder(
                shrinkWrap: true,
//              scrollDirection: Axis.horizontal,
                itemCount:stores.length,
                itemBuilder: (BuildContext context, int index){
                  return

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(
                          color:Colors.black
                        )
                      ),
                        child:Row(
                          children: <Widget>[
                            Expanded(
                              flex:9,
                              child:RaisedButton(
                                onPressed:(){
                                  selectedStore = stores[index].toString();
                                  Navigator.of(context).push<dynamic>(
                                    MaterialPageRoute<dynamic>(
                                      builder:(BuildContext context){
                                        return ShowSaleDetailsAtSelectedStore();
                                      }
                                    )
                                  );
                                },
                                child: Text(
                                  storeIdNameMap[stores[index].toString()],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex:1,
                              child: Text('\u20B9 ',
                                style: TextStyle(color: Colors.black,
                                    fontSize: 30.0,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Expanded(
                              flex:6,
                              child:RaisedButton(
                                onPressed: (){
                                  selectedStore = stores[index].toString();
                                  Navigator.of(context).push<dynamic>(
                                    MaterialPageRoute<dynamic>(
                                      builder:(BuildContext context){
                                        return ShowBillsForSelectedStore();
                                      }
                                    )
                                  );
                                },
                                child: Text(
                                  saleDetailsAtStore[stores[index]]['totalSale'].toStringAsFixed(0),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30.0,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        )
                    );

//                  Container
//                    (
//                      child:
//
//                      Column(
//                        children: <Widget>[
//                          Container(
//                              width: MediaQuery.of(context).size.width,
//                              child:Text(storeIdNameMap[stores[index].toString()],
//                                style: TextStyle(color: Colors.black,
//                                  fontSize: 30.0,
//                                  fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
//                                ),
//                                textAlign: TextAlign.center,
//                              )
//                          ),
//                          Container(
//                            width: MediaQuery.of(context).size.width,
//                            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                            child:Row(
//                              children: <Widget>[
//                                Expanded(
//                                  flex:4,
//                                  child: Text('Total Sale:',
//                                    style: TextStyle(color: Colors.black,
//                                      fontSize: 20.0,
//                                      fontFamily: 'Montserrat',
////                    fontWeight: FontWeight.bold
//                                    ),),
//                                ),
//                                Expanded(
//                                  flex:2,
//                                  child: Text('\u20B9 ',
//                                    style: TextStyle(color: Colors.black,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold
//                                    ),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                ),
//                                Expanded(
//                                  flex:4,
//                                  child: RaisedButton(
//                                    onPressed:(){
//                                      Navigator.of(context).pop();
//                                      Navigator.of(context).push<dynamic>(
//                                          MaterialPageRoute<dynamic>(
//                                              builder:(BuildContext context){
//                                                return DailySalePerStore();
//                                              }
//                                          )
//                                      );
//                                    },
//                                    child: Text( saleDetailsAtStore[stores[index]]['totalSale'].toStringAsFixed(0),
//                                      style: TextStyle(color: Colors.deepOrangeAccent,
//                                          fontSize: 30.0,
//                                          fontFamily: 'Montserrat',
//                                          fontWeight: FontWeight.bold),
//                                      textAlign: TextAlign.right,
//                                    ),
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                          Container(
//                            width: MediaQuery.of(context).size.width,
//                            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                            child:Row(
//                              children: <Widget>[
//                                Expanded(
//                                  flex:6,
//                                  child: Text('Total Walkins:',
//                                    style: TextStyle(color: Colors.black,
//                                      fontSize: 20.0,
//                                      fontFamily: 'Montserrat',
////                    fontWeight: FontWeight.bold
//                                    ),),
//                                ),
//                                Expanded(
//                                  flex:4,
//                                  child: Text(saleDetailsAtStore[stores[index]]['totalWalkins'].toStringAsFixed(0),
//                                    style: TextStyle(color: Colors.black,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                          Container(
//                            width: MediaQuery.of(context).size.width,
//                            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                            child:Row(
//                              children: <Widget>[
//                                Expanded(
//                                  flex:4,
//                                  child: Text('Cash Sale:',
//                                    style: TextStyle(color: Colors.black,
//                                      fontSize: 20.0,
//                                      fontFamily: 'Montserrat',
////                    fontWeight: FontWeight.bold
//                                    ),),
//                                ),
//                                Expanded(
//                                  flex:2,
//                                  child: Text('\u20B9 ',
//                                    style: TextStyle(color: Colors.black,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold
//                                    ),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                ),
//                                Expanded(
//                                  flex:4,
//                                  child: Text(saleDetailsAtStore[stores[index]]['cashSale'].toStringAsFixed(0),
//                                    style: TextStyle(color: Colors.deepOrangeAccent,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                          Container(
//                            width: MediaQuery.of(context).size.width,
//                            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                            child:Row(
//                              children: <Widget>[
//                                Expanded(
//                                  flex:4,
//                                  child: Text('Bank Card Sale:',
//                                    style: TextStyle(color: Colors.black,
//                                      fontSize: 20.0,
//                                      fontFamily: 'Montserrat',
////                    fontWeight: FontWeight.bold
//                                    ),),
//                                ),
//                                Expanded(
//                                  flex:2,
//                                  child: Text('\u20B9 ',
//                                    style: TextStyle(color: Colors.black,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold
//                                    ),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                ),
//                                Expanded(
//                                  flex:4,
//                                  child: Text( saleDetailsAtStore[stores[index]]['bankCardSale'].toStringAsFixed(0),
//                                    style: TextStyle(color: Colors.deepOrangeAccent,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                          Container(
//                            width: MediaQuery.of(context).size.width,
//                            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                            child:Row(
//                              children: <Widget>[
//                                Expanded(
//                                  flex:4,
//                                  child: Text('UPI Sale:',
//                                    style: TextStyle(color: Colors.black,
//                                      fontSize: 20.0,
//                                      fontFamily: 'Montserrat',
////                    fontWeight: FontWeight.bold
//                                    ),),
//                                ),
//                                Expanded(
//                                  flex:2,
//                                  child: Text('\u20B9 ',
//                                    style: TextStyle(color: Colors.black,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold
//                                    ),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                ),
//                                Expanded(
//                                  flex:4,
//                                  child: Text(saleDetailsAtStore[stores[index]]['upiSale'].toStringAsFixed(0),
//                                    style: TextStyle(color: Colors.deepOrangeAccent,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                          Container(
//                            width: MediaQuery.of(context).size.width,
//                            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                            child:Row(
//                              children: <Widget>[
//                                Expanded(
//                                  flex:4,
//                                  child: Text('eWallet Sale:',
//                                    style: TextStyle(color: Colors.black,
//                                      fontSize: 20.0,
//                                      fontFamily: 'Montserrat',
////                    fontWeight: FontWeight.bold
//                                    ),),
//                                ),
//                                Expanded(
//                                  flex:2,
//                                  child: Text('\u20B9 ',
//                                    style: TextStyle(color: Colors.black,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold
//                                    ),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                ),
//                                Expanded(
//                                  flex:4,
//                                  child: Text( saleDetailsAtStore[stores[index]]['eWalletSale'].toStringAsFixed(0),
//                                    style: TextStyle(color: Colors.deepOrangeAccent,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                          Container(
//                            width: MediaQuery.of(context).size.width,
//                            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                            child:Row(
//                              children: <Widget>[
//                                Expanded(
//                                  flex:4,
//                                  child: Text('Food Card Sale:',
//                                    style: TextStyle(color: Colors.black,
//                                      fontSize: 20.0,
//                                      fontFamily: 'Montserrat',
////                    fontWeight: FontWeight.bold
//                                    ),),
//                                ),
//                                Expanded(
//                                  flex:2,
//                                  child: Text('\u20B9 ',
//                                    style: TextStyle(color: Colors.black,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold
//                                    ),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                ),
//                                Expanded(
//                                  flex:4,
//                                  child: Text(saleDetailsAtStore[stores[index]]['foodCardSale'].toStringAsFixed(0),
//                                    style: TextStyle(color: Colors.deepOrangeAccent,
//                                        fontSize: 30.0,
//                                        fontFamily: 'Montserrat',
//                                        fontWeight: FontWeight.bold),
//                                    textAlign: TextAlign.right,
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                        ],
//                      ));
                },
              ),
            )


      ),
    );
  }
}
