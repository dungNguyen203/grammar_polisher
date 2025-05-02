import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/languages.dart';
import '../../../core/debouncer.dart';
import '../../../data/models/extra_translation.dart';
import '../../blocs/translate/translate_cubit.dart';
import '../rounded_button.dart';
import 'language_picker_dialog.dart';

class TranslateDialog extends StatefulWidget {
  final String initialText;

  const TranslateDialog({super.key, required this.initialText});

  @override
  State<TranslateDialog> createState() => _TranslateDialogState();
}

class _TranslateDialogState extends State<TranslateDialog> {
  late TextEditingController _sourceController;
  late TextEditingController _targetController;
  bool _showAllExtraTranslations = false;
  late ScrollController _scrollController;
  Language _source = Language.languages.firstWhere((element) => element.code == 'en');
  Language _target = Language.languages.firstWhere((element) => element.code == 'ja');
  final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranslateCubit, TranslateState>(
      listener: (context, state) {
        _targetController.text = state.translateSnapshot?.content ?? "";
        if (state.errorMessage != null) {
          _targetController.text = state.errorMessage!;
        }
      },
      builder: (context, state) {
        List<ExtraTranslation> extraTranslations = state.translateSnapshot?.moreTranslations ?? [];
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          shadowColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    width: 600,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.translate)),
                            Text("Translate", style: Theme.of(context).textTheme.bodyLarge),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.close))
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleSmall,
                            children: [
                              const TextSpan(text: "Source: "),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: RoundedButton(
                                  expand: false,
                                  padding: EdgeInsets.all(4.0),
                                  borderRadius: 8,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => LanguagePickerDialog(
                                        onChanged: (language) {
                                          setState(() {
                                            _source = language;
                                          });
                                          _translate(_sourceController.text);
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(_source.name),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _sourceController,
                                onChanged: (value) {
                                  _debouncer(() {
                                    _translate(value);
                                  });
                                },
                                maxLines: 1,
                                onSubmitted: _translate,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                                decoration: InputDecoration(
                                  hintText: "Type your translation here",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context).colorScheme.primaryContainer,
                                ),
                              ),
                            ),
                            if (_sourceController.text.isNotEmpty)
                              IconButton(
                                onPressed: _onDelete,
                                icon: Icon(
                                  Icons.cancel,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 16,
                                ),
                              )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.primary.withAlpha(100),
                                ),
                              ),
                              IconButton(
                                  onPressed: _onSwitch, icon: Icon(Icons.swap_vert, color: Theme.of(context).colorScheme.primary)),
                              Expanded(
                                child: Divider(
                                  color: Theme.of(context).colorScheme.primary.withAlpha(100),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleSmall,
                            children: [
                              const TextSpan(text: "Target: "),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: RoundedButton(
                                  expand: false,
                                  padding: EdgeInsets.all(4.0),
                                  borderRadius: 8,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => LanguagePickerDialog(
                                        onChanged: (language) {
                                          setState(() {
                                            _target = language;
                                          });
                                          _translate(_sourceController.text);
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(_target.name),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                enabled: false,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                                controller: _targetController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Translation will appear here",
                                ),
                              ),
                            ),
                            if (state.translateSnapshot != null && state.translateSnapshot!.type != null)
                              FilterChip(
                                label: Text(state.translateSnapshot!.type!),
                                onSelected: (value) {},
                                selected: true,
                                showCheckmark: false,
                              ),
                            if ((state.translateSnapshot?.content ?? "").isNotEmpty) IconButton(
                              onPressed: _onCopy,
                              icon: Icon(
                                Icons.copy,
                                color: Theme.of(context).colorScheme.primary,
                                size: 16,
                              ),
                            )
                          ],
                        ),
                        if (state.translateSnapshot?.spelling != null)
                          Text(state.translateSnapshot!.spelling!, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        RoundedButton(
                          borderRadius: 16,
                          child: Text("Translate"),
                          onPressed: () {
                            if (_sourceController.text.isEmpty) {
                              return;
                            }
                            _translate(_sourceController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                  if (extraTranslations.isNotEmpty)
                    Container(
                      width: 600,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text("More translations (${extraTranslations.length})",
                                      style: Theme.of(context).textTheme.titleSmall),
                                  const Spacer(),
                                  if (extraTranslations.length > 1)
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _showAllExtraTranslations = !_showAllExtraTranslations;
                                          });
                                        },
                                        child: Text(_showAllExtraTranslations ? "Hide" : "Show all")),
                                ],
                              ),
                              ...List.generate(
                                _showAllExtraTranslations ? extraTranslations.length : 1,
                                (index) {
                                  var translation = extraTranslations[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(translation.label, style: Theme.of(context).textTheme.titleSmall),
                                            const SizedBox(height: 8),
                                            ...translation.content.map((e) => FilterChip(
                                                  label: Text(e),
                                                  onSelected: (bool value) {
                                                    _onPick(e);
                                                  },
                                                )),
                                          ],
                                        ),
                                        const Spacer(),
                                        FilterChip(
                                          label: Text(translation.type),
                                          onSelected: (value) {},
                                          selected: true,
                                          showCheckmark: false,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _translate(String value) async {
    context.read<TranslateCubit>().translate(_source.code, _target.code, value);
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
    setState(() {
      _showAllExtraTranslations = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _sourceController = TextEditingController();
    _targetController = TextEditingController();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final languageCode = WidgetsBinding.instance.window.locale.languageCode;
      if (languageCode != 'en') {
        final language = Language.languages.firstWhere((element) => element.code == languageCode);
        setState(() {
          _target = language;
        });
      }
      setState(() {
        _sourceController.text = widget.initialText;
        _translate(widget.initialText);
      });
    });
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _targetController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onCopy() {
    if (_targetController.text.isEmpty) {
      return;
    }
    Clipboard.setData(ClipboardData(text: _targetController.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  void _onDelete() {
    _sourceController.clear();
    _targetController.clear();
    context.read<TranslateCubit>().clear();
  }

  void _onSwitch() {
    setState(() {
      final temp = _source;
      _source = _target;
      _target = temp;
    });
    _sourceController.text = _targetController.text;
    _translate(_sourceController.text);
  }

  void _onPick(String translation) {
    _sourceController.text = translation;
    _translate(_sourceController.text);
  }
}
