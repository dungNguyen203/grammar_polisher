import 'package:flutter/material.dart';

import '../../../constants/languages.dart';
import 'data_picker_dialog.dart';

class LanguagePickerDialog extends StatefulWidget {
  final Function(Language) onChanged;

  const LanguagePickerDialog({super.key, required this.onChanged});

  @override
  State<LanguagePickerDialog> createState() => _StatePickerDialogState();
}

class _StatePickerDialogState extends State<LanguagePickerDialog> {
  final List<Language> _languages = Language.languages;

  List<Language> _filteredLanguage = Language.languages;

  @override
  Widget build(BuildContext context) {
    return DataPickerDialog<Language>(
      onChanged: widget.onChanged,
      data: _filteredLanguage,
      itemBuilder: (county) => Text(
        "${county.flag} ${county.name}",
      ),
      onChangedSearch: (value) {
        setState(() {
          _filteredLanguage = _languages
              .where(
                (function) => function.name.toLowerCase().contains(
                      value.toLowerCase(),
                    ),
              )
              .toList();
        });
      },
    );
  }
}
