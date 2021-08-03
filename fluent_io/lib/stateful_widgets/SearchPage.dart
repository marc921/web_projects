import 'package:flutter/material.dart'; // base package

import 'package:fluent_io/data/record.dart';

class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController;
  List<Record> _matchingRecords;

  @override
  void initState() {
    super.initState();
    setState(() {
      _searchController = TextEditingController();
      _matchingRecords = new List();
    });
    _searchController.addListener(setMatchingRecords);
  }

  void setMatchingRecords() {
    setState(() {
      _matchingRecords = FakeDatabase.getMatchingRecords(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Search a word or sentence, in any language.',
          ),
          validator: (value) =>
            value.isEmpty
              ? 'Search text...'
              : null,
          controller: _searchController,
        ),
        SizedBox(
          height: 500,
          width: double.infinity,
          child: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: _matchingRecords.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 50,
                color: Colors.yellow,
                child: Center(child: Text(_matchingRecords[index].toString())),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(),
          ),
        ),
      ],
    );
  }
}