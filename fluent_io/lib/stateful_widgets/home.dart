import 'package:flutter/material.dart'; // base package

import 'package:fluent_io/stateless_widgets/FluentDrawer.dart'; // Left Panel (Drawer) = Nav Bar
import 'package:fluent_io/stateful_widgets/AddGraphForm.dart';  // "Add Records" page
import 'package:fluent_io/stateful_widgets/SearchPage.dart';    // "Search" page

 enum Page {
  addRecords,
  search
}
const PageTitle = {
  Page.addRecords: "Add Records",
  Page.search: "Search"
};


class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Page _currentPage;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentPage = Page.search;
    });
  }

  void _changePage (Page page) {
    setState(() {
      _currentPage = page;
    });
  }


  @override
  Widget build(BuildContext context) {  // rerun every time setState is called
    return Scaffold(
      drawer: FluentDrawer(changePage: _changePage),
      appBar: AppBar(
        title: Text(PageTitle[_currentPage]),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage() {
    switch (_currentPage) {
      case Page.addRecords:
        return AddGraphForm(changePage: _changePage,);
      case Page.search:
        return SearchPage();
      default:
        return Text("YOU SHOULD NOT BE HERE");
    }
  }
}