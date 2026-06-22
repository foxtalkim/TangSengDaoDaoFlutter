import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

class PwdSubmitResult {
  const PwdSubmitResult._(this.kind, [this.remain = 0]);

  static const ok = PwdSubmitResult._(PwdSubmitKind.ok);
  static const errorWiped = PwdSubmitResult._(PwdSubmitKind.errorWiped);
  static PwdSubmitResult errorWith(int remain) =>
      PwdSubmitResult._(PwdSubmitKind.error, remain);

  final PwdSubmitKind kind;
  final int remain;
}

enum PwdSubmitKind { ok, error, errorWiped }

class ChatPasswordSheet extends StatefulWidget {
  const ChatPasswordSheet({
    super.key,
    required this.onSubmit,
    required this.onWiped,
  });

  final Future<PwdSubmitResult> Function(String pwd) onSubmit;
  final VoidCallback onWiped;

  @override
  State<ChatPasswordSheet> createState() => _ChatPasswordSheetState();
}

class _ChatPasswordSheetState extends State<ChatPasswordSheet> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String _value = '';
  String _errorText = '';
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final next = _controller.text.replaceAll(RegExp(r'\D'), '');
      if (next.length > 6) {
        _controller.text = next.substring(0, 6);
        _controller.selection = TextSelection.collapsed(
          offset: _controller.text.length,
        );
        return;
      }
      if (next != _controller.text) {
        _controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
        return;
      }
      setState(() {
        _value = next;
        _errorText = '';
      });
      if (next.length == 6 && !_submitting) {
        unawaited(_submit());
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final t = AppLocalizations.of(context);
    setState(() => _submitting = true);
    final result = await widget.onSubmit(_value);
    if (!mounted) return;
    switch (result.kind) {
      case PwdSubmitKind.ok:
        Navigator.of(context).pop();
      case PwdSubmitKind.errorWiped:
        Navigator.of(context).pop();
        widget.onWiped();
      case PwdSubmitKind.error:
        setState(() {
          _submitting = false;
          _value = '';
          _errorText = t.chatPasswordErrorRemain(result.remain);
        });
        _controller.clear();
        _focus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        8,
        0,
        8,
        (viewInsets > 0 ? viewInsets : safeBottom + 8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: ColoredBox(
          color: MoyuColors.of(context).background,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.chatPasswordTitle,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: MoyuColors.of(context).textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t.chatPasswordHint,
                  style: TextStyle(
                    fontSize: 13,
                    color: MoyuColors.of(context).textTertiary,
                  ),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _focus.requestFocus(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < 6; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: MoyuColors.of(context).backgroundSoft,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: i < _value.length
                                  ? MoyuColors.of(context).primary
                                  : MoyuColors.of(context).line,
                              width: i < _value.length ? 1.2 : 0.5,
                            ),
                          ),
                          child: i < _value.length
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: MoyuColors.of(context).textPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                  width: 0,
                  child: Opacity(
                    opacity: 0,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focus,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      enabled: !_submitting,
                      decoration: const InputDecoration(counterText: ''),
                    ),
                  ),
                ),
                if (_errorText.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    _errorText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: MoyuColors.of(context).red,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                MoyuPrimaryButton(
                  label: t.actionCancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
