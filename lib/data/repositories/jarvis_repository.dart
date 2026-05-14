import '../models/jarvis_models.dart';

class JarvisRepository {
  List<HomeStat> getHomeStats() {
    return const [
      HomeStat(label: 'Height', value: '175', unit: 'CM', progress: 0.72),
      HomeStat(label: 'Weight', value: '72', unit: 'KG', progress: 0.60),
    ];
  }

  List<VitalStat> getVitalStats() {
    return const [
      VitalStat(label: 'BMI', value: '23.5'),
      VitalStat(label: 'AGE', value: '24'),
      VitalStat(label: 'FAT%', value: '18%'),
      VitalStat(label: 'WATER', value: '62%'),
    ];
  }

  List<ModuleSummary> getModuleSummaries() {
    return const [
      ModuleSummary(
        id: 'study-page',
        icon: '📚',
        name: 'Study',
        moduleLabel: 'Module 01',
      ),
      ModuleSummary(
        id: 'gym-page',
        icon: '🏋️',
        name: 'Gym',
        moduleLabel: 'Module 02',
      ),
      ModuleSummary(
        id: 'expense-page',
        icon: '💳',
        name: 'Expense',
        moduleLabel: 'Module 09',
      ),
      ModuleSummary(
        id: 'workout-page',
        icon: '⚡',
        name: 'Workout',
        moduleLabel: 'Module 03',
      ),
      ModuleSummary(
        id: 'fashion-page',
        icon: '👔',
        name: 'Fashion',
        moduleLabel: 'Module 04',
      ),
      ModuleSummary(
        id: 'motivation-page',
        icon: '🔥',
        name: 'Motivate',
        moduleLabel: 'Module 05',
      ),
      ModuleSummary(
        id: 'mood-page',
        icon: '🧠',
        name: 'Mood',
        moduleLabel: 'Module 06',
      ),
      ModuleSummary(
        id: 'business-page',
        icon: '💼',
        name: 'Business',
        moduleLabel: 'Module 07',
      ),
      ModuleSummary(
        id: 'skincare-page',
        icon: '✨',
        name: 'Skincare',
        moduleLabel: 'Module 08',
      ),
    ];
  }

  ModuleDetail? getModuleById(String id) {
    return _modules[id];
  }

