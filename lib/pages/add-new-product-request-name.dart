import 'package:flutter/material.dart';
import 'package:kiranawala_admin/pages/inventory-manager/inventory-manager-home-page.dart';

class AddNewProductRequestName extends StatefulWidget {
  @override
  _AddNewProductRequestNameState createState() => _AddNewProductRequestNameState();
}

class _AddNewProductRequestNameState extends State<AddNewProductRequestName> {
  TextEditingController productNameTextController = TextEditingController();
  String inputValue = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productNameTextController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    {
      return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop(null);
          return;
        },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.keyboard_backspace),
                tooltip: 'Go Back',
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text('NAME'),
                    ),
                    Container(
                      height: 100.0,
                      child: TextField(
                        controller: productNameTextController,
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.text,
                        minLines: 3,
                        maxLines: 3,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                        autofocus: true,
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        cursorWidth: 8.0,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold)),
                        onChanged: (value) {
                          inputValue = value;
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            print('RequestValue:inputValue:' + inputValue);
                            if(inputValue.length > 0 )
                              Navigator.of(context).pop(inputValue);
                          },
                          child: Text('CONFIRM',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                                color: Colors.white,
                              ))),
                    )
                  ],
                ))),
      );
    }
  }
}
