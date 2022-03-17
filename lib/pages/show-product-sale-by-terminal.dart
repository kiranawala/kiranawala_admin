import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'show-sale-position-home.dart';
class ShowProductSaleByTerminal extends StatefulWidget {
  @override
  _ShowProductSaleByTerminalState createState() => _ShowProductSaleByTerminalState();
}

List<Widget> saleByTerminalWidget = [];

class _ShowProductSaleByTerminalState extends State<ShowProductSaleByTerminal> {

  void getSaleByTerminalWidget()
  {
    saleByTerminalWidget = [];
        terminalSalePosition.forEach((String terminal, double salePosition){
          saleByTerminalWidget.add(
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color:Colors.black)
              ),
              padding: EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text(
                    terminal,
                    style:TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color:Colors.black
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  child: Text(
                    salePosition.toStringAsFixed(0),
                    style:TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color:Colors.black
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
              ),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    getSaleByTerminalWidget();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:Text('SALE POSITION BY TERMINAL',
          style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color:Colors.white
          ),
        ),
        leading: IconButton(
          icon:Icon(Icons.keyboard_backspace),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child:
        ListView(
          children: saleByTerminalWidget
        )
      ),
    );
  }
}
