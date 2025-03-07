import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alquran_malayalam/pages/settings/settings_controller.dart';
import 'package:alquran_malayalam/pages/settings/settings_page.dart';

class SettingsDialog extends StatelessWidget {
  final SettingsController controller = Get.isRegistered<SettingsController>()
      ? Get.find<SettingsController>()
      : Get.put(SettingsController());

  SettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 350,
        height: 500,
        child: Column(
          children: [
            // Dialog Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFF734E09),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            // Dialog Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SettingsView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
