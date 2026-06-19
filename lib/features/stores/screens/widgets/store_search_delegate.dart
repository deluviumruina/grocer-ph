import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/layouts/store_card.dart';
import 'package:grocer_ph/features/stores/models/store_model.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class StoreSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Type something to search.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Stores')
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

        final List<StoreModel> stores = snapshot.data!.docs
            .map((doc) => StoreModel.fromQuerySnapshot(doc))
            .toList();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stores.length,
          itemBuilder: (_, index) {
            return StoreCard(store: stores[index]);
          },
          separatorBuilder: (_, index) =>
              const SizedBox(height: Sizes.spaceBtwItems),
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
          .collection('Stores')
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

        final List<StoreModel> stores = snapshot.data!.docs
            .map((doc) => StoreModel.fromQuerySnapshot(doc))
            .toList();

        return Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stores.length,
            itemBuilder: (_, index) {
              return StoreCard(store: stores[index]);
            },
            separatorBuilder: (_, index) =>
                const SizedBox(height: Sizes.spaceBtwItems),
          ),
        );
      },
    );
  }
}
