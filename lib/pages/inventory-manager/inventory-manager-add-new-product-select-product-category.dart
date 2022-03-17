import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

// class Category {
//   const Category(this.categoryId, this.categoryName);    
//     final String categoryId;
//     final String categoryName;    
// }

class InventoryManagerAddNewProductSelectProductCategory extends StatefulWidget {
  @override
  _InventoryManagerAddNewProductSelectProductCategoryState createState() => _InventoryManagerAddNewProductSelectProductCategoryState();
}

class _InventoryManagerAddNewProductSelectProductCategoryState extends State<InventoryManagerAddNewProductSelectProductCategory> {




  bool retrievingCategories = false;  

//  void getProductCategories() async{
//    retrievingCategories = true;
//    categorySearchResults = List<Category>();
//    categories = List<Category>();
//
//    FirebaseDatabase
//    .instance
//    .reference()
//    .child('categories')
//    .once()
//    .then((productCategoriesSnapshot){
//      if(productCategoriesSnapshot != null && productCategoriesSnapshot.value != null)
//      {
//        print('Product Categories Child Node Available');
//        print(productCategoriesSnapshot.value);
//        Map<dynamic, dynamic> categoryList = productCategoriesSnapshot.value;
//        categoryList.forEach((dynamic key, dynamic value){
//          print(key.toString());
//          print(value['name']);
//          categories.add(Category(num.parse(key.toString()),value['name'].toString()));
//        });
//
//        categories.sort((a,b){
//          return (
//            a.categoryName.compareTo(b.categoryName)
//          );
//        });
//
//        setState(() {
//          retrievingCategories = false;
//          categorySearchResults = categories;
//        });
//      }
//      else
//      {
//        print('Product Brands Child Not Available');
//        setState(() {
//          retrievingCategories = false;
//        });
//      }
//
//    });
//  }

  @override
  void initState() {
    super.initState();
//    getProductCategories();
  }

  @override
  Widget build(BuildContext context) {
    if(retrievingCategories)
      return 
        Scaffold(
          appBar:
            AppBar(
              centerTitle: true,
              title:Text(
                'SELECT CATEGORY',
                style:TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize:24.0,
                  fontWeight: FontWeight.bold,
                )
              ),
            ),
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
                    child: Text("Retrieving Categories.....")
                  ),
                ],
              ),
            ),
          ),
        );
    else    
      return 
      Scaffold(appBar: 
        AppBar(
          title:Text(
            'Change Product Category',
            style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize:12.0,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        body:Column(
          children:<Widget>[ 
            
            Expanded(
              flex:2,
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Search Category...',
                  hintStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize:24.0,
                    fontWeight: FontWeight.bold,
                    color:Colors.black
                  )
                ),
                onChanged: (value){
                  print(value);
                  if(value.isNotEmpty)
                  {
                    categorySearchResults = [];
                    productCategories.forEach((category){
                      if(category.toLowerCase().contains(value.toLowerCase()))
                      {
                        categorySearchResults.add(category);
                      }
                    });
                    setState(() {
                      
                    });
                  }                
                },
              ),
            ),
            Expanded(
              flex:20,
                child: Container(
                  // decoration: BoxDecoration(color: Colors.purple),
                  child: ListView.builder(
                  itemCount:categorySearchResults.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FlatButton(
                        color:Colors.blue,
                        child: Text(
                          categorySearchResults[index],
                          style: TextStyle(
                            color:Colors.white,
                            fontWeight:FontWeight.bold,
                            fontFamily: 'Montserrat',
                            fontSize:24.0
                          ),
                        ),
                        onPressed: (){
                          selectedCategoryName = categorySearchResults[index];
                          Navigator.of(context).pop(selectedCategoryName);
                        },
                      ),
                    );
                  },
              ),
                ),
            )
          ]
        //  DropdownButton(
        //     hint: Text('Select Brand'), // Not necessary for Option 1
        //     value: selectedBrand,
        //     onChanged: (newValue) {
        //       setState(() {
        //         selectedBrand = newValue;
        //       });
        //     },
        //     underline: Container(
        //             height: 2,
        //             color: Colors.deepPurpleAccent,
        //           ),
        //     items: brands.map((Brand brand) {
        //       return DropdownMenuItem(
        //         child: new Text(brand.brandName),
        //         value: brand,
        //       );
        //     }).toList(),
        //   ),
        )
      );
    }
  }