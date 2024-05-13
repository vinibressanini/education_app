import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/common/widgets/admin_button.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/src/course/presentation/widgets/add_course_sheet.dart';
import 'package:education_app/src/profile/presentation/widgets/profile_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProfileInfoCard(
              color: Colours.physicsTileColour,
              icon: const Icon(
                IconlyLight.document,
                color: Color(0xff767dff),
                size: 24,
              ),
              infoTitle: 'Courses',
              infoValue: user!.enrolledCoursesId.length.toString(),
            ),
            ProfileInfoCard(
              color: Colours.languageTileColour,
              icon: Image.asset(
                MediaRes.scoreboard,
                width: 24,
                height: 24,
              ),
              infoTitle: 'Score',
              infoValue: user.points.toString(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ProfileInfoCard(
              color: Colours.biologyTileColour,
              icon: const Icon(
                IconlyLight.user,
                size: 24,
                color: Color(0xff56aeff),
              ),
              infoTitle: 'Followers',
              infoValue: user.followers.length.toString(),
            ),
            ProfileInfoCard(
              color: Colours.chemistryTileColour,
              icon: const Icon(
                IconlyLight.user,
                size: 24,
                color: Color(0xffff84aa),
              ),
              infoTitle: 'Following',
              infoValue: user.following.length.toString(),
            ),
          ],
        ),
        if (user.isAdmin) ...[
          AdminButton(
            icon: IconlyLight.paper_upload,
            label: 'Add Course',
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (_) => BlocProvider(
                  create: (_) => sl<CourseCubit>(),
                  child: const AddCourseSheet(),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
