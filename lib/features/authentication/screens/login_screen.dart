import 'package:flutter/material.dart';
import 'package:grocer_ph/common/styles/spacing_styles.dart';
import 'package:grocer_ph/features/authentication/screens/widgets/login_form.dart';
import 'package:grocer_ph/utils/constants/images.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: SpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              
              /// -- Logo, Title, and SubTitle
              const LoginHeader(),

              /// -- Form
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// -- App Logo
            Center(
              child: Image(
                image: AssetImage(Images.appLogo), 
                height: 150
              ),
            ),
            SizedBox(height: Sizes.spaceBtwItems,),

            /// -- Login Header
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
    );
  }
}
