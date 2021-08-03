import 'package:flutter/material.dart';
import 'package:fluent_io/stateful_widgets/home.dart';


class FluentDrawer extends StatelessWidget {
  FluentDrawer({Key key, this.changePage}) : super(key: key);
  final Function changePage;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Icon(
                Icons.translate,
                color: Colors.white,
                size: 100,
              ),
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
            ),
            ListTile(
              title: Text(PageTitle[Page.addRecords]),
              onTap: () {
                // Update the state of the app.
                changePage(Page.addRecords);
                // Then close the drawer.
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(PageTitle[Page.search]),
              onTap: () {
                changePage(Page.search);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
  }
}