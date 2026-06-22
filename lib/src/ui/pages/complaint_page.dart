import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../conversation/chat_conversation.dart' show ChatConversation;
import '../../l10n/app_localizations.dart';
import '../../social/social_service.dart'
    show ChatReportCategory, ChatSocialGateway;
import '../detail_scaffold.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_group_widgets.dart';
import '../settings_row_widgets.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key, this.conversation, this.socialGateway});

  final ChatConversation? conversation;
  final ChatSocialGateway? socialGateway;

  @override
  State<ComplaintPage> createState() => ComplaintPageState();
}

const _fallbackReportCategoryNos = ['10006', '20006', '30000'];

List<ChatReportCategory> _fallbackReportCategories(AppLocalizations t) => [
  ChatReportCategory(no: '10006', name: t.complaintFallbackOtherViolation),
  ChatReportCategory(no: '20006', name: t.complaintFallbackFraud),
  ChatReportCategory(no: '30000', name: t.complaintFallbackAccountCompromised),
];

class ComplaintPageState extends State<ComplaintPage> {
  final _controller = TextEditingController();
  bool _submitted = false;
  bool _loadingCategories = false;
  bool _submitting = false;
  var _categories = const <ChatReportCategory>[];
  String _selectedCategoryNo = _fallbackReportCategoryNos.first;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
    if (widget.socialGateway != null) {
      _loadingCategories = true;
      unawaited(_loadCategories());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final categories = _categories.isEmpty
        ? _fallbackReportCategories(t)
        : _categories;
    return DetailScaffold(
      title: t.complaintTitle,
      children: [
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.complaintHint,
            maxLines: 4,
            prefixBuilder: (context, style, variants) =>
                FTextField.prefixIconBuilder(
                  context,
                  style,
                  variants,
                  Icon(FIcons.circleAlert),
                ),
          ),
        ),
        settingsBlockGap(context),
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Text(
            t.complaintType,
            style: TextStyle(
              color: MoyuColors.of(context).textTertiary,
              fontSize: 13,
            ),
          ),
        ),
        settingsFlatGroup(
          context,
          rows: [
            if (_loadingCategories)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              for (var i = 0; i < categories.length; i++) ...[
                PlainSettingRow(
                  title: categories[i].name,
                  showChevron: false,
                  trailing: Icon(
                    categories[i].no == _selectedCategoryNo
                        ? FIcons.circleCheck
                        : FIcons.circle,
                    size: 18,
                    color: categories[i].no == _selectedCategoryNo
                        ? MoyuColors.of(context).primary
                        : MoyuColors.of(context).textTertiary,
                  ),
                  onTap: () => setState(() {
                    _selectedCategoryNo = categories[i].no;
                    _error = '';
                  }),
                ),
                if (i != categories.length - 1) const RowDivider(),
              ],
          ],
        ),
        if (_submitted)
          Padding(
            padding: EdgeInsets.fromLTRB(22, 8, 22, 10),
            child: Text(
              t.complaintSubmitted,
              style: TextStyle(
                color: MoyuColors.of(context).primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (_error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 10),
            child: Text(
              _error,
              style: TextStyle(
                color: MoyuColors.of(context).red,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MoyuPrimaryButton(
            label: _submitted ? t.statusSubmitted : t.complaintSubmit,
            loadingLabel: t.complaintSubmitting,
            loading: _submitting,
            onPressed:
                _submitted ||
                    _controller.text.trim().isEmpty ||
                    _selectedCategoryNo.isEmpty
                ? null
                : _submit,
          ),
        ),
      ],
    );
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await widget.socialGateway!.loadReportCategories();
      if (!mounted) return;
      setState(() {
        if (categories.isNotEmpty) {
          _categories = categories;
          _selectedCategoryNo = categories.first.no;
        }
        _loadingCategories = false;
      });
    } catch (e) {
      debugPrint('[complaint] loadReportCategories failed: $e');
      if (mounted) {
        setState(() => _loadingCategories = false);
      }
    }
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = '';
    });
    try {
      final conversation = widget.conversation;
      if (widget.socialGateway != null && conversation != null) {
        await widget.socialGateway!.submitReport(
          channelId: conversation.channelId,
          channelType: conversation.channelType,
          categoryNo: _selectedCategoryNo,
          remark: _controller.text.trim(),
        );
      }
      if (mounted) {
        setState(() => _submitted = true);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }
}
