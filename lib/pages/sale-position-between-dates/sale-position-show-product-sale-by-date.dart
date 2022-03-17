import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
//import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-home.dart';
class ShowProductSaleByDate extends StatefulWidget {
  @override
  _ShowProductSaleByDateState createState() => _ShowProductSaleByDateState();
}

List<Widget> saleByDateWidget = [];

class _ShowProductSaleByDateState extends State<ShowProductSaleByDate> {

  void getSaleByDateWidget()
  {
    saleByDateWidget = [];
    stockOutwardByDate.forEach((String date, double salePosition){
          saleByDateWidget.add(
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color:Colors.black)
              ),
              padding: EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: Text(
                    date,
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
    getSaleByDateWidget();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:Text('SALE POSITION BY DATE',
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
          children: saleByDateWidget
        )
      ),
    );
  }
}
