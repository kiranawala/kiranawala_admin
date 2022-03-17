import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
//import 'package:kiranawala_admin/pages/show-home-page.dart';
class ShowProductSaleByProductCode extends StatefulWidget {
  @override
  _ShowProductSaleByProductCodeState createState() => _ShowProductSaleByProductCodeState();
}

List<Widget> saleByProductCodeWidget = [];

class _ShowProductSaleByProductCodeState extends State<ShowProductSaleByProductCode> {

  void getSaleByProductCodeWidget()
  {
    saleByProductCodeWidget = [];
        productSalePosition.forEach((String productCode, double salePosition){
          saleByProductCodeWidget.add(
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color:Colors.black)
              ),
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    fullProductBasicDetailsMap[int.parse(productCode)].productName.toString(),
                    style:TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color:Colors.black
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: Text(
                        fullProductBasicDetailsMap[int.parse(productCode)].productPrice.toString(),
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
                ],
              ),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    print('ShowProductSaleByProductCode:productSalePosition:');
    print(productSalePosition);
    getSaleByProductCodeWidget();
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
          children: saleByProductCodeWidget
        )
      ),
    );
  }
}
