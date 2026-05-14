import 'package:hive/hive.dart';

import '../models/study_models.dart';

class StudyRepository {
  StudyRepository(
    this._moduleBox,
    this._materialBox,
    this._lectureBox,
    this._checklistBox,
    this._flashcardBox,
    this._gradeBox,
    this._pdfBox,
    this._plannerBox,
    this._examBox,
    this._assignmentBox,
    this._pomodoroStateBox,
    this._pomodoroSessionBox,
  );

  final Box<StudyModule> _moduleBox;
  final Box<StudyMaterial> _materialBox;
  final Box<Map> _lectureBox;
  final Box<Map> _checklistBox;
  final Box<Map> _flashcardBox;
  final Box<Map> _gradeBox;
  final Box<Map> _pdfBox;
  final Box<Map> _plannerBox;
  final Box<Map> _examBox;
  final Box<Map> _assignmentBox;
  final Box<Map> _pomodoroStateBox;
  final Box<Map> _pomodoroSessionBox;

  static const List<String> materialTypes = [
    'lecture_notes',
    'slides',
    'assignment',
    'past_paper',
    'reference',
  ];

  List<StudyModule> getModules() {
    final modules = _moduleBox.values.toList()
      ..sort((a, b) => a.priorityIndex.compareTo(b.priorityIndex));
    return modules;
  }

  List<StudyMaterial> getMaterialsForModule(String moduleId) {
    return _materialBox.values
        .where((item) => item.moduleId == moduleId)
        .toList()
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  }

  List<StudyLecture> getLecturesForModule(String moduleId) {
    return _lectureBox.values
        .map(StudyLecture.fromMap)
        .where((l) => l.moduleId == moduleId)
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));
  }

  List<StudyChecklistItem> getChecklistForModule(String moduleId) {
    return _checklistBox.values
        .map(StudyChecklistItem.fromMap)
        .where((c) => c.moduleId == moduleId)
        .toList();
  }

  List<StudyFlashcard> getFlashcardsForModule(String moduleId) {
    return _flashcardBox.values
        .map(StudyFlashcard.fromMap)
        .where((f) => f.moduleId == moduleId)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  List<StudyGrade> getGradesForModule(String moduleId) {
    return _gradeBox.values
        .map(StudyGrade.fromMap)
        .where((g) => g.moduleId == moduleId)
        .toList();
  }

  List<StudyPdf> getPdfsForModule(String moduleId) {
    return _pdfBox.values
        .map(StudyPdf.fromMap)
        .where((p) => p.moduleId == moduleId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<PlannerItem> getPlannerItems() {
    return _plannerBox.values
        .map(PlannerItem.fromMap)
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  List<ExamItem> getExamItems() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _examBox.values
        .map(ExamItem.fromMap)
        .toList()
      ..sort((a, b) {
        final aDate = DateTime(a.examDate.year, a.examDate.month, a.examDate.day);
        final bDate = DateTime(b.examDate.year, b.examDate.month, b.examDate.day);
        final aUpcoming = !aDate.isBefore(today);
        final bUpcoming = !bDate.isBefore(today);

        if (aUpcoming != bUpcoming) {
          return aUpcoming ? -1 : 1;
        }
        if (aUpcoming) {
          // Upcoming exams: nearest first.
          return aDate.compareTo(bDate);
        }
        // Past exams: most recent first.
        return bDate.compareTo(aDate);
      });
  }

  List<AssignmentItem> getAssignments() {
    return _assignmentBox.values
        .map(AssignmentItem.fromMap)
        .toList()
      ..sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return a.dueDate.compareTo(b.dueDate);
      });
  }

  PomodoroState getPomodoroState() {
    final map = _pomodoroStateBox.get('state');
    if (map == null) {
      return PomodoroState(linkedModuleId: getModules().isEmpty ? null : getModules().first.id);
    }
    return PomodoroState.fromMap(map);
  }

  List<PomodoroSession> getPomodoroSessions() {
    return _pomodoroSessionBox.values
        .map(PomodoroSession.fromMap)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> seedIfEmpty() async {
    if (_moduleBox.isNotEmpty) {
      return;
    }

    final now = DateTime.now();
    final initial = [
      StudyModule(
        id: _idFromName('Mathematics', now),
        name: 'Mathematics',
        priorityIndex: 0,
        createdAt: now,
      ),
      StudyModule(
        id: _idFromName('Physics', now.add(const Duration(seconds: 1))),
        name: 'Physics',
        priorityIndex: 1,
        createdAt: now,
      ),
      StudyModule(
        id: _idFromName('Programming', now.add(const Duration(seconds: 2))),
        name: 'Programming',
        priorityIndex: 2,
        createdAt: now,
      ),
    ];

    for (final module in initial) {
      await _moduleBox.put(module.id, module);
    }

    if (_lectureBox.isEmpty) {
      final modules = getModules();
      for (final module in modules) {
        for (var i = 0; i < 8; i++) {
          final lecture = StudyLecture(
            id: '${module.id}_lec_$i',
            moduleId: module.id,
            title: '${module.name} Lecture ${i + 1}',
            index: i,
            isReviewed: i < (module.name == 'Programming' ? 7 : module.name == 'Mathematics' ? 5 : 3),
          );
          await _lectureBox.put(lecture.id, lecture.toMap());
        }
      }
    }

    if (_checklistBox.isEmpty) {
      final modules = getModules();
      for (final module in modules) {
        final items = [
          'Revise key formulas',
          'Solve past papers',
          'Summarize lecture notes',
        ];
        for (var i = 0; i < items.length; i++) {
          final item = StudyChecklistItem(
            id: '${module.id}_chk_$i',
            moduleId: module.id,
            label: items[i],
            isDone: i == 0,
          );
          await _checklistBox.put(item.id, item.toMap());
        }
      }
    }

    if (_flashcardBox.isEmpty) {
      final modules = getModules();
      for (final module in modules) {
        final cards = [
          StudyFlashcard(
            id: '${module.id}_flash_0',
            moduleId: module.id,
            question: 'Core concept of ${module.name}?',
            answer: 'Review lecture summary and key equations.',
            order: 0,
          ),
          StudyFlashcard(
            id: '${module.id}_flash_1',
            moduleId: module.id,
            question: 'Most common exam question pattern?',
            answer: 'Past paper style problem solving.',
            order: 1,
          ),
        ];
        for (final card in cards) {
          await _flashcardBox.put(card.id, card.toMap());
        }
      }
    }

    if (_gradeBox.isEmpty) {
      final modules = getModules();
      for (final module in modules) {
        final grade = StudyGrade(
          id: '${module.id}_grade_mid',
          moduleId: module.id,
          label: 'Midterm',
          value: module.name == 'Programming' ? '87%' : module.name == 'Mathematics' ? '74%' : '65%',
          band: module.name == 'Programming'
              ? StudyGradeBand.good
              : module.name == 'Mathematics'
                  ? StudyGradeBand.warn
                  : StudyGradeBand.bad,
        );
        await _gradeBox.put(grade.id, grade.toMap());
      }
    }

    if (_examBox.isEmpty) {
      final modules = getModules();
      final now = DateTime.now();
      for (var i = 0; i < modules.length; i++) {
        final item = ExamItem(
          id: '${modules[i].id}_exam',
          moduleId: modules[i].id,
          title: '${modules[i].name} Final Exam',
          examDate: now.add(Duration(days: [3, 16, 34][i % 3])),
          updatedAt: now,
          mode: i == 1 ? 'online' : 'physical',
          timeLabel: i == 0 ? '09:00' : i == 1 ? '14:00' : '11:30',
          scopeNote: i == 0
              ? 'Mathematics · Ch 4-6'
              : i == 1
                  ? 'Physics · Full syllabus'
                  : 'Programming · DSA',
        );
        await _examBox.put(item.id, item.toMap());
      }
    }

    if (_plannerBox.isEmpty) {
      final modules = getModules();
      final now = DateTime.now();
      for (var i = 0; i < modules.length; i++) {
        final item = PlannerItem(
          id: 'plan_$i',
          title: '${modules[i].name} Deep Review',
          moduleId: modules[i].id,
          startAt: DateTime(now.year, now.month, now.day, 9 + i * 2),
          durationMinutes: 90,
          type: 'study_block',
        );
        await _plannerBox.put(item.id, item.toMap());
      }
    }

    if (_pomodoroStateBox.get('state') == null) {
      final state = PomodoroState(
        mode: PomodoroMode.focus,
        remainingSeconds: 1500,
        sessionIndex: 1,
        linkedModuleId: getModules().first.id,
      );
      await _pomodoroStateBox.put('state', state.toMap());
    }
  }

  Future<StudyModule> createModule(String rawName) async {
    final name = rawName.trim();
    if (name.isEmpty) {
      throw ArgumentError('Module name cannot be empty.');
    }
    if (_nameExists(name)) {
      throw ArgumentError('A module with this name already exists.');
    }

    final modules = getModules();
    final now = DateTime.now();
    final module = StudyModule(
      id: _idFromName(name, now),
      name: name,
      priorityIndex: modules.length,
      createdAt: now,
    );
    await _moduleBox.put(module.id, module);
    return module;
  }

  Future<void> updateModuleName({
    required String moduleId,
    required String rawName,
  }) async {
    final module = _moduleBox.get(moduleId);
    if (module == null) {
      throw ArgumentError('Target module not found.');
    }
    final name = rawName.trim();
    if (name.isEmpty) {
      throw ArgumentError('Module name cannot be empty.');
    }
    if (_nameExists(name, excludeModuleId: moduleId)) {
      throw ArgumentError('A module with this name already exists.');
    }

    await _moduleBox.put(moduleId, module.copyWith(name: name));
  }

  Future<void> reorderModules(List<String> orderedModuleIds) async {
    for (var i = 0; i < orderedModuleIds.length; i++) {
      final module = _moduleBox.get(orderedModuleIds[i]);
      if (module == null) {
        continue;
      }
      await _moduleBox.put(
        module.id,
        module.copyWith(priorityIndex: i),
      );
    }
  }

  Future<void> deleteModule(String moduleId) async {
    await _moduleBox.delete(moduleId);

    final materialKeys = _materialBox.keys
        .where((key) => _materialBox.get(key)?.moduleId == moduleId)
        .toList();
    await _materialBox.deleteAll(materialKeys);

    await _normalizePriorityIndexes();
  }

  Future<void> restoreModule(StudyModule module) async {
    if (_moduleBox.containsKey(module.id)) {
      return;
    }
    final restored = module.copyWith(priorityIndex: getModules().length);
    await _moduleBox.put(restored.id, restored);
  }

  Future<StudyMaterial> addMaterial({
    required String moduleId,
    required String title,
    required String type,
    String? source,
    String? notes,
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Material title cannot be empty.');
    }
    if (!materialTypes.contains(type)) {
      throw ArgumentError('Unsupported material type.');
    }

    final material = StudyMaterial(
      id: '${moduleId}_${DateTime.now().microsecondsSinceEpoch}',
      moduleId: moduleId,
      title: cleanTitle,
      type: type,
      source: source?.trim().isEmpty == true ? null : source?.trim(),
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
    );
    await _materialBox.put(material.id, material);
    return material;
  }

  Future<void> updateMaterial(StudyMaterial material) async {
    await _materialBox.put(material.id, material);
  }

  Future<void> deleteMaterial(String materialId) async {
    await _materialBox.delete(materialId);
  }

  Future<void> toggleMaterialCompletion(String materialId) async {
    final existing = _materialBox.get(materialId);
    if (existing == null) {
      return;
    }
    await _materialBox.put(
      materialId,
      existing.copyWith(isCompleted: !existing.isCompleted),
    );
  }

  Future<void> setModulePriority(String moduleId, StudyPriority priority) async {
    final module = _moduleBox.get(moduleId);
    if (module == null) return;
    await _moduleBox.put(moduleId, module.copyWith(priority: priority));
  }

  Future<void> toggleChecklist(String checklistId) async {
    final map = _checklistBox.get(checklistId);
    if (map == null) return;
    final item = StudyChecklistItem.fromMap(map);
    await _checklistBox.put(checklistId, item.copyWith(isDone: !item.isDone).toMap());
  }

  Future<void> addPdf(String moduleId, String name) async {
    final file = StudyPdf(
      id: '${moduleId}_pdf_${DateTime.now().microsecondsSinceEpoch}',
      moduleId: moduleId,
      name: name,
      sizeLabel: '${(1 + (DateTime.now().millisecond % 4))}.${DateTime.now().second % 9} MB',
      createdAt: DateTime.now(),
    );
    await _pdfBox.put(file.id, file.toMap());
  }

  Future<void> setPomodoroState(PomodoroState state) async {
    await _pomodoroStateBox.put('state', state.toMap());
  }

  Future<void> addPomodoroSession({
    required String moduleId,
    required int durationMinutes,
  }) async {
    final session = PomodoroSession(
      id: 'pom_${DateTime.now().microsecondsSinceEpoch}',
      moduleId: moduleId,
      durationMinutes: durationMinutes,
      timestamp: DateTime.now(),
    );
    await _pomodoroSessionBox.put(session.id, session.toMap());
  }

  Future<ExamItem> createExam({
    required String moduleId,
    required String title,
    required DateTime examDate,
    required String mode,
    required String timeLabel,
    String? scopeNote,
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Exam title cannot be empty.');
    }
    final module = _moduleBox.get(moduleId);
    if (module == null) {
      throw ArgumentError('Target module not found.');
    }

    final item = ExamItem(
      id: 'exam_${DateTime.now().microsecondsSinceEpoch}',
      moduleId: moduleId,
      title: cleanTitle,
      examDate: examDate,
      updatedAt: DateTime.now(),
      mode: mode,
      timeLabel: timeLabel,
      scopeNote: scopeNote?.trim().isEmpty == true ? null : scopeNote?.trim(),
    );
    await _examBox.put(item.id, item.toMap());
    return item;
  }

  Future<void> updateExam(ExamItem exam) async {
    await _examBox.put(
      exam.id,
      exam.copyWith(updatedAt: DateTime.now()).toMap(),
    );
  }

  Future<void> deleteExam(String examId) async {
    await _examBox.delete(examId);
  }

  Future<AssignmentItem> createAssignment({
    required String moduleId,
    required String title,
    required DateTime dueDate,
    required String timeLabel,
    String? notes,
  }) async {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Assignment title cannot be empty.');
    }
    final module = _moduleBox.get(moduleId);
    if (module == null) {
      throw ArgumentError('Target module not found.');
    }

    final item = AssignmentItem(
      id: 'asg_${DateTime.now().microsecondsSinceEpoch}',
      moduleId: moduleId,
      title: cleanTitle,
      dueDate: dueDate,
      timeLabel: timeLabel,
      notes: notes?.trim().isEmpty == true ? null : notes?.trim(),
    );
    await _assignmentBox.put(item.id, item.toMap());
    return item;
  }

  Future<void> updateAssignment(AssignmentItem assignment) async {
    await _assignmentBox.put(assignment.id, assignment.toMap());
  }

  Future<void> deleteAssignment(String assignmentId) async {
    await _assignmentBox.delete(assignmentId);
  }

  Future<void> toggleAssignment(String assignmentId) async {
    final map = _assignmentBox.get(assignmentId);
    if (map == null) return;
    final item = AssignmentItem.fromMap(map);
    await _assignmentBox.put(
      assignmentId,
      item.copyWith(isCompleted: !item.isCompleted).toMap(),
    );
  }

  bool _nameExists(String name, {String? excludeModuleId}) {
    final lower = name.toLowerCase();
    return _moduleBox.values.any(
      (item) =>
          item.id != excludeModuleId && item.name.toLowerCase() == lower,
    );
  }

  Future<void> _normalizePriorityIndexes() async {
    final modules = getModules();
    for (var i = 0; i < modules.length; i++) {
      final module = modules[i];
      if (module.priorityIndex == i) {
        continue;
      }
      await _moduleBox.put(module.id, module.copyWith(priorityIndex: i));
    }
  }

  static String _idFromName(String name, DateTime dt) {
    final slug = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return '${slug}_${dt.microsecondsSinceEpoch}';
  }
}
