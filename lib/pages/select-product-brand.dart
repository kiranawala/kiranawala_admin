import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';

import 'check-if-admin.dart';



class SelectProductBrand extends StatefulWidget {
  @override
  _SelectProductBrandState createState() => _SelectProductBrandState();
}

class _SelectProductBrandState extends State<SelectProductBrand> {


  // List<Brand> brands = [];
  // // List<Brand> searchResults = [];
  // Brand selectedBrand;

  // bool retrievingBrands = false;

  List<String> productBrands = List<String>();

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
//          brandSearchResults = productBbrands;
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

//  productBrands = List<String>();
//  productBrands.add('DURACELL');
//  productBrands.add('LIJJAT');
//  productBrands.add('SGR(777) FOODS');
//  productBrands.add('LASER');
//  productBrands.add('JABSONS');
//  productBrands.add('SNACATAC');
//  productBrands.add('DS SPICES');
//  productBrands.add('ZYDUS WELLNESS');
//  productBrands.add('HENNA GROUP');
//  productBrands.add('DWIBHASHI');
//  productBrands.add('LOHIYA');
//  productBrands.add('PEPSI');
//  productBrands.add('TOP RAMEN');
//  productBrands.add('WEIKFIELD');
//  productBrands.add('CONTINENTAL');
//  productBrands.add('HATSUN');
//  productBrands.add('AMUL');
//  productBrands.add('CADBURY');
//  productBrands.add('TIP-TOP KIRANA');
//  productBrands.add('TIP-TOP HOMECARE');
//  productBrands.add('PARLE');
//  productBrands.add('EVEREST');
//  productBrands.add('MTR');
//  productBrands.add('BAMBINO');
//  productBrands.add('SHANTI NAMKEENS');
//  productBrands.add('MILKY MIST');
//  productBrands.add('ID FRESH');
//  productBrands.add('GRB');
//  productBrands.add('PATANJALI');
//  productBrands.add('BRITANNIA');
//  productBrands.add('NIVEA');
//  productBrands.add('FEM');
//  productBrands.add('LOTUS');
//  productBrands.add('BANJARAS');
//  productBrands.add('NYCIL');
//  productBrands.add('DENVER');
//  productBrands.add('PARK AVENUE');
//  productBrands.add('FOGG');
//  productBrands.add('NAVRATNA');
//  productBrands.add('DERMI COOL');
//  productBrands.add('PRIYA');
//  productBrands.add('LION');
//  productBrands.add('GOLDDROP');
//  productBrands.add('FREEDOM');
//  productBrands.add('FORTUNE');
//  productBrands.add('LOREAL');
//  productBrands.add('VIJAYA');
//  productBrands.add('HALDIRAMS');
//  productBrands.add('HERITAGE');
//  productBrands.add('KIRANAWALA');
//  productBrands.add('UNIBIC');
//  productBrands.add('KWALITY WALLS');
//  productBrands.add('CYCLE');
//  productBrands.add('SCTOCH-BRITE');
//  productBrands.add('LG');
//  productBrands.add('INDULEKHA');
//  productBrands.add('BISLERI');
//  productBrands.add('KINGFISHER');
//  productBrands.add('MOGU MOGU');
//  productBrands.add('SCHWEPPES');
//  productBrands.add('DUKES');
//  productBrands.add('PARRYS');
//  productBrands.add('NESTLE');
//  productBrands.add('FUNFOODS');
//  productBrands.add('TATA');
//  productBrands.add('ANOYA');
//  productBrands.add('EVEREADY');
//  productBrands.add('NIPPO');
//  productBrands.add('LOTTE');
//  productBrands.add('EPIGAMIA');
//  productBrands.add('SUGAR FREE');
//  productBrands.add('SRILALITHA');
//  productBrands.add('INDIA GATE');
//  productBrands.add('KOHINOOR');
//  productBrands.add('DAAWAT');
//  productBrands.add('PAMPERS');
//  productBrands.add('MAMY POKO');
//  productBrands.add('DURGA GHEE');
//  productBrands.add('KELLOGGS');
//  productBrands.add('AGROTECH');
//  productBrands.add('UNANI');
//  productBrands.add('HERSHEYS');
//  productBrands.add('COLGATE-PALMOLIVE');
//  productBrands.add('SCJOHNSON');
//  productBrands.add('JOHNSONS');
//  productBrands.add('SPENCERS');
//  productBrands.add('CREATIVE MARKETING');
//  productBrands.add('KARACHI BAKERY');
//  productBrands.add('PROCTER & GAMBLE');
//  productBrands.add('CELLO');
//  productBrands.add('MONTEX');
//  productBrands.add('NATRAJ');
//  productBrands.add('APSARA');
//  productBrands.add('CAMLIN');
//  productBrands.add('LUXOR');
//  productBrands.add('LINC');
//  productBrands.add('DOMYOS');
//  productBrands.add('GURU');
//  productBrands.add('VICKY');
//  productBrands.add('M-SEAL');
//  productBrands.add('NANDINI');
//  productBrands.add('PIDILITE');
//  productBrands.add('PRIME QUALITY');
//  productBrands.add('UNILEVER');
//  productBrands.add('CAVINKARE');
//  productBrands.add('RECKITT BENCKISER');
//  productBrands.add('PERFETTI');
//  productBrands.add('VCARE');
//  productBrands.add('NISSINS');
//  productBrands.add('VINI');
//  productBrands.add('DABUR');
//  productBrands.add('ITC');
//  productBrands.add('HIMALAYA');
//  productBrands.add('FLAIR');
//  productBrands.add('PCI');
//  productBrands.add('AVA');
//  productBrands.add('EMAMI');
//  productBrands.add('ECOF');
//  productBrands.add('BAULI');
//  productBrands.add('WRIGLEY');
//  productBrands.add('MARS');
//  productBrands.add('JYOTHY LABS');
//  productBrands.add('GLAXO SMITHKLINE');
//  productBrands.add('RASNA');
//  productBrands.add('AJAY');
//  productBrands.add('BUDWEISER');
//  productBrands.add('STREAX');
//  productBrands.add('AMRUTANJAN');
//  productBrands.add('KEO KARPIN');
//  productBrands.add('BAJAJ');
//  productBrands.add('AMBICA');
//  productBrands.add('VANESA');
//  productBrands.add('RUCHI SOYA');
//  productBrands.add('FERRARI');
//  productBrands.add('WIPRO');
//  productBrands.add('CAPITAL FOODS');
//  productBrands.add('KARNATAKA SOAPS');
//  productBrands.add('MARINO');
//  productBrands.add('MARICO');
//  productBrands.add('SWASTIK');
//  productBrands.add('ANURAG');
//  productBrands.add('LASER');
//  productBrands.add('RED BULL');
//  productBrands.add('HECTOR BEVERAGES');
//  productBrands.add('ASWINI');
//  productBrands.add('VICCO');
//  productBrands.add('HEERA');





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