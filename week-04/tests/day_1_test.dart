// Week 4, day 1 — your copy of the template is Shelf now.
// Copy this file to shelf_v2/test/week_04/ and run: flutter test test/week_04/day_1_test.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_v2/ui/core/strings.dart';
import 'package:shelf_v2/ui/core/theme.dart';

void main() {
  test('the app is called Shelf', () {
    expect(AppStrings.appName, 'Shelf');
  });

  test("the colours come from Shelf's brown", () {
    expect(seedColor, const Color(0xFF6D4C41));
  });

  test('the Android app id is your own, not the example one', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, isNot(contains('com.example')));
  });

  test('the iOS bundle id is your own, not the example one', () {
    final project = File('ios/Runner.xcodeproj/project.pbxproj').readAsStringSync();
    expect(project, isNot(contains('com.example')));
  });
}