  final Map<String, ModuleDetail> _modules = {
    'study-page': const ModuleDetail(
      id: 'study-page',
      moduleLabel: 'Module 01',
      title: 'STUDY HUB',
      tip: "Boss, you study best between 9AM-12PM. You're 34% more productive in this window.",
      progressItems: [
        ProgressItem(label: 'Mathematics', percent: 75),
        ProgressItem(label: 'Physics', percent: 45),
        ProgressItem(label: 'Programming', percent: 90),
      ],
      actions: [
        ActionItem(icon: '⏱️', label: 'Pomodoro'),
        ActionItem(icon: '📝', label: 'Notes'),
        ActionItem(icon: '🎯', label: 'Set Goals'),
        ActionItem(icon: '📊', label: 'Analytics'),
      ],
      tags: [TagItem('Exam in 12 days'), TagItem('4hr streak'), TagItem('Top 5%')],
    ),
    'gym-page': const ModuleDetail(
      id: 'gym-page',
      moduleLabel: 'Module 02',
      title: 'GYM INTEL',
      intro: 'Today\'s Split: PUSH',
      tip: 'Bench Press 4x8 · Overhead Press 3x10 · Incline DB 3x12 · Tricep Pushdown 3x15 · Lateral Raises 4x15',
      progressItems: [
        ProgressItem(label: 'Muscle Mass', percent: 68),
        ProgressItem(label: 'Strength Index', percent: 72),
        ProgressItem(label: 'Endurance', percent: 55),
      ],
      actions: [
        ActionItem(icon: '🏋️', label: 'Log Lift'),
        ActionItem(icon: '🥗', label: 'Nutrition'),
        ActionItem(icon: '💤', label: 'Recovery'),
        ActionItem(icon: '📈', label: 'Progress'),
      ],
      tags: [TagItem('Chest'), TagItem('Shoulders'), TagItem('Triceps')],
    ),
    'workout-page': const ModuleDetail(
      id: 'workout-page',
      moduleLabel: 'Module 03',
      title: 'WORKOUT ENGINE',
      highlightTitle: 'Day 4 / 6',
      highlightSubtitle: 'Upper Body Power',
      steps: [
        StepItem(number: '1', title: 'Warm Up - 10 min', subtitle: 'Dynamic stretching + jump rope'),
        StepItem(number: '2', title: 'Main Block - 40 min', subtitle: '4 compound lifts, 4x8 each'),
        StepItem(number: '3', title: 'Accessory Work - 20 min', subtitle: 'Isolation movements + core'),
        StepItem(number: '4', title: 'Cool Down - 10 min', subtitle: 'Static stretch + breathing'),
      ],
      actions: [ActionItem(icon: '▶', label: 'START SESSION')],
    ),
    'fashion-page': const ModuleDetail(
      id: 'fashion-page',
      moduleLabel: 'Module 04',
      title: 'STYLE MATRIX',
      intro: 'Today\'s Rec',
      tip: 'Boss, today is a work meeting + gym combo. Suggesting business-casual AM, athletic PM.',
      outfits: [
        OutfitItem(icon: '🌅', name: 'Morning: Smart Casual', description: 'Dark chinos · White Oxford · Loafers'),
        OutfitItem(icon: '🌆', name: 'Evening: Sporty Edge', description: 'Joggers · Oversized Tee · Sneakers'),
        OutfitItem(icon: '🌙', name: 'Night Out: Elevated', description: 'Black slim fit · Chelsea boots · Chain'),
      ],
      tags: [TagItem('Minimalist'), TagItem('Dark Tones'), TagItem('Structured'), TagItem('Futuristic')],
    ),
    'motivation-page': const ModuleDetail(
      id: 'motivation-page',
      moduleLabel: 'Module 05',
      title: 'IGNITE PROTOCOL',
      quotes: [
        QuoteItem(
          text: 'The difference between who you are and who you want to be is what you do.',
          author: 'DAILY DIRECTIVE',
          primary: true,
        ),
        QuoteItem(
          text: 'Discipline is choosing between what you want now and what you want most.',
          author: 'JARVIS CORE PRINCIPLE',
        ),
      ],
      actions: [
        ActionItem(icon: '🎯', label: 'Daily Goals'),
        ActionItem(icon: '🏆', label: 'Wins Today'),
        ActionItem(icon: '🔁', label: 'New Quote'),
        ActionItem(icon: '📌', label: 'Pin It'),
      ],
      highlightTitle: '14 Days Consistent',
      highlightSubtitle: "Don't break the chain, Boss.",
    ),
    'mood-page': const ModuleDetail(
      id: 'mood-page',
      moduleLabel: 'Module 06',
      title: 'MOOD SCANNER',
      intro: 'How are you feeling, Boss?',
      moods: [
        MoodOption(emoji: '😤', label: 'Focused'),
        MoodOption(emoji: '😴', label: 'Tired'),
        MoodOption(emoji: '🔥', label: 'Energized'),
        MoodOption(emoji: '😟', label: 'Stressed'),
        MoodOption(emoji: '😎', label: 'Confident'),
        MoodOption(emoji: '😐', label: 'Neutral'),
      ],
      tip: 'Detected: High focus mode. Recommended deep work session now (2hr block). Hydrate and avoid social media until 14:00.',
      moodWeekly: [0.40, 0.70, 0.55, 0.85, 0.45, 0.95, 0.80],
    ),
    'business-page': const ModuleDetail(
      id: 'business-page',
      moduleLabel: 'Module 07',
      title: 'COMMAND CENTER',
      metrics: [
        MetricItem(icon: '💰', value: 'RM 8.4K', label: 'Revenue MTD'),
        MetricItem(icon: '📈', value: '+24%', label: 'Growth Rate'),
        MetricItem(icon: '🤝', value: '12', label: 'Active Clients'),
        MetricItem(icon: '⏳', value: '3', label: 'Pending Deals'),
      ],
      steps: [
        StepItem(number: '!', title: 'Finalize Q2 proposal', subtitle: 'Due: Today 5PM', critical: true),
        StepItem(number: '2', title: 'Client call - Ahmad', subtitle: 'Tomorrow 10AM'),
        StepItem(number: '3', title: 'Update portfolio site', subtitle: 'This week'),
      ],
      actions: [
        ActionItem(icon: '📄', label: 'Invoices'),
        ActionItem(icon: '🗓️', label: 'Calendar'),
        ActionItem(icon: '📣', label: 'Marketing'),
        ActionItem(icon: '💡', label: 'Ideation'),
      ],
    ),
    'expense-page': const ModuleDetail(
      id: 'expense-page',
      moduleLabel: 'Module 09',
      title: 'EXPENSE LEDGER',
      intro: 'This month — snapshot',
      tip: 'Boss, recurring subs are creeping up (+8% vs last month). Review flagged categories.',
      metrics: [
        MetricItem(icon: '🧾', value: 'RM 2.4K', label: 'Spent MTD'),
        MetricItem(icon: '🎯', value: 'RM 900', label: 'Budget left'),
        MetricItem(icon: '📍', value: 'Food · 34%', label: 'Top category'),
        MetricItem(icon: '⚡', value: '3', label: 'Large purchases'),
      ],
      actions: [
        ActionItem(icon: '➕', label: 'Log expense'),
        ActionItem(icon: '📂', label: 'Categories'),
        ActionItem(icon: '📊', label: 'Breakdown'),
        ActionItem(icon: '🔔', label: 'Budget alerts'),
      ],
      tags: [TagItem('Sync bank (soon)'), TagItem('Export CSV')],
    ),
    'skincare-page': const ModuleDetail(
      id: 'skincare-page',
      moduleLabel: 'Module 08',
      title: 'SKIN PROTOCOL',
      intro: 'Skin Profile',
      tip: 'Type: Combination · Concern: Oiliness, Dark spots · UV Index Today: 7 (High)',
      tags: [TagItem('SPF Required'), TagItem('Hydrate++'), TagItem('Niacinamide')],
      steps: [
        StepItem(number: '1', title: 'Gentle Cleanser', subtitle: 'Cerave or La Roche-Posay · 60 sec'),
        StepItem(number: '2', title: 'Niacinamide Serum', subtitle: 'The Ordinary 10% · 2 drops'),
        StepItem(number: '3', title: 'Lightweight Moisturizer', subtitle: 'Oil-free · Gel formula preferred'),
        StepItem(number: '4', title: 'SPF 50+ Sunscreen', subtitle: 'MANDATORY today · UV Index 7'),
      ],
      highlightTitle: '82/100',
      highlightSubtitle: 'Improving. Keep the SPF consistent, Boss.',
    ),
  };
}
