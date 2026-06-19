import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:grocer_ph/common/widgets/layouts/grid_layout.dart';
import 'package:grocer_ph/data/repositories/product_repository.dart';
import 'package:grocer_ph/features/products/controllers/product_controller.dart';
import 'package:grocer_ph/features/products/models/product_model.dart';
import 'package:grocer_ph/features/products/screens/widgets/product_card_vertical.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/shimmer_vertical_card.dart';
import 'package:iconsax/iconsax.dart';

class SortableProducts extends StatefulWidget {
  const SortableProducts({
    super.key,
    required this.queryFirst,
    required this.queryMore,
    this.queryFirstLimit = 6,
    this.queryMoreLimit = 6,
  });

  final Query queryFirst, queryMore;
  final int queryFirstLimit, queryMoreLimit;

  @override
  State<SortableProducts> createState() => _SortableProducts();
}

class _SortableProducts extends State<SortableProducts> {
  final ScrollController scrollController = ScrollController();
  final controller = ProductController.instance;
  List<ProductModel> products = [];
  List<ProductModel> sortableProducts = [];
  bool _isLoadingFirst = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    getFirst();
    scrollController.addListener(_scrollListener);
  }

  Future<void> getFirst() async {
    setState(() => _isLoadingFirst = true);

    QuerySnapshot query = await ProductRepository.instance.queryFirstProducts(
      widget.queryFirst,
      widget.queryFirstLimit,
    );

    if (query.docs.isNotEmpty) {
      _lastDocument = query.docs.last;
      products.addAll(query.docs.map((snapshot) => ProductModel.fromQuerySnapshot(snapshot)).toList());
      sortableProducts.addAll(products);

      if (query.docs.length <= widget.queryFirstLimit - 1) {
        _hasMoreData = false;
      }
    } else {
      _hasMoreData = false;
    }

    setState(() => _isLoadingFirst = false);
  }

  Future<void> getMore() async {
    if (_isLoadingFirst || _isLoadingMore || !_hasMoreData) return;

    setState(() => _isLoadingMore = true);

    QuerySnapshot query = await ProductRepository.instance.queryMoreProducts(
      widget.queryMore,
      _lastDocument!,
      widget.queryMoreLimit,
    );

    if (query.docs.isNotEmpty) {
      _lastDocument = query.docs.last;
      products.addAll(query.docs.map((snapshot) => ProductModel.fromQuerySnapshot(snapshot)).toList());
      sortableProducts.addAll(products);
    } else {
      _hasMoreData = false;
    }

    setState(() => _isLoadingMore = false);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (_hasMoreData) {
        getMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.assignProducts(sortableProducts, controller.selectedSortOption.value, products);

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          children: [
            /// -- Dropdown Sorting Menu
            DropdownButtonFormField(
              decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
              initialValue: controller.selectedSortOption.value,
              onChanged: (value) {
                controller.sortProducts(value!, products);
              },
              items: ['Newest', 'Oldest', 'Most Reported', 'Least Reported']
                  .map(
                    (option) =>
                        DropdownMenuItem(value: option, child: Text(option)),
                  )
                  .toList(),
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            GridLayout(
              itemCount: _isLoadingFirst
                  ? widget.queryFirstLimit
                  : controller.products.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (_, index) {
                if (_isLoadingFirst) {
                  return const VerticalCardShimmer();
                } else if (index == controller.products.length) {
                  return const VerticalCardShimmer();
                }

                return Obx(
                  () =>
                    ProductCardVertical(product: controller.products[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
