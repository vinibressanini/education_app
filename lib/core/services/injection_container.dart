import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasource.dart';
import 'package:education_app/src/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:education_app/src/auth/data/repositories/auth_repo_impl.dart';
import 'package:education_app/src/auth/domain/repositories/auth_repo.dart';
import 'package:education_app/src/auth/domain/usecases/forgot_password.dart';
import 'package:education_app/src/auth/domain/usecases/sign_in.dart';
import 'package:education_app/src/auth/domain/usecases/sign_up.dart';
import 'package:education_app/src/auth/domain/usecases/update_user.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/course/data/datasources/course_remote_datasource.dart';
import 'package:education_app/src/course/data/datasources/course_remote_datasource_impl.dart';
import 'package:education_app/src/course/data/repositories/course_repository_impl.dart';
import 'package:education_app/src/course/domain/repositories/course_repo.dart';
import 'package:education_app/src/course/domain/usecases/add_course.dart';
import 'package:education_app/src/course/domain/usecases/get_courses.dart';
import 'package:education_app/src/course/presentation/cubit/course_cubit.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_datasource.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_datasource_impl.dart';
import 'package:education_app/src/on_boarding/data/repositories/on_boarding_repository_impl.dart';
import 'package:education_app/src/on_boarding/domain/repositories/on_boarding_repository.dart';
import 'package:education_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:education_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:education_app/src/on_boarding/presentation/cubits/cubit/on_boarding_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.main.dart';
