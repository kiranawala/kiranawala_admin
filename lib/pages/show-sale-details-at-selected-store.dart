import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

class ShowSaleDetailsAtSelectedStore extends StatefulWidget {
  @override
  _ShowSaleDetailsAtSelectedStoreState createState() => _ShowSaleDetailsAtSelectedStoreState();
}

class _ShowSaleDetailsAtSelectedStoreState extends State<ShowSaleDetailsAtSelectedStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          storeIdNameMap[
          selectedStore],
          style: TextStyle(
              color: Colors.white,
            fontSize: 14.0,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold
          ),
        ),
        leading:IconButton(
          icon:Icon(Icons.keyboard_backspace),
          onPressed:(){
            Navigator.of(context).pop();
          },
        )
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child:Row(
              children: <Widget>[
                Expanded(
                  flex:4,
                  child: Text('Total Sale:',
                    style: TextStyle(color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                    ),),
                ),
                Expanded(
                  flex:2,
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
                  flex:4,
                  child: RaisedButton(
                    onPressed:(){
//                        Navigator.of(context).pop();
//                        Navigator.of(context).push<dynamic>(
//                            MaterialPageRoute<dynamic>(
//                                builder:(BuildContext context){
//                                  return DailySalePerStore();
//                                }
//                            )
//                        );
                    },
                    child: Text( saleDetailsAtStore[selectedStore]['totalSale'].toStringAsFixed(0),
                      style: TextStyle(color: Colors.deepOrangeAccent,
                          fontSize: 30.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child:Row(
              children: <Widget>[
                Expanded(
                  flex:6,
                  child: Text('Total Walkins:',
                    style: TextStyle(color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                    ),),
                ),
                Expanded(
                  flex:4,
                  child: Text(saleDetailsAtStore[selectedStore]['totalWalkins'].toStringAsFixed(0),
                    style: TextStyle(color: Colors.black,
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child:Row(
              children: <Widget>[
                Expanded(
                  flex:4,
                  child: Text('Cash Sale:',
                    style: TextStyle(color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                    ),),
                ),
                Expanded(
                  flex:2,
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
                  flex:4,
                  child: Text(saleDetailsAtStore[selectedStore]['cashSale'].toStringAsFixed(0),
                    style: TextStyle(color: Colors.deepOrangeAccent,
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child:Row(
              children: <Widget>[
                Expanded(
                  flex:4,
                  child: Text('Bank Card Sale:',
                    style: TextStyle(color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                    ),),
                ),
                Expanded(
                  flex:2,
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
                  flex:4,
                  child: Text( saleDetailsAtStore[selectedStore]['bankCardSale'].toStringAsFixed(0),
                    style: TextStyle(color: Colors.deepOrangeAccent,
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child:Row(
              children: <Widget>[
                Expanded(
                  flex:4,
                  child: Text('UPI Sale:',
                    style: TextStyle(color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                    ),),
                ),
                Expanded(
                  flex:2,
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
                  flex:4,
                  child: Text(saleDetailsAtStore[selectedStore]['upiSale'].toStringAsFixed(0),
                    style: TextStyle(color: Colors.deepOrangeAccent,
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child:Row(
              children: <Widget>[
                Expanded(
                  flex:4,
                  child: Text('eWallet Sale:',
                    style: TextStyle(color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                    ),),
                ),
                Expanded(
                  flex:2,
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
                  flex:4,
                  child: Text( saleDetailsAtStore[selectedStore]['eWalletSale'].toStringAsFixed(0),
                    style: TextStyle(color: Colors.deepOrangeAccent,
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(border: Border.all(color:Colors.black), borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child:Row(
              children: <Widget>[
                Expanded(
                  flex:4,
                  child: Text('Food Card Sale:',
                    style: TextStyle(color: Colors.black,
                      fontSize: 20.0,
                      fontFamily: 'Montserrat',
//                    fontWeight: FontWeight.bold
                    ),),
                ),
                Expanded(
                  flex:2,
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
                  flex:4,
                  child: Text(saleDetailsAtStore[selectedStore]['foodCardSale'].toStringAsFixed(0),
                    style: TextStyle(color: Colors.deepOrangeAccent,
                        fontSize: 30.0,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

