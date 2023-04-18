import 'dart:collection';

import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;

  const Product(this.name, this.price);
}

class Cart {
  final List<Product> _items = [];

  UnmodifiableListView<Product> get items => UnmodifiableListView(_items);

  double get totalPrice =>
      _items.fold(0, (total, current) => total + current.price);

  void addProduct(Product product) {
    _items.add(product);
  }

  void removeProduct(Product product) {
    _items.remove(product);
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Cart App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingCartPage(),
    );
  }
}

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  final Cart _cart = Cart();
  final List<Product> _products = [
    Product('Apple', 0.50),
    Product('Banana', 0.30),
    Product('Orange', 0.60),
    Product('Grapes', 0.80),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];

          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                setState(() {
                  _cart.addProduct(product);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Items in Cart',
                      style: TextStyle(fontSize: 20),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cart.items.length,
                        itemBuilder: (context, index) {
                          final cartProduct = _cart.items[index];

                          return ListTile(
                            title: Text(cartProduct.name),
                            subtitle: Text('\$${cartProduct.price}'),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_shopping_cart),
                              onPressed: () {
                                setState(() {
                                  _cart.removeProduct(cartProduct);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Text(
                      'Total: \$${_cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
