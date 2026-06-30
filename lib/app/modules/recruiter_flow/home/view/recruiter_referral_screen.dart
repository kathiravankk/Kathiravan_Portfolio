import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internsharks/app/core/widgets/app_background_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/asset_images.dart';

class RecruiterReferralScreen extends StatelessWidget {
  const RecruiterReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBarWidget: AppBar(),
      bodyWidget: Column(
        children: [
          SvgPicture.asset(AssetImages.referRecruiters),
          Image.asset(AssetImages.freeCreditsUser),
          _buildText(
            '''Know a recruiter, HR professional, startup founder, or company looking to hire 
interns and fresh talent?''',
          ),
          const SizedBox(height: 15),
          _buildText(
            '''Invite them to join Internsharks and help them connect with qualified candidates.''',
          ),
        ],
      ),
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteColor,
        ),
      ),
    );
  }
}

class ReferrerDetailsCard extends StatelessWidget {
  const ReferrerDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(children: [const Text('YOUR REFERRAL CODE')]));
  }
}

class HowItWorksCard extends StatelessWidget {
  const HowItWorksCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [Center(child: const Text('HOW IT WORKS'))]),
    );
  }

  Widget _buildStepItem(String assetName, String title, String subTitle) {
    return Row(
      children: [
        Image.asset(assetName),
        const SizedBox(width: 10),
        Column(children: [Text(title), Text(subTitle)]),
      ],
    );
  }
}
