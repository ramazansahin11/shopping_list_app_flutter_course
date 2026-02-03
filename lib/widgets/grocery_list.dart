import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_app_flutter_course/api_constants/api_cons.dart';
import 'package:shopping_list_app_flutter_course/data/categories.dart';
import 'package:shopping_list_app_flutter_course/models/category.dart';
import 'package:shopping_list_app_flutter_course/models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app_flutter_course/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(firebaseUrl, 'shopping-list.json');
    final response = await http.get(url);

    final Map<String, dynamic> listData = json.decode(response.body);
    final List<GroceryItem> _loadedItems = [];
    for (final item in listData.entries) {
      final category = categories.entries
          .firstWhere(
            (catItem) => catItem.value.title == item.value['category'],
          )
          .value;
      _loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    setState(() {
      _groceryItems = _loadedItems;
    });
  }

  void _addItem() async {
    await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (context) => NewItem()));
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet'));

    if (_groceryItems.isNotEmpty) {
      content = Center(
        child: ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index) {
            return Dismissible(
              background: Container(color: Colors.red),
              key: ValueKey(_groceryItems[index].id),
              onDismissed: (direction) {
                setState(() {
                  _groceryItems.remove(_groceryItems[index]);
                });
              },
              child: ListTile(
                title: Text(_groceryItems[index].name),
                leading: Container(
                  height: 24,
                  width: 24,
                  color: _groceryItems[index].category.color,
                ),
                trailing: Text(_groceryItems[index].quantity.toString()),
              ),
            );
          },
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
