import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'nila-point-of-sale.dart';

class BillProductNoBarCode extends StatefulWidget {
  @override
  _BillProductNoBarCodeState createState() => _BillProductNoBarCodeState();
}

class _BillProductNoBarCodeState extends State<BillProductNoBarCode> {
  bool nextProductCodeAvailable = false;
  int nextProductCode = 0;
  double productPrice = 0.0;

  getNextProductCode() async{
    this.nextProductCodeAvailable = false;
    FirebaseDatabase
          .instance
          .reference()
          .child('stores')
          .child('KIRANAWALA_STORE_2')
          .child('latestProductCode')
          .once()
          .then((snapshot){
            if(snapshot != null && snapshot.value != null)
            {
              print(snapshot.value);
              print(snapshot.value['productCode']);
              print('Extracting product code now.');
              int lastProductCode = int.parse(snapshot.value['productCode'].toString());
              this.nextProductCode = lastProductCode + 1;
              setState(() {
                this.nextProductCodeAvailable = true;
              }); 

              FirebaseDatabase
                .instance
                .reference()
                .child('stores')
                .child('KIRANAWALA_STORE_2')
                .child('latestProductCode')
                .update(
                  {
                    'productCode':this.nextProductCode
                  }
                ).then((onValue){
                  print('latest product code added to firebase successfully');             
                });
            }
          });
  }

  @override
  void initState() {
    super.initState();
    getNextProductCode();
  }

  @override
  Widget build(BuildContext context) {
    if(nextProductCodeAvailable)
    {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:Text(
            'ADD DUMMY PRODUCT',
            style:TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 14.0
            )          
          )),
        body:                          
          Column(
            children: <Widget>[
              Expanded(
                child:Text(
                        nextProductCode.toString(),
                        style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                        )
                      ),
              ),
              Expanded(
                child: 
                  TextField(
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Product Price',
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize:16.0,
                        fontWeight: FontWeight.bold
                        )
                    ),
                    onChanged: (value){
                      if(double.parse(value) > 0){
                        productPrice = double.parse(value);
                      }
                    },
                  )
                ), 
                FlatButton(
                  color:Colors.blue,
                  child: Text('PROCEED',
                    style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize:16.0,
                          fontWeight: FontWeight.bold
                          )),
                  onPressed: () {
                    if(productPrice > 0)
                    {                                         

                      addProductToCart(
                        nextProductCode, 
                        nextProductCode.toString(), 
                        nextProductCode.toString(), 
                        productPrice, 
                        'NOCATEGORY', 
                        'NOBRAND', 
                        1, 
                        productPrice
                        );         
                        Navigator.of(context).pop();                                   
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return NilaPointOfSale();
                        }));
                    }
                  },
                ),                                                                            
              ],
            ), 
          );
    }
    else
    {
        return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:Text(
            'ADD DUMMY PRODUCT',
            style:TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 14.0
            )          
          )),
          body: 
            Container(
        color: Colors.white,
        child: Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex:2,
                child: new CircularProgressIndicator()
              ),
              SizedBox(width:10.0),
              Expanded(
                flex:12,
                child: Text("Generating Product Code..")
              ),
            ],
          ),
        ),
      ),
      );
    }

  }
}