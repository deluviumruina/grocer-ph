import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/app_bar.dart';
import 'package:grocer_ph/common/widgets/buttons/floating_action_button.dart';
import 'package:grocer_ph/common/widgets/containers/search_container.dart';
import 'package:grocer_ph/common/widgets/tabs/tab_bar.dart';
import 'package:grocer_ph/features/stores/controllers/store_category_controller.dart';
import 'package:grocer_ph/features/stores/screens/add_store_screen.dart';
import 'package:grocer_ph/features/stores/screens/widgets/store_category_tab.dart';
import 'package:grocer_ph/features/stores/screens/widgets/store_search_delegate.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';

class AllStoresScreen extends StatelessWidget {
  const AllStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storeCategories = StoreCategoryController.instance.allStoreCategories;

    return DefaultTabController(
      length: storeCategories.length,
      child: Scaffold(

        /// -- App Bar
        appBar: DefaultAppBar(
          title: Text(
            'Stores',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),

        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: HelperFunctions.isDarkMode(context)
                    ? AppColors.dark
                    : Colors.white,
                expandedHeight: 170,

                /// -- Search Bar
                flexibleSpace: Padding(
                  padding: EdgeInsets.all(Sizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: Sizes.spaceBtwItems),
                      SearchContainer(
                        text: 'Search Stores',
                        showBorder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                        onTap: (){
                          showSearch(
                            context: context, 
                            delegate: StoreSearchDelegate()
                          );
                        },
                      ),
                      SizedBox(height: Sizes.spaceBtwSections),
                    ],
                  ),
                ),

                /// -- Store Tabs (Selector)
                bottom: AppTabBar(
                  tabs: storeCategories
                      .map(
                        (storeCategory) => Tab(child: Text(storeCategory.name)),
                      )
                      .toList(),
                ),
              ),
            ];
          },

          /// -- Store Tabs (Content)
          body: TabBarView(
            children: storeCategories.map((storeCategory) => StoreCategoryTab(storeCategory: storeCategory)).toList()
          ),
        ),

        /// -- Add New Store
        floatingActionButton: GFloatingActionButton(onPressed: () => Get.to(() => const AddStoreScreen())),
      ),
    );
  }
}