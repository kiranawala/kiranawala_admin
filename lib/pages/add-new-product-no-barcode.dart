import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/main.dart' as prefix0;
import 'package:kiranawala_admin/pages/barcode-manual-search.dart';
import 'package:kiranawala_admin/pages/select-product-category.dart';

import 'select-product-brand.dart';

class AddNewProductNoBarcode extends StatefulWidget {
  @override
  _AddNewProductNoBarcodeState createState() => _AddNewProductNoBarcodeState();
}

class _AddNewProductNoBarcodeState extends State<AddNewProductNoBarcode> {

  int nextProductCode;
  String nextBarCode;
  String newProductName;
  String newProductPrice;


  List<Brand> brands = [];
  List<Brand> brandSearchResults = [];
  Brand selectedBrand;

  bool retrievingBrands = false;  

  bool nextProductCodeAvailable = false;

    generateBarCode(String code)
  {  
    int checkSum = this.checkSum(code);
    return code + '' + checkSum.toString();
  }

  int checkSum(String productCode)
  {

    int sum = 0;

        int N1 = int.parse(productCode.substring(0,1));
        int N2 = int.parse(productCode.substring(1,2));
        int N3 = int.parse(productCode.substring(2,3));
        int N4 = int.parse(productCode.substring(3,4));
        int N5 = int.parse(productCode.substring(4,5));
        int N6 = int.parse(productCode.substring(5,6));
        int N7 = int.parse(productCode.substring(6,7));
        int N8 = int.parse(productCode.substring(7,8));
        int N9 = int.parse(productCode.substring(8,9));
        int N10 = int.parse(productCode.substring(9,10));
        int N11= int.parse(productCode.substring(10,11));
        int N12= int.parse(productCode.substring(11,12));

        sum = N1 + N2*3 + N3 + N4*3 + N5 + N6*3 + N7 + N8*3 + N9 + N10*3 + N11 + N12*3;

        double div = (sum * 1.0)/10;
        int ceilDiv = div.ceil();
        int checkSum = (ceilDiv * 10) - sum;        
        return checkSum;
}

  @override
  void initState() {
    super.initState();
    selectedCategoryName = 'NOCATEGORY';
    selectedBrandName = 'NOBRAND';
    getNextProductCode();     
    // getProductCategories();
    // getProductBrands();
  }

  
  // void getProductBrands() async{
  //   retrievingBrands = true;

  //   FirebaseDatabase
  //   .instance
  //   .reference()
  //   .child('brands')
  //   .once()
  //   .then((productBrandsSnapshot){
  //     if(productBrandsSnapshot != null && productBrandsSnapshot.value != null)
  //     {
  //       print('Product Brands Child Node Available');
  //       print(productBrandsSnapshot.value);
  //       Map<dynamic, dynamic> brandList = productBrandsSnapshot.value;
  //       brandList.forEach((key,value){
  //         print(key.toString());
  //         print(value['name']);
  //         brands.add(new Brand(key.toString(),value['name'].toString()));
  //       });

  //       brands.sort((a,b){
  //         return (
  //           a.brandName.compareTo(b.brandName)
  //         ); 
  //       });

  //       setState(() {
  //         retrievingBrands = false;
  //         brandSearchResults = brands;
  //       });
  //     }
  //     else
  //     {
  //       print('Product Brands Child Not Available');        
  //       setState(() {
  //         retrievingBrands = false;
  //       });
  //     }

  //   });
  // }

  // List<Category> categories = [];
  // List<Category> categorySearchResults = [];
  // Category selectedCategory;

  // bool retrievingCategories = false;  

  // void getProductCategories() async{
  //   retrievingCategories = true;

  //   FirebaseDatabase
  //   .instance
  //   .reference()
  //   .child('categories')
  //   .once()
  //   .then((productCategoriesSnapshot){
  //     if(productCategoriesSnapshot != null && productCategoriesSnapshot.value != null)
  //     {
  //       print('Product Categories Child Node Available');
  //       print(productCategoriesSnapshot.value);
  //       Map<dynamic, dynamic> categoryList = productCategoriesSnapshot.value;
  //       categoryList.forEach((key,value){
  //         print(key.toString());
  //         print(value['name']);
  //         categories.add(new Category(key.toString(),value['name'].toString()));
  //       });

  //       categories.sort((a,b){
  //         return (
  //           a.categoryName.compareTo(b.categoryName)
  //         ); 
  //       });

  //       setState(() {
  //         retrievingCategories = false;
  //         categorySearchResults = categories;
  //       });
  //     }
  //     else
  //     {
  //       print('Product Brands Child Not Available');        
  //       setState(() {
  //         retrievingCategories = false;
  //       });
  //     }

  //   });
  // }

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
              this.nextBarCode = generateBarCode(this.nextProductCode.toString());
              setState(() {
                this.nextProductCodeAvailable = true;
              });              
            }
          });
  }

  @override
  Widget build(BuildContext context) {

    if(nextProductCodeAvailable)
      return Scaffold(
        appBar: AppBar(title:Text('Add New Product')),
              body: Container(
                height: MediaQuery.of(context).size.height/2,
                child: Column(
                  children: [
                    Expanded(
                      child: Text(this.nextBarCode),
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
                    Expanded(
                          child: TextField(  
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "PRODUCT NAME",
                              // icon: Icon(Icons.camera_alt),
                            ),
                            keyboardType: TextInputType.text,                             
                            autofocus: true,
                            onChanged: (value) {
                              this.newProductName = value;
                            },
                          ),
                    ),
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
                          hintText: "PRODUCT PRICE",
                          // icon: Icon(Icons.camera_alt),
                        ),
                        keyboardType: TextInputType.number,                              
                        autofocus: true,
                        onChanged: (value) {
                          this.newProductPrice = value;
                        },
                      ),
                    ),
                      Expanded(
                      child: Container(
                        child: FlatButton( 
                          color:Colors.blue,
                          child:Text(
                            selectedCategoryName,
                            style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),                        
                          ),
                          onPressed: (){
                            // Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                              return SelectProductCategory();
                            }));
                          },
                          
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: FlatButton( 
                          color:Colors.blue,
                          child:Text(
                            selectedBrandName,
                            style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),                        
                          ),
                          onPressed: (){
                            // Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                              return SelectProductBrand();
                            }));
                          },                        
                        ),
                      ),
                    ),
                     Expanded(
                          child: Container(
                            child: FlatButton(   
                              color: Colors.blue,
                              child:Text('ADD PRODUCT'),
                              onPressed: ()
                              {
                                if(this.newProductName != '' && this.newProductPrice != '')    
                                     {
                                    // this.newProductNameMessage = 'Product Name OK';
                                    if(double.parse(this.newProductPrice) > 0)
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
                                          'barcode':this.nextBarCode.toLowerCase(),
                                          'productcode':this.nextProductCode,
                                          'title':this.newProductName,
                                          'price':double.parse(this.newProductPrice),
                                          'category':selectedCategoryName,
                                          'brand':selectedBrandName,
                                          'imageurl':'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
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
                                              prefix0.barCodeSearchResults = [];
                                              barCodeSearchResults.add(new ProductStockPosition(
                                                                        newProductName, 
                                                                        double.parse(newProductPrice), 
                                                                        int.parse(nextProductCode.toString()), 
                                                                        this.nextBarCode, 
                                                                        'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad', 
                                                                        selectedCategoryName, 
                                                                        selectedBrandName,
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
                                      print('Invalid Price!!');
                                    }                                                            
                                  }       
                                  else
                                  {
                                    print('Invalid Price/Name');
                                  }        
                              },                   
                            ),
                          ),
                    ),
                  ]
                ),
              ),
      );
  else
  {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Product'),),
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
                child: Text("Loading Details.......")
              ),
            ],
          ),
        ),
      )
    ); 
  }
  }
}