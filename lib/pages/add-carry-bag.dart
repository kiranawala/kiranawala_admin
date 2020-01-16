import 'package:flutter/material.dart';

import '../main.dart';
import 'show-final-bill.dart';

class AddCarryBag extends StatefulWidget {
  @override
  _AddCarryBagState createState() => _AddCarryBagState();
}

class _AddCarryBagState extends State<AddCarryBag> {

  // List<String> carryBags = [];
  String selectedCarryBag;
  bool carryBagSelected = false;
  @override
  void initState() {
    super.initState();
    // carryBags.add('SMALL');
    // carryBags.add('MEDIUM');
    // carryBags.add('LARGE');
    // carryBags.add('XTRA-LARGE');
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
                  print(invoiceEntry);
                  print(selectedCarryBag);
                  print(carryBagMap[selectedCarryBag]['productName']);  
                  List<dynamic> billedProducts = invoiceEntry['billedProducts'];  

                  itemCount = itemCount + 1;
                  productCount = productCount + 1;
                  cartTotal = cartTotal + double.parse(carryBagMap[selectedCarryBag]['productPrice'].toString());

                  invoiceEntry['itemCount'] = itemCount;
                  invoiceEntry['productCount'] = productCount;
                  invoiceEntry['cartTotal'] = cartTotal;

                  // print(billedProducts);
                  billedProducts.add(carryBagMap[selectedCarryBag]);
                  // print(billedProducts);
                  invoiceEntry['billedProducts'] = billedProducts;
                  print(invoiceEntry);
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
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(
      //       icon:Icon(Icons.arrow_forward),
      //       title: Text(
      //         'PROCEED'
      //       )
      //     ),
      //     BottomNavigationBarItem(
      //       icon:Icon(Icons.arrow_back),
      //       title: Text(
      //         'GO BACK'
      //       )
      //     ),
      //   ],
      //    onTap: (index) {
      //       switch (index) {
      //         case 0:
      //           print(selectedCarryBag);
      //           print(carryBagMap[selectedCarryBag]['productName']);  
      //           print(invoiceEntry);  
      //           // List<dynamic> x = invoiceEntry['billedProducts'];  
      //           // print(x);
      //           // x.add(carryBagMap[selectedCarryBag]);
      //           // print(x);
      //         break;
      //         case 0:
      //         break;
      //         // Navigator.push(context, MaterialPageRoute(builder: (context) {
      //         //   return HomePageListViewSearch();
      //         // }));
      //       }
      //     },
       
        
      // ),
        
    );
  }
}