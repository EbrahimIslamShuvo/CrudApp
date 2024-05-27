import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/product_provider.dart';
import './screens/product_list_screen.dart';
import './screens/add_product_screen.dart';
import './screens/update_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProductListScreen(),
        routes: {
          AddProductScreen.routeName: (ctx) => AddProductScreen(),
          UpdateProductScreen.routeName: (ctx) => UpdateProductScreen(),
        },
      ),
    );
  }
}
