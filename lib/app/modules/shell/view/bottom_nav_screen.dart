import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lest_chat_5/app/modules/group/view/group_home_screen.dart';
import 'package:lest_chat_5/app/modules/shell/controller/home_appbar_controller.dart';

import '../../../data/models/user_model.dart';
import '../../../utils/constants/constant_colors.dart';
import '../../home/view/home_screen.dart';
import '../../home/view/widgets/home_add_popup.dart';
import '../../settings/view/more_screen.dart';
import '../controller/bottom_nav_controller.dart';


class BottomNavigationView extends StatelessWidget {
  final int currentIdx;
  final UserModel userModel;
  late var appbarController;

  BottomNavigationView({
    super.key,
    this.currentIdx = 0,
    required this.userModel,
  }) {
    final controller = Get.put(BottomNavController(userModel: userModel));
    controller.initController(currentIdx);
    appbarController = Get.put(HomeAppbarController());



  }

  final List<String> labels = ["Chat", "Group", "More"];
  final List<String> activeIcons = [
    "assets/icons/bottom_chat_active.png",
    "assets/icons/bottom_group_active.png",
    // "assets/icons/bottom_profile_active.png"
  ];
  final List<String> inactiveIcons = [
    "assets/icons/bottom_chat_inactive.png",
    "assets/icons/bottom_group_inactive.png",
    // "assets/icons/bottom_profile_inactive.png"
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.find();
    final double w = MediaQuery.of(context).size.width;

    final List<Widget> navigationScreens = [
      HomeScreen(userModel: userModel),
      GroupHomeScreen(userModel: userModel),
      MoreScreen(),
    ];

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                AnimatedContainer(
                  height: 70,
                  width: double.infinity,
                  color: ConstantColors.appbar,
                  duration: const Duration(milliseconds: 200),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(
                                () => AnimatedContainer(
                              width: appbarController.searchSelected.value ? 350 : 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              duration: const Duration(milliseconds: 500),
                              child: appbarController.searchSelected.value
                                  ? Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                child: const TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                                  : IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: appbarController.enableSearch,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(() {
                            final bool isActive = appbarController.searchSelected.value || appbarController.addSelected.value;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: isActive ? Colors.blueAccent : ConstantColors.appbar,
                                shape: BoxShape.circle,
                              ),
                              child: AnimatedRotation(
                                turns: isActive ? 0.125 : 0.0,
                                duration: const Duration(milliseconds: 500),
                                child: GestureDetector(
                                  onTap: isActive ? appbarController.onCrossTap : appbarController.onAddTap,
                                  child: const Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: controller.pageController,
                    onPageChanged: (index) => controller.currentIdx.value = index,
                    children: navigationScreens,
                  ),
                ),
              ],
            ),
            Obx(() => Stack(
              children: [
                if (appbarController.addSelected.value)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => appbarController.addSelected.value = false,
                      child: ModalBarrier(
                        dismissible: true,
                        onDismiss: () => appbarController.addSelected.value = false,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  top: appbarController.addSelected.value ? 50 : -500,
                  left: 20,
                  right: 20,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: appbarController.addSelected.value ? 1.0 : 0.0,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      child: HomeAddPopup(userModel: userModel),
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
        bottomNavigationBar: Obx(
              () => Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: -10,
                left: (controller.currentIdx.value * w / 3) + (w / 6) - 40,
                child: Container(
                  height: 70,
                  width: 80,
                  decoration: BoxDecoration(
                    color: ConstantColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(3, (index) {
                  if (index == 2) {
                    return _buildNavItemWithIcon(
                      index: index,
                      icon: Icons.menu,
                      label: labels[index],
                      isSelected: controller.currentIdx.value == index,
                      onTap: () => controller.onItemTapped(index),
                    );
                  }
                  return _buildNavItem(
                    index: index,
                    activeIconPath: activeIcons[index],
                    inactiveIconPath: inactiveIcons[index],
                    label: labels[index],
                    isSelected: controller.currentIdx.value == index,
                    onTap: () => controller.onItemTapped(index),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildNavItem({
    required int index,
    required String activeIconPath,
    required String inactiveIconPath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 70, // Uniform height for all navigation items
        width: 80,  // Uniform width
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                isSelected ? activeIconPath : inactiveIconPath,
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItemWithIcon({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 70, // Match height with `_buildNavItem`
        width: 80,  // Match width with `_buildNavItem`
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24, // Match size with image icons
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
