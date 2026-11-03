import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/containers/app_bar.dart';
import 'package:grocer_ph/common/widgets/containers/large_header_container.dart';
import 'package:grocer_ph/features/authentication/models/user_model.dart';
import 'package:grocer_ph/features/profiles/controllers/user_controller.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userProfile});

  final UserModel userProfile;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            /// -- Header
            LargeHeaderContainer(
              child: Column(
                children: [

                  /// -- App Bar
                  DefaultAppBar(
                    showBackArrow: true,
                    whiteBackArrow: true,
                    title: Text(
                      'Viewing Profile',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSections),
                ],
              ),
            ),

            /// -- Body
            Padding(
              padding: EdgeInsets.all(Sizes.defaultSpace),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [

                        /// -- Username
                        Text(
                          userProfile.username,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: Sizes.spaceBtwItems / 4),

                        /// -- Price Reports & Account Reputation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(controller.formatPriceReportNumber(userProfile)),
                            SizedBox(width: Sizes.spaceBtwItems),
                            Text('${userProfile.reputation} reputation'),
                          ],
                        ),
                      ],
                    ),
                  ),                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}