import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-brand-sale-single-store.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-category-sale.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-daily-sale-between-dates.dart';
import 'package:kiranawala_admin/pages/sale-position-between-dates/sale-position-show-product-sale-single-store.dart';
import 'package:kiranawala_admin/pages/show-admin-home-page.dart';


String startDate = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days:0)));
String endDate = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days:0)));
DateTime startDateAsDateTime = DateTime.now().add(Duration(days:0));
DateTime endDateAsDateTime = DateTime.now().add(Duration(days:0));

//String productName = 'SELECT PRODUCT';
//String brandName = 'SELECT BRAND';
//String categoryName = 'SELECT CATEGORY';

//List<Brand> brandSearchResults = List<Brand>();
//List<Category> categorySearchResults = List<Category>();

//bool retrievingProductDetails = false;

//Map<String, List<String>> storeGroups = {
//  'S-MART GROUP':['S-MART I','S-MART II','S-MART III','S-MART IV','S-MART V','S-MART VI','S-MART VII'],
//  'S-MART I':['S-MART I'],
//  'S-MART II':['S-MART II'],
//  'S-MART III':['S-MART III'],
//  'S-MART IV':['S-MART IV'],
//  'S-MART V':['S-MART V'],
//  'S-MART VI':['S-MART VI'],
//  'S-MART VII':['S-MART VII'],
//};

//Map<String, List<String>> storeTerminalMap = {
//  'S-MART GROUP':['POS_4','POS_3','POS_2','POS_5','POS_6','POS_7','POS_8'],
//  'S-MART I':['POS_4'],
//  'S-MART II':['POS_3'],
//  'S-MART III':['POS_2'],
//  'S-MART IV':['POS_6'],
//  'S-MART V':['POS_7'],
//  'S-MART VI':['POS_5'],
//  'S-MART VII':['POS_8','POS_9'],
//};

//class Brand {
//  const Brand(this.brandId, this.brandName);
//  final String brandId;
//  final String brandName;
//}
//
//class Category {
//  const Category(this.categoryId, this.categoryName);
//  final String categoryId;
//  final String categoryName;
//}
//
//List<Brand> brands = List<Brand>();
//List<Category> categories = List<Category>();

//bool retrievingBrands = false;
//bool retrievingCategories = false;

class ShowSalePositionHomePage extends StatefulWidget {
  @override
  _ShowSalePositionHomePageState createState() => _ShowSalePositionHomePageState();
}

class _ShowSalePositionHomePageState extends State<ShowSalePositionHomePage> {

  void loadBrands()
  {
    retrievingBrands = true;
    brands = List<Brand>();

    FirebaseDatabase
        .instance
        .reference()
        .child('brands')
        .once()
        .then((productBrandsSnapshot){
      if(productBrandsSnapshot != null && productBrandsSnapshot.value != null)
      {
        Map<dynamic, dynamic> brandList = productBrandsSnapshot.value;
        brandList.forEach((dynamic key,dynamic value){
          brands.add(new Brand(key.toString(),value['name'].toString()));
        });

        brands.sort((a,b){
          return (
              a.brandName.compareTo(b.brandName)
          );
        });

        setState(() {
          retrievingBrands = false;

        });
      }
      else
      {
        setState(() {
          retrievingBrands = false;
        });
      }
      print(brands);
    });
  }

  void loadCategories() async{
    retrievingCategories = true;
    categories = List<Category>();

    FirebaseDatabase
        .instance
        .reference()
        .child('categories')
        .once()
        .then((productCategoriesSnapshot){
      if(productCategoriesSnapshot != null && productCategoriesSnapshot.value != null)
      {
        Map<dynamic, dynamic> categoryList = productCategoriesSnapshot.value;
        categoryList.forEach((dynamic key, dynamic value){
          categories.add(Category(num.parse(key.toString()),value['name'].toString()));
        });

        categories.sort((a,b){
          return (
              a.categoryName.compareTo(b.categoryName)
          );
        });

        setState(() {
          retrievingCategories = false;
        });
      }
      else
      {
        setState(() {
          retrievingCategories = false;
        });
      }
      print(categories);
    });
  }

