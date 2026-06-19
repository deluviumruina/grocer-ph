import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/features/welcoming/onboarding_controller.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/constants/images.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';
import 'package:grocer_ph/utils/device/device_utility.dart';
import 'package:grocer_ph/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      body: Stack(
        children: [

          /// -- Onboarding Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [

              /// -- Page 1
              OnBoardingPage(
                image: Images.appLogo,
                title: 'Welcome to GrocerPH!', 
                subTitle: 'User testing of a mobile app for crowdsourced grocery price comparison.'
              ),

              /// -- Page 2
              OnBoardingPage(
                image: Images.onBoardingImage2,
                title: 'Report Prices', 
                subTitle: 'Make sure to attribute your price reports to the correct product and store!'
              ),

              // -- Page 3
              OnBoardingPage(
                image: Images.onBoardingImage3, 
                title: 'View Other Price Reports',
                subTitle: 'Confirm helpful price reports and submit new ones if they are outdated.'
              ),
            ],
          ),
          
          /// -- Skip Button
          const OnBoardingSkip(),

          /// -- Page Indicator
          const OnBoardingDotNavigation(),

          /// -- Next Button
          OnBoardingNext()
        ],
      ),
    );  
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key, 
    required this.image, 
    required this.title, 
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Column(
        children: [
          SizedBox(height: Sizes.appBarHeight * 2),
          Image(
            width: HelperFunctions.screenWidth() * 0.8,
            height: HelperFunctions.screenHeight() * 0.9,
            image: AssetImage(image)
          ),
          const SizedBox(height: Sizes.spaceBtwSections),
          SizedBox(
            width: HelperFunctions.screenWidth() * 0.8,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ), 
          ),
          const SizedBox(height: Sizes.spaceBtwItems),
          SizedBox(
            width: HelperFunctions.screenWidth() * 0.8,
            child: Text(
              subTitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: DeviceUtils.getAppBarHeight(),
      right: Sizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnboardingController.instance.skipPage(), 
        child: const Text('Skip'),
      )
    );
  }
}

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: DeviceUtils.getBottomNavigationBarHeight() + 25,
      left: Sizes.defaultSpace,
      child: SmoothPageIndicator(
        count: 3,
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        effect: ExpandingDotsEffect(activeDotColor: dark ? AppColors.light: AppColors.dark, dotHeight: 6),
      ),
    );
  }
}

class OnBoardingNext extends StatelessWidget {
  const OnBoardingNext({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    return Positioned(
      right: Sizes.defaultSpace,
      bottom: DeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnboardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(shape: const CircleBorder(), backgroundColor: dark ? AppColors.primary : AppColors.black),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}