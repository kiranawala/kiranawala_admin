import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';

// class Category {
//   const Category(this.categoryId, this.categoryName);    
//     final String categoryId;
//     final String categoryName;    
// }

class SelectProductCategory extends StatefulWidget {
  @override
  _SelectProductCategoryState createState() => _SelectProductCategoryState();
}

class _SelectProductCategoryState extends State<SelectProductCategory> {




  bool retrievingCategories = false;  

  void getProductCategories() async{
    retrievingCategories = true;
    categorySearchResults = [];

    FirebaseDatabase
    .instance
    .reference()
    .child('categories')
    .once()
    .then((productCategoriesSnapshot){
      if(productCategoriesSnapshot != null && productCategoriesSnapshot.value != null)
      {
        print('Product Categories Child Node Available');
        print(productCategoriesSnapshot.value);
        Map<dynamic, dynamic> categoryList = productCategoriesSnapshot.value;
        categoryList.forEach((key,value){
          print(key.toString());
          print(value['name']);
          categories.add(Category(key.toString(),value['name'].toString()));
        });

        categories.sort((a,b){
          return (
            a.categoryName.compareTo(b.categoryName)
          ); 
        });

        setState(() {
          retrievingCategories = false;
          categorySearchResults = categories;
        });
      }
      else
      {
        print('Product Brands Child Not Available');        
        setState(() {
          retrievingCategories = false;
        });
      }

    });
  }

  @override
  void initState() {
    super.initState();
    getProductCategories();    
  }

  @override
  Widget build(BuildContext context) {
    if(retrievingCategories)
      return 
        Scaffold(
          appBar:
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
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search Category...'
                ),
                onChanged: (value){
                  print(value);
                  if(value.isNotEmpty)
                  {
                    categorySearchResults = [];
                    categories.forEach((category){
                      if(category.categoryName.toLowerCase().contains(value.toLowerCase()))
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
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      child: FlatButton(
                        child: Text(categorySearchResults[index].categoryName),
                        onPressed: (){
                          selectedCategoryName = categorySearchResults[index].categoryName;
                          Navigator.of(context).pop();
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