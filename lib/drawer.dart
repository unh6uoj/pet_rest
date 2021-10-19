import 'package:flutter/material.dart';

Drawer myDrawer = Drawer(
    child: ListView(
  padding: EdgeInsets.zero,
  children: [
    const DrawerHeader(
        decoration: BoxDecoration(color: Colors.green),
        child: Text('Drawer Header')),
    ListTile(title: const Text('Item 1'), onTap: () {}),
    ListTile(title: const Text('Item 2'), onTap: () {}),
  ],
));
