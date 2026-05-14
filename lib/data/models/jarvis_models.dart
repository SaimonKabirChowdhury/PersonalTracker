class HomeStat {
  const HomeStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.progress,
  });

  final String label;
  final String value;
  final String unit;
  final double progress;
}

class VitalStat {
  const VitalStat({required this.label, required this.value});

  final String label;
  final String value;
}

class ModuleSummary {
  const ModuleSummary({
    required this.id,
    required this.icon,
    required this.name,
    required this.moduleLabel,
  });

  final String id;
  final String icon;
  final String name;
  final String moduleLabel;
}

class ProgressItem {
  const ProgressItem({required this.label, required this.percent});

  final String label;
  final int percent;
}

class ActionItem {
  const ActionItem({required this.icon, required this.label});

  final String icon;
  final String label;
}

class TagItem {
  const TagItem(this.label);

  final String label;
}

class StepItem {
  const StepItem({
    required this.number,
    required this.title,
    required this.subtitle,
    this.critical = false,
  });

  final String number;
  final String title;
  final String subtitle;
  final bool critical;
}

class MetricItem {
  const MetricItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final String icon;
  final String value;
  final String label;
}

class QuoteItem {
  const QuoteItem({required this.text, required this.author, this.primary = false});

  final String text;
  final String author;
  final bool primary;
}

class OutfitItem {
  const OutfitItem({
    required this.icon,
    required this.name,
    required this.description,
  });

  final String icon;
  final String name;
  final String description;
}

class MoodOption {
  const MoodOption({required this.emoji, required this.label});

  final String emoji;
  final String label;
}

class ModuleDetail {
  const ModuleDetail({
    required this.id,
    required this.title,
    required this.moduleLabel,
    this.intro,
    this.tip,
    this.progressItems = const [],
    this.actions = const [],
    this.tags = const [],
    this.steps = const [],
    this.metrics = const [],
    this.quotes = const [],
    this.outfits = const [],
    this.moods = const [],
    this.moodWeekly = const [],
    this.highlightTitle,
    this.highlightSubtitle,
  });

  final String id;
  final String title;
  final String moduleLabel;
  final String? intro;
  final String? tip;
  final List<ProgressItem> progressItems;
  final List<ActionItem> actions;
  final List<TagItem> tags;
  final List<StepItem> steps;
  final List<MetricItem> metrics;
  final List<QuoteItem> quotes;
  final List<OutfitItem> outfits;
  final List<MoodOption> moods;
  final List<double> moodWeekly;
  final String? highlightTitle;
  final String? highlightSubtitle;
}
