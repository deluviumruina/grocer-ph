import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/layouts/grid_layout.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/features/products/screens/widgets/product_card_vertical.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class ProductSearchDelegate extends SearchDelegate {
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: (){query = '';}, 
        icon: Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){close(context, null);}, 
      icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    
    if (query.isEmpty) {
      return const Center(child: Text('Type something to search.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
        .collection('Products')
        .where('Name', isGreaterThanOrEqualTo: query)
        .where('Name', isLessThanOrEqualTo: '${query}z')
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        final List<ProductModel> products = snapshot.data!.docs.map((doc) => ProductModel.fromQuerySnapshot(doc)).toList();

        return GridLayout(
          itemCount: products.length, 
          itemBuilder: (context, index) => ProductCardVertical(product: products[index])
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type something to search.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
        .collection('Products')
        .where('Name', isGreaterThanOrEqualTo: query)
        .where('Name', isLessThanOrEqualTo: '${query}z')
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No results found.'));
        }

        final List<ProductModel> products = snapshot.data!.docs.map((doc) => ProductModel.fromQuerySnapshot(doc)).toList();

        return Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: GridLayout(
            itemCount: products.length, 
            itemBuilder: (context, index) => ProductCardVertical(product: products[index])
          ),
        );
      },
    );
  }
}