import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/check-if-admin.dart';

class InventoryManagerAddNewProductSelectProductBrand extends StatefulWidget {
  @override
  _InventoryManagerAddNewProductSelectProductBrandState createState() => _InventoryManagerAddNewProductSelectProductBrandState();
}

class _InventoryManagerAddNewProductSelectProductBrandState extends State<InventoryManagerAddNewProductSelectProductBrand> {


  // List<Brand> brands = [];
  // // List<Brand> searchResults = [];
  // Brand selectedBrand;

  // bool retrievingBrands = false;  

//  void getProductBrands() async{
//    retrievingBrands = true;
//    brandSearchResults = List<Brand>();
//    brands = List<Brand>();
//
//    FirebaseDatabase
//    .instance
//    .reference()
//    .child('brands')
//    .once()
//    .then((productBrandsSnapshot){
//      if(productBrandsSnapshot != null && productBrandsSnapshot.value != null)
//      {
//        print('Product Brands Child Node Available');
//        print(productBrandsSnapshot.value);
//        Map<dynamic, dynamic> brandList = productBrandsSnapshot.value;
//        brandList.forEach((dynamic key,dynamic value){
//          print(key.toString());
//          print(value['name']);
//          brands.add(new Brand(key.toString(),value['name'].toString()));
//        });
//
//        brands.sort((a,b){
//          return (
//            a.brandName.compareTo(b.brandName)
//          );
//        });
//
//        setState(() {
//          retrievingBrands = false;
//          brandSearchResults = brands;
//        });
//      }
//      else
//      {
//        print('Product Brands Child Not Available');
//        setState(() {
//          retrievingBrands = false;
//        });
//      }
//
//    });
//  }

  @override
  void initState() {
    // TODO: implement initState
//    getProductBrands();
    
  }
  @override
  Widget build(BuildContext context) {
    if(retrievingBrands)
      return 
        Scaffold(
          appBar:
            AppBar(
              title:Text(
                'Change Product Brand',
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
                    child: Text("Retrieving Brands,",
                        style:TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize:12.0,
                          fontWeight: FontWeight.bold,
                        )
                        )
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
          centerTitle: true,
          title:Text(
            'SELECT BRAND',
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
                  hintText: 'Search Brand...',
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
                    brandSearchResults = [];
                    productBrands.forEach((brand){
                      if(brand.toLowerCase().contains(value.toLowerCase()))
                      {
                        brandSearchResults.add(brand);
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
                  itemCount:brandSearchResults.length,
                  itemBuilder: (BuildContext context, int index){
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: FlatButton(
                        color:Colors.blue,
                        child: Text(brandSearchResults[index],
                            style:TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize:24.0,
                              fontWeight: FontWeight.bold,
                              color:Colors.white
                            )),
                        onPressed: (){
                          selectedBrandName = brandSearchResults[index];
                          Navigator.of(context).pop(selectedBrandName);
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