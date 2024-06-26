import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/src/auth/data/models/local_user_model.dart';
import 'package:education_app/src/dashboard/presentation/providers/dashboard_controller.dart';
import 'package:education_app/src/dashboard/presentation/utils/dashboard_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalUserModel>(
      stream: DashboardUtils.userDataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          context.read<UserProvider>().user = snapshot.data;
          return Consumer<DashboardController>(
            builder: (_, controller, __) {
              return Scaffold(
                body: IndexedStack(
                  index: controller.currentIndex,
                  children: controller.screens,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.shifting,
                  currentIndex: controller.currentIndex,
                  showSelectedLabels: false,
                  elevation: 8,
                  onTap: (value) {
                    setState(() {
                      controller.changeIndex(value);
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        controller.currentIndex == 0
                            ? IconlyBold.home
                            : IconlyLight.home,
                        color: controller.currentIndex == 0
                            ? Colours.primaryColour
                            : Colors.grey,
                      ),
                      label: 'Home',
                      backgroundColor: Colors.white,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        controller.currentIndex == 1
                            ? IconlyBold.document
                            : IconlyLight.document,
                        color: controller.currentIndex == 1
                            ? Colours.primaryColour
                            : Colors.grey,
                      ),
                      label: 'Materials',
                      backgroundColor: Colors.white,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        controller.currentIndex == 2
                            ? IconlyBold.chat
                            : IconlyLight.chat,
                        color: controller.currentIndex == 2
                            ? Colours.primaryColour
                            : Colors.grey,
                      ),
                      label: 'Chat',
                      backgroundColor: Colors.white,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        controller.currentIndex == 3
                            ? IconlyBold.profile
                            : IconlyLight.profile,
                        color: controller.currentIndex == 3
                            ? Colours.primaryColour
                            : Colors.grey,
                      ),
                      label: 'Profile',
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
