import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../config/app_brand.dart';
import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  List<_OnboardingPageData> _pages(AppLocalizations t) => [
    _OnboardingPageData(
      image: 'assets/onboarding_illustrations/onboarding_chat.png',
      title: t.onboardingChatTitle(AppBrand.displayName),
      subtitle: t.onboardingChatSubtitle,
      semanticLabel: t.onboardingChatSemantic,
    ),
    _OnboardingPageData(
      image: 'assets/onboarding_illustrations/onboarding_friends.png',
      title: t.onboardingFriendsTitle,
      subtitle: t.onboardingFriendsSubtitle,
      semanticLabel: t.onboardingFriendsSemantic,
    ),
    _OnboardingPageData(
      image: 'assets/onboarding_illustrations/onboarding_security.png',
      title: t.onboardingSecurityTitle,
      subtitle: t.onboardingSecuritySubtitle,
      semanticLabel: t.onboardingSecuritySemantic,
    ),
  ];

  bool _isLast(List<_OnboardingPageData> pages) => _page == pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    final pages = _pages(AppLocalizations.of(context));
    if (_isLast(pages)) {
      widget.onComplete();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final colors = MoyuColors.of(context);
    final pages = _pages(t);
    final isLast = _isLast(pages);
    return Semantics(
      identifier: 'moyu.onboarding.screen',
      container: true,
      child: FScaffold(
        childPad: false,
        child: SafeArea(
          child: ColoredBox(
            color: colors.background,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedOpacity(
                      opacity: isLast ? 0 : 1,
                      duration: const Duration(milliseconds: 160),
                      child: FButton(
                        variant: FButtonVariant.ghost,
                        size: FButtonSizeVariant.sm,
                        mainAxisSize: MainAxisSize.min,
                        onPress: isLast ? null : widget.onComplete,
                        child: Text(
                          t.actionSkip,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: pages.length,
                      onPageChanged: (index) => setState(() => _page = index),
                      itemBuilder: (context, index) {
                        return _OnboardingPage(data: pages[index]);
                      },
                    ),
                  ),
                  _OnboardingDots(count: pages.length, active: _page),
                  const SizedBox(height: 24),
                  MoyuPrimaryButton(
                    label: isLast ? t.actionGetStarted : t.actionContinue,
                    onPressed: _next,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 260,
              child: Image.asset(
                data.image,
                height: 260,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                semanticLabel: data.semanticLabel,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 28,
                height: 1.12,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.42,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingDots extends StatelessWidget {
  const _OnboardingDots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: i == active ? 18 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == active ? colors.primary : colors.line,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          if (i != count - 1) const SizedBox(width: 7),
        ],
      ],
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.semanticLabel,
  });

  final String image;
  final String title;
  final String subtitle;
  final String semanticLabel;
}
