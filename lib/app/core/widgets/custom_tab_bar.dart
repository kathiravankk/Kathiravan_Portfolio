import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

typedef TabOnClickFun = dynamic Function(String value);

class CustomTabBar extends StatefulWidget {
  final List<String>? tabNames;
  final List<Widget>? tabPages;
  final TabOnClickFun? tabOnClickFun;
  final bool? isLoading;
  final TabController tabController;
  final Color activeBoxColor;
  final Color activeTextColor;

  const CustomTabBar({
    super.key,
    this.tabNames,
    this.tabPages,
    this.tabOnClickFun,
    this.isLoading = false,
    required this.tabController,
    required this.activeBoxColor,
    required this.activeTextColor,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  int _selectedIndex = 0;

  final List<GlobalKey> dataKey = [];

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController;
    _scrollController = ScrollController();
    _selectedIndex = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedTab(int index) {
    Scrollable.ensureVisible(dataKey[index].currentContext!);
  }

  Future<void> _onTabPressed(int index) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    if (widget.tabOnClickFun != null) {
      await widget.tabOnClickFun!(widget.tabNames![index]);
    }

    if (!mounted) return;
    setState(() {
      _tabController.animateTo(index);
      _scrollToSelectedTab(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.tabNames?.length,
            itemBuilder: (context, index) {
              dataKey.add(GlobalKey());
              return Padding(
                key: dataKey[index],
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: ElevatedButton(
                  onPressed: widget.isLoading!
                      ? () {}
                      : () => _onTabPressed(index),
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    backgroundColor: _selectedIndex == index
                        ? widget.activeBoxColor
                        : AppColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: _selectedIndex == index
                            ? widget.activeBoxColor
                            : AppColors.whiteColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.tabNames![index],
                        style: AppStyles.customTextStyle(
                          weight: FontWeight.w400,
                          size: 10,
                          color: _selectedIndex == index
                              ? widget.activeTextColor
                              : AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: widget.isLoading!
              ? const Center(
                  child: CupertinoActivityIndicator(
                    color: AppColors.secondaryColor,
                  ),
                )
              : TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: widget.tabPages!,
                ),
        ),
      ],
    );
  }
}
