import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kiranawala_admin/pages/show-brand-sale.dart';
import 'package:kiranawala_admin/pages/show-home-page.dart';
import 'show-sale-position-home.dart';
class ShowBrandSaleResults extends StatefulWidget {
  @override
  _ShowBrandSaleResultsState createState() => _ShowBrandSaleResultsState();
}

List<Widget> saleByProductCodeWidget = [];

class _ShowBrandSaleResultsState extends State<ShowBrandSaleResults> {

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
                fullProductMap[int.parse(productCode)].productName.toString(),
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
                    fullProductMap[int.parse(productCode)].productPrice.toString(),
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
    print('ShowProductSaleByProductCode:productSalePositionByDateAtTerminal:');
    print(productSalePositionByDateAtTerminal);
    productSalePositionByDateAtTerminal.forEach((dynamic key, dynamic a) {
      print('Terminal:' + key.toString() + ':Sale Position By Date:');
      print(a);
      a.forEach((dynamic productCode, dynamic b){
        print('Product Code:' + productCode.toString());
        print(b);
        b.forEach((dynamic key, dynamic value) {
          if (productSalePosition[productCode.toString()] != null) {
            productSalePosition[productCode.toString()] = productSalePosition[productCode.toString()] + value;
          }
          else{
            productSalePosition[productCode.toString()] = value;
          }
        });
      });
    });
    print('productSalePosition:');
    print(productSalePosition);
    getSaleByProductCodeWidget();
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return ShowBrandSalePosition();
            }
          )
        );
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title:Text('PRODUCT-WISE BREAK-DOWN',
            style:TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color:Colors.white
            ),
          ),
          leading: IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute<dynamic>(
                  builder:(BuildContext context){
                    return ShowBrandSalePosition();
                  }
                )
              );
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
      ),
    );
  }
}
