import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

//import 'package:kiranawala_admin/pages/inventory-manager/stock-inward-check-if-admin.dart';

class ShowCategories extends StatefulWidget {
  @override
  _ShowCategoriesState createState() => _ShowCategoriesState();
}

List<dynamic> searchResults = List<dynamic>();
List<dynamic> fullList = List<dynamic>();

class _ShowCategoriesState extends State<ShowCategories> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('inventory-manager-load-categories:initState:categoryNameCategoryDetailsMap:');
    print(categoryNameCategoryDetailsMap);
    print(categoryNameCategoryDetailsMap.length);
//    print(homeCategoryNameCategoryDetailsMap);
//    print(homeCategories);
    categoryNameCategoryDetailsMap.forEach((dynamic key, dynamic value) {
      print(value['displayName']);
      fullList.add(value);
    });

    fullList.sort((dynamic a,dynamic b){
      return (
          a['displayName'].compareTo(b['displayName'])
      );
    });
    searchResults = fullList;
  }

  @override
  Widget build(BuildContext context) {


    return
      Scaffold(appBar:
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
//                        print(value);
                      if(value.isNotEmpty)
                      {
                        searchResults = <dynamic>[];
                        fullList.forEach((dynamic item){
                          if(item['displayName'].toLowerCase().contains(value.toLowerCase()))
                          {
                            searchResults.add(item);
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
                      itemCount:searchResults.length,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: FlatButton(
                            color:Colors.blue,
                            child: Column(
                              children: <Widget>[
                                Text(searchResults[index]['displayName'],
                                    style:TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize:24.0,
                                        fontWeight: FontWeight.bold,
                                        color:Colors.white
                                    )),
                                Row(
                                  children: <Widget>[
                                    Text('IS ACTIVE:',
                                        style:TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:24.0,
                                            fontWeight: FontWeight.bold,
                                            color:Colors.white
                                        )),
                                    Text(searchResults[index]['isActive'],
                                        style:TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize:24.0,
                                            fontWeight: FontWeight.bold,
                                            color:Colors.white
                                        )),
                                  ],
                                ),
                              ],

                            ),
                            onPressed: (){
                              selectedCategory = searchResults[index]['displayName'];
                              print(selectedCategory);

                              if(searchResults[index]['isActive'] == 'YES')
                                {
                                  categoryNameCategoryDetailsMap[searchResults[index]['categoryName']]['isActive'] = 'NO';
                                  searchResults[index]['isActive'] = 'NO';
                                }
                              else
                                {
                                  searchResults[index]['isActive'] = 'YES';
                                  categoryNameCategoryDetailsMap[searchResults[index]['categoryName']]['isActive'] = 'YES';
                                }

                              print(categoryList);
                              print(searchResults[index]['categoryName']);
                              print(categoryNameCategoryDetailsMap[searchResults[index]['categoryName']]['isActive']);

                              FirebaseDatabase
                                .instance
                                .reference()
                                .child('stores')
                                .child(inventoryNode)
                                .child('categoriesMaster')
                                .set(categoryList)
                                .then((value){
                                 print('Category List updated SUCCESSFUL');
                              }).catchError((dynamic error){
                                print('Category List update FAILED');
                              });
                              setState(() {

                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                )
              ]
          )
      );
  }
}
