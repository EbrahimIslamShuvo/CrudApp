import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'update_product_screen.dart';
import 'add_product_screen.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context, listen: false).fetchProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(child: Text('An error occurred!'));
            } else {
              return Consumer<ProductProvider>(
                builder: (ctx, productProvider, child) => ListView.builder(
                  itemCount: productProvider.products.length,
                  itemBuilder: (ctx, index) {
                    final product = productProvider.products[index];
                    return ListTile(
                      leading: Image.network(product.imgUrl),
                      title: Text(product.name),
                      subtitle: Text('Unit Price: \$${product.unitPrice}, Quantity: ${product.quantity}, Total Price: \$${product.totalPrice}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                UpdateProductScreen.routeName,
                                arguments: product.id,
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteDialog(context, product.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddProductScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to remove the product from the list?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Provider.of<ProductProvider>(context, listen: false)
                  .deleteProduct(productId);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
