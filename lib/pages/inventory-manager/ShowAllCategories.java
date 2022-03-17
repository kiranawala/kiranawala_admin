import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/stock-inward/selected-category-products.dart';
import '../main.dart';

class ShowAllCategories extends StatefulWidget {
  @override
  _ShowAllCategoriesState createState() => _ShowAllCategoriesState();
}

class _ShowAllCategoriesState extends State<ShowAllCategories> {   

  @override
  Widget build(BuildContext context) {
    if (!storeLoadingSuccessful) return Container(
        color: Colors.white,
        child: Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("Loading Store...."),
            ],
          ),
        ),
      );
    return Expanded(
      child: ListView.builder(
          itemCount: homeCategories.length,
          itemBuilder: (BuildContext context, int index) {
            List<String> subcategories = [];

//            print(categoryNameCategoryDetailsMap);

            homeCategories[index]['subCategories'].forEach((dynamic entry) {
//              print(entry);
              if(categoryNameCategoryDetailsMap.containsKey(entry['categoryName'].toString()))
              subcategories.add(entry['categoryName'].toString());
            });
            return buildHomeCategoryWidget(
                context, homeCategories[index]['displayName'], subcategories);
          }),
    );
  }
  Widget buildSubCategoryWidget(
    BuildContext context, List<String> subcategories) {

  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: subcategories.length,
    itemBuilder: (BuildContext context, int index) {

      return InkWell(
        onTap: () {
          categorySelected = subcategories[index];

          Navigator.push<dynamic>(context,
              MaterialPageRoute<dynamic>(builder: (BuildContext context) {
            return SelectedCategoryProducts();
          }));
        },
        child: Stack(children: <Widget>[
          Container(
              // margin: const EdgeInsets.all(5.0),
              width: 150.0,
              height: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blueGrey[300]),
                image: DecorationImage(
                  image: NetworkImage(
                      categoryNameCategoryDetailsMap[subcategories[index]]
                          ['categoryImage']),

                  fit: BoxFit.contain,
                ),
              )),
          Positioned(
            left: 25.0,
            bottom: 0.0,
            child: Container(
              height: 20.0,
              child: Text(

                subcategories[index],
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
                maxLines: 2,
                softWrap: true,
              ),
            ),
          ),
        ]),
      );
    },
  );
}

Widget buildHomeCategoryWidget(
    BuildContext context, String categoryName, List<String> subcategories) {
  // print('buildHomeCategoryWidgetNew:subcategories');
  // print(subcategories);
  return Column(children: <Widget>[
    const SizedBox(
      height: 10.0,
    ),
    Container(
      alignment: Alignment.centerLeft,
      child: Text(categoryName,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Montserrat',
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            // backgroundColor: Colors.blueGrey
          )),
    ),
    Container(
        // margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: buildSubCategoryWidget(context, subcategories)),
    const SizedBox(
      height: 10.0,
    ),
  ]);
}
}


