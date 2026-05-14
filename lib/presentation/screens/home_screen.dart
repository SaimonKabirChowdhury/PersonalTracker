import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/jarvis_provider.dart';

const _thinBlackBorder = Color(0x33000000);

const _surface = Color(0xFFFAF7F2);
const _ink = Color(0xFF0F172A);
const _inkMuted = Color(0xFF64748B);

const _emerald = Color(0xFF059669);
const _amber = Color(0xFFD97706);
const _indigo = Color(0xFF4F46E5);
const _sky = Color(0xFF0284C7);
const _orange = Color(0xFFEA580C);
const _cyan = Color(0xFF0891B2);
const _slate = Color(0xFF475569);
const _pink = Color(0xFFDB2777);
const _rose = Color(0xFFE11D48);

const _avatarBg = Color(0xFFFEE2E2);
const _avatarFg = Color(0xFFBE123C);

bool _homeAnimatedOnce = false;

Color _tintOf(Color color, {double amount = 0.18}) =>
    Color.alphaBlend(color.withValues(alpha: amount), Colors.white);

String _formatThousands(double value) {
  final n = value.round();
  return n.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (match) => '${match[1]},',
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static _ModuleCardSpec _moduleCardSpec(String moduleId) {
    switch (moduleId) {
      case 'study-page':
        return const _ModuleCardSpec(
          icon: Icons.menu_book_outlined,
          title: 'Study hub',
          description: 'Modules, notes, flashcards & planner',
          statusPill: '4 tasks',
          accent: _indigo,
          surface: Color(0xFFEEF2FF),
          footerText: '75% overall progress',
        );
      case 'gym-page':
        return const _ModuleCardSpec(
          icon: Icons.fitness_center_rounded,
          title: 'Gym & workout',
          description: 'Workouts, sets, reps & body tracking',
          statusPill: 'Active',
          accent: _emerald,
          surface: Color(0xFFECFDF5),
          footerText: '4-day streak',
        );
      case 'expense-page':
        return const _ModuleCardSpec(
          icon: Icons.account_balance_wallet_outlined,
          title: 'Expenses',
          description: 'Budget, categories, spending & planning',
          statusPill: '74%',
          accent: _amber,
          surface: Color(0xFFFFFBEB),
          footerText: 'RM 660 left',
        );
      case 'workout-page':
        return const _ModuleCardSpec(
          icon: Icons.flash_on_rounded,
          title: 'Workout',
          description: 'Daily split, sets, volume & session logs',
          statusPill: 'Day 4/6',
          accent: _sky,
          surface: Color(0xFFF0F9FF),
          footerText: 'Upper body power',
        );
      case 'fashion-page':
        return const _ModuleCardSpec(
          icon: Icons.checkroom_outlined,
          title: 'Fashion',
          description: 'Outfits, style picks & occasion matching',
          statusPill: 'Today',
          accent: _pink,
          surface: Color(0xFFFDF2F8),
          footerText: 'Smart casual ready',
        );
      case 'motivation-page':
        return const _ModuleCardSpec(
          icon: Icons.local_fire_department_outlined,
          title: 'Motivate',
          description: 'Goals, streaks, quotes & mindset',
          statusPill: 'Top 5%',
          accent: _orange,
          surface: Color(0xFFFFF7ED),
          footerText: 'Good today',
        );
      case 'mood-page':
        return const _ModuleCardSpec(
          icon: Icons.psychology_alt_outlined,
          title: 'Mood',
          description: 'Mood check-ins, patterns & insights',
          statusPill: 'Focused',
          accent: _cyan,
          surface: Color(0xFFECFEFF),
          footerText: 'High focus mode',
        );
      case 'business-page':
        return const _ModuleCardSpec(
          icon: Icons.work_outline_rounded,
          title: 'Business',
          description: 'Revenue, tasks, clients & priorities',
          statusPill: 'Q2',
          accent: _slate,
          surface: Color(0xFFF8FAFC),
          footerText: '3 pending deals',
        );
      case 'skincare-page':
        return const _ModuleCardSpec(
          icon: Icons.auto_awesome_outlined,
          title: 'Skincare',
          description: 'Routine, products, UV alerts & progress',
          statusPill: 'SPF',
          accent: _rose,
          surface: Color(0xFFFFF1F2),
          footerText: 'UV index high',
        );
      default:
        return const _ModuleCardSpec(
          icon: Icons.widgets_outlined,
          title: 'Module',
          description: 'Open module details',
          statusPill: 'Open',
          accent: _slate,
          surface: Colors.white,
          footerText: 'Ready',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JarvisProvider>();
    final moduleCards = provider.moduleSummaries
        .map((module) => (module.id, _moduleCardSpec(module.id)))
        .toList(growable: false);
    final animateNumbers = !_homeAnimatedOnce;
    if (animateNumbers) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _homeAnimatedOnce = true;
      });
    }

    return Scaffold(
      backgroundColor: _surface,
      body: ColoredBox(
        color: _surface,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Reveal(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good morning, Boss.',
                              style: GoogleFonts.exo2(
                                color: _ink,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'All systems nominal. Ready to dominate.',
                              style: GoogleFonts.exo2(
                                color: _inkMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _CircleButton(
                        icon: Icons.notifications_outlined,
                        background: Colors.white,
                        foreground: _ink,
                        showDot: true,
                        onTap: () {},
                      ),
                      const SizedBox(width: 10),
                      _CircleButton(
                        label: 'YU',
                        background: _avatarBg,
                        foreground: _avatarFg,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                _Reveal(
                  delay: const Duration(milliseconds: 80),
                  pressable: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.favorite_outline_rounded,
                          title: 'HEALTH',
                          targetValue: 23.5,
                          formatter: (v) => v.toStringAsFixed(1),
                          unit: 'bmi',
                          subtitle: '72 kg - 175 cm - age 24',
                          chip1Text: 'Fat 18%',
                          chip1Color: _emerald,
                          chip2Text: 'H2O 62%',
                          chip2Color: _sky,
                          accent: _emerald,
                          surface: const Color(0xFFECFDF5),
                          animate: animateNumbers,
                          onTap: () => provider.openModule('gym-page'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'EXPENSES',
                          targetValue: 1840,
                          formatter: _formatThousands,
                          unit: 'rm',
                          subtitle: 'of RM 2,500 budget',
                          chip1Text: 'RM 660 left',
                          chip1Color: _emerald,
                          chip2Text: '74%',
                          chip2Color: _amber,
                          accent: _amber,
                          surface: const Color(0xFFFFFBEB),
                          animate: animateNumbers,
                          onTap: () => provider.openModule('expense-page'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                for (var i = 0; i < moduleCards.length; i++) ...[
                  _Reveal(
                    delay: Duration(milliseconds: 160 + i * 70),
                    child: _ModuleCommandCard(
                      spec: moduleCards[i].$2,
                      onTap: () => provider.openModule(moduleCards[i].$1),
                    ),
                  ),
                  if (i < moduleCards.length - 1) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleCardSpec {
  const _ModuleCardSpec({
    required this.icon,
    required this.title,
    required this.description,
    required this.statusPill,
    required this.accent,
    required this.surface,
    required this.footerText,
  });

  final IconData icon;
  final String title;
  final String description;
  final String statusPill;
  final Color accent;
  final Color surface;
  final String footerText;
}

class _Reveal extends StatefulWidget {
  const _Reveal({
    required this.child,
    this.delay = Duration.zero,
    this.pressable = true,
  });

  final Widget child;
  final Duration delay;
  final bool pressable;

  @override
  State<_Reveal> createState() => _RevealState();
}

class _RevealState extends State<_Reveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _entrance.forward();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);
    final slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(curve);

    Widget content = widget.child;
    if (widget.pressable) {
      content = Listener(
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          child: content,
        ),
      );
    }

    return FadeTransition(
      opacity: curve,
      child: SlideTransition(
        position: slide,
        child: content,
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    this.icon,
    this.label,
    required this.background,
    required this.foreground,
    this.showDot = false,
    required this.onTap,
  });

  final IconData? icon;
  final String? label;
  final Color background;
  final Color foreground;
  final bool showDot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Widget inner = icon != null
        ? Icon(icon, color: foreground, size: 20)
        : Text(
            label ?? '',
            style: GoogleFonts.exo2(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: Border.all(color: _thinBlackBorder, width: 0.8),
              boxShadow: [
                BoxShadow(
                  color: foreground.withValues(alpha: 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: inner,
          ),
          if (showDot)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: _rose,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.4),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.targetValue,
    required this.formatter,
    required this.unit,
    required this.subtitle,
    required this.chip1Text,
    required this.chip1Color,
    required this.chip2Text,
    required this.chip2Color,
    required this.accent,
    required this.surface,
    required this.animate,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final double targetValue;
  final String Function(double value) formatter;
  final String unit;
  final String subtitle;
  final String chip1Text;
  final Color chip1Color;
  final String chip2Text;
  final Color chip2Color;
  final Color accent;
  final Color surface;
  final bool animate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _thinBlackBorder, width: 0.8),
      ),
      shadowColor: accent.withValues(alpha: 0.25),
      elevation: 2.4,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _thinBlackBorder, width: 0.6),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: accent, size: 18),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.orbitron(
                  color: accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.9,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  _AnimatedNumber(
                    target: targetValue,
                    animate: animate,
                    builder: (_, value) => Text(
                      formatter(value),
                      style: GoogleFonts.orbitron(
                        color: _ink,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: GoogleFonts.exo2(
                      color: _inkMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: GoogleFonts.exo2(
                  color: _inkMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 3,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _MiniPill(text: chip1Text, color: chip1Color),
                  const SizedBox(width: 8),
                  _MiniPill(text: chip2Text, color: chip2Color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCommandCard extends StatelessWidget {
  const _ModuleCommandCard({
    required this.spec,
    required this.onTap,
  });

  final _ModuleCardSpec spec;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: spec.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: _thinBlackBorder, width: 0.8),
      ),
      shadowColor: spec.accent.withValues(alpha: 0.25),
      elevation: 2.4,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: _thinBlackBorder, width: 0.6),
                ),
                alignment: Alignment.center,
                child: Icon(spec.icon, color: spec.accent, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            spec.title,
                            style: GoogleFonts.exo2(
                              color: spec.accent,
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                        ),
                        _MiniPill(
                          text: spec.statusPill,
                          color: spec.accent,
                          compact: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      spec.description,
                      style: GoogleFonts.exo2(
                        color: _inkMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: spec.accent,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _Dot(color: spec.accent),
                        const SizedBox(width: 4),
                        _Dot(color: spec.accent),
                        const SizedBox(width: 4),
                        _Dot(color: spec.accent),
                        const SizedBox(width: 4),
                        _Dot(color: spec.accent),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      spec.footerText,
                      style: GoogleFonts.exo2(
                        color: spec.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _thinBlackBorder, width: 0.6),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.arrow_outward_rounded, color: spec.accent, size: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _AnimatedNumber extends StatelessWidget {
  const _AnimatedNumber({
    required this.target,
    required this.animate,
    required this.builder,
  });

  static const _duration = Duration(milliseconds: 1100);

  final double target;
  final bool animate;
  final Widget Function(BuildContext context, double value) builder;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: animate ? 0.0 : target, end: target),
      duration: animate ? _duration : Duration.zero,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => builder(context, value),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({
    required this.text,
    required this.color,
    this.compact = false,
  });

  final String text;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: _tintOf(color, amount: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.6),
      ),
      child: Text(
        text,
        style: GoogleFonts.exo2(
          color: color,
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
