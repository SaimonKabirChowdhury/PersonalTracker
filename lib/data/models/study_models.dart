import 'package:hive/hive.dart';

enum StudyPriority { high, medium, low }

enum StudyTab { home, modules, pomodoro, planner, analytics }

enum PomodoroMode { focus, shortBreak, longBreak }

enum StudyGradeBand { good, warn, bad }

enum ExamSortOption { closestUpcoming, mostUpdated }

class StudyModule {
  StudyModule({
    required this.id,
    required this.name,
    required this.priorityIndex,
    required this.createdAt,
    this.priority = StudyPriority.medium,
    this.progressPercent = 0,
    this.examDate,
    this.hoursStudied = 0,
    this.colorHex = '534AB7',
  });

  final String id;
  final String name;
  final int priorityIndex;
  final DateTime createdAt;
  final StudyPriority priority;
  final int progressPercent;
  final DateTime? examDate;
  final int hoursStudied;
  final String colorHex;

  StudyModule copyWith({
    String? id,
    String? name,
    int? priorityIndex,
    DateTime? createdAt,
    StudyPriority? priority,
    int? progressPercent,
    DateTime? examDate,
    int? hoursStudied,
    String? colorHex,
  }) {
    return StudyModule(
      id: id ?? this.id,
      name: name ?? this.name,
      priorityIndex: priorityIndex ?? this.priorityIndex,
      createdAt: createdAt ?? this.createdAt,
      priority: priority ?? this.priority,
      progressPercent: progressPercent ?? this.progressPercent,
      examDate: examDate ?? this.examDate,
      hoursStudied: hoursStudied ?? this.hoursStudied,
      colorHex: colorHex ?? this.colorHex,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'priorityIndex': priorityIndex,
      'createdAt': createdAt.toIso8601String(),
      'priority': priority.name,
      'progressPercent': progressPercent,
      'examDate': examDate?.toIso8601String(),
      'hoursStudied': hoursStudied,
      'colorHex': colorHex,
    };
  }

  static StudyModule fromMap(Map<dynamic, dynamic> map) {
    return StudyModule(
      id: map['id'] as String,
      name: map['name'] as String,
      priorityIndex: map['priorityIndex'] as int,
      createdAt: DateTime.parse(map['createdAt'] as String),
      priority: StudyPriority.values.firstWhere(
        (p) => p.name == (map['priority'] as String? ?? 'medium'),
        orElse: () => StudyPriority.medium,
      ),
      progressPercent: map['progressPercent'] as int? ?? 0,
      examDate: map['examDate'] == null
          ? null
          : DateTime.parse(map['examDate'] as String),
      hoursStudied: map['hoursStudied'] as int? ?? 0,
      colorHex: map['colorHex'] as String? ?? '534AB7',
    );
  }
}

class StudyModuleAdapter extends TypeAdapter<StudyModule> {
  @override
  final int typeId = 0;

  @override
  StudyModule read(BinaryReader reader) {
    return StudyModule(
      id: reader.readString(),
      name: reader.readString(),
      priorityIndex: reader.readInt(),
      createdAt: DateTime.parse(reader.readString()),
    );
  }

  @override
  void write(BinaryWriter writer, StudyModule obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.name)
      ..writeInt(obj.priorityIndex)
      ..writeString(obj.createdAt.toIso8601String());
  }
}

class StudyMaterial {
  StudyMaterial({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.type,
    this.source,
    this.notes,
    this.isCompleted = false,
  });

  final String id;
  final String moduleId;
  final String title;
  final String type;
  final String? source;
  final String? notes;
  final bool isCompleted;

  StudyMaterial copyWith({
    String? id,
    String? moduleId,
    String? title,
    String? type,
    String? source,
    String? notes,
    bool? isCompleted,
  }) {
    return StudyMaterial(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      type: type ?? this.type,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class StudyMaterialAdapter extends TypeAdapter<StudyMaterial> {
  @override
  final int typeId = 1;

  @override
  StudyMaterial read(BinaryReader reader) {
    return StudyMaterial(
      id: reader.readString(),
      moduleId: reader.readString(),
      title: reader.readString(),
      type: reader.readString(),
      source: reader.read(),
      notes: reader.read(),
      isCompleted: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, StudyMaterial obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.moduleId)
      ..writeString(obj.title)
      ..writeString(obj.type)
      ..write(obj.source)
      ..write(obj.notes)
      ..writeBool(obj.isCompleted);
  }
}

class StudyLecture {
  StudyLecture({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.index,
    this.isReviewed = false,
  });

  final String id;
  final String moduleId;
  final String title;
  final int index;
  final bool isReviewed;

  StudyLecture copyWith({bool? isReviewed}) => StudyLecture(
    id: id,
    moduleId: moduleId,
    title: title,
    index: index,
    isReviewed: isReviewed ?? this.isReviewed,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'moduleId': moduleId,
    'title': title,
    'index': index,
    'isReviewed': isReviewed,
  };

  static StudyLecture fromMap(Map<dynamic, dynamic> map) => StudyLecture(
    id: map['id'] as String,
    moduleId: map['moduleId'] as String,
    title: map['title'] as String,
    index: map['index'] as int,
    isReviewed: map['isReviewed'] as bool? ?? false,
  );
}

class StudyChecklistItem {
  StudyChecklistItem({
    required this.id,
    required this.moduleId,
    required this.label,
    this.isDone = false,
  });

  final String id;
  final String moduleId;
  final String label;
  final bool isDone;

  StudyChecklistItem copyWith({bool? isDone}) => StudyChecklistItem(
    id: id,
    moduleId: moduleId,
    label: label,
    isDone: isDone ?? this.isDone,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'moduleId': moduleId,
    'label': label,
    'isDone': isDone,
  };

  static StudyChecklistItem fromMap(Map<dynamic, dynamic> map) =>
      StudyChecklistItem(
        id: map['id'] as String,
        moduleId: map['moduleId'] as String,
        label: map['label'] as String,
        isDone: map['isDone'] as bool? ?? false,
      );
}

class StudyFlashcard {
  StudyFlashcard({
    required this.id,
    required this.moduleId,
    required this.question,
    required this.answer,
    required this.order,
  });

  final String id;
  final String moduleId;
  final String question;
  final String answer;
  final int order;

  Map<String, dynamic> toMap() => {
    'id': id,
    'moduleId': moduleId,
    'question': question,
    'answer': answer,
    'order': order,
  };

  static StudyFlashcard fromMap(Map<dynamic, dynamic> map) => StudyFlashcard(
    id: map['id'] as String,
    moduleId: map['moduleId'] as String,
    question: map['question'] as String,
    answer: map['answer'] as String,
    order: map['order'] as int,
  );
}

class StudyGrade {
  StudyGrade({
    required this.id,
    required this.moduleId,
    required this.label,
    required this.value,
    this.band = StudyGradeBand.warn,
  });

  final String id;
  final String moduleId;
  final String label;
  final String value;
  final StudyGradeBand band;

  Map<String, dynamic> toMap() => {
    'id': id,
    'moduleId': moduleId,
    'label': label,
    'value': value,
    'band': band.name,
  };

  static StudyGrade fromMap(Map<dynamic, dynamic> map) => StudyGrade(
    id: map['id'] as String,
    moduleId: map['moduleId'] as String,
    label: map['label'] as String,
    value: map['value'] as String,
    band: StudyGradeBand.values.firstWhere(
      (b) => b.name == (map['band'] as String? ?? 'warn'),
      orElse: () => StudyGradeBand.warn,
    ),
  );
}

class StudyPdf {
  StudyPdf({
    required this.id,
    required this.moduleId,
    required this.name,
    required this.sizeLabel,
    required this.createdAt,
  });

  final String id;
  final String moduleId;
  final String name;
  final String sizeLabel;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
    'id': id,
    'moduleId': moduleId,
    'name': name,
    'sizeLabel': sizeLabel,
    'createdAt': createdAt.toIso8601String(),
  };

  static StudyPdf fromMap(Map<dynamic, dynamic> map) => StudyPdf(
    id: map['id'] as String,
    moduleId: map['moduleId'] as String,
    name: map['name'] as String,
    sizeLabel: map['sizeLabel'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
  );
}

class PlannerItem {
  PlannerItem({
    required this.id,
    required this.title,
    required this.moduleId,
    required this.startAt,
    required this.durationMinutes,
    required this.type,
  });

  final String id;
  final String title;
  final String moduleId;
  final DateTime startAt;
  final int durationMinutes;
  final String type;

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'moduleId': moduleId,
    'startAt': startAt.toIso8601String(),
    'durationMinutes': durationMinutes,
    'type': type,
  };

  static PlannerItem fromMap(Map<dynamic, dynamic> map) => PlannerItem(
    id: map['id'] as String,
    title: map['title'] as String,
    moduleId: map['moduleId'] as String,
    startAt: DateTime.parse(map['startAt'] as String),
    durationMinutes: map['durationMinutes'] as int,
    type: map['type'] as String,
  );
}

class ExamItem {
  ExamItem({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.examDate,
    required this.updatedAt,
    this.mode = 'physical',
    this.timeLabel = '09:00',
    this.scopeNote,
  });

  final String id;
  final String moduleId;
  final String title;
  final DateTime examDate;
  final DateTime updatedAt;
  final String mode;
  final String timeLabel;
  final String? scopeNote;

  ExamItem copyWith({
    String? id,
    String? moduleId,
    String? title,
    DateTime? examDate,
    DateTime? updatedAt,
    String? mode,
    String? timeLabel,
    String? scopeNote,
  }) {
    return ExamItem(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      examDate: examDate ?? this.examDate,
      updatedAt: updatedAt ?? this.updatedAt,
      mode: mode ?? this.mode,
      timeLabel: timeLabel ?? this.timeLabel,
      scopeNote: scopeNote ?? this.scopeNote,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'moduleId': moduleId,
    'title': title,
    'examDate': examDate.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'mode': mode,
    'timeLabel': timeLabel,
    'scopeNote': scopeNote,
  };

  static ExamItem fromMap(Map<dynamic, dynamic> map) => ExamItem(
    id: map['id'] as String,
    moduleId: map['moduleId'] as String,
    title: map['title'] as String,
    examDate: DateTime.parse(map['examDate'] as String),
    updatedAt: map['updatedAt'] == null
        ? DateTime.parse(map['examDate'] as String)
        : DateTime.parse(map['updatedAt'] as String),
    mode: map['mode'] as String? ?? 'physical',
    timeLabel: map['timeLabel'] as String? ?? '09:00',
    scopeNote: map['scopeNote'] as String?,
  );
}

class AssignmentItem {
  AssignmentItem({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.dueDate,
    this.timeLabel = '23:59',
    this.notes,
    this.isCompleted = false,
  });

  final String id;
  final String moduleId;
  final String title;
  final DateTime dueDate;
  final String timeLabel;
  final String? notes;
  final bool isCompleted;

  AssignmentItem copyWith({
    String? id,
    String? moduleId,
    String? title,
    DateTime? dueDate,
    String? timeLabel,
    String? notes,
    bool? isCompleted,
  }) {
    return AssignmentItem(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      timeLabel: timeLabel ?? this.timeLabel,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'moduleId': moduleId,
    'title': title,
    'dueDate': dueDate.toIso8601String(),
    'timeLabel': timeLabel,
    'notes': notes,
    'isCompleted': isCompleted,
  };

  static AssignmentItem fromMap(Map<dynamic, dynamic> map) => AssignmentItem(
    id: map['id'] as String,
    moduleId: map['moduleId'] as String,
    title: map['title'] as String,
    dueDate: DateTime.parse(map['dueDate'] as String),
    timeLabel: map['timeLabel'] as String? ?? '23:59',
    notes: map['notes'] as String?,
    isCompleted: map['isCompleted'] as bool? ?? false,
  );
}

class PomodoroState {
  PomodoroState({
    this.mode = PomodoroMode.focus,
    this.remainingSeconds = 1500,
    this.isRunning = false,
    this.sessionIndex = 1,
    this.linkedModuleId,
  });

  final PomodoroMode mode;
  final int remainingSeconds;
  final bool isRunning;
  final int sessionIndex;
  final String? linkedModuleId;

  PomodoroState copyWith({
    PomodoroMode? mode,
    int? remainingSeconds,
    bool? isRunning,
    int? sessionIndex,
    String? linkedModuleId,
  }) {
    return PomodoroState(
      mode: mode ?? this.mode,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      sessionIndex: sessionIndex ?? this.sessionIndex,
      linkedModuleId: linkedModuleId ?? this.linkedModuleId,
    );
  }

  Map<String, dynamic> toMap() => {
    'mode': mode.name,
    'remainingSeconds': remainingSeconds,
    'isRunning': isRunning,
    'sessionIndex': sessionIndex,
    'linkedModuleId': linkedModuleId,
  };

  static PomodoroState fromMap(Map<dynamic, dynamic> map) => PomodoroState(
    mode: PomodoroMode.values.firstWhere(
      (m) => m.name == (map['mode'] as String? ?? 'focus'),
      orElse: () => PomodoroMode.focus,
    ),
    remainingSeconds: map['remainingSeconds'] as int? ?? 1500,
    isRunning: map['isRunning'] as bool? ?? false,
    sessionIndex: map['sessionIndex'] as int? ?? 1,
    linkedModuleId: map['linkedModuleId'] as String?,
  );
}

class PomodoroSession {
  PomodoroSession({
    required this.id,
    required this.moduleId,
    required this.durationMinutes,
    required this.timestamp,
  });

  final String id;
  final String moduleId;
  final int durationMinutes;
  final DateTime timestamp;

  Map<String, dynamic> toMap() => {
    'id': id,
    'moduleId': moduleId,
    'durationMinutes': durationMinutes,
    'timestamp': timestamp.toIso8601String(),
  };

  static PomodoroSession fromMap(Map<dynamic, dynamic> map) => PomodoroSession(
    id: map['id'] as String,
    moduleId: map['moduleId'] as String,
    durationMinutes: map['durationMinutes'] as int,
    timestamp: DateTime.parse(map['timestamp'] as String),
  );
}
