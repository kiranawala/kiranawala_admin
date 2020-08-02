import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/multi-store-stock-position.dart';
import 'package:kiranawala_admin/pages/reset-store.dart';
import 'package:kiranawala_admin/pages/search-barcode.dart';
import 'package:kiranawala_admin/pages/select-store.dart';
import 'package:kiranawala_admin/pages/show-product-sale.dart';
import 'package:kiranawala_admin/pages/store-stock-position.dart';
//import 'package:kiranawala_admin/pages/store-stock-position.dart';

import 'show-brand-sale.dart';
import 'show-home-page.dart';
import 'show-lyrics.dart';
import 'show-sinima-home-page.dart';

String startDate = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days:-1)));
String endDate = DateFormat('dd-MM-yyyy').format(DateTime.now().add(Duration(days:-1)));
DateTime startDateAsDateTime = DateTime.now().add(Duration(days:-1));
DateTime endDateAsDateTime = DateTime.now().add(Duration(days:-1));
Map<String, double> saleByDate = Map<String, double>();
Map<String, double> terminalSalePosition = Map<String, double>();
Map<String,double> productSalePosition = Map<String, double>();
String productName = 'SELECT PRODUCT';
String brandName = 'SELECT BRAND';
String categoryName = 'SELECT CATEGORY';
Map<dynamic, dynamic> productSalePositionByDateAtTerminal = Map<dynamic, dynamic>();

List<Brand> brandSearchResults = List<Brand>();
List<Category> categorySearchResults = List<Category>();

bool retrievingProductDetails = false;


class Brand {
  const Brand(this.brandId, this.brandName);
  final String brandId;
  final String brandName;
}

class Category {
  const Category(this.categoryId, this.categoryName);
  final String categoryId;
  final String categoryName;
}

List<Brand> brands = List<Brand>();
List<Category> categories = List<Category>();

bool retrievingBrands = false;
bool retrievingCategories = false;

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
          categories.add(Category(key.toString(),value['name'].toString()));
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

    });
  }


  void initState()
  {
    super.initState();

    retrievingBrands = true;
    loadBrands();

    retrievingCategories = true;
    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        Navigator.of(context).push<dynamic>(
          MaterialPageRoute<dynamic>(
            builder:(BuildContext context){
              return ShowHomePage();
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
                        return ShowHomePage();
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
                        return ShowProductSalePosition();
                      }));
                    },
                    child:Center(child: getTextWidget('PRODUCT SALE POSITION', 20.0, Colors.white))
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                    color:Colors.blue,
                    onPressed: (){
                      Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
                        return ShowBrandSalePosition();
                      }));
                    },
                    child:Center(child: getTextWidget('BRAND SALE POSITION', 20.0, Colors.white))
                ),
              ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: RaisedButton(
//                color:Colors.blue,
//                onPressed: (){
//                  Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(builder:(BuildContext context){
//                    return ShowCategorySalePosition();
//                  }));
//                },
//                child:Center(child: getTextWidget('CATEGORY SALE POSITION', 20.0, Colors.white))
//            ),
//          ),
            ],
          ),
        ),
      ),
    );
  }
}