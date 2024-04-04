import 'dart:convert';

import 'package:education_app/core/utils/typedefs.dart';
import 'package:education_app/src/auth/data/models/local_user_model.dart';
import 'package:education_app/src/auth/domain/entities/local_user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tLocalUserModel = LocalUserModel.empty();

  test('[LocalUserModel] MUST be a subclass of [LocalUser]', () {
    expect(tLocalUserModel, isA<LocalUser>());
  });

  late DataMap userMap;

  setUp(() => userMap = jsonDecode(fixture('user.json')) as DataMap);

  group('fromMap', () {
    test('MUST return a [LocalUserModel] WHEN succesful', () {
      final result = LocalUserModel.fromMap(userMap);

      expect(result, isA<LocalUserModel>());
      expect(result, equals(tLocalUserModel));
    });

    test('MUST throw a [ArgumentError] WHEN the JSON is invalid', () {
      userMap.remove('uid');

      const methodCall = LocalUserModel.fromMap;

      expect(() => methodCall(userMap), throwsA(isA<ArgumentError>()));
    });
  });

  group('toMap', () {
    test('MUST return a valid [DataMap] when succesful', () {
      final map = tLocalUserModel.toMap();

      expect(map, equals(userMap));
    });
  });

  group('copyWith', () {
    test('MUST change the only the given attribute WHEN [copyWith] is called',
        () {
      final result = tLocalUserModel.copyWith(fullName: 'test');

      expect(result.fullName, 'test');
    });
  });
}
