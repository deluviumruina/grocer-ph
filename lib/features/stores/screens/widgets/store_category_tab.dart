import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/layouts/store_card.dart';
import 'package:grocer_ph/data/repositories/store_repository.dart';
import 'package:grocer_ph/features/stores/models/store_category_model.dart';
import 'package:grocer_ph/features/stores/models/store_model.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/loaders/shimmer_sizes.dart';

class StoreCategoryTab extends StatefulWidget {
  const StoreCategoryTab({super.key, required this.storeCategory});

  final StoreCategoryModel storeCategory;

  @override
  State<StoreCategoryTab> createState() => _StoreCategoryTabState();
}

class _StoreCategoryTabState extends State<StoreCategoryTab> {
  final ScrollController scrollController = ScrollController();
  List<StoreModel> stores = [];
  int limit = 7;
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

    QuerySnapshot query = await StoreRepository.instance.getFirstCategoryStores(widget.storeCategory.id, limit);

    if (query.docs.isNotEmpty) {
      _lastDocument = query.docs.last;
      stores.addAll(query.docs.map((snapshot) => StoreModel.fromQuerySnapshot(snapshot)).toList());

      if (query.docs.length <= limit - 1) {
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

    QuerySnapshot query = await StoreRepository.instance.getMoreCategoryStores(widget.storeCategory.id, _lastDocument!, limit);

    if (query.docs.isNotEmpty) {
      _lastDocument = query.docs.last;
      stores.addAll(query.docs.map((snapshot) => StoreModel.fromQuerySnapshot(snapshot)).toList());
    } else {
      _hasMoreData = false;
    }

    setState(() => _isLoadingMore = false);
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      if (_hasMoreData) {
        getMore();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: ListView.separated(
        controller: scrollController,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: stores.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (_, index) {
          if (_isLoadingFirst) {
            return StoreCategoryTabLoader(limit: limit);
          } else if (index == stores.length) {
            return const StoreCardShimmer();
          }

          return StoreCard(store: stores[index]);
        }, 
        separatorBuilder: (_, index) =>
          const SizedBox(height: Sizes.spaceBtwItems), 
      ),
    );
  }
}

class StoreCategoryTabLoader extends StatelessWidget {
  const StoreCategoryTabLoader({
    super.key,
    required this.limit,
  });

  final int limit;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: limit,
      itemBuilder: (_, index) =>
        const StoreCardShimmer(),
      separatorBuilder: (_, index) =>
        const SizedBox(height: Sizes.spaceBtwItems),
    );
  }
}