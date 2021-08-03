import 'package:flutter/material.dart'; // base package

import 'package:fluent_io/data/record.dart';
import 'package:fluent_io/stateless_widgets/LanguageRadio.dart';
import 'package:fluent_io/stateful_widgets/home.dart';

final _formKey = GlobalKey<FormState>();

class AddGraphForm extends StatefulWidget {
  AddGraphForm({Key key, this.changePage}) : super(key: key);
  final Function changePage;

  @override
  _AddGraphFormState createState() => _AddGraphFormState();
}


class _AddGraphFormState extends State<AddGraphForm> {
  List<String> _languages;
  List<TextEditingController> _controllers;
  int _recordCounter;
  int _linkCounter;

  @override
  void initState() {
    super.initState();
    setState(() {
      _languages = [FakeDatabase.getLanguages()[0]];
      _controllers = [TextEditingController()];
      _recordCounter = FakeDatabase.getRecords().length;
      _linkCounter = FakeDatabase.getLinks().length;
    });
  }

  void addRecordField() {
    setState(() {
      _languages.add(FakeDatabase.getLanguages()[0]);
      _controllers.add(TextEditingController());
    });
  }

  void removeRecordField(int index) {
    setState(() {
      _languages.removeAt(index);
      _controllers.removeAt(index);
    });
  }

  List<Widget> getRecordFields() {
    List<Widget> recordFields = new List();
    for (var i = 0; i < _languages.length; i++) {
      recordFields.addAll([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: LanguageRadio(
                option: _languages[i],
                onChange: (lang) => changeLanguage(lang, i)
              ),
            ),
            Expanded(
              flex: 1,
              child: FloatingActionButton(
                onPressed: () => removeRecordField(i),
                tooltip: 'Remove record field',
                child: Icon(Icons.delete),
              ),
            ),
          ],
        ),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Enter your word/sentence in the first language',
          ),
          validator: (value) =>
            value.isEmpty
              ? 'Please enter some text'
              : null,
          controller: _controllers[i],
        ),
      ]);
    }
    return recordFields;
  }

  void changeLanguage(String language, int recordIndex) {
    setState(() {
      _languages[recordIndex] = language;
    });
  }

  /// Graph refers to records linked together by links, meaning they are translations or synonyms of each other.
  void submitGraph () {
    // Validate will return true if the form is valid, or false if the form is invalid.
    if (_formKey.currentState.validate()) {
      // Creates links between all filled records
      List<Link> links = new List();
      for (var i = 0; i < _languages.length; i++) {
        for (var j = i+1; j < _languages.length; j++) {
          links.add(
            new Link(
              id: _linkCounter++,
              record1: _recordCounter + i,
              record2: _recordCounter + j
            )
          );
        }
      }
      // Inserts records and links into database
      FakeDatabase.insertGraph(
        List.generate(_languages.length, (i) {
          return Record(
            id: _recordCounter++,
            value: _controllers[i].text,
            language: _languages[i],
          );
        }),
        links
      );
      _showDialog(true);
    }
    else
      _showDialog(false);
  }

  // user defined function
  void _showDialog(bool success) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(success
            ? "New Records Added"
            : "Empty fields"
          ),
          content: new Text(success
            ? "New records successfully added in database."
            : "Could not insert records in database as some fields are empty."
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Add other records"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Go to Search Page"),
              onPressed: () {
                Navigator.of(context).pop();
                widget.changePage(Page.search);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is removed from the widget tree.
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ...getRecordFields(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: FloatingActionButton(
                  onPressed: addRecordField,
                  tooltip: 'Add record field to page',
                  child: Icon(Icons.add),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: FloatingActionButton(
                  onPressed: submitGraph,
                  tooltip: 'Save records into database',
                  child: Icon(Icons.save_alt),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}