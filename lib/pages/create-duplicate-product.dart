import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/barcode-manual-search.dart';

class CreateDuplicateProduct extends StatefulWidget {
  @override
  _CreateDuplicateProductState createState() => _CreateDuplicateProductState();
}

class _CreateDuplicateProductState extends State<CreateDuplicateProduct> {
  String duplicatedProductPrice = '';
  String duplicatedProductPriceHint = 'DUPLICATE PRODUCT';

  int nextProductCode;
  String nextBarCode;
  // String newProductName;
  double newProductPrice = 0.0;
  String newProductPriceHint = '';

  bool nextProductCodeAvailable = false;

  @override
  void initState() {
    super.initState();
    // this.newProductName = productToDuplicate.productName;
    this.newProductPrice = productToDuplicate.productPrice;
    getNextProductCode();     
  }

  getNextProductCode() async{
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
            }
          });
  }


  @override
  Widget build(BuildContext context) {

  if(!nextProductCodeAvailable)
  {
    return Scaffold(
      appBar: AppBar(title: Text('Create Duplicate'),),
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
                child: Text("Generating next product code.....")
              ),
            ],
          ),
        ),
      )
    ); 
  }
  else
  {
      return Scaffold(
        appBar: AppBar(title:Text('Add New Product')),
              body: Container(
                height: MediaQuery.of(context).size.height/2,
                child: Column(
                  children: [
                    Expanded(
                      child: Text(barCodeToSearch),
                      ),
                    Expanded(
                      child: Text(this.nextProductCode.toString(),
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.0,
                            color: Colors.blue)),
                  ),
                    // Expanded(
                    //     child: Text('Product Name',
                    //       style: TextStyle(
                    //        fontFamily: 'Montserrat',
                    //           fontSize: 12.0,
                    //           color: Colors.blue)),
                    // ),
                    // Expanded(
                    //       child: TextField(  
                    //         textAlign: TextAlign.center,
                    //         decoration: InputDecoration(
                    //           hintText: productToDuplicate.productName,
                    //           // icon: Icon(Icons.camera_alt),
                    //         ),
                    //         keyboardType: TextInputType.text,                             
                    //         autofocus: true,
                    //         onChanged: (value) {
                    //           print('product name changed');
                    //           this.newProductName = value;
                    //           productToDuplicate.productName = value;
                    //         },
                    //       ),
                    // ),
                    // Expanded(
                    //   child: Text('Product Price',
                    //     style: TextStyle(
                    //         fontFamily: 'Montserrat',
                    //         fontSize: 12.0,
                    //         color: Colors.blue)),
                    // ),
                    Expanded(
                      child: TextField( 
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: productToDuplicate.productPrice.toString(),
                          // icon: Icon(Icons.camera_alt),
                        ),
                        keyboardType: TextInputType.number,                              
                        autofocus: true,
                        onChanged: (value) {
                          if(value != '')
                            this.newProductPrice = double.parse(value);
                        },
                      ),
                    ),
                     Expanded(
                          child: FlatButton(   
                            color: Colors.blue,
                            child:Text('ADD DUPLICATE'),
                            onPressed: ()
                            {
                                  // this.newProductNameMessage = 'Product Name OK';
                                  if(this.newProductPrice > 0)
                                  {
                                    // this.newProductPriceMessage = 'Product Price OK';
                                    FirebaseDatabase
                                      .instance
                                      .reference()
                                      .child('stores')
                                      .child('KIRANAWALA_STORE_2')
                                      .child('products')
                                      .child(this.nextProductCode.toString())
                                      .update({
                                        'barcode':productToDuplicate.productBarCode.toLowerCase(),
                                        'productcode':this.nextProductCode,
                                        'title':productToDuplicate.productName,
                                        'price':this.newProductPrice,
                                        'category':productToDuplicate.productCategory,
                                        'brand':productToDuplicate.productBrand,
                                        'imageurl':productToDuplicate.productImageURL,
                                        'stockposition':0,
                                      })
                                      .then((value){
                                        print('Product Added Successfully.');
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
                                            // barCodeSearchResults = [];
                                            barCodeSearchResults.add(new ProductStockPosition(
                                                                      productToDuplicate.productName, 
                                                                      newProductPrice, 
                                                                      int.parse(nextProductCode.toString()), 
                                                                      productToDuplicate.productBarCode.toLowerCase(), 
                                                                      productToDuplicate.productImageURL, 
                                                                      productToDuplicate.productCategory, 
                                                                      productToDuplicate.productBrand,
                                                                      0.0,                                              
                                                                      0.0,                                              
                                                                      0.0, 
                                                                    )
                                                                );
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                              return BarCodeManualSearch();
                                            }));
                                          });                                                                  
                                      })
                                      .catchError((onError){
                                        print('Product Could not be added. Try Again!!');
                                        // Navigator.of(context).pop();
                                      });
                                  }
                                  else
                                  {
                                    setState(() {
                                      newProductPriceHint = 'INVALID PRICE';
                                    });
                                    print('Invalid Price!!');
                                  }                                                            
                            },                   
                          ),
                    ),
                  ]
                ),
              ),
      );
  }
  }
}