import 'package:flutter/material.dart';

import '../main.dart';
import 'show-final-bill.dart';
import 'nila-point-of-sale.dart';

class AddCarryBag extends StatefulWidget {
  @override
  _AddCarryBagState createState() => _AddCarryBagState();
}

class _AddCarryBagState extends State<AddCarryBag> {  
  String selectedCarryBag;
  bool carryBagSelected = false;
  @override
  void initState() {
    super.initState(); 
  }
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: new IconButton(
         icon: new Icon(
            Icons.arrow_back, color: Colors.orange
            ),
            onPressed: (){ 
              processingBill = false;
            Navigator.of(context).pop();
            },
          ), 
        centerTitle: true,
        title: Text(
          'CARRY BAG',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),        
      ),
      body:Center(
              child: Column(
          mainAxisAlignment: MainAxisAlignment.center,          
          
          children: <Widget>[
           DropdownButton(
              hint: Text('Select Carry Bag'), // Not necessary for Option 1
              value: selectedCarryBag,
              onChanged: (newValue) {
                setState(() {
                  selectedCarryBag = newValue;  
                  carryBagSelected = true;                
                });
              },
              underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
              items: carryBags.map((String carryBag) {
                return DropdownMenuItem(
                  child: new Text(carryBag),
                  value: carryBag,
                );
              }).toList(),
            ),
            RaisedButton(
              color: Colors.purpleAccent,
              onPressed: (){
                if(carryBagSelected)
                {                  
                  addProductToCart(
                    int.parse(carryBagMap[selectedCarryBag]['productCode'].toString()),
                    carryBagMap[selectedCarryBag]['productBarCode'].toString(),
                    carryBagMap[selectedCarryBag]['productName'].toString(),
                    double.parse(carryBagMap[selectedCarryBag]['productPrice'].toString()),
                    carryBagMap[selectedCarryBag]['productCategory'].toString(),
                    carryBagMap[selectedCarryBag]['productBrand'].toString(),
                    1,
                    double.parse(carryBagMap[selectedCarryBag]['productPrice'].toString()),
                  );

                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                    return ShowFinalBill();
                  }));
                }              
              },
              child:Text(
                'PROCEED',
                style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize:14.0,
                )
              )
            )
          ],
          

        ),
      ),
    );
  }
}