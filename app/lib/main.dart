import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'features/reminders/data/background_tasks.dart';
import 'features/reminders/domain/reminder_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  if (!kIsWeb) {
    // Neither of these should block the first frame or crash startup.
    unawaited(sl<ReminderNotifier>().initialise().catchError((Object e) => debugPrint('Notifications: $e')));
    unawaited(registerBackgroundTasks().catchError((Object e) => debugPrint('Workmanager: $e')));
  }

  runApp(const WealthMateApp());
}
