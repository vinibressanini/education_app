import 'dart:async';

import 'package:education_app/core/common/app/providers/tab_navigator.dart';
import 'package:education_app/core/common/widgets/custom_pop_up_item.dart';
import 'package:education_app/core/extensions/context_extension.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ProfileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Account',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.white,
      actions: [
        PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          surfaceTintColor: Colors.white,
          offset: const Offset(0, 50),
          itemBuilder: (context) {
            return [
              PopupMenuItem<void>(
                child: const CustomPopUpItem(
                  icon: IconlyLight.edit,
                  label: 'Edit Profile',
                ),
                onTap: () => context.push(
                  TabItem(
                    child: const Placeholder(),
                  ),
                ),
              ),
              PopupMenuItem<void>(
                child: const CustomPopUpItem(
                  icon: IconlyLight.notification,
                  label: 'Notifications',
                ),
                onTap: () => context.push(
                  TabItem(
                    child: const Placeholder(),
                  ),
                ),
              ),
              PopupMenuItem<void>(
                child: const CustomPopUpItem(
                  icon: IconlyLight.info_circle,
                  label: 'Help',
                ),
                onTap: () => context.push(
                  TabItem(
                    child: const Placeholder(),
                  ),
                ),
              ),
              PopupMenuItem<void>(
                height: 1,
                padding: EdgeInsets.zero,
                child: Divider(
                  color: Colors.grey.shade400,
                  endIndent: 16,
                  indent: 16,
                ),
              ),
              PopupMenuItem<void>(
                child: const CustomPopUpItem(
                  icon: IconlyLight.logout,
                  label: 'Logout',
                ),
                onTap: () async {
                  final navigator = Navigator.of(context);
                  await sl<FirebaseAuth>().signOut();
                  unawaited(
                    navigator.pushNamedAndRemoveUntil('/', (route) => false),
                  );
                },
              )
            ];
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
