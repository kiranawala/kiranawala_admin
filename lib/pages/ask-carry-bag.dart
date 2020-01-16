import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/add-carry-bag.dart';

import '../main.dart';

class AskCarryBag extends StatefulWidget {
  @override
  _AskCarryBagState createState() => _AskCarryBagState();
}

class _AskCarryBagState extends State<AskCarryBag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (BuildContext context)
          {
            return IconButton(
              icon:Icon(
                Icons.arrow_back,
                color: Colors.purple,
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
            );
          },
        ),        
      ), 
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'NEED CARRY BAG?',
              style:TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 14.0
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                flex:2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color:Colors.blueAccent,                  
                    child:Text(
                      'YES', 
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0
                        ),
                      ),
                    onPressed: (){
                      carryBagRequested = true;
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return AddCarryBag();
                      }));
                    },
                  ),
                ),
              ),
              Expanded(
                flex:2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(                  
                    color:Colors.purpleAccent,                  
                    child:Text(
                      'NO', 
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0
                        ),
                      ),
                    onPressed: (){
                      carryBagRequested = false;
                      Navigator.of(context).pop();
                      },
                    ),
                ),
                )
              ],
            )
          ],
        ),
      ),  
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            title: Text('GO BACK')
             ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            title:Text('PROCEED')
            )
        ],
        onTap: (index){
          switch(index){
            case 0:
              Navigator.of(context).pop();
            break;
            case 1:
             
            break;
          }
        },
        ),           
    );
  }
}