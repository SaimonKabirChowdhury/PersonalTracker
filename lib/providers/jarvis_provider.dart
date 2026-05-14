import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models/jarvis_models.dart';
import '../data/models/study_models.dart';
import '../data/repositories/jarvis_repository.dart';
import '../data/repositories/study_repository.dart';

class JarvisProvider extends ChangeNotifier {
  JarvisProvider(this._repository, this._studyRepository);

  final JarvisRepository _repository;
  final StudyRepository _studyRepository;
  final List<String> _history = [];

  String? _activeModuleId;
  String _selectedMood = 'Focused';

  bool _isStudyLoading = true;
  String? _studyError;
  StudyTab _studyTab = StudyTab.home;
  final List<StudyTab> _studyTabHistory = [];
  List<StudyModule> _studyModules = [];
  final Map<String, List<StudyMaterial>> _materialsByModule = {};
  final Map<String, List<StudyLecture>> _lecturesByModule = {};
  final Map<String, List<StudyChecklistItem>> _checklistByModule = {};
  final Map<String, List<StudyFlashcard>> _flashcardsByModule = {};
  final Map<String, List<StudyGrade>> _gradesByModule = {};
  final Map<String, List<StudyPdf>> _pdfsByModule = {};
  List<PlannerItem> _plannerItems = [];
  List<ExamItem> _examItems = [];
  List<AssignmentItem> _assignmentItems = [];
  ExamSortOption _examSortOption = ExamSortOption.closestUpcoming;
  PomodoroState _pomodoroState = PomodoroState();
  List<PomodoroSession> _pomodoroSessions = [];
  final Map<String, int> _flashcardIndexes = {};
  Timer? _pomodoroTicker;

  List<HomeStat> get homeStats => _repository.getHomeStats();
  List<VitalStat> get vitalStats => _repository.getVitalStats();
  List<ModuleSummary> get moduleSummaries => _repository.getModuleSummaries();
  ModuleDetail? get activeModule =>
      _activeModuleId == null ? null : _repository.getModuleById(_activeModuleId!);
  String get selectedMood => _selectedMood;
  bool get isStudyLoading => _isStudyLoading;
  String? get studyError => _studyError;
  StudyTab get studyTab => _studyTab;
  List<StudyModule> get studyModules => _studyModules;
  List<PlannerItem> get plannerItems => _plannerItems;
  List<ExamItem> get examItems => _sortedExams(_examItems);
  List<AssignmentItem> get assignmentItems => _assignmentItems;
  ExamSortOption get examSortOption => _examSortOption;
  PomodoroState get pomodoroState => _pomodoroState;
  List<PomodoroSession> get pomodoroSessions => _pomodoroSessions;

  void setStudyTab(StudyTab tab, {bool fromBack = false}) {
    if (_studyTab == tab) {
      return;
    }
    if (!fromBack) {
      _studyTabHistory.add(_studyTab);
    }
    _studyTab = tab;
    notifyListeners();
  }

  void resetStudyNavigation() {
    _studyTab = StudyTab.home;
    _studyTabHistory.clear();
    notifyListeners();
  }

  bool handleStudyBack() {
    if (_studyTabHistory.isNotEmpty) {
      final previous = _studyTabHistory.removeLast();
      _studyTab = previous;
      notifyListeners();
      return true;
    }

    if (_studyTab != StudyTab.home) {
      _studyTab = StudyTab.home;
      notifyListeners();
      return true;
    }

    return false;
  }

  List<StudyMaterial> getMaterialsForModule(String moduleId) =>
      _materialsByModule[moduleId] ?? const [];
  List<StudyLecture> getLecturesForModule(String moduleId) =>
      _lecturesByModule[moduleId] ?? const [];
  List<StudyChecklistItem> getChecklistForModule(String moduleId) =>
      _checklistByModule[moduleId] ?? const [];
  List<StudyFlashcard> getFlashcardsForModule(String moduleId) =>
      _flashcardsByModule[moduleId] ?? const [];
  List<StudyGrade> getGradesForModule(String moduleId) =>
      _gradesByModule[moduleId] ?? const [];
  List<StudyPdf> getPdfsForModule(String moduleId) =>
      _pdfsByModule[moduleId] ?? const [];

  int getCompletedCount(String moduleId) =>
      getChecklistForModule(moduleId).where((m) => m.isDone).length;

  int getCurrentFlashcardIndex(String moduleId) => _flashcardIndexes[moduleId] ?? 0;

  StudyFlashcard? getCurrentFlashcard(String moduleId) {
    final cards = getFlashcardsForModule(moduleId);
    if (cards.isEmpty) return null;
    return cards[getCurrentFlashcardIndex(moduleId) % cards.length];
  }

  void nextFlashcard(String moduleId) {
    final cards = getFlashcardsForModule(moduleId);
    if (cards.isEmpty) return;
    _flashcardIndexes[moduleId] = (getCurrentFlashcardIndex(moduleId) + 1) % cards.length;
    notifyListeners();
  }

  void prevFlashcard(String moduleId) {
    final cards = getFlashcardsForModule(moduleId);
    if (cards.isEmpty) return;
    final idx = getCurrentFlashcardIndex(moduleId);
    _flashcardIndexes[moduleId] = (idx - 1 + cards.length) % cards.length;
    notifyListeners();
  }

  Future<void> initStudyData() async {
    _isStudyLoading = true;
    _studyError = null;
    notifyListeners();
    try {
      await _studyRepository.seedIfEmpty();
      await refreshStudyData();
    } catch (e) {
      _studyError = e.toString();
      _isStudyLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshStudyData() async {
    _studyModules = _studyRepository.getModules();
    _plannerItems = _studyRepository.getPlannerItems();
    _examItems = _studyRepository.getExamItems();
    _assignmentItems = _studyRepository.getAssignments();
    _pomodoroState = _studyRepository.getPomodoroState();
    _pomodoroSessions = _studyRepository.getPomodoroSessions();
    _materialsByModule.clear();
    _lecturesByModule.clear();
    _checklistByModule.clear();
    _flashcardsByModule.clear();
    _gradesByModule.clear();
    _pdfsByModule.clear();
    for (final module in _studyModules) {
      _materialsByModule[module.id] = _studyRepository.getMaterialsForModule(module.id);
      _lecturesByModule[module.id] = _studyRepository.getLecturesForModule(module.id);
      _checklistByModule[module.id] = _studyRepository.getChecklistForModule(module.id);
      _flashcardsByModule[module.id] = _studyRepository.getFlashcardsForModule(module.id);
      _gradesByModule[module.id] = _studyRepository.getGradesForModule(module.id);
      _pdfsByModule[module.id] = _studyRepository.getPdfsForModule(module.id);
    }
    _isStudyLoading = false;
    notifyListeners();
  }

  void openModule(String id) {
    if (_activeModuleId == null) {
      _history.add('home');
    } else {
      _history.add(_activeModuleId!);
    }
    _activeModuleId = id;
    if (id == 'study-page') {
      _studyTab = StudyTab.home;
      _studyTabHistory.clear();
    }
    notifyListeners();
  }

  void goBack() {
    if (_history.isEmpty) return;
    final previous = _history.removeLast();
    _activeModuleId = previous == 'home' ? null : previous;
    notifyListeners();
  }

  void selectMood(String label) {
    _selectedMood = label;
    notifyListeners();
  }

  Future<void> createStudyModule(String name) async {
    await _studyRepository.createModule(name);
    await refreshStudyData();
  }

  Future<void> updateStudyModuleName({
    required String moduleId,
    required String name,
  }) async {
    await _studyRepository.updateModuleName(
      moduleId: moduleId,
      rawName: name,
    );
    await refreshStudyData();
  }

  Future<void> reorderStudyModules(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final next = [..._studyModules];
    final moved = next.removeAt(oldIndex);
    next.insert(newIndex, moved);
    _studyModules = next;
    notifyListeners();
    await _studyRepository.reorderModules(next.map((e) => e.id).toList());
    await refreshStudyData();
  }

  Future<void> setStudyPriority(String moduleId, StudyPriority priority) async {
    await _studyRepository.setModulePriority(moduleId, priority);
    await refreshStudyData();
  }

  Future<void> deleteStudyModule(String moduleId) async {
    await _studyRepository.deleteModule(moduleId);
    await refreshStudyData();
  }

  Future<void> restoreStudyModule(StudyModule module) async {
    await _studyRepository.restoreModule(module);
    await refreshStudyData();
  }

  Future<void> addStudyMaterial({
    required String moduleId,
    required String title,
    required String type,
    String? source,
    String? notes,
  }) async {
    await _studyRepository.addMaterial(
      moduleId: moduleId,
      title: title,
      type: type,
      source: source,
      notes: notes,
    );
    await refreshStudyData();
  }

  Future<void> toggleStudyMaterial(String materialId) async {
    await _studyRepository.toggleMaterialCompletion(materialId);
    await refreshStudyData();
  }

  Future<void> deleteStudyMaterial(String materialId) async {
    await _studyRepository.deleteMaterial(materialId);
    await refreshStudyData();
  }

  Future<void> toggleChecklist(String checklistId) async {
    await _studyRepository.toggleChecklist(checklistId);
    await refreshStudyData();
  }

  Future<void> addPdf(String moduleId, String fileName) async {
    await _studyRepository.addPdf(moduleId, fileName);
    await refreshStudyData();
  }

  Future<void> createExam({
    required String moduleId,
    required String title,
    required DateTime examDate,
    required String mode,
    required String timeLabel,
    String? scopeNote,
  }) async {
    await _studyRepository.createExam(
      moduleId: moduleId,
      title: title,
      examDate: examDate,
      mode: mode,
      timeLabel: timeLabel,
      scopeNote: scopeNote,
    );
    await refreshStudyData();
  }

  Future<void> updateExam(ExamItem exam) async {
    await _studyRepository.updateExam(exam);
    await refreshStudyData();
  }

  Future<void> deleteExam(String examId) async {
    await _studyRepository.deleteExam(examId);
    await refreshStudyData();
  }

  void setExamSortOption(ExamSortOption option) {
    if (_examSortOption == option) return;
    _examSortOption = option;
    notifyListeners();
  }

  Future<void> createAssignment({
    required String moduleId,
    required String title,
    required DateTime dueDate,
    required String timeLabel,
    String? notes,
  }) async {
    await _studyRepository.createAssignment(
      moduleId: moduleId,
      title: title,
      dueDate: dueDate,
      timeLabel: timeLabel,
      notes: notes,
    );
    await refreshStudyData();
  }

  Future<void> updateAssignment(AssignmentItem assignment) async {
    await _studyRepository.updateAssignment(assignment);
    await refreshStudyData();
  }

  Future<void> deleteAssignment(String assignmentId) async {
    await _studyRepository.deleteAssignment(assignmentId);
    await refreshStudyData();
  }

  Future<void> toggleAssignment(String assignmentId) async {
    await _studyRepository.toggleAssignment(assignmentId);
    await refreshStudyData();
  }

  static const _modeDurations = {
    PomodoroMode.focus: 1500,
    PomodoroMode.shortBreak: 300,
    PomodoroMode.longBreak: 900,
  };

  Future<void> setPomodoroMode(PomodoroMode mode) async {
    _stopPomodoroTicker();
    _pomodoroState = _pomodoroState.copyWith(
      mode: mode,
      remainingSeconds: _modeDurations[mode],
      isRunning: false,
    );
    await _studyRepository.setPomodoroState(_pomodoroState);
    notifyListeners();
  }

  Future<void> setPomodoroLinkedModule(String moduleId) async {
    _pomodoroState = _pomodoroState.copyWith(linkedModuleId: moduleId);
    await _studyRepository.setPomodoroState(_pomodoroState);
    notifyListeners();
  }

  Future<void> togglePomodoro() async {
    if (_pomodoroState.isRunning) {
      _stopPomodoroTicker();
      _pomodoroState = _pomodoroState.copyWith(isRunning: false);
      await _studyRepository.setPomodoroState(_pomodoroState);
      notifyListeners();
      return;
    }

    _pomodoroState = _pomodoroState.copyWith(isRunning: true);
    await _studyRepository.setPomodoroState(_pomodoroState);
    _pomodoroTicker = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_pomodoroState.remainingSeconds <= 0) {
        final linked = _pomodoroState.linkedModuleId ?? (_studyModules.isEmpty ? null : _studyModules.first.id);
        if (linked != null && _pomodoroState.mode == PomodoroMode.focus) {
          await _studyRepository.addPomodoroSession(moduleId: linked, durationMinutes: 25);
        }
        _stopPomodoroTicker();
        _pomodoroState = _pomodoroState.copyWith(
          isRunning: false,
          remainingSeconds: _modeDurations[_pomodoroState.mode],
          sessionIndex: _pomodoroState.sessionIndex >= 4 ? 1 : _pomodoroState.sessionIndex + 1,
        );
        await _studyRepository.setPomodoroState(_pomodoroState);
        await refreshStudyData();
        return;
      }
      _pomodoroState = _pomodoroState.copyWith(
        remainingSeconds: _pomodoroState.remainingSeconds - 1,
      );
      await _studyRepository.setPomodoroState(_pomodoroState);
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> resetPomodoro() async {
    _stopPomodoroTicker();
    _pomodoroState = _pomodoroState.copyWith(
      isRunning: false,
      remainingSeconds: _modeDurations[_pomodoroState.mode],
    );
    await _studyRepository.setPomodoroState(_pomodoroState);
    notifyListeners();
  }

  Future<void> skipPomodoro() async {
    _stopPomodoroTicker();
    _pomodoroState = _pomodoroState.copyWith(
      isRunning: false,
      remainingSeconds: _modeDurations[_pomodoroState.mode],
      sessionIndex: _pomodoroState.sessionIndex >= 4 ? 1 : _pomodoroState.sessionIndex + 1,
    );
    await _studyRepository.setPomodoroState(_pomodoroState);
    notifyListeners();
  }

  Future<void> addPomodoroMinute() async {
    _pomodoroState = _pomodoroState.copyWith(
      remainingSeconds: (_pomodoroState.remainingSeconds + 60).clamp(0, 99 * 60),
    );
    await _studyRepository.setPomodoroState(_pomodoroState);
    notifyListeners();
  }

  void _stopPomodoroTicker() {
    _pomodoroTicker?.cancel();
    _pomodoroTicker = null;
  }

  List<ExamItem> _sortedExams(List<ExamItem> source) {
    final list = [...source];
    if (_examSortOption == ExamSortOption.mostUpdated) {
      list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return list;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    list.sort((a, b) {
      final aDate = DateTime(a.examDate.year, a.examDate.month, a.examDate.day);
      final bDate = DateTime(b.examDate.year, b.examDate.month, b.examDate.day);
      final aUpcoming = !aDate.isBefore(today);
      final bUpcoming = !bDate.isBefore(today);
      if (aUpcoming != bUpcoming) return aUpcoming ? -1 : 1;
      if (aUpcoming) return aDate.compareTo(bDate);
      return bDate.compareTo(aDate);
    });
    return list;
  }

  @override
  void dispose() {
    _stopPomodoroTicker();
    super.dispose();
  }
}
