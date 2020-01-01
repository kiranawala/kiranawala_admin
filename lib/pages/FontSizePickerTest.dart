import 'package:flutter/material.dart';

import 'FontSizePicker.dart';

class FontSizePickerTest extends StatefulWidget {
  @override
  _FontSizePickerTestState createState() => _FontSizePickerTestState();
}

class _FontSizePickerTestState extends State<FontSizePickerTest> {
  double _fontSize = 20.0;

  void _showFontSizePickerDialog() async {
    // <-- note the async keyword here

    // this will contain the result from Navigator.pop(context, result)
    final selectedFontSize = await showDialog<double>(
      context: context,
      builder: (context) => FontSizePickerDialog(initialFontSize: _fontSize),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectedFontSize != null) {
      setState(() {
        _fontSize = selectedFontSize;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Font Size: ${_fontSize}'),
            RaisedButton(
              onPressed: _showFontSizePickerDialog,
              child: Text('Select Font Size'),
            )
          ],
        ),
      ),
    );
  }
}