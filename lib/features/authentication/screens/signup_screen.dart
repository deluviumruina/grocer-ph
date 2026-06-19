import 'package:flutter/material.dart';
import 'package:grocer_ph/features/authentication/screens/widgets/signup_form.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// -- Title
              Text(
                'Create an Account',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),

              /// -- Form
              SignupForm(),
            ],
          ),
        ),
      ),
    );
  }
}