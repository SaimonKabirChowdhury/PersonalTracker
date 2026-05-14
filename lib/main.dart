import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/models/study_models.dart';
import 'data/repositories/jarvis_repository.dart';
import 'data/repositories/study_repository.dart';
import 'providers/jarvis_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StudyModuleAdapter());
  Hive.registerAdapter(StudyMaterialAdapter());
  final moduleBox = await Hive.openBox<StudyModule>('study_modules');
  final materialBox = await Hive.openBox<StudyMaterial>('study_materials');
  final lectureBox = await Hive.openBox<Map>('study_lectures');
  final checklistBox = await Hive.openBox<Map>('study_checklist');
  final flashcardBox = await Hive.openBox<Map>('study_flashcards');
  final gradeBox = await Hive.openBox<Map>('study_grades');
  final pdfBox = await Hive.openBox<Map>('study_pdfs');
  final plannerBox = await Hive.openBox<Map>('study_planner');
  final examBox = await Hive.openBox<Map>('study_exams');
  final assignmentBox = await Hive.openBox<Map>('study_assignments');
  final pomodoroStateBox = await Hive.openBox<Map>('study_pomodoro_state');
  final pomodoroSessionBox = await Hive.openBox<Map>('study_pomodoro_sessions');

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => JarvisRepository()),
        Provider(
          create: (_) => StudyRepository(
            moduleBox,
            materialBox,
            lectureBox,
            checklistBox,
            flashcardBox,
            gradeBox,
            pdfBox,
            plannerBox,
            examBox,
            assignmentBox,
            pomodoroStateBox,
            pomodoroSessionBox,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => JarvisProvider(
            context.read<JarvisRepository>(),
            context.read<StudyRepository>(),
          )..initStudyData(),
        ),
      ],
      child: const JarvisApp(),
    ),
  );
}
