import 'package:flutter/material.dart';
import 'package:grocer_ph/common/widgets/containers/app_bar.dart';
import 'package:grocer_ph/utils/constants/sizes.dart';

class InformedConsentForm extends StatelessWidget {
  const InformedConsentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(showBackArrow: true, title: Text('Informed Consent Form')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// -- Research Title
              Text('RESEARCH TITLE', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Sizes.spaceBtwItems / 2),
              Text('GrocerPH: Design and Development of a Crowdsourced Price Comparison Mobile App for Filipino Consumers', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: Sizes.spaceBtwItems * 1.5),

              /// -- Principal Researcher
              Text('PRINCIPAL RESEARCHER', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Sizes.spaceBtwItems / 2),
              Text('Alyssa Marie G. San Pablo', style: Theme.of(context).textTheme.bodyMedium),
              Text('Siena College of San Jose', style: Theme.of(context).textTheme.bodyMedium),
              Text('alyssasanpablo1122@gmail.com', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: Sizes.spaceBtwItems * 1.5),

              /// -- About
              Text('ABOUT', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Sizes.spaceBtwItems / 2),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Thank you for downloading this application! You are being asked to take part in the ', style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(text: 'user testing and evaluation phases of my undergraduate thesis', style: Theme.of(context).textTheme.bodyMedium!.apply(fontWeightDelta: 2)),
                    TextSpan(text: '. Before you decide to participate, it is important that you understand why this research is being done and what it will involve. Please read the following information carefully.', style: Theme.of(context).textTheme.bodyMedium)
                  ]
                )
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'The purpose of this study is to design a price comparison app tailored to the specific needs of the Filipino market. It takes inspiration from one of DTI\'s e-Presyo app concepts, implementing crowdsourcing as a core functionality of the app to ensure the inclusion of the numerous local family-owned businesses and market stalls that comprise the Filipino grocery retail industry. ', style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(text: ' This application is a prototype, accessible for a duration of 14 days, and you are kindly requested to provide feedback through a survey distributed through the application\'s GitHub page.', style: Theme.of(context).textTheme.bodyMedium!.apply(fontWeightDelta: 2))
                  ]
                )
              ),
              const SizedBox(height: Sizes.spaceBtwItems * 1.5),

              /// -- Confidentiality
              Text('CONFIDENTIALITY', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Sizes.spaceBtwItems / 2),
              Text('In accordance with the Data Privacy Act of 2012 (RA 10173), all information taken from the app and its attached feedback survey will be kept strictly confidential and will be solely utilized for the purpose of this study. Participants will not be asked to provide any identifying information to the app other than their email, which is required by the app’s authentication provider, and they may withdraw from the study at any time by deleting their account.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text('All data associated with this study will be stored in a secure location then disposed of a year after its conclusion.', style: Theme.of(context).textTheme.bodyMedium)
            ],
          ),
        ),
      ),
    );
  }
}