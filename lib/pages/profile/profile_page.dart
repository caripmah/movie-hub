import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviehub/constant/color_constant.dart';
import 'package:moviehub/pages/login/login_page.dart';
import 'package:moviehub/controller/profile_controller.dart';

import 'package:moviehub/services/auth_firebase.dart';
import 'package:moviehub/utils/secure_storage/secure_storage_util.dart';

class ProfilePage extends StatefulWidget {
  final ScrollController scrollController;
  const ProfilePage({super.key, required this.scrollController});

  @override
  State<ProfilePage> createState() => ProfiledPageState();
}

class ProfiledPageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final ProfileController authController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (authController.userData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: authController.userData['photoURL'] != null
                      ? NetworkImage(authController.userData['photoURL'])
                      : const AssetImage('assets/images/avatar.png')
                          as ImageProvider,
                ),
                const SizedBox(height: 10),
                Text(
                  authController.userData['displayName'] ?? 'No Name',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffFFFFFF)),
                ),
                const SizedBox(height: 5),
                Text(
                  authController.userData['email'] ?? 'No Email',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      buildListTile(Icons.privacy_tip, 'Privacy', false),
                      buildListTile(Icons.history, 'Purchase History', false),
                      buildListTile(
                          Icons.help_outline, 'Help & Support', false),
                      buildListTile(Icons.settings, 'Settings', false),
                      buildListTile(Icons.person_add, 'Invite a Friend', false),
                      buildListTile(Icons.logout, 'Logout', true),
                    ],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, bool? navigation) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.grey[850], borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
        trailing: navigation != true
            ? const Icon(Icons.arrow_forward_ios, color: Colors.red)
            : const SizedBox.shrink(),
        onTap: () {
          if (title == 'Logout') {
            Get.offAll(const LoginPage());
            SecureStorageUtil().deleteAll();
            AuthMethod().signOut();
          }
        },
      ),
    );
  }
}
