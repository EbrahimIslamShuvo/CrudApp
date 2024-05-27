import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final url = 'https://crud.teamrabbil.com/api/v1/ReadProduct';
    final response = await http.get(Uri.parse(url));
    final List<dynamic> responseData = json.decode(response.body)['data'];

    _products = responseData.map((productData) {
      return Product(
        id: productData['ProductCode'],
        name: productData['ProductName'],
        unitPrice: double.parse(productData['UnitPrice']),
        quantity: int.parse(productData['Qty']),
        totalPrice: double.parse(productData['TotalPrice']),
        imgUrl: productData['Img'],
      );
    }).toList();

    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://crud.teamrabbil.com/api/v1/CreateProduct';
    await http.post(
      Uri.parse(url),
      body: json.encode({
        'Img': product.imgUrl,
        'ProductCode': product.id,
        'ProductName': product.name,
        'Qty': product.quantity.toString(),
        'TotalPrice': product.totalPrice.toString(),
        'UnitPrice': product.unitPrice.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    _products.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url = 'https://crud.teamrabbil.com/api/v1/UpdateProduct/$id';
    await http.post(
      Uri.parse(url),
      body: json.encode({
        'Img': newProduct.imgUrl,
        'ProductCode': newProduct.id,
        'ProductName': newProduct.name,
        'Qty': newProduct.quantity.toString(),
        'TotalPrice': newProduct.totalPrice.toString(),
        'UnitPrice': newProduct.unitPrice.toString(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    final productIndex = _products.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      _products[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://crud.teamrabbil.com/api/v1/DeleteProduct/$id';
    await http.get(Uri.parse(url));

    _products.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
