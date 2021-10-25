import 'package:flutter/material.dart';

mydialog(BuildContext context,
    {required String title, required String content, required VoidCallback ok}) async {
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              onPressed: ok,
              child: Text("Yes"),
            ),
            FlatButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      });
}
