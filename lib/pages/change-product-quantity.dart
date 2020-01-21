import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/nila-point-of-sale.dart';

class ChangeBilledProductQty extends StatefulWidget {
  @override
  _ChangeBilledProductQtyState createState() => _ChangeBilledProductQtyState();
}

class _ChangeBilledProductQtyState extends State<ChangeBilledProductQty> {

  @override
  void initState() {    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHANGE QUANTITY',
          style:TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
            ),
          ),
        automaticallyImplyLeading: false,
        leading: new IconButton(
         icon: new Icon(
            Icons.arrow_back, color: Colors.orange
            ),
            onPressed: (){ 
              // updateProductInCart();              
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return NilaPointOfSale();
              }));
            },
          ), 
        ),        
      body:Center(
        child: Column(
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(cartProductToUpdate['productName'],
             style:TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
              ),),
          ),
          Row(
            children:<Widget>[
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('PRICE',
               style:TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(cartProductToUpdate['productPrice'].toString(),
                style:TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                ),),
            ),
            ]         
        ),
           Row(
             children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Bill Amount',
                  style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cartProductToUpdate['productBillAmount'].toString(),
                  style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  ),
                ),
              ),
             ],               
           ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon:Icon(Icons.remove,
                    size: 48.0,),
                     onPressed: (){
                       setState(() {
                        cartProductToUpdate['productBilledQty'] = cartProductToUpdate['productBilledQty'] - 1;   
                        cartProductToUpdate['productBillAmount'] = cartProductToUpdate['productBillAmount'] - cartProductToUpdate['productPrice'];
                        productCodeCartEntryMap[cartProductCodeToUpdate] = cartProductToUpdate;
                        cartProducts = [];
                        productCodeCartEntryMap.forEach((code, entry){
                        cartProducts.add({
                          'productCode':entry['productCode'], 
                          'productBarCode': entry['productBarCode'],
                          'productName':entry['productName'],
                          'productPrice':entry['productPrice'],                                                                                                                                             
                          'productCategory':entry['productCategory'], 
                          'productBrand':entry['productBrand'],
                          'productBilledQty':entry['productBilledQty'],                                              
                          'productBillAmount':entry['productBillAmount'],                                                                                                                    
                        });

  });
  invoiceEntry['billedProducts'] = cartProducts;
                        cartTotal = cartTotal - cartProductToUpdate['productPrice'];
                        itemCount = itemCount - 1;
                        if(cartProductToUpdate['productBilledQty'] == 0)
                        {
                          removeProductFromCart(cartProductCodeToUpdate);
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                            return NilaPointOfSale();
                          }));
                        }
                      });    
                  },
                    ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(cartProductToUpdate['productBilledQty'].toString(),
                  textAlign: TextAlign.center,
                  style:TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                    ),
                  ),
            ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: (){
                    setState(() {
                      addProductToCart(
                        cartProductToUpdate['productCode'], 
                        cartProductToUpdate['productBarCode'], 
                        cartProductToUpdate['productName'],
                        cartProductToUpdate['productPrice'], 
                        cartProductToUpdate['productCategory'], 
                        cartProductToUpdate['productBrand'], 
                        cartProductToUpdate['productBilledQty'], 
                        cartProductToUpdate['productBillAmount']);
                      // cartProductToUpdate['productBilledQty'] = cartProductToUpdate['productBilledQty'] + 1;
                      // cartProductToUpdate['productBillAmount'] = cartProductToUpdate['productBillAmount'] + cartProductToUpdate['productPrice'];
                      // itemCount = itemCount + 1;
                      // cartTotal = cartTotal + cartProductToUpdate['productPrice'];
                    });                    
                  },
                  icon:Icon(
                    Icons.add,
                    size:48.0,              
                  )
                ),
              ),
            )
          ],
          ),
          FlatButton(
            color: Colors.blue,
            child: Text('PROCEED'),
            onPressed: (){
              // updateProductInCart();
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return NilaPointOfSale();
              }));
            },)
          
        ],),
      )

    );
  }
}