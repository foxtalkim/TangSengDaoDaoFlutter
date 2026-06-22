import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../l10n/app_localizations.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';
import 'models/contact_models.dart';

/// Height (pre-safeBottom) reserved for the floating home tab bar overlay.
/// Tab pages add this to their bottom padding so the final row stays tappable
/// above the glass pill.
const double kTabBarReservedHeight = MoyuTabBar.reservedHeight;

class MoyuDetailScaffold extends StatefulWidget {
  const MoyuDetailScaffold({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
    this.onBack,
    this.onRefresh,
    this.bottomSticky,
    this.bottomStickyHeight = 76,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
  });

  final String title;
  final List<Widget> children;
  final Widget? trailing;
  final VoidCallback? onBack;
  final Future<void> Function()? onRefresh;
  final Widget? bottomSticky;
  final double bottomStickyHeight;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  @override
  State<MoyuDetailScaffold> createState() => _MoyuDetailScaffoldState();
}

class _MoyuDetailScaffoldState extends State<MoyuDetailScaffold> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topInset = media.padding.top;
    final bottomInset = media.padding.bottom;
    final headerHeight = topInset + MoyuDetailHeader.height;
    final stickyTotal = widget.bottomSticky == null
        ? 0.0
        : widget.bottomStickyHeight + bottomInset;

    Widget list = ListView(
      controller: _scrollController,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      padding: EdgeInsets.only(top: headerHeight, bottom: 24 + stickyTotal),
      children: widget.children,
    );
    if (widget.onRefresh != null) {
      list = RefreshIndicator(onRefresh: widget.onRefresh!, child: list);
    }

    return FScaffold(
      childPad: false,
      child: MoyuSettingsFlat(
        child: ColoredBox(
          color: MoyuColors.of(context).backgroundSoft,
          child: Stack(
            children: [
              Positioned.fill(child: list),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: MoyuGlass(
                  borderRadius: BorderRadius.zero,
                  showHairline: false,
                  child: SafeArea(
                    bottom: false,
                    child: MoyuDetailHeader(
                      title: widget.title,
                      trailing: widget.trailing,
                      onBack: widget.onBack,
                      onTitleDoubleTap: _scrollToTop,
                    ),
                  ),
                ),
              ),
              if (widget.bottomSticky != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: MoyuGlass(
                    borderRadius: BorderRadius.zero,
                    showHairline: false,
                    child: SafeArea(top: false, child: widget.bottomSticky!),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoyuRowDivider extends StatelessWidget {
  const MoyuRowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: const EdgeInsetsDirectional.only(start: 16),
      color: MoyuColors.of(context).line,
    );
  }
}

Widget moyuSettingsFlatGroup(
  BuildContext context, {
  required List<Widget> rows,
  EdgeInsets padding = EdgeInsets.zero,
}) {
  return Container(
    width: double.infinity,
    color: MoyuColors.of(context).background,
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    ),
  );
}

Widget moyuSettingsBlockGap(BuildContext context) =>
    Container(height: 12, color: MoyuColors.of(context).backgroundSoft);

class MoyuPlainSettingRow extends StatelessWidget {
  const MoyuPlainSettingRow({
    super.key,
    required this.title,
    this.leading,
    this.value = '',
    this.valueMuted = false,
    this.trailing,
    this.showChevron = false,
    this.danger = false,
    this.center = false,
    this.onTap,
  });

  final String title;
  final Widget? leading;
  final String value;
  final bool valueMuted;
  final Widget? trailing;
  final bool showChevron;
  final bool danger;
  final bool center;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleWidget = Text(
      title,
      textAlign: center ? TextAlign.center : TextAlign.left,
      style: TextStyle(
        fontSize: 15.5,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.08,
        color: danger
            ? MoyuColors.of(context).red
            : MoyuColors.of(context).textPrimary,
      ),
    );
    final Widget content;
    if (center) {
      content = Center(child: titleWidget);
    } else {
      content = Row(
        children: [
          if (leading != null) ...[
            SizedBox(
              width: 24,
              height: 24,
              child: IconTheme(
                data: IconThemeData(
                  color: MoyuColors.of(context).textSecondary,
                  size: 20,
                ),
                child: leading!,
              ),
            ),
            const SizedBox(width: 14),
          ],
          titleWidget,
          const SizedBox(width: 12),
          Expanded(
            child: value.isEmpty
                ? const SizedBox.shrink()
                : Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: valueMuted
                          ? MoyuColors.of(context).textTertiary
                          : MoyuColors.of(context).textSecondary,
                      fontSize: 14,
                    ),
                  ),
          ),
          if (trailing != null) ...[const SizedBox(width: 6), trailing!],
          if (showChevron) ...[
            const SizedBox(width: 4),
            Icon(
              moyuForwardChevronIcon(context),
              size: 16,
              color: MoyuColors.of(context).textTertiary,
            ),
          ],
        ],
      );
    }
    final row = Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: MoyuColors.of(context).background,
      child: content,
    );
    if (onTap == null) return row;
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }
}

class MoyuSelectableContactRow extends StatelessWidget {
  const MoyuSelectableContactRow({
    super.key,
    required this.contact,
    required this.selected,
    required this.onChanged,
  });

  final UiContact contact;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return FTappable(
      onPress: () => onChanged(!selected),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(
              selected ? FIcons.circleCheck : FIcons.circle,
              color: selected
                  ? MoyuColors.of(context).primary
                  : MoyuColors.of(context).textTertiary,
            ),
            const SizedBox(width: 12),
            MoyuResolvedAvatar.raw(
              label: contact.avatarLabel,
              size: 42,
              colors: contact.colors,
              online: contact.online,
              imageUrl: contact.avatarPath,
            ),
            const SizedBox(width: 12),
            Text(
              contact.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: MoyuColors.of(context).textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoyuContactPickerPage extends StatefulWidget {
  const MoyuContactPickerPage({
    super.key,
    required this.title,
    required this.contacts,
    required this.selectedContacts,
  });

  final String title;
  final List<UiContact> contacts;
  final List<UiContact> selectedContacts;

  @override
  State<MoyuContactPickerPage> createState() => _MoyuContactPickerPageState();
}

class _MoyuContactPickerPageState extends State<MoyuContactPickerPage> {
  late final TextEditingController _controller;
  late final Set<String> _selectedIds;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
    _selectedIds = {
      for (final contact in widget.selectedContacts)
        _moyuContactChannelId(contact),
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final contacts = _filteredContacts();

    return MoyuDetailScaffold(
      title: widget.title,
      trailing: MoyuTextButton(label: t.actionDone, onPressed: _submit),
      children: [
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.pickerSearchContacts,
            prefixBuilder: (context, style, variants) =>
                FTextField.prefixIconBuilder(
                  context,
                  style,
                  variants,
                  const Icon(FIcons.search),
                ),
          ),
        ),
        moyuSettingsBlockGap(context),
        moyuSettingsFlatGroup(
          context,
          rows: contacts.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        t.pickerNoMatchingContacts,
                        style: TextStyle(
                          color: MoyuColors.of(context).textTertiary,
                        ),
                      ),
                    ),
                  ),
                ]
              : [
                  for (var i = 0; i < contacts.length; i++) ...[
                    MoyuSelectableContactRow(
                      contact: contacts[i],
                      selected: _selectedIds.contains(
                        _moyuContactChannelId(contacts[i]),
                      ),
                      onChanged: (selected) =>
                          _setSelected(contacts[i], selected),
                    ),
                    if (i != contacts.length - 1) const MoyuRowDivider(),
                  ],
                ],
        ),
      ],
    );
  }

  List<UiContact> _filteredContacts() {
    final query = _controller.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.contacts;
    }
    return widget.contacts
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(query) ||
              contact.subtitle.toLowerCase().contains(query),
        )
        .toList();
  }

  void _setSelected(UiContact contact, bool selected) {
    final id = _moyuContactChannelId(contact);
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  void _submit() {
    Navigator.of(context).pop([
      for (final contact in widget.contacts)
        if (_selectedIds.contains(_moyuContactChannelId(contact))) contact,
    ]);
  }
}

String _moyuContactChannelId(UiContact contact) =>
    contact.uid.isEmpty ? contact.name : contact.uid;
