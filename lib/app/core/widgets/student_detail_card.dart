import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';
import 'package:internsharks/app/core/widgets/custom_button_widget.dart';

class StudentDetailCard extends StatelessWidget {
  final String? studentProfile;
  final String? studentName;
  final String? studentCollegeName;
  final String? studentDegree;
  final String? studentDepartment;
  final bool? isVerified;
  final bool? isShortList;
  final bool? isLoading;
  final VoidCallback? requestFunc;
  final VoidCallback? shortlistFunc;

  const StudentDetailCard({
    super.key,
    this.studentProfile = "",
    this.studentName = "",
    this.studentCollegeName = "",
    this.studentDegree = "",
    this.studentDepartment = "",
    this.isVerified = false,
    this.isShortList = false,
    this.isLoading = false,
    this.shortlistFunc,
    this.requestFunc
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor2,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.cardBorder2),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.more_vert, color: Colors.grey.shade400),
          ),

          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyanAccent, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: .4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(studentProfile ?? ""),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Flexible(
                child: Text(
                  studentName ?? "",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 12,
                    weight: FontWeight.w600,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),

              Visibility(
                visible: isVerified!,
                child: Icon(
                  Icons.verified,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance, size: 18, color: Colors.white),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  studentCollegeName ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 10,
                    weight: FontWeight.w500,
                    color: AppColors.whiteColor,
                    lineSpace: 1.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 5,
            children: [
              const Icon(Icons.school, size: 18, color: Colors.white),
              Expanded(
                child: Text(
                  studentDegree ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.customTextStyle(
                    size: 10,
                    color: AppColors.whiteColor,
                    lineSpace: 1.4,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Row(
            spacing: 5,
            children: [
              Expanded(
                child: CustomButtonWidget(
                  height: 40,
                  buttonFunction: requestFunc!,
                  buttonWidget: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Icon(Icons.telegram_sharp, color: AppColors.blackColor),
                        Text(
                          "Request",
                          style: AppStyles.customTextStyle(
                            size: 9,
                            weight: FontWeight.w700,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CustomButtonWidget(
                  height: 40,
                  buttonFunction: shortlistFunc!,
                  bgColor: AppColors.contButtonColor,
                  buttonWidget: Center(
                    child: isLoading!
                        ? CupertinoActivityIndicator(
                            color: AppColors.secondaryColor,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 5,
                            children: [
                              isShortList!
                                  ? Icon(
                                      Icons.bookmark,
                                      color: AppColors.secondaryColor,
                                    )
                                  : Icon(
                                      Icons.bookmark_border_sharp,
                                      color: AppColors.whiteColor,
                                    ),
                              Text(
                                isShortList! ? "Shortlisted" : "Shortlist",
                                style: AppStyles.customTextStyle(
                                  size: 9,
                                  weight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
