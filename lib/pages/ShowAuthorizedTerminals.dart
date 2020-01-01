import 'package:flutter/material.dart';
import 'package:kiranawala_admin/main.dart';
import 'package:kiranawala_admin/pages/ShowCategoryWiseSalePositionStreamBuilder.dart';
import 'package:kiranawala_admin/pages/showOrderCount.dart';

import 'ShowTerminalWiseSalePositionStreamBuilder.dart';

class ShowAuthorizedTerminals extends StatefulWidget {
  @override
  _ShowAuthorizedTerminalsState createState() => _ShowAuthorizedTerminalsState();
}

class _ShowAuthorizedTerminalsState extends State<ShowAuthorizedTerminals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
    appBar: AppBar(
          title: const Text(
            'ONLINE ORDERS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        drawer: new Drawer(
        child: new ListView(children: <Widget>[       
          Divider(),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShowTerminalWiseSalePosition()));
            },
            child: ListTile(
              title: Text('Terminal-Wise Sales'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),
          Divider(),    
            Divider(),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ShowOrderCount()));
            },
            child: ListTile(
              title: Text('Order Count'),
              leading: Icon(Icons.person, color: Colors.green),
            ),
          ),     
        ]),
      ),
        body:Container(
          child: Align(
            // child:Text('Authorized Terminals : ' 
            //   + terminalsAtStore[0].toString() + ' '
            //   + terminalsAtStore[1].toString() + ' '
            //   + terminalsAtStore[2].toString() + ' '
            //   )
            alignment: Alignment.center,
            child: ListView.builder(
              itemCount: terminalsAtStore.length,
              itemBuilder: (BuildContext context, int index){      
                                return FlatButton(
                                  color: Colors.blue,
                                  child:Text(terminalsAtStore[index], style: TextStyle(color: Colors.white),),
                                  onPressed: (){
                                    selectedTerminal = terminalsAtStore[index];
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                      return ShowCategoryWiseSalePosition();
                                    }));
                                  },                                  
                                );
                              },
            )
             
          ),
        ),
      );
  }
}