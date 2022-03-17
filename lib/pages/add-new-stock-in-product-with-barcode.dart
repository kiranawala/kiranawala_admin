import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';

//import 'package:kiranawala_admin/pages/show-home-page.dart';
//import 'package:kiranawala_admin/pages/inventory-manager-store-stock-position.dart';
//import '../main.dart';
import 'select-product-category.dart';

import 'select-product-brand.dart';

//import 'check-if-admin.dart';
import 'request-number-value.dart';
import 'request-string-value.dart';

class AddNewStockInwardProduct extends StatefulWidget {
  @override
  _AddNewStockInwardProductState createState() => _AddNewStockInwardProductState();
}

class _AddNewStockInwardProductState extends State<AddNewStockInwardProduct> {

  int nextProductCode = 1234567890;
  String nextBarCode = '12345678909';
  String newProductName = 'PRODUCT NAME';
  double newProductPrice = 0;


  List<Brand> brands = [];
  List<Brand> brandSearchResults = [];
  Brand selectedBrand;

  bool retrievingBrands = false;  

  bool nextProductCodeAvailable = false;

  String generateBarCode(String code)
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
    nextProductCode = 1234567890;
    nextBarCode = '12345678909';
    newProductName = 'PRODUCT NAME';
    newProductPrice = 0;
    print('AddNewProductBarCode' + barCodeToSearch);
    selectedCategoryName = 'NOCATEGORY';
    selectedBrandName = 'NOBRAND';
    getNextProductCode();
    print(selectedCategoryName);
    print(selectedBrandName);
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

  void getNextProductCode() async{
    this.nextProductCodeAvailable = false;
//    FirebaseDatabase
//          .instance
//          .reference()
//          .child('stores')
//          .child('KIRANAWALA_STORE_7')
//          .child('latestProductCode')
//          .once()
//          .then((snapshot){
//            if(snapshot != null && snapshot.value != null)
//            {
//              print(snapshot.value);
//              print(snapshot.value['productCode']);
//              print('Extracting product code now.');
//              int lastProductCode = int.parse(snapshot.value['productCode'].toString());
//              this.nextProductCode = lastProductCode + 1;
//              this.nextBarCode = generateBarCode(this.nextProductCode.toString());
//              setState(() {
//                this.nextProductCodeAvailable = true;
//              });
//            }
//          });


    FirebaseDatabase
        .instance
        .reference()
        .child('stores')
        .child(productNode)
        .child('latestProductCode')
        .child('productCode')
        .runTransaction((mutableData) async {
      print('initState:mutabledata');
      print(mutableData);
      print(mutableData.value);
      if(mutableData != null && mutableData.value != null)
      {
        this.nextProductCode = mutableData.value + 1;
        setState(() {
          this.nextProductCodeAvailable = true;
        });
      }
      mutableData.value =(mutableData.value??0) + 1;
      return mutableData;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (nextProductCodeAvailable)
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: Text('Add New Product')),
          body:

          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width:MediaQuery.of(context).size.width,
                    child:
                    RaisedButton(
                      color: Colors.grey[300],
                      onPressed:(){},
                      child:Text(barCodeToSearch,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 24.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    )
                ),
                Container(
                    width:MediaQuery.of(context).size.width,
                    child:RaisedButton(
                      color: Colors.grey[300],
                      onPressed:(){},
                      child:Text(this.nextProductCode.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color:Colors.grey[300],
                    child:Text(
                      newProductName,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0),
                    ),
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return RequestString('PRODUCT NAME');
                      })).then((dynamic value){
                        if(value != null)
                        {
                          setState(() {
                            newProductName = value.toString();
                          });
                        }
                      });

                    },
                  ),
                ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  child: RaisedButton(
                      color:Colors.grey[300],
                      child:Text(
                        newProductPrice.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0),
                      ),
                      onPressed:(){
                        Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                          return RequestNumber('PRODUCT PRICE');
                        })).then((dynamic value){
                          if(value != null)
                          {
                            setState(() {
                              newProductPrice = double.parse(value.toString());
                            });
                          }
                        });
                      }
                  ),
                ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color:Colors.grey[300],
                    child: Text(
                      selectedCategoryName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) {
                                return SelectProductCategory();
                              })).then((dynamic value) {
                        {
                          print(value);
                          if (value != null)
                            setState(() {
                              selectedCategoryName = value.toString().toUpperCase();
                            });
                        }
                      });
                    },
                  ),
                ),
                Container(
                  width:MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color: Colors.grey[300],
                    child: Text(
                      selectedBrandName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) {
                                return SelectProductBrand();
                              })).then((dynamic value) {
                        print(value.toString());
                        if (value != null) {
                          setState(() {
                            selectedBrandName = value.toString().toUpperCase();
                          });
                        }
                      });
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        'ADD PRODUCT',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      onPressed: () {
                        if (this.newProductName != '' &&
                            this.newProductPrice != '') {
                          if (this.newProductPrice > 0) {
                            FirebaseDatabase.instance
                                .reference()
                                .child('stores')
                                .child(productNode)
                                .child('products')
                                .child(this.nextProductCode.toString())
                                .update(<String, dynamic>{
                              'barcode': barCodeToSearch.toLowerCase(),
                              'productcode': this.nextProductCode,
                              'title': this.newProductName.toUpperCase(),
                              'price': this.newProductPrice,
                              'category': selectedCategoryName.toUpperCase(),
                              'brand': selectedBrandName.toUpperCase(),
                              'imageurl':
                              'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
                              'stockposition': 0,
                            }).then((value) {
                              print('Product Added Successfully.');
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('stores')
                                  .child(inventoryNode)
                                  .child('latestProductCode')
                                  .update(<String, dynamic>{
                                'productCode': this.nextProductCode
                              }).then((onValue) {
                                print(
                                    'latest product code added to firebase successfully');
                                barCodeSearchResults = [];
                                barCodeSearchResults.add(new ProductBasicDetails(
                                  newProductName.toUpperCase(),
                                  newProductPrice,
                                  int.parse(nextProductCode.toString()),
                                  barCodeToSearch,
                                  'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
                                  selectedCategoryName.toUpperCase(),
                                  selectedBrandName.toUpperCase(),
                                  'N/A',
                                  'N/A',
                                  'N/A'
                                ));
                                Navigator.of(context).pop();
//                                Navigator.of(context).push<dynamic>(
//                                    MaterialPageRoute<dynamic>(
//                                        builder: (BuildContext context) {
//                                          return StockInManager();
//                                        }));
                              });
                            }).catchError((dynamic onError) {
                              print('Product Could not be added. Try Again!!');
                              // Navigator.of(context).pop();
                            });
                          } else {
                            print('Invalid Price!!');
                          }
                        } else {
                          print('Invalid Price/Name');
                        }
                      },
                    ),
                  ),
                ),
              ]));
    else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Add New Product'),
          ),
          body: Container(
            color: Colors.white,
            child: Dialog(
              child: new Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(flex: 2, child: new CircularProgressIndicator()),
                  SizedBox(width: 10.0),
                  Expanded(flex: 12, child: Text("Loading Details.......")),
                ],
              ),
            ),
          ));
    }
  }
}