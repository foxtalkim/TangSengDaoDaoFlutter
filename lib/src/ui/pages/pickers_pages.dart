import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../l10n/app_localizations.dart';
import '../contact_list_widgets.dart';
import '../detail_scaffold.dart';
import '../models/contact_models.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';

class FilePickerPage extends StatelessWidget {
  const FilePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.pickerFileTitle,
      children: [
        SectionTitle(t.pickerRecentFiles),
        StaticActionRow(
          icon: FIcons.fileText,
          iconColor: MoyuColors.of(context).primary,
          title: t.pickerSampleProjectFile,
          subtitle: t.pickerSampleProjectFileSubtitle,
          value: t.actionSend,
        ),
        StaticActionRow(
          icon: FIcons.fileImage,
          iconColor: MoyuColors.of(context).primary,
          title: t.pickerSampleScreenshotFile,
          subtitle: t.pickerSampleScreenshotFileSubtitle,
          value: t.actionSend,
        ),
      ],
    );
  }
}

class ContactCardPickerPage extends StatefulWidget {
  const ContactCardPickerPage({
    super.key,
    required this.contacts,
    this.title,
    this.sectionTitle,
  });

  final List<UiContact> contacts;
  final String? title;
  final String? sectionTitle;

  @override
  State<ContactCardPickerPage> createState() => _ContactCardPickerPageState();
}

class _ContactCardPickerPageState extends State<ContactCardPickerPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final query = _controller.text.trim().toLowerCase();
    final contacts = widget.contacts
        .where(
          (contact) =>
              query.isEmpty ||
              contact.name.toLowerCase().contains(query) ||
              contact.subtitle.toLowerCase().contains(query),
        )
        .toList();

    return DetailScaffold(
      title: widget.title ?? t.pickerContactTitle,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.pickerSearchContacts,
            prefixBuilder: (context, style, variants) =>
                FTextField.prefixIconBuilder(
                  context,
                  style,
                  variants,
                  Icon(FIcons.search),
                ),
          ),
        ),
        SectionTitle(widget.sectionTitle ?? t.pickerContactCardSection),
        MoyuSection(
          padding: EdgeInsets.zero,
          children: contacts.isEmpty
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
                    ContactTile(
                      contact: contacts[i],
                      onTap: () => Navigator.of(context).pop(contacts[i]),
                    ),
                    if (i != contacts.length - 1) const MoyuDivider(),
                  ],
                ],
        ),
      ],
    );
  }
}
