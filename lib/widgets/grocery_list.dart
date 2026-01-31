import 'package:flutter/material.dart';
import 'package:shopping_list_app_flutter_course/models/grocery_item.dart';
import 'package:shopping_list_app_flutter_course/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];
  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (context) => NewItem()));

    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItems.add(newItem);
    });
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
