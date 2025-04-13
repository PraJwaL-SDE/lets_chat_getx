import 'package:flutter/material.dart';
import 'package:lest_chat_5/app/modules/shell/controller/home_appbar_controller.dart';

import '../../../../utils/constants/constant_colors.dart';
import 'package:get/get.dart';
class HomeAppbar extends StatelessWidget {
  late var controller;
   HomeAppbar({super.key}){
    controller = Get.put(HomeAppbarController());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
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
              Obx(() => AnimatedContainer(
                width: controller.searchSelected.value ? 350 : 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                duration: const Duration(milliseconds: 500),
                child: controller.searchSelected.value
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
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
                  onPressed: controller.enableSearch,
                ),
              )),
              const SizedBox(width: 10),
              Obx(() {
                bool isActive = controller.searchSelected.value || controller.addSelected.value;
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
                      onTap: isActive ? controller.onCrossTap : controller.onAddTap,
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
    );
  }
}