  void loadAllStores()
  {
    print('loadAllStores:' + productNode);
    FirebaseDatabase.instance
        .reference()
        .child('stores')
        .child(productNode)
        .child('products')
        .once()
        .then((productsSnapshot) {
          print(productsSnapshot);
      if(productsSnapshot != null && productsSnapshot.value != null) {
        print(productsSnapshot.value);
        productsSnapshot.value.forEach((dynamic productCode, dynamic productSnapshot) {
          if(productSnapshot['title'] != null && productSnapshot['title'] != ''){

            ProductBasicDetails product = ProductBasicDetails(
                productSnapshot['title'],
                double.parse(productSnapshot['price'].toString()),
                int.parse(productCode.toString()),
                productSnapshot['barcode'].toString(),
                (productSnapshot['imageurl'] != null)
                    ? productSnapshot['imageurl']
                    : 'https://firebasestorage.googleapis.com/v0/b/oshop-21421.appspot.com/o/organization%2Fkiranawala.jpg?alt=media&token=07614d66-6dbc-4e09-a2c5-7db7bf4efdad',
                productSnapshot['category'],
                productSnapshot['brand'],
                (productSnapshot['productStatus'] != null)
                    ? productSnapshot['productStatus']
                    : 'INACTIVE',
                (productSnapshot['productParent'] != null)
                    ? productSnapshot['productParent']
                    : 'N/A',
                (productSnapshot['productCreationTimeStamp'] != null)
                    ? productSnapshot['productCreationTimeStamp']
                    : 'N/A'
            );
            fullProductBasicDetailsMap[int.parse(productCode.toString())]= product;
            fullProductBasicDetailsList.add(product);
          }
        });

        fullProductBasicDetailsMapAvailable = true;

        print('Full Product Map :' +
            fullProductBasicDetailsMap.length.toString());

        if (this.mounted) {
          setState(() {
          });
        }
      }
    });

  }


  void initState()
  {
    super.initState();

    retrievingBrands = true;
    loadBrands();

    retrievingCategories = true;
    loadCategories();

//    fullProductBasicDetailsMapAvailable = false;
//    loadAllStores();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return ShowAdminHomePage();
            }
          )
        );
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('SALE POSITION',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon:Icon(Icons.keyboard_backspace),
            onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                  MaterialPageRoute<dynamic>(
                      builder:(BuildContext context){
                        return ShowAdminHomePage();
                      }
                  )
              );
            },
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return SalePositionShowDailySaleBetweenDates();
                      }));
                    },
                    child:Center(child: Text('DAILY SALE POSITION',
                        style:TextStyle(
                          fontSize:20.0,
                          color:Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight:FontWeight.bold,
                        )
                    )
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return ShowProductSalePositionSingleStore();
                      }));
                    },
                    child:Center(child: Text('PRODUCT SALE POSITION',
                        style:TextStyle(
                            fontSize:20.0,
                            color:Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight:FontWeight.bold,
                        )
                    )
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return ShowBrandSalePositionSingleStore();
                      }));
                    },
                    child:Center(child: Text('BRAND SALE POSITION',
                        style:TextStyle(
                          fontSize: 20.0,
                          color:Colors.white,
                          fontFamily:'Montserrat',
                          fontWeight:FontWeight.bold
                        )
                    )
                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color:Colors.blue,
                  onPressed: (){
                    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                      return ShowCategorySalePosition();
                    }));
                  },
                  child:Center(child: Text('CATEGORY SALE POSITION',
                      style:TextStyle(
                          fontSize: 20.0,
                          color:Colors.white,
                          fontFamily:'Montserrat',
                          fontWeight:FontWeight.bold
                      )
                  )
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}