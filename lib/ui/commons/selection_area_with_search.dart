import 'package:flutter/material.dart';

import 'dialogs/translation_dialog.dart';

class SelectionAreaWithSearch extends StatefulWidget {
  final Widget child;

  const SelectionAreaWithSearch({super.key, required this.child});

  @override
  State<SelectionAreaWithSearch> createState() => _SelectionAreaWithSearchState();
}

class _SelectionAreaWithSearchState extends State<SelectionAreaWithSearch> {
  String? _selectedText;

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
        onSelectionChanged: (text) {
          setState(() {
            _selectedText = text?.plainText;
          });
        },
        contextMenuBuilder: (context, editableTextState) {
          final List<ContextMenuButtonItem> buttonItems = editableTextState.contextMenuButtonItems;
          buttonItems.insert(
            0,
            ContextMenuButtonItem(
              label: 'Translate',
              onPressed: _onTranslate,
            ),
          );
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: buttonItems,
          );
        },
        child: widget.child);
  }

  void _onTranslate() {
    showDialog(
      context: context,
      builder: (context) => TranslateDialog(
        initialText: _selectedText ?? "",
      ),
    );
  }
}
