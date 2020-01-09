import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';



class SelectProductBrand extends StatefulWidget {
  @override
  _SelectProductBrandState createState() => _SelectProductBrandState();
}

class _SelectProductBrandState extends State<SelectProductBrand> {


  // List<Brand> brands = [];
  // // List<Brand> searchResults = [];
  // Brand selectedBrand;

  // bool retrievingBrands = false;  

  void getProductBrands() async{
    retrievingBrands = true;
    brandSearchResults = [];

    FirebaseDatabase
    .instance
    .reference()
    .child('brands')
    .once()
    .then((productBrandsSnapshot){
      if(productBrandsSnapshot != null && productBrandsSnapshot.value != null)
      {
        print('Product Brands Child Node Available');
        print(productBrandsSnapshot.value);
        Map<dynamic, dynamic> brandList = productBrandsSnapshot.value;
        brandList.forEach((key,value){
          print(key.toString());
          print(value['name']);
          brands.add(new Brand(key.toString(),value['name'].toString()));
        });

        brands.sort((a,b){
          return (
            a.brandName.compareTo(b.brandName)
          ); 
        });

        setState(() {
          retrievingBrands = false;
          brandSearchResults = brands;
        });
      }
      else
      {
        print('Product Brands Child Not Available');        
        setState(() {
          retrievingBrands = false;
        });
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getProductBrands();
    
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
                    child: Text("Generating next product code.....")
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
            'Change Product Brand',
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
                  hintText: 'Search Brand...'
                ),
                onChanged: (value){
                  print(value);
                  if(value.isNotEmpty)
                  {
                    brandSearchResults = [];
                    brands.forEach((brand){
                      if(brand.brandName.toLowerCase().contains(value.toLowerCase()))
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
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      child: FlatButton(
                        child: Text(brandSearchResults[index].brandName),
                        onPressed: (){
                          selectedBrandName = brandSearchResults[index].brandName;
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