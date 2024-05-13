import 'dart:io';

import 'package:education_app/core/common/widgets/titled_form_field.dart';
import 'package:education_app/core/res/colours.dart';
import 'package:education_app/core/utils/constants.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/course/data/models/course_model.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class AddCourseSheet extends StatefulWidget {
  const AddCourseSheet({super.key});

  @override
  State<AddCourseSheet> createState() => _AddCourseSheetState();
}

class _AddCourseSheetState extends State<AddCourseSheet> {
  final titleController = TextEditingController();
  final descrptionController = TextEditingController();
  final imageController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isFile = false;

  bool loading = false;

  File? image;

  @override
  void dispose() {
    titleController.dispose();
    descrptionController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    imageController.addListener(() {
      if (isFile && imageController.text.trim().isEmpty) {
        isFile = false;
        image = null;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CourseCubit, CourseState>(
      listener: (_, state) {
        if (state is CourseError) {
          CoreUtils.showSnackbar(context, state.message);
        } else if (state is AddingCourse) {
          loading = true;
          CoreUtils.showModalLoader(context);
        } else if (state is CourseAdded) {
          if (loading) {
            loading = false;
            Navigator.pop(context);
          }
          CoreUtils.showSnackbar(context, 'Course succesfully added');
          Navigator.pop(context);
          // TODO(vinibressanini): implement notification sender
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const Text(
                  'Add Course',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                TitledFormField(
                  controller: titleController,
                  label: 'Course Title',
                  required: true,
                ),
                TitledFormField(
                  controller: descrptionController,
                  label: 'Course Description',
                  required: true,
                ),
                TitledFormField(
                  controller: imageController,
                  label: 'Course Image',
                  required: false,
                  hint: 'Pick an image from the gallery or insert the URL',
                  hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      image = await CoreUtils.pickImage();
                      if (image != null) {
                        isFile = true;
                        final imageName = image!.path.split('/').last;
                        imageController.text = imageName;
                      }
                    },
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colours.primaryColour,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colours.primaryColour,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final now = DateTime.now();
                            final course = CourseModel.empty().copyWith(
                              title: titleController.text.trim(),
                              description: descrptionController.text.trim(),
                              image: imageController.text.trim().isEmpty
                                  ? kDefaultAvatar
                                  : isFile
                                      ? image!.path
                                      : imageController.text.trim(),
                              createdAt: now,
                              updatedAt: now,
                              imageIsFile: isFile,
                            );

                            context.read<CourseCubit>().addCourse(course);
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
