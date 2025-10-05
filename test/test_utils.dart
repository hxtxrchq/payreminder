import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payreminderapp/logic/providers/database_providers.dart';
import 'package:payreminderapp/data/db/app_database.dart';

List<Override> inMemoryDbOverride() => [
      databaseProvider.overrideWithValue(AppDatabase.memory()),
    ];
