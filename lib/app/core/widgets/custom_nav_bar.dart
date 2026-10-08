import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

typedef TappedCallback = dynamic Function(int value);

class CustomNavBar extends StatefulWidget {
  final bool isStudentFlow;
  final List<Widget>? screens;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final ValueChanged<int>? onTabChanged;

  const CustomNavBar({
    super.key,
    this.screens,
    this.scaffoldKey,
    this.isStudentFlow = true,
    this.onTabChanged,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  Widget getTabWidget(int index) {
    return widget.screens![index];
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (context, int value, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: IndexedStack(
                index: value,
                children: widget.screens!.cast<Widget>(),
              ),
            ),

            if (widget.isStudentFlow)
              _buildStudentNavBar(context, value)
            else
              _buildRecruiterBottomNav(value),
          ],
        );
      },
    );
  }

  Widget _buildStudentNavBar(BuildContext context, int value) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 360;
    final bool isMediumScreen = screenWidth < 390;

    final double horizontalMargin = isSmallScreen
        ? 10.0
        : (isMediumScreen ? 12.0 : 14.0);
    final double itemSpacing = isSmallScreen
        ? 2.0
        : (isMediumScreen ? 3.0 : 4.0);
    final double circleSize = isSmallScreen
        ? 36.0
        : (isMediumScreen ? 38.0 : 40.0);
    final double iconSize = isSmallScreen
        ? 18.0
        : (isMediumScreen ? 20.0 : 21.0);
    final double fontSize = isSmallScreen
        ? 11.0
        : (isMediumScreen ? 12.0 : 12.5);

    return Positioned(
      right: horizontalMargin,
      left: horizontalMargin,
      bottom: 15,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 4 : 6,
          vertical: 6,
        ),
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.fieldBgColor,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: widget.isStudentFlow
            ? Row(
                children: [
                  _navItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: "Home",
                    selectedIndex: value,
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                  ),
                  SizedBox(width: itemSpacing),
                  _navItem(
                    index: 1,
                    icon: CupertinoIcons.location_fill,
                    label: "Applied",
                    selectedIndex: value,
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                  ),
                  SizedBox(width: itemSpacing),
                  _navItem(
                    index: 2,
                    icon: Icons.work,
                    label: "Internships",
                    selectedIndex: value,
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                  ),
                  SizedBox(width: itemSpacing),
                  _navItem(
                    index: 3,
                    icon: Icons.video_chat,
                    label: "Webinar",
                    selectedIndex: value,
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                  ),
                  SizedBox(width: itemSpacing),
                  _navItem(
                    index: 4,
                    icon: Icons.person,
                    label: "Profile",
                    selectedIndex: value,
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                  ),
                ],
              )
            : Row(
                children: [
                  _navItem(
                    index: 0,
                    icon: Icons.home_rounded,
                    label: "Home",
                    selectedIndex: value,
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                  ),
                  SizedBox(width: itemSpacing),
                  _navItem(
                    index: 1,
                    icon: CupertinoIcons.location_fill,
                    label: "My Post",
                    selectedIndex: value,
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                  ),
                  SizedBox(width: itemSpacing),
                  _navItem(
                    index: 3,
                    icon: Icons.person,
                    label: "Profile",
                    selectedIndex: value,
                    circleSize: circleSize,
                    iconSize: iconSize,
                    fontSize: fontSize,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required IconData icon,
    required String label,
    required int selectedIndex,
    required double circleSize,
    required double iconSize,
    required double fontSize,
  }) {
    final bool isSelected = index == selectedIndex;

    final Widget circleWidget = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? AppColors.primaryColor : AppColors.contColor2,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: .45),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Icon(
        icon,
        color: isSelected ? AppColors.blackColor : AppColors.whiteColor,
        size: iconSize,
      ),
    );

    return Expanded(
      flex: isSelected ? 3 : 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          currentIndex.value = index;
          widget.onTabChanged?.call(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 56,
          padding: EdgeInsets.symmetric(horizontal: isSelected ? 4 : 0),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.contColor2 : AppColors.fieldBgColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: isSelected
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    circleWidget,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6, right: 4),
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.customTextStyle(
                            size: fontSize,
                            weight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: FittedBox(fit: BoxFit.scaleDown, child: circleWidget),
                ),
        ),
      ),
    );
  }

  Widget _buildRecruiterBottomNav(int selectedIndex) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: 70,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xff031D1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _recruiterNavItem(
                      index: 0,
                      selectedIndex: selectedIndex,
                      icon: Icons.home_rounded,
                      label: "Home",
                    ),
                  ),

                  Expanded(
                    child: _recruiterNavItem(
                      index: 1,
                      selectedIndex: selectedIndex,
                      icon: Icons.work,
                      label: "My Post",
                    ),
                  ),

                  const SizedBox(width: 70),

                  Expanded(
                    child: _recruiterNavItem(
                      index: 2,
                      selectedIndex: selectedIndex,
                      icon: Icons.groups,
                      label: "My Interns",
                    ),
                  ),

                  Expanded(
                    child: _recruiterNavItem(
                      index: 3,
                      selectedIndex: selectedIndex,
                      icon: Icons.people_alt_outlined,
                      label: "Referral",
                    ),
                  ),
                ],
              ),
            ),

            // Positioned(
            //   top: -25,
            //   child: GestureDetector(
            //     onTap: () {
            //       currentIndex.value = 2;
            //     },
            //     child: Container(
            //       width: 58,
            //       height: 58,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: AppColors.blackColor,
            //         border: Border.all(
            //           color: AppColors.secondaryColor,
            //           width: 2,
            //         ),
            //         boxShadow: [
            //           BoxShadow(
            //             color: AppColors.secondaryColor.withValues(alpha: 0.45),
            //             blurRadius: 15,
            //             spreadRadius: 2,
            //           ),
            //         ],
            //       ),
            //       child: const Icon(Icons.add, color: Colors.white, size: 30),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _recruiterNavItem({
    required int index,
    required int selectedIndex,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = index == selectedIndex;

    return InkWell(
      onTap: () {
        currentIndex.value = index;
        widget.onTabChanged?.call(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isSelected ? AppColors.secondaryColor : AppColors.whiteColor,
          ),

          const SizedBox(height: 4),

          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.customTextStyle(
              size: 10,
              weight: FontWeight.w500,
              color: isSelected
                  ? AppColors.secondaryColor
                  : AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }

  // List<BottomNavigationBarItem> _appNavBarsItems() {
  //   return [
  //     const BottomNavigationBarItem(
  //       icon: Icon(Icons.home_outlined, color: AppColors.whiteColor),
  //       label: "Home",
  //       activeIcon: Icon(Icons.home, color: AppColors.secondaryColor),
  //       tooltip: "Home"
  //     ),
  //     const BottomNavigationBarItem(
  //       icon: Icon(CupertinoIcons.location, color: AppColors.whiteColor),
  //       activeIcon: Icon(
  //         CupertinoIcons.location_fill,
  //         color: AppColors.secondaryColor,
  //       ),
  //       label: ("Applied"),
  //       tooltip: "Applied"
  //     ),
  //     const BottomNavigationBarItem(
  //       icon: Icon(Icons.file_copy_outlined, color: AppColors.whiteColor),
  //       activeIcon: Icon(
  //         Icons.file_copy_sharp,
  //         color: AppColors.secondaryColor,
  //       ),
  //       label: ("Internships"),
  //       tooltip: "Internships"
  //     ),
  //     const BottomNavigationBarItem(
  //       icon: Icon(Icons.person_outline_sharp, color: AppColors.whiteColor),
  //       activeIcon: Icon(Icons.person, color: AppColors.secondaryColor),
  //       label: ("Profile"),
  //       tooltip: "Profile"
  //     ),
  //   ];
  // }
}
