import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/jarvis_models.dart';
import '../../data/models/study_models.dart';
import '../../providers/jarvis_provider.dart';
import '../widgets/ui_blocks.dart';

const _htmlP = Color(0xFF534AB7);
const _htmlPLight = Color(0xFFEEEDFE);
const _htmlPDark = Color(0xFF3C3489);
const _htmlPTextDark = Color(0xFF26215C);
const _htmlC = Color(0xFFD85A30);
const _htmlCLight = Color(0xFFFAECE7);
const _htmlCDark = Color(0xFF993C1D);
const _htmlB = Color(0xFF185FA5);
const _htmlBLight = Color(0xFFE6F1FB);
const _htmlG = Color(0xFF3B6D11);
const _htmlGLight = Color(0xFFEAF3DE);
const _htmlA = Color(0xFFBA7517);
const _htmlALight = Color(0xFFFAEEDA);
const _htmlADark = Color(0xFF633806);

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({super.key, required this.detail});

  final ModuleDetail detail;

  @override
  Widget build(BuildContext context) {
    if (detail.id == 'study-page') {
      return const _StudyHubScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.snow,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(title: detail.title, subtitle: detail.moduleLabel),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (detail.intro != null || detail.tip != null)
                    SectionCard(
                      title: detail.intro ?? 'Insight',
                      child: Text(detail.tip ?? ''),
                    ),
                  if (detail.progressItems.isNotEmpty)
                    SectionCard(
                      title: 'Progress',
                      child: Column(
                        children: detail.progressItems
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(item.label)),
                                    Text('${item.percent}%'),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  if (detail.metrics.isNotEmpty)
                    SectionCard(
                      title: 'Key numbers',
                      child: Column(
                        children: detail.metrics
                            .map(
                              (m) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Text(m.icon, style: const TextStyle(fontSize: 20)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        m.label,
                                        style: GoogleFonts.exo2(
                                          fontSize: 13,
                                          color: AppColors.ink2.withValues(alpha: 0.85),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      m.value,
                                      style: GoogleFonts.orbitron(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  if (detail.actions.isNotEmpty)
                    GridView.builder(
                      itemCount: detail.actions.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) => Card(
                        child: Center(child: Text(detail.actions[index].label)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudyHubScreen extends StatelessWidget {
  const _StudyHubScreen();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    return Scaffold(
      backgroundColor: AppColors.snow,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF6F0FF),
                Color(0xFFFFF6FB),
                Color(0xFFF1F8FF),
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
          child: Column(
            children: [
              _TopBar(
                title: 'STUDY HUB',
                subtitle: 'Module 01',
                onBackPressed: () {
                  final provider = context.read<JarvisProvider>();
                  final handledInStudy = provider.handleStudyBack();
                  if (!handledInStudy) {
                    provider.goBack();
                  }
                },
              ),
              if (provider.isStudyLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else ...[
                Expanded(
                  child: Stack(
                    children: [
                      IndexedStack(
                        index: provider.studyTab.index,
                        children: const [
                          _StudyHomeTab(),
                          _StudyModulesTab(),
                          _StudyPomodoroTab(),
                          _StudyPlannerTab(),
                          _StudyAnalyticsTab(),
                        ],
                      ),
                      if (provider.studyTab == StudyTab.home)
                        const Positioned(
                          right: 16,
                          bottom: 16,
                          child: _QuickAddFab(),
                        ),
                    ],
                  ),
                ),
                const _StudyNavBar(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.subtitle,
    this.onBackPressed,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFAF6FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.p500.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: onBackPressed ?? context.read<JarvisProvider>().goBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '// $subtitle',
                style: GoogleFonts.orbitron(
                  fontSize: 10,
                  color: AppColors.p400,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StudyNavBar extends StatelessWidget {
  const _StudyNavBar();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    final now = DateTime.now();
    final overdue = provider.assignmentItems
        .where((a) => !a.isCompleted && a.dueDate.isBefore(now))
        .length;
    final urgentExams = provider.examItems.where((e) {
      final days = e.examDate.difference(now).inDays;
      return days >= 0 && days <= 3;
    }).length;
    final plannerBadge = overdue + urgentExams;
    final focusRunning = provider.pomodoroState.isRunning;
    final focusLiveTime = focusRunning
        ? _formatTime(provider.pomodoroState.remainingSeconds)
        : null;

    const items = <_StudyNavItem>[
      _StudyNavItem(
        StudyTab.home,
        Icons.home_rounded,
        Icons.home_outlined,
        'Home',
      ),
      _StudyNavItem(
        StudyTab.modules,
        Icons.dashboard_rounded,
        Icons.dashboard_outlined,
        'Modules',
      ),
      _StudyNavItem(
        StudyTab.pomodoro,
        Icons.timer_rounded,
        Icons.timer_outlined,
        'Focus',
      ),
      _StudyNavItem(
        StudyTab.planner,
        Icons.calendar_month_rounded,
        Icons.calendar_month_outlined,
        'Planner',
      ),
      _StudyNavItem(
        StudyTab.analytics,
        Icons.insights_rounded,
        Icons.insights_outlined,
        'Insights',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFFAF6FF)],
          ),
          border: Border.all(color: _htmlP.withValues(alpha: 0.10)),
          boxShadow: [
            BoxShadow(
              color: _htmlP.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Row(
            children: items.map((item) {
              final selected = provider.studyTab == item.tab;
              int badge = 0;
              bool pulsing = false;
              String? liveTime;
              if (item.tab == StudyTab.planner) {
                badge = plannerBadge;
              } else if (item.tab == StudyTab.pomodoro) {
                pulsing = focusRunning;
                liveTime = focusLiveTime;
              }
              return Expanded(
                flex: selected ? 2 : 1,
                child: _StudyNavTab(
                  item: item,
                  selected: selected,
                  badgeCount: badge,
                  pulsing: pulsing,
                  liveTime: liveTime,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    provider.setStudyTab(item.tab);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _StudyNavItem {
  const _StudyNavItem(
    this.tab,
    this.activeIcon,
    this.inactiveIcon,
    this.label,
  );
  final StudyTab tab;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
}

class _StudyNavTab extends StatelessWidget {
  const _StudyNavTab({
    required this.item,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
    this.pulsing = false,
    this.liveTime,
  });

  final _StudyNavItem item;
  final bool selected;
  final VoidCallback onTap;
  final int badgeCount;
  final bool pulsing;
  final String? liveTime;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      selected ? item.activeIcon : item.inactiveIcon,
      key: ValueKey<bool>(selected),
      size: 20,
      color: selected
          ? Colors.white
          : AppColors.ink2.withValues(alpha: 0.55),
    );

    final iconStack = Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: iconWidget,
        ),
        if (badgeCount > 0)
          Positioned(
            top: -5,
            right: -8,
            child: TweenAnimationBuilder<double>(
              key: ValueKey<String>('badge-${item.tab.name}-$badgeCount'),
              tween: Tween<double>(begin: 0.4, end: 1.0),
              duration: const Duration(milliseconds: 360),
              curve: Curves.elasticOut,
              builder: (_, scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: _BadgeBubble(
                count: badgeCount,
                onSelectedTab: selected,
              ),
            ),
          ),
        if (pulsing)
          Positioned(
            top: -2,
            right: -2,
            child: _PulsingDot(
              color: selected
                  ? const Color(0xFFFFD897)
                  : const Color(0xFF1FB67E),
              size: 7,
            ),
          ),
      ],
    );

    final showLiveBelowIcon = liveTime != null && !selected;
    final iconCell = showLiveBelowIcon
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              iconStack,
              const SizedBox(height: 3),
              Text(
                liveTime!,
                style: GoogleFonts.orbitron(
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1FB67E),
                  letterSpacing: 0.2,
                  height: 1,
                ),
              ),
            ],
          )
        : iconStack;

    final labelText = (liveTime != null && selected) ? liveTime! : item.label;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: selected ? 12 : 8,
              vertical: showLiveBelowIcon ? 5 : 9,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: selected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6D28D9), Color(0xFFC026D3)],
                    )
                  : null,
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: _htmlP.withValues(alpha: 0.32),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                iconCell,
                ClipRect(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    child: selected
                        ? Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: AnimatedSwitcher(
                              duration:
                                  const Duration(milliseconds: 180),
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(
                                opacity: anim,
                                child: child,
                              ),
                              child: Text(
                                labelText,
                                key: ValueKey<String>(labelText),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: liveTime != null
                                    ? GoogleFonts.orbitron(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 0.4,
                                      )
                                    : GoogleFonts.exo2(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: 0.2,
                                      ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeBubble extends StatelessWidget {
  const _BadgeBubble({required this.count, required this.onSelectedTab});

  final int count;
  final bool onSelectedTab;

  @override
  Widget build(BuildContext context) {
    final label = count > 9 ? '9+' : '$count';
    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: onSelectedTab ? Colors.white : const Color(0xFFFFFFFF),
          width: 1.4,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4DE53935),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.exo2(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot({required this.color, this.size = 7});

  final Color color;
  final double size;

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = _ctrl.value;
        final haloScale = 0.7 + 0.7 * t;
        final haloAlpha = 0.45 - 0.40 * t;
        return SizedBox(
          width: widget.size + 8,
          height: widget.size + 8,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: (widget.size + 8) * haloScale,
                height: (widget.size + 8) * haloScale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(
                    alpha: haloAlpha.clamp(0.0, 1.0),
                  ),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                  border: Border.all(color: Colors.white, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.45),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StudyHomeTab extends StatelessWidget {
  const _StudyHomeTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    final modules = provider.studyModules;
    final exams = provider.examItems;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final visibleExams = provider.examSortOption == ExamSortOption.closestUpcoming
        ? exams.where((e) {
            final d = DateTime(e.examDate.year, e.examDate.month, e.examDate.day);
            return !d.isBefore(todayDate);
          }).toList()
        : exams;
    final assignments = provider.assignmentItems;
    final pendingAssignments =
        assignments.where((a) => !a.isCompleted).toList();
    final nextExam = exams.isEmpty ? null : exams.first;
    final nextAssignment =
        pendingAssignments.isEmpty ? null : pendingAssignments.first;

    final pomodoroSessions = provider.pomodoroSessions;
    final streak = _streakFromSessions(pomodoroSessions);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 108),
      children: [
        _StudyReveal(
          delay: const Duration(milliseconds: 0),
          child: _StudyHero(
            nextExam: nextExam,
            nextAssignment: nextAssignment,
            sessions: pomodoroSessions,
          ),
        ),
        const SizedBox(height: 12),
        _StudyReveal(
          delay: const Duration(milliseconds: 50),
          child: _StatPillsRow(
            modulesCount: modules.length,
            streakDays: streak,
            pendingTasks: pendingAssignments.length,
            examsCount: exams.length,
          ),
        ),
        const SizedBox(height: 12),
        _StudyReveal(
          delay: const Duration(milliseconds: 100),
          child: _HomeCard(
            title: 'Upcoming Exams',
            accent: _htmlC,
            leadingIcon: Icons.fact_check_outlined,
            actionLabel: '+ Add',
            onAction: () => _showAddExamDialog(context),
            child: visibleExams.isEmpty
                ? Column(
                    children: [
                      _ExamSortBar(
                        value: provider.examSortOption,
                        onChanged: context.read<JarvisProvider>().setExamSortOption,
                      ),
                      const SizedBox(height: 8),
                      const _EmptyHint(text: 'No exams scheduled yet.'),
                    ],
                  )
                : Column(
                    children: [
                      _ExamSortBar(
                        value: provider.examSortOption,
                        onChanged: context.read<JarvisProvider>().setExamSortOption,
                      ),
                      const SizedBox(height: 8),
                      ...visibleExams.map((e) {
                        String moduleName = 'Module';
                        for (final module in modules) {
                          if (module.id == e.moduleId) {
                            moduleName = module.name;
                            break;
                          }
                        }
                        return _ExamRow(
                          item: e,
                          moduleName: moduleName,
                          onEdit: () =>
                              _showAddExamDialog(context, existingExam: e),
                          onDelete: () =>
                              context.read<JarvisProvider>().deleteExam(e.id),
                        );
                      }),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 10),
        _StudyReveal(
          delay: const Duration(milliseconds: 150),
          child: _HomeCard(
            title: 'Assignments Due',
            accent: _htmlA,
            leadingIcon: Icons.assignment_outlined,
            actionLabel: '+ Add',
            onAction: () => _showAddAssignmentDialog(context),
            child: assignments.isEmpty
                ? const _EmptyHint(
                    text: 'No assignments yet. Add one with a due date.')
                : Column(
                    children: assignments.map((a) {
                      String moduleName = 'Module';
                      for (final module in modules) {
                        if (module.id == a.moduleId) {
                          moduleName = module.name;
                          break;
                        }
                      }
                      return _AssignmentRow(
                        item: a,
                        moduleName: moduleName,
                        onToggle: () => context
                            .read<JarvisProvider>()
                            .toggleAssignment(a.id),
                        onEdit: () => _showAddAssignmentDialog(
                          context,
                          existingAssignment: a,
                        ),
                        onDelete: () => context
                            .read<JarvisProvider>()
                            .deleteAssignment(a.id),
                      );
                    }).toList(),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        _StudyReveal(
          delay: const Duration(milliseconds: 200),
          child: _HomeCard(
            title: 'Modules',
            accent: _htmlP,
            leadingIcon: Icons.school_rounded,
            actionLabel: 'View all',
            onAction: () =>
                context.read<JarvisProvider>().setStudyTab(StudyTab.modules),
            child: modules.isEmpty
                ? const _EmptyHint(text: 'Add a module to start tracking.')
                : Column(
                    children: modules.toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final module = entry.value;
                      int? examDays;
                      for (final exam in exams) {
                        if (exam.moduleId == module.id) {
                          examDays =
                              exam.examDate.difference(DateTime.now()).inDays;
                          break;
                        }
                      }
                      return _ModulePreviewRow(
                        module: module,
                        index: index,
                        examDays: examDays,
                      );
                    }).toList(),
                  ),
          ),
        ),
        const SizedBox(height: 14),
        _StudyReveal(
          delay: const Duration(milliseconds: 250),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: _htmlP.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.dashboard_customize_rounded,
                    color: _htmlP, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                'JUMP TO',
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  letterSpacing: 1.4,
                  color: _htmlP,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _StudyReveal(
          delay: const Duration(milliseconds: 300),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.0,
            children: [
              _QuickCard(
                label: 'Pomodoro',
                subtitle: 'Focus timer',
                icon: Icons.av_timer_rounded,
                bg: _htmlPLight,
                iconColor: _htmlP,
                onTap: () => context
                    .read<JarvisProvider>()
                    .setStudyTab(StudyTab.pomodoro),
              ),
              _QuickCard(
                label: 'Notes',
                subtitle: 'Lectures & PDFs',
                icon: Icons.description_outlined,
                bg: _htmlBLight,
                iconColor: _htmlB,
                onTap: () => context
                    .read<JarvisProvider>()
                    .setStudyTab(StudyTab.modules),
              ),
              _QuickCard(
                label: 'Planner',
                subtitle: 'Targets & deadlines',
                icon: Icons.event_note_rounded,
                bg: _htmlALight,
                iconColor: _htmlA,
                onTap: () => context
                    .read<JarvisProvider>()
                    .setStudyTab(StudyTab.planner),
              ),
              _QuickCard(
                label: 'Analytics',
                subtitle: 'Study insights',
                icon: Icons.insights_rounded,
                bg: _htmlGLight,
                iconColor: _htmlG,
                onTap: () => context
                    .read<JarvisProvider>()
                    .setStudyTab(StudyTab.analytics),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

int _streakFromSessions(List<PomodoroSession> sessions) {
  if (sessions.isEmpty) return 0;
  final days = sessions
      .map((s) => DateTime(
            s.timestamp.year,
            s.timestamp.month,
            s.timestamp.day,
          ))
      .toSet();
  var streak = 0;
  var cursor = DateTime.now();
  cursor = DateTime(cursor.year, cursor.month, cursor.day);
  while (days.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

class _StatPillsRow extends StatelessWidget {
  const _StatPillsRow({
    required this.modulesCount,
    required this.streakDays,
    required this.pendingTasks,
    required this.examsCount,
  });

  final int modulesCount;
  final int streakDays;
  final int pendingTasks;
  final int examsCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatPill(
            value: '$modulesCount',
            label: 'Modules',
            icon: Icons.school_rounded,
            color: _htmlP,
            onTap: () =>
                context.read<JarvisProvider>().setStudyTab(StudyTab.modules),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatPill(
            value: '${streakDays}d',
            label: 'Streak',
            icon: Icons.local_fire_department_rounded,
            color: _htmlC,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatPill(
            value: '$pendingTasks',
            label: 'Pending',
            icon: Icons.assignment_turned_in_outlined,
            color: _htmlA,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatPill(
            value: '$examsCount',
            label: 'Exams',
            icon: Icons.fact_check_outlined,
            color: _htmlB,
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 9, 6, 9),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.22)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.10),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.18),
                      color.withValues(alpha: 0.08),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 15),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.orbitron(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.exo2(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink2.withValues(alpha: 0.62),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: GoogleFonts.exo2(
          fontSize: 12,
          color: AppColors.ink2.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _ExamSortBar extends StatelessWidget {
  const _ExamSortBar({
    required this.value,
    required this.onChanged,
  });

  final ExamSortOption value;
  final ValueChanged<ExamSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final label = switch (value) {
      ExamSortOption.closestUpcoming => 'Closest upcoming',
      ExamSortOption.mostUpdated => 'Most updated',
    };
    return Align(
      alignment: Alignment.centerRight,
      child: PopupMenuButton<ExamSortOption>(
        initialValue: value,
        onSelected: onChanged,
        itemBuilder: (context) => const [
          PopupMenuItem(
            value: ExamSortOption.closestUpcoming,
            child: Text('Closest upcoming'),
          ),
          PopupMenuItem(
            value: ExamSortOption.mostUpdated,
            child: Text('Most updated'),
          ),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _htmlCLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFF0B39B), width: 0.8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.sort_rounded, size: 14, color: _htmlCDark),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.exo2(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _htmlCDark,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 15,
                color: _htmlCDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyReveal extends StatefulWidget {
  const _StudyReveal({required this.delay, required this.child});
  final Duration delay;
  final Widget child;

  @override
  State<_StudyReveal> createState() => _StudyRevealState();
}

class _StudyRevealState extends State<_StudyReveal> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _show = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      offset: _show ? Offset.zero : const Offset(0, 0.06),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
        opacity: _show ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}

class _StudyHero extends StatelessWidget {
  const _StudyHero({
    required this.nextExam,
    required this.nextAssignment,
    required this.sessions,
  });

  final ExamItem? nextExam;
  final AssignmentItem? nextAssignment;
  final List<PomodoroSession> sessions;

  static const _dailyGoalHours = 4.0;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    if (hour < 21) return 'Good evening';
    return 'Late night focus';
  }

  String _focusLine() {
    if (nextExam != null) {
      final days = nextExam!.examDate.difference(DateTime.now()).inDays;
      return '${nextExam!.title} in ${days}d. Stay sharp.';
    }
    if (nextAssignment != null) {
      final days =
          nextAssignment!.dueDate.difference(DateTime.now()).inDays;
      return '${nextAssignment!.title} due in ${days}d.';
    }
    return 'Calm window — plan your next move.';
  }

  IconData _focusIcon() {
    if (nextExam != null) return Icons.fact_check_outlined;
    if (nextAssignment != null) return Icons.assignment_outlined;
    return Icons.auto_awesome_rounded;
  }

  List<double> _last7DayHours() {
    final today = DateTime.now();
    final base = DateTime(today.year, today.month, today.day);
    final result = List<double>.filled(7, 0.0);
    for (final s in sessions) {
      final ts = s.timestamp;
      final d = DateTime(ts.year, ts.month, ts.day);
      final daysAgo = base.difference(d).inDays;
      if (daysAgo >= 0 && daysAgo < 7) {
        result[6 - daysAgo] += s.durationMinutes / 60;
      }
    }
    return result;
  }

  int _streakDays() {
    if (sessions.isEmpty) return 0;
    final days = sessions
        .map((s) => DateTime(
              s.timestamp.year,
              s.timestamp.month,
              s.timestamp.day,
            ))
        .toSet();
    var streak = 0;
    var cursor = DateTime.now();
    cursor = DateTime(cursor.year, cursor.month, cursor.day);
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final last7 = _last7DayHours();
    final today = last7.isEmpty ? 0.0 : last7.last;
    final streak = _streakDays();
    final progress = (today / _dailyGoalHours).clamp(0.0, 1.0);
    final hoursLabel =
        today < 0.05 ? '0h' : '${today.toStringAsFixed(today >= 10 ? 0 : 1)}h';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3B2DAB),
            Color(0xFF6D28D9),
            Color(0xFFC026D3),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x405046C5),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned(
              top: -34,
              right: -28,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
            ),
            Positioned(
              bottom: -30,
              left: -22,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(
              top: 26,
              right: 70,
              child: Icon(
                Icons.auto_awesome,
                size: 14,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
            Positioned(
              top: 80,
              right: 28,
              child: Icon(
                Icons.bolt_rounded,
                size: 11,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.wb_sunny_outlined,
                                    size: 13,
                                    color:
                                        Colors.white.withValues(alpha: 0.85)),
                                const SizedBox(width: 5),
                                Text(
                                  _greeting().toUpperCase(),
                                  style: GoogleFonts.orbitron(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        Colors.white.withValues(alpha: 0.9),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  _focusIcon(),
                                  color: const Color(0xFFFFD897),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _focusLine(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StreakChip(streak: streak),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _ProgressRing(
                        progress: progress,
                        size: 78,
                        primary: hoursLabel,
                        secondary: 'of ${_dailyGoalHours.toInt()}h goal',
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: _Sparkline(values: last7)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => context
                              .read<JarvisProvider>()
                              .setStudyTab(StudyTab.pomodoro),
                          icon:
                              const Icon(Icons.play_arrow_rounded, size: 18),
                          label: Text(
                            'Start Focus',
                            style: GoogleFonts.exo2(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: _htmlPDark,
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _showQuickAddSheet(context),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(
                          'Add',
                          style: GoogleFonts.exo2(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withValues(alpha: 0.55),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: Color(0xFFFFC56F),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${streak}d',
            style: GoogleFonts.orbitron(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.progress,
    required this.size,
    required this.primary,
    required this.secondary,
  });

  final double progress;
  final double size;
  final String primary;
  final String secondary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(progress: progress),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                primary,
                style: GoogleFonts.orbitron(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                secondary,
                style: GoogleFonts.exo2(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.85),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - stroke) / 2;
    final bg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.white.withValues(alpha: 0.22);
    canvas.drawCircle(center, radius, bg);
    final fg = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      progress.clamp(0.0, 1.0) * 2 * math.pi,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _Sparkline extends StatelessWidget {
  const _Sparkline({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final maxV = values.fold<double>(0, math.max).clamp(0.5, 12.0);
    final today = DateTime.now();
    final labels = List.generate(7, (i) {
      final d = today.subtract(Duration(days: 6 - i));
      return const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][d.weekday - 1];
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.show_chart_rounded,
              size: 12,
              color: Colors.white.withValues(alpha: 0.75),
            ),
            const SizedBox(width: 4),
            Text(
              'LAST 7 DAYS',
              style: GoogleFonts.exo2(
                fontSize: 9,
                color: Colors.white.withValues(alpha: 0.75),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(values.length, (i) {
              final h = ((values[i] / maxV) * 36).clamp(3.0, 36.0);
              final isToday = i == values.length - 1;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        height: h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: isToday
                                ? const [
                                    Color(0xFFFFD897),
                                    Color(0xFFFF8C42),
                                  ]
                                : [
                                    Colors.white.withValues(alpha: 0.65),
                                    Colors.white.withValues(alpha: 0.35),
                                  ],
                          ),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[i],
                        style: GoogleFonts.exo2(
                          fontSize: 9,
                          color: Colors.white.withValues(
                              alpha: isToday ? 1.0 : 0.7),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ModulePreviewRow extends StatelessWidget {
  const _ModulePreviewRow({
    required this.module,
    required this.index,
    required this.examDays,
  });

  final StudyModule module;
  final int index;
  final int? examDays;

  @override
  Widget build(BuildContext context) {
    final style = _moduleStyle(index);
    final priorityLabel = switch (module.priority) {
      StudyPriority.high => 'high',
      StudyPriority.medium => 'med',
      StudyPriority.low => 'low',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () =>
            context.read<JarvisProvider>().setStudyTab(StudyTab.modules),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: style.color.withValues(alpha: 0.04),
            border: Border.all(
              color: style.color.withValues(alpha: 0.18),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          style.color.withValues(alpha: 0.20),
                          style.color.withValues(alpha: 0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: style.color.withValues(alpha: 0.30),
                      ),
                    ),
                    child: Icon(
                      _moduleIcon(module.name),
                      color: style.color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          module.name,
                          style: GoogleFonts.rajdhani(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _priorityBg(module.priority),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            priorityLabel,
                            style: GoogleFonts.exo2(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _priorityFg(module.priority),
                            ),
                          ),
                        ),
                        if (examDays != null && examDays! <= 7)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _htmlCLight,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              'exam soon',
                              style: GoogleFonts.exo2(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _htmlCDark,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${module.progressPercent}%',
                    style: GoogleFonts.orbitron(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: style.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: style.color.withValues(alpha: 0.7),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  minHeight: 5,
                  value: (module.progressPercent / 100).clamp(0.02, 1.0),
                  color: style.color,
                  backgroundColor: style.color.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleStyle {
  const _ModuleStyle(this.color);
  final Color color;
}

IconData _moduleIcon(String name) {
  final n = name.toLowerCase();
  if (n.contains('math') ||
      n.contains('calc') ||
      n.contains('algeb') ||
      n.contains('stat')) {
    return Icons.calculate_rounded;
  }
  if (n.contains('phys')) return Icons.science_rounded;
  if (n.contains('chem')) return Icons.biotech_rounded;
  if (n.contains('bio')) return Icons.eco_rounded;
  if (n.contains('prog') ||
      n.contains('code') ||
      n.contains('comp') ||
      n.contains('algo') ||
      n.contains('soft')) {
    return Icons.code_rounded;
  }
  if (n.contains('eng') || n.contains('lit') || n.contains('writ')) {
    return Icons.menu_book_rounded;
  }
  if (n.contains('hist')) return Icons.history_edu_rounded;
  if (n.contains('econ') || n.contains('finan') || n.contains('account')) {
    return Icons.show_chart_rounded;
  }
  if (n.contains('art') || n.contains('design')) return Icons.brush_rounded;
  if (n.contains('mus')) return Icons.music_note_rounded;
  if (n.contains('lang') || n.contains('span') || n.contains('fren')) {
    return Icons.translate_rounded;
  }
  if (n.contains('geo') || n.contains('earth')) {
    return Icons.public_rounded;
  }
  return Icons.school_rounded;
}

_ModuleStyle _moduleStyle(int index) {
  switch (index) {
    case 0:
      return const _ModuleStyle(_htmlP);
    case 1:
      return const _ModuleStyle(_htmlC);
    default:
      return const _ModuleStyle(Color(0xFF1D9E75));
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.bg,
    required this.iconColor,
    required this.onTap,
  });
  final String label;
  final String subtitle;
  final IconData icon;
  final Color bg;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, bg.withValues(alpha: 0.55)],
            ),
            border: Border.all(
              color: iconColor.withValues(alpha: 0.22),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: iconColor.withValues(alpha: 0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(icon, size: 19, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.rajdhani(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.exo2(
                        fontSize: 10,
                        color: AppColors.ink2.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 12,
                color: iconColor.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyModulesTab extends StatelessWidget {
  const _StudyModulesTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    final modules = provider.studyModules;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        _SectionHeader(
          title: 'Modules',
          actionLabel: '+ Add Module',
          onAction: () => _showAddModuleDialog(context),
        ),
        const SizedBox(height: 8),
        SectionCard(
          title: 'Priority Order',
          child: ReorderableListView.builder(
            itemCount: modules.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: provider.reorderStudyModules,
            itemBuilder: (context, index) {
              final module = modules[index];
              return Dismissible(
                key: ValueKey(module.id),
                direction: DismissDirection.horizontal,
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    await _showEditModuleDialog(context, module: module);
                    return false;
                  }
                  if (direction == DismissDirection.endToStart) {
                    return _confirmDeleteModule(context, module: module);
                  }
                  return false;
                },
                background: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _htmlPLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCFC7F0)),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit_rounded, color: _htmlP),
                      const SizedBox(width: 8),
                      Text(
                        'Edit module',
                        style: GoogleFonts.exo2(
                          fontWeight: FontWeight.w700,
                          color: _htmlP,
                        ),
                      ),
                    ],
                  ),
                ),
                secondaryBackground: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: _htmlCLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF0997B)),
                  ),
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Delete module',
                        style: GoogleFonts.exo2(
                          fontWeight: FontWeight.w700,
                          color: _htmlCDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.delete_outline_rounded, color: _htmlCDark),
                    ],
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ExpansionTile(
                    title: Text(module.name),
                    subtitle: Text('Priority #${index + 1}'),
                    trailing: const Icon(Icons.drag_indicator_rounded),
                    children: [
                      _PriorityChips(moduleId: module.id, selected: module.priority),
                      _ModuleDetails(moduleId: module.id),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<void> _showAddModuleDialog(BuildContext context) async {
  final controller = TextEditingController();
  final provider = context.read<JarvisProvider>();
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: _RelaxedDialogFrame(
          title: 'Add Module',
          onCancel: () => Navigator.of(dialogContext).pop(),
          onConfirm: () async {
            final name = controller.text.trim();
            if (name.isEmpty) return;
            try {
              await provider.createStudyModule(name);
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            } on ArgumentError catch (e) {
              if (dialogContext.mounted) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.message.toString().contains('already exists')
                          ? 'Unable to add module. Use a unique name.'
                          : 'Unable to add module. Please try again.',
                    ),
                  ),
                );
              }
            } catch (_) {
              if (dialogContext.mounted) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Unable to add module. Please try again.'),
                  ),
                );
              }
            }
          },
          confirmLabel: 'Add',
          child: TextField(
            controller: controller,
            autofocus: true,
            style: GoogleFonts.exo2(fontSize: 17, fontWeight: FontWeight.w600, color: _htmlPTextDark),
            decoration: _relaxedInputDecoration(
              hintText: 'e.g. Calculus II',
              label: 'Module',
            ),
          ),
        ),
      );
    },
  );
}

Future<bool> _confirmDeleteModule(
  BuildContext context, {
  required StudyModule module,
}) async {
  final provider = context.read<JarvisProvider>();
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete module?'),
        content: Text(
          'This will remove "${module.name}" from your study list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: _htmlC,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  if (confirmed == true) {
    await provider.deleteStudyModule(module.id);
    if (context.mounted) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text('Module "${module.name}" deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              context.read<JarvisProvider>().restoreStudyModule(module);
            },
          ),
        ),
      );
    }
    return true;
  }
  return false;
}

Future<void> _showEditModuleDialog(
  BuildContext context, {
  required StudyModule module,
}) async {
  final controller = TextEditingController(text: module.name);
  final provider = context.read<JarvisProvider>();
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: _RelaxedDialogFrame(
          title: 'Edit Module',
          onCancel: () => Navigator.of(dialogContext).pop(),
          onConfirm: () async {
            final name = controller.text.trim();
            if (name.isEmpty) return;
            try {
              await provider.updateStudyModuleName(
                moduleId: module.id,
                name: name,
              );
              if (dialogContext.mounted) Navigator.of(dialogContext).pop();
            } on ArgumentError catch (e) {
              if (dialogContext.mounted) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(
                    content: Text(
                      e.message.toString().contains('already exists')
                          ? 'Unable to rename module. Use a unique name.'
                          : 'Unable to rename module. Please try again.',
                    ),
                  ),
                );
              }
            } catch (_) {
              if (dialogContext.mounted) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(
                    content: Text('Unable to rename module. Please try again.'),
                  ),
                );
              }
            }
          },
          confirmLabel: 'Save',
          child: TextField(
            controller: controller,
            autofocus: true,
            style: GoogleFonts.exo2(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: _htmlPTextDark,
            ),
            decoration: _relaxedInputDecoration(
              hintText: 'e.g. Calculus II',
              label: 'Module',
            ),
          ),
        ),
      );
    },
  );
}

class _PriorityChips extends StatelessWidget {
  const _PriorityChips({required this.moduleId, required this.selected});
  final String moduleId;
  final StudyPriority selected;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<JarvisProvider>();
    return Wrap(
      spacing: 8,
      children: StudyPriority.values
          .map(
            (p) => ChoiceChip(
              label: Text(p.name),
              selected: selected == p,
              onSelected: (_) => provider.setStudyPriority(moduleId, p),
            ),
          )
          .toList(),
    );
  }
}

class _ModuleDetails extends StatefulWidget {
  const _ModuleDetails({required this.moduleId});
  final String moduleId;

  @override
  State<_ModuleDetails> createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<_ModuleDetails> {
  bool revealFlash = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    final lectures = provider.getLecturesForModule(widget.moduleId);
    final checklist = provider.getChecklistForModule(widget.moduleId);
    final flash = provider.getCurrentFlashcard(widget.moduleId);
    final grades = provider.getGradesForModule(widget.moduleId);
    final pdfs = provider.getPdfsForModule(widget.moduleId);
    final assignments = provider.assignmentItems
        .where((a) => a.moduleId == widget.moduleId)
        .toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Column(
        children: [
          _SubSection(
            title: 'Assignments',
            child: _ModuleAssignmentsBlock(
              moduleId: widget.moduleId,
              assignments: assignments,
            ),
          ),
          _SubSection(title: 'Lectures & Notes', child: Text('${lectures.where((l) => l.isReviewed).length}/${lectures.length} reviewed')),
          _SubSection(
            title: 'PDF Attachments',
            child: Column(
              children: [
                ...pdfs.take(2).map((p) => ListTile(contentPadding: EdgeInsets.zero, title: Text(p.name), subtitle: Text(p.sizeLabel))),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => provider.addPdf(widget.moduleId, 'New notes.pdf'),
                    child: const Text('Attach PDF'),
                  ),
                ),
              ],
            ),
          ),
          _SubSection(
            title: 'Revision Checklist',
            child: Column(
              children: checklist
                  .map(
                    (c) => CheckboxListTile(
                      value: c.isDone,
                      onChanged: (_) => provider.toggleChecklist(c.id),
                      title: Text(c.label),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                  .toList(),
            ),
          ),
          if (flash != null)
            _SubSection(
              title: 'Flashcards',
              child: Column(
                children: [
                  InkWell(
                    onTap: () => setState(() => revealFlash = !revealFlash),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.p50, borderRadius: BorderRadius.circular(12)),
                      child: Text(revealFlash ? flash.answer : flash.question),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(onPressed: () => provider.prevFlashcard(widget.moduleId), child: const Text('Prev')),
                      const Spacer(),
                      TextButton(onPressed: () => provider.nextFlashcard(widget.moduleId), child: const Text('Next')),
                    ],
                  ),
                ],
              ),
            ),
          _SubSection(
            title: 'Grades',
            child: Column(
              children: grades
                  .map((g) => ListTile(contentPadding: EdgeInsets.zero, title: Text(g.label), trailing: Text(g.value)))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleAssignmentsBlock extends StatelessWidget {
  const _ModuleAssignmentsBlock({
    required this.moduleId,
    required this.assignments,
  });

  final String moduleId;
  final List<AssignmentItem> assignments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (assignments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              'No assignments. Add a due date below.',
              style: GoogleFonts.exo2(
                fontSize: 12,
                color: AppColors.ink2.withValues(alpha: 0.6),
              ),
            ),
          )
        else
          ...assignments.map(
            (a) => _ModuleAssignmentTile(item: a),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _showAddAssignmentDialog(
              context,
              prefilledModuleId: moduleId,
            ),
            icon: const Icon(Icons.event_outlined, size: 16, color: _htmlP),
            label: Text(
              '+ Add Assignment Due Date',
              style: GoogleFonts.exo2(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _htmlP,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModuleAssignmentTile extends StatelessWidget {
  const _ModuleAssignmentTile({required this.item});

  final AssignmentItem item;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<JarvisProvider>();
    final days = item.dueDate.difference(DateTime.now()).inDays;
    final urgency = _examUrgency(days);
    final completed = item.isCompleted;
    final dateLabel =
        '${item.dueDate.day} ${_monthAbbr(item.dueDate.month)} · ${item.timeLabel}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => _showAddAssignmentDialog(
          context,
          existingAssignment: item,
        ),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: completed ? _htmlGLight : urgency.light,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => provider.toggleAssignment(item.id),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: completed ? _htmlG : Colors.white,
                    border: Border.all(
                      color: completed
                          ? _htmlG
                          : urgency.dark.withValues(alpha: 0.5),
                    ),
                  ),
                  child: completed
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.rajdhani(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration: completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: completed
                            ? AppColors.ink2.withValues(alpha: 0.55)
                            : AppColors.ink,
                      ),
                    ),
                    Text(
                      dateLabel,
                      style: GoogleFonts.exo2(
                        fontSize: 10,
                        color: completed ? _htmlG : urgency.dark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                completed ? 'done' : '${days}d',
                style: GoogleFonts.orbitron(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: completed ? _htmlG : urgency.dark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubSection extends StatelessWidget {
  const _SubSection({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.orbitron(fontSize: 10, color: AppColors.p500)),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.orbitron(
            fontSize: 11,
            letterSpacing: 1.2,
            color: AppColors.p500,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: GoogleFonts.exo2(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.p600,
              ),
            ),
          ),
      ],
    );
  }
}

class _StudyPomodoroTab extends StatelessWidget {
  const _StudyPomodoroTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    final state = provider.pomodoroState;
    final total = switch (state.mode) {
      PomodoroMode.focus => 1500,
      PomodoroMode.shortBreak => 300,
      PomodoroMode.longBreak => 900,
    };
    final progress = 1 - (state.remainingSeconds / total).clamp(0.0, 1.0);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        SectionCard(
          title: 'Pomodoro',
          child: Column(
            children: [
              const Wrap(
                spacing: 8,
                children: [
                  _PomModeChip(mode: PomodoroMode.focus, label: 'Focus'),
                  _PomModeChip(mode: PomodoroMode.shortBreak, label: 'Short break'),
                  _PomModeChip(mode: PomodoroMode.longBreak, label: 'Long break'),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 170,
                      height: 170,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: AppColors.p50,
                        color: AppColors.p600,
                      ),
                    ),
                    Text(_formatTime(state.remainingSeconds), style: GoogleFonts.orbitron(fontSize: 26, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: provider.skipPomodoro, icon: const Icon(Icons.skip_next_rounded)),
                  FilledButton(
                    onPressed: provider.togglePomodoro,
                    child: Icon(state.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  ),
                  IconButton(onPressed: provider.addPomodoroMinute, icon: const Icon(Icons.add_rounded)),
                ],
              ),
              TextButton(onPressed: provider.resetPomodoro, child: const Text('Reset')),
            ],
          ),
        ),
        SectionCard(
          title: 'Linked Module',
          child: Column(
            children: provider.studyModules
                .map(
                  (m) => RadioListTile<String>(
                    value: m.id,
                    groupValue: state.linkedModuleId,
                    onChanged: (value) {
                      if (value != null) provider.setPomodoroLinkedModule(value);
                    },
                    title: Text(m.name),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                )
                .toList(),
          ),
        ),
        SectionCard(
          title: "Today's Sessions",
          child: Column(
            children: provider.pomodoroSessions
                .take(8)
                .map(
                  (s) {
                    String? moduleName;
                    for (final module in provider.studyModules) {
                      if (module.id == s.moduleId) {
                        moduleName = module.name;
                        break;
                      }
                    }
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(moduleName ?? 'Module'),
                      trailing: Text('${s.durationMinutes} min'),
                    );
                  },
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _PomModeChip extends StatelessWidget {
  const _PomModeChip({required this.mode, required this.label});
  final PomodoroMode mode;
  final String label;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    return ChoiceChip(
      label: Text(label),
      selected: provider.pomodoroState.mode == mode,
      onSelected: (_) => context.read<JarvisProvider>().setPomodoroMode(mode),
    );
  }
}

class _StudyPlannerTab extends StatelessWidget {
  const _StudyPlannerTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        _SectionHeader(
          title: 'Planner',
          actionLabel: '+ Add Exam',
          onAction: () => _showAddExamDialog(context),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _showAddAssignmentDialog(context),
            icon: const Icon(Icons.assignment_outlined, size: 16, color: _htmlP),
            label: Text(
              '+ Add Assignment',
              style: GoogleFonts.exo2(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _htmlP,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SectionCard(
          title: 'Calendar',
          child: SizedBox(
            height: 240,
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
              onDateChanged: (_) {},
            ),
          ),
        ),
        SectionCard(
          title: 'Study Blocks',
          child: Column(
            children: provider.plannerItems
                .map(
                  (p) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(p.title),
                    subtitle: Text('${p.startAt.hour.toString().padLeft(2, '0')}:${p.startAt.minute.toString().padLeft(2, '0')} • ${p.durationMinutes} min'),
                  ),
                )
                .toList(),
          ),
        ),
        SectionCard(
          title: 'Exam Countdowns',
          child: Column(
            children: provider.examItems
                .map(
                  (e) {
                    final days = e.examDate.difference(DateTime.now()).inDays;
                    final pct = (1 - (days / 40)).clamp(0.05, 1.0);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.p50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(e.title, style: GoogleFonts.rajdhani(fontSize: 15, fontWeight: FontWeight.w700))),
                                Text('$days d', style: GoogleFonts.orbitron(fontSize: 10, color: AppColors.p600)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(value: pct, minHeight: 6),
                          ],
                        ),
                      ),
                    );
                  },
                )
                .toList(),
          ),
        ),
        _AssignmentCountdownsSection(items: provider.assignmentItems),
      ],
    );
  }
}

class _AssignmentCountdownsSection extends StatelessWidget {
  const _AssignmentCountdownsSection({required this.items});

  final List<AssignmentItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SectionCard(
        title: 'Assignment Countdowns',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            'No assignments yet. Tap "+ Add Assignment" above.',
            style: GoogleFonts.exo2(
              fontSize: 12,
              color: AppColors.ink2.withValues(alpha: 0.6),
            ),
          ),
        ),
      );
    }
    return SectionCard(
      title: 'Assignment Countdowns',
      child: Column(
        children: items.map((a) {
          final days = a.dueDate.difference(DateTime.now()).inDays;
          final pct = (1 - (days / 21)).clamp(0.05, 1.0);
          final urgency = _examUrgency(days);
          final completed = a.isCompleted;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: completed ? _htmlGLight : urgency.light,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          a.title,
                          style: GoogleFonts.rajdhani(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            decoration: completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: completed
                                ? AppColors.ink2.withValues(alpha: 0.55)
                                : AppColors.ink,
                          ),
                        ),
                      ),
                      Text(
                        completed ? 'done' : '$days d',
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          color: completed ? _htmlG : urgency.dark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: completed ? 1.0 : pct,
                    minHeight: 6,
                    color: completed ? _htmlG : urgency.dark,
                    backgroundColor: completed
                        ? _htmlGLight
                        : urgency.light.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

Future<void> _showAddExamDialog(BuildContext context, {ExamItem? existingExam}) async {
  final provider = context.read<JarvisProvider>();
  final titleController = TextEditingController(text: existingExam?.title ?? '');
  final noteController = TextEditingController();
  String? selectedModuleId =
      existingExam?.moduleId ?? (provider.studyModules.isEmpty ? null : provider.studyModules.first.id);
  DateTime selectedDate = existingExam?.examDate ?? DateTime.now().add(const Duration(days: 7));
  TimeOfDay selectedTime = _parseTimeLabel(existingExam?.timeLabel) ?? const TimeOfDay(hour: 9, minute: 0);
  String selectedMode = existingExam?.mode ?? 'physical';
  noteController.text = existingExam?.scopeNote ?? '';

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: _RelaxedDialogFrame(
              title: existingExam == null ? 'Add Exam' : 'Edit Exam',
              onCancel: () => Navigator.of(dialogContext).pop(),
              onConfirm: () async {
                final title = titleController.text.trim();
                if (title.isEmpty || selectedModuleId == null) return;
                try {
                  if (existingExam == null) {
                    await provider.createExam(
                      moduleId: selectedModuleId!,
                      title: title,
                      examDate: selectedDate,
                      mode: selectedMode,
                      timeLabel:
                          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                      scopeNote: noteController.text.trim(),
                    );
                  } else {
                    await provider.updateExam(
                      existingExam.copyWith(
                        moduleId: selectedModuleId!,
                        title: title,
                        examDate: selectedDate,
                        mode: selectedMode,
                        timeLabel:
                            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}',
                        scopeNote: noteController.text.trim(),
                      ),
                    );
                  }
                  if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                } catch (_) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(content: Text('Unable to add exam. Please try again.')),
                    );
                  }
                }
              },
              confirmLabel: existingExam == null ? 'Add' : 'Save',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: GoogleFonts.exo2(fontSize: 17, fontWeight: FontWeight.w600, color: _htmlPTextDark),
                    decoration: _relaxedInputDecoration(
                      hintText: 'Exam title',
                      label: 'Title',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: noteController,
                    maxLines: 2,
                    style: GoogleFonts.exo2(fontSize: 15, fontWeight: FontWeight.w500, color: _htmlPTextDark),
                    decoration: _relaxedInputDecoration(
                      hintText: 'What is coming on exam? e.g. Ch 4-6, derivations',
                      label: 'Exam note',
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedModuleId,
                    style: GoogleFonts.exo2(fontSize: 16, fontWeight: FontWeight.w600, color: _htmlPTextDark),
                    items: provider.studyModules
                        .map((module) => DropdownMenuItem<String>(
                              value: module.id,
                              child: Text(
                                module.name,
                                style: GoogleFonts.exo2(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _htmlPTextDark,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => selectedModuleId = value),
                    decoration: _relaxedInputDecoration(label: 'Module'),
                    borderRadius: BorderRadius.circular(14),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mode',
                      style: GoogleFonts.exo2(
                        fontSize: 13,
                        color: AppColors.ink2.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F6FB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFBDB3D7), width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ModePill(
                            label: 'Physical',
                            selected: selectedMode == 'physical',
                            onTap: () => setState(() => selectedMode = 'physical'),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _ModePill(
                            label: 'Online',
                            selected: selectedMode == 'online',
                            onTap: () => setState(() => selectedMode = 'online'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 1)),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: _htmlPLight.withValues(alpha: 0.55),
                        border: Border.all(color: const Color(0xFFD8CEF9)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: GoogleFonts.exo2(fontSize: 17, color: _htmlPDark),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: dialogContext,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: _htmlPLight.withValues(alpha: 0.55),
                        border: Border.all(color: const Color(0xFFD8CEF9)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Time: ${selectedTime.format(dialogContext)}',
                        style: GoogleFonts.exo2(fontSize: 17, color: _htmlPDark),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _ModePill extends StatelessWidget {
  const _ModePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _htmlPLight : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _htmlP : Colors.transparent,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.exo2(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? _htmlPTextDark : AppColors.ink2.withValues(alpha: 0.72),
            ),
          ),
        ),
      ),
    );
  }
}

InputDecoration _relaxedInputDecoration({
  required String label,
  String? hintText,
}) {
  return InputDecoration(
    hintText: hintText,
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: GoogleFonts.exo2(
      fontSize: 12,
      color: AppColors.ink2.withValues(alpha: 0.7),
    ),
    hintStyle: GoogleFonts.exo2(
      fontSize: 15,
      color: AppColors.ink2.withValues(alpha: 0.55),
    ),
    filled: true,
    fillColor: const Color(0xFFFDFBFF),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFBDB3D7), width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFBDB3D7), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _htmlP, width: 1.2),
    ),
  );
}

class _RelaxedDialogFrame extends StatelessWidget {
  const _RelaxedDialogFrame({
    required this.title,
    required this.child,
    required this.onCancel,
    required this.onConfirm,
    required this.confirmLabel,
  });

  final String title;
  final Widget child;
  final VoidCallback onCancel;
  final Future<void> Function() onConfirm;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFCFAFF), Color(0xFFF6F2FF)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x1F120A2D), blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.exo2(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _htmlPTextDark,
            ),
          ),
          const SizedBox(height: 10),
          child,
          const SizedBox(height: 14),
          Row(
            children: [
              const Spacer(),
              TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancel',
                  style: GoogleFonts.exo2(
                    fontSize: 15,
                    color: AppColors.ink2.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: onConfirm,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF5D47A3),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(74, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                child: Text(
                  confirmLabel,
                  style: GoogleFonts.exo2(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StudyAnalyticsTab extends StatelessWidget {
  const _StudyAnalyticsTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    final totalHours = provider.studyModules.fold<int>(0, (sum, m) => sum + m.hoursStudied);
    final weekly = [2.0, 3.5, 4.0, 3.0, 5.0, 2.0, 0.0];
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            _StatTile(value: '${totalHours}h', label: 'This month'),
            const _StatTile(value: '4.2h', label: 'Daily avg'),
            const _StatTile(value: '4', label: 'Day streak'),
            const _StatTile(value: 'Top 5%', label: 'This week'),
          ],
        ),
        SectionCard(
          title: 'Hours This Week',
          child: SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(weekly.length, (index) {
                final h = weekly[index];
                final maxVal = weekly.reduce(math.max);
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      height: ((h / maxVal) * 70).clamp(6, 70),
                      decoration: BoxDecoration(
                        color: index == 5 ? AppColors.p500 : AppColors.p100,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SectionCard(
          title: 'Time by Module',
          child: Column(
            children: provider.studyModules
                .map(
                  (m) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(m.name),
                    trailing: Text('${m.hoursStudied}h'),
                  ),
                )
                .toList(),
          ),
        ),
        const SectionCard(
          title: 'Best Study Window',
          child: Text('Peak focus: 9 AM - 12 PM, about 34% more productive.'),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: GoogleFonts.orbitron(fontWeight: FontWeight.w800, fontSize: 18)),
            Text(label, style: GoogleFonts.exo2(fontSize: 11, color: AppColors.ink2.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}

Color _priorityBg(StudyPriority p) {
  switch (p) {
    case StudyPriority.high:
      return _htmlCLight;
    case StudyPriority.medium:
      return _htmlALight;
    case StudyPriority.low:
      return _htmlGLight;
  }
}

Color _priorityFg(StudyPriority p) {
  switch (p) {
    case StudyPriority.high:
      return _htmlCDark;
    case StudyPriority.medium:
      return _htmlADark;
    case StudyPriority.low:
      return const Color(0xFF27500A);
  }
}

String _formatTime(int seconds) {
  final min = (seconds ~/ 60).toString().padLeft(2, '0');
  final sec = (seconds % 60).toString().padLeft(2, '0');
  return '$min:$sec';
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
    this.accent,
    this.leadingIcon,
  });
  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? accent;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final color = accent ?? _htmlP;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1A000000), width: 0.6),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.85),
                    color.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withValues(alpha: 0.18),
                              color.withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: color.withValues(alpha: 0.30),
                          ),
                        ),
                        child: Icon(
                          leadingIcon ?? Icons.bookmark_rounded,
                          color: color,
                          size: 14,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.orbitron(
                            fontSize: 11,
                            color: color,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      if (actionLabel != null && onAction != null)
                        InkWell(
                          onTap: onAction,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: color.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (actionLabel!.startsWith('+')) ...[
                                  Icon(Icons.add_rounded,
                                      color: color, size: 12),
                                  const SizedBox(width: 2),
                                  Text(
                                    actionLabel!.replaceFirst('+', '').trim(),
                                    style: GoogleFonts.exo2(
                                      fontSize: 11,
                                      color: color,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ] else
                                  Text(
                                    actionLabel!,
                                    style: GoogleFonts.exo2(
                                      fontSize: 11,
                                      color: color,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  child,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamRow extends StatelessWidget {
  const _ExamRow({
    required this.item,
    required this.moduleName,
    required this.onEdit,
    required this.onDelete,
  });
  final ExamItem item;
  final String moduleName;
  final VoidCallback onEdit;
  final Future<void> Function() onDelete;
  @override
  Widget build(BuildContext context) {
    final days = item.examDate.difference(DateTime.now()).inDays;
    final urgency = _examUrgency(days);
    final dayLabel = item.examDate.day.toString();
    final monthLabel = _monthAbbr(item.examDate.month);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey('exam-swipe-${item.id}'),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Swipe right -> edit
            onEdit();
            return false;
          }
          if (direction == DismissDirection.endToStart) {
            // Swipe left -> delete
            await onDelete();
            return true;
          }
          return false;
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _htmlPLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCFC7F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.edit_rounded, color: _htmlP),
              const SizedBox(width: 8),
              Text(
                'Edit',
                style: GoogleFonts.exo2(
                  fontWeight: FontWeight.w700,
                  color: _htmlP,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _htmlCLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF0997B)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete',
                style: GoogleFonts.exo2(
                  fontWeight: FontWeight.w700,
                  color: _htmlCDark,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.delete_outline_rounded, color: _htmlCDark),
            ],
          ),
        ),
        child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: urgency.light,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayLabel,
                  style: GoogleFonts.rajdhani(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: urgency.dark,
                    height: 0.9,
                  ),
                ),
                Text(
                  monthLabel,
                  style: GoogleFonts.exo2(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: urgency.dark,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 4,
                  children: [
                    Text(item.title, style: GoogleFonts.rajdhani(fontSize: 15, fontWeight: FontWeight.w700)),
                    if (urgency.label != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: urgency.light,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          urgency.label!,
                          style: GoogleFonts.exo2(fontSize: 9, fontWeight: FontWeight.w700, color: urgency.dark),
                        ),
                      ),
                  ],
                ),
                Text(
                  item.scopeNote ?? '$moduleName · ${item.mode == 'online' ? 'Online' : 'Physical'} · ${item.timeLabel}',
                  style: GoogleFonts.exo2(fontSize: 11, color: AppColors.ink2.withValues(alpha: 0.62)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: urgency.light,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('${days}d', style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.w700, color: urgency.dark)),
          ),
        ],
        ),
      ),
    );
  }
}

class _ExamUrgencyStyle {
  const _ExamUrgencyStyle({
    required this.light,
    required this.dark,
    this.label,
  });

  final Color light;
  final Color dark;
  final String? label;
}

_ExamUrgencyStyle _examUrgency(int days) {
  if (days <= 5) {
    return const _ExamUrgencyStyle(
      light: _htmlCLight,
      dark: _htmlCDark,
      label: 'urgent',
    );
  }
  if (days <= 20) {
    return const _ExamUrgencyStyle(
      light: _htmlBLight,
      dark: _htmlB,
    );
  }
  return const _ExamUrgencyStyle(
    light: _htmlGLight,
    dark: _htmlG,
  );
}

String _monthAbbr(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  if (month < 1 || month > 12) return '';
  return months[month - 1];
}

class _AssignmentRow extends StatelessWidget {
  const _AssignmentRow({
    required this.item,
    required this.moduleName,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final AssignmentItem item;
  final String moduleName;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final days = item.dueDate.difference(DateTime.now()).inDays;
    final urgency = _examUrgency(days);
    final dayLabel = item.dueDate.day.toString();
    final monthLabel = _monthAbbr(item.dueDate.month);
    final completed = item.isCompleted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: ValueKey('assignment-swipe-${item.id}'),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onEdit();
            return false;
          }
          if (direction == DismissDirection.endToStart) {
            await onDelete();
            return true;
          }
          return false;
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _htmlPLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCFC7F0)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.edit_rounded, color: _htmlP),
              const SizedBox(width: 8),
              Text(
                'Edit',
                style: GoogleFonts.exo2(
                  fontWeight: FontWeight.w700,
                  color: _htmlP,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _htmlCLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF0997B)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete',
                style: GoogleFonts.exo2(
                  fontWeight: FontWeight.w700,
                  color: _htmlCDark,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.delete_outline_rounded, color: _htmlCDark),
            ],
          ),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: completed ? _htmlGLight : urgency.light,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: completed
                        ? _htmlG.withValues(alpha: 0.4)
                        : Colors.transparent,
                  ),
                ),
                child: completed
                    ? const Icon(Icons.check_rounded, color: _htmlG, size: 20)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayLabel,
                            style: GoogleFonts.rajdhani(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: urgency.dark,
                              height: 0.9,
                            ),
                          ),
                          Text(
                            monthLabel,
                            style: GoogleFonts.exo2(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: urgency.dark,
                              height: 0.9,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 4,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.rajdhani(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          decoration: completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: completed
                              ? AppColors.ink2.withValues(alpha: 0.55)
                              : AppColors.ink,
                        ),
                      ),
                      if (!completed && urgency.label != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: urgency.light,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            urgency.label!,
                            style: GoogleFonts.exo2(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: urgency.dark,
                            ),
                          ),
                        ),
                      if (completed)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: _htmlGLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'done',
                            style: GoogleFonts.exo2(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: _htmlG,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    item.notes ?? '$moduleName · due ${item.timeLabel}',
                    style: GoogleFonts.exo2(
                      fontSize: 11,
                      color: AppColors.ink2.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: completed ? _htmlGLight : urgency.light,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                completed ? 'done' : '${days}d',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: completed ? _htmlG : urgency.dark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showAddAssignmentDialog(
  BuildContext context, {
  AssignmentItem? existingAssignment,
  String? prefilledModuleId,
}) async {
  final provider = context.read<JarvisProvider>();
  final titleController =
      TextEditingController(text: existingAssignment?.title ?? '');
  final noteController =
      TextEditingController(text: existingAssignment?.notes ?? '');
  String? selectedModuleId = existingAssignment?.moduleId ??
      prefilledModuleId ??
      (provider.studyModules.isEmpty ? null : provider.studyModules.first.id);
  DateTime selectedDate = existingAssignment?.dueDate ??
      DateTime.now().add(const Duration(days: 5));
  TimeOfDay selectedTime = _parseTimeLabel(existingAssignment?.timeLabel) ??
      const TimeOfDay(hour: 23, minute: 59);

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: _RelaxedDialogFrame(
              title:
                  existingAssignment == null ? 'Add Assignment' : 'Edit Assignment',
              onCancel: () => Navigator.of(dialogContext).pop(),
              onConfirm: () async {
                final title = titleController.text.trim();
                if (title.isEmpty || selectedModuleId == null) return;
                final timeLabel =
                    '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
                try {
                  if (existingAssignment == null) {
                    await provider.createAssignment(
                      moduleId: selectedModuleId!,
                      title: title,
                      dueDate: selectedDate,
                      timeLabel: timeLabel,
                      notes: noteController.text.trim(),
                    );
                  } else {
                    await provider.updateAssignment(
                      existingAssignment.copyWith(
                        moduleId: selectedModuleId!,
                        title: title,
                        dueDate: selectedDate,
                        timeLabel: timeLabel,
                        notes: noteController.text.trim().isEmpty
                            ? null
                            : noteController.text.trim(),
                      ),
                    );
                  }
                  if (dialogContext.mounted) Navigator.of(dialogContext).pop();
                } catch (_) {
                  if (dialogContext.mounted) {
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to save assignment.'),
                      ),
                    );
                  }
                }
              },
              confirmLabel: existingAssignment == null ? 'Add' : 'Save',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: GoogleFonts.exo2(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: _htmlPTextDark,
                    ),
                    decoration: _relaxedInputDecoration(
                      hintText: 'Assignment title',
                      label: 'Title',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: noteController,
                    maxLines: 2,
                    style: GoogleFonts.exo2(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _htmlPTextDark,
                    ),
                    decoration: _relaxedInputDecoration(
                      hintText: 'Optional details, scope or links',
                      label: 'Notes',
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedModuleId,
                    style: GoogleFonts.exo2(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _htmlPTextDark,
                    ),
                    items: provider.studyModules
                        .map(
                          (module) => DropdownMenuItem<String>(
                            value: module.id,
                            child: Text(
                              module.name,
                              style: GoogleFonts.exo2(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _htmlPTextDark,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => selectedModuleId = value),
                    decoration: _relaxedInputDecoration(label: 'Module'),
                    borderRadius: BorderRadius.circular(14),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: dialogContext,
                        initialDate: selectedDate,
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 1)),
                        lastDate: DateTime(2035),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: _htmlPLight.withValues(alpha: 0.55),
                        border: Border.all(color: const Color(0xFFD8CEF9)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Due date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: GoogleFonts.exo2(
                          fontSize: 17,
                          color: _htmlPDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: dialogContext,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: _htmlPLight.withValues(alpha: 0.55),
                        border: Border.all(color: const Color(0xFFD8CEF9)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Due time: ${selectedTime.format(dialogContext)}',
                        style: GoogleFonts.exo2(
                          fontSize: 17,
                          color: _htmlPDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _QuickAddFab extends StatelessWidget {
  const _QuickAddFab();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _htmlPDark.withValues(alpha: 0.40),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6D28D9), Color(0xFFC026D3)],
            ),
          ),
          child: InkWell(
            onTap: () => _showQuickAddSheet(context),
            child: const SizedBox(
              width: 54,
              height: 54,
              child: Icon(Icons.add_rounded, color: Colors.white, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _showQuickAddSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.32),
    isScrollControlled: false,
    builder: (sheetContext) {
      Future<void> close() async => Navigator.of(sheetContext).pop();
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFCFAFF), Color(0xFFF6F2FF)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x29120A2D),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.ink2.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: _htmlP.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: _htmlP,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Quick add',
                      style: GoogleFonts.exo2(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _htmlPTextDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _QuickAddOption(
                  icon: Icons.assignment_outlined,
                  iconBg: _htmlALight,
                  iconColor: _htmlA,
                  title: 'Assignment',
                  subtitle: 'Track a task with a due date',
                  onTap: () async {
                    await close();
                    if (!context.mounted) return;
                    await _showAddAssignmentDialog(context);
                  },
                ),
                const SizedBox(height: 8),
                _QuickAddOption(
                  icon: Icons.fact_check_outlined,
                  iconBg: _htmlCLight,
                  iconColor: _htmlC,
                  title: 'Exam',
                  subtitle: 'Add an upcoming exam',
                  onTap: () async {
                    await close();
                    if (!context.mounted) return;
                    await _showAddExamDialog(context);
                  },
                ),
                const SizedBox(height: 8),
                _QuickAddOption(
                  icon: Icons.school_rounded,
                  iconBg: _htmlPLight,
                  iconColor: _htmlP,
                  title: 'Module',
                  subtitle: 'Create a new study module',
                  onTap: () async {
                    await close();
                    if (!context.mounted) return;
                    await _showAddModuleDialog(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _QuickAddOption extends StatelessWidget {
  const _QuickAddOption({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: iconColor.withValues(alpha: 0.22)),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 19),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.exo2(
                        fontSize: 11,
                        color: AppColors.ink2.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: iconColor.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TimeOfDay? _parseTimeLabel(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  final parts = value.split(':');
  if (parts.length != 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
  return TimeOfDay(hour: hour, minute: minute);
}
