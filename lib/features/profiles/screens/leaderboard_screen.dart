import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocer_ph/common/widgets/containers/app_bar.dart';
import 'package:grocer_ph/common/widgets/images/app_icons.dart';
import 'package:grocer_ph/data/repositories/user_repository.dart';
import 'package:grocer_ph/features/profiles/screens/profile_screen.dart';
import 'package:grocer_ph/utils/constants/colors.dart';
import 'package:grocer_ph/utils/loaders/shimmer.dart';
import 'package:iconsax/iconsax.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DefaultAppBar(
              showBackArrow: true,
              title: Text('Leaderboard'),
            ),

            FutureBuilder(
              future: UserRepository.instance.getLeaderboard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerLoader(width: 150, height: 10);
                }

                final users = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final rank = index + 1;
                    return InkWell(
                      onTap: () => Get.to(() => ProfileScreen(userProfile: user)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Text(rank.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 15),
                            AppIcons(icon: Iconsax.user, size: 35),
                            const SizedBox(width: 15),
                            Text(user.username, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
                            const Spacer(),
                            Container(
                              height: 25,
                              width: 70,
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                children: [
                                  const SizedBox(width: 5),
                                  const Icon(Iconsax.medal, color: AppColors.primary),
                                  const SizedBox(width: 5),
                                  Text(
                                    user.reputation.toString(), 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.black)
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              }
            )
          ],
        )
      ),
    );
  }
}