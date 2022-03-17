import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-add-product-get-barcode.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-product-lookup.dart';
class InventoryManagerAddProductRequestBarCode extends StatefulWidget {
  @override
  _InventoryManagerAddProductRequestBarCodeState createState() => _InventoryManagerAddProductRequestBarCodeState();
}
class _InventoryManagerAddProductRequestBarCodeState extends State<InventoryManagerAddProductRequestBarCode> {
  String barCode = '';
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: (){
//          retrievingProductDetails = false;
          Navigator.of(context).pop();
          Navigator.of(context).push<dynamic>(
            MaterialPageRoute<dynamic>(
              builder:(BuildContext context){
                return InventoryManagerAddProductGetBarCode();
              }
            )
          );
          return;
        },
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading:IconButton(
                  icon:Icon(Icons.keyboard_backspace),
                  onPressed: (){
//                    retrievingProductDetails = false;
                    Navigator.of(context).pop();
                    Navigator.of(context).push<dynamic>(
                        MaterialPageRoute<dynamic>(
                            builder:(BuildContext context){
                              return InventoryManagerAddProductGetBarCode();
                            }
                        )
                    );
                  },
                )
            ),
            body:Container(
                width:MediaQuery.of(context).size.width,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      keyboardType: TextInputType.text,
                      style:TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight:FontWeight.bold,
                        fontSize: 24.0,
                        color:Colors.black,
                      ),
                      autofocus: true,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.black,
                      cursorWidth: 8.0,
                      decoration: InputDecoration(
                          hintText: 'BARCODE',
                          hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold)),
                      onChanged: (value) {
                        barCode = value;
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          color:Colors.blue,
                          onPressed:(){
                            Navigator.of(context).pop(barCode);
                          },
                          child:Text('CONFIRM',
                              style:TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight:FontWeight.bold,
                                fontSize: 24.0,
                                color:Colors.white,
                              ))
                      ),
                    )
                  ],
                )

            )
        ),
      );
  }
}
