import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnswerInputField extends StatefulWidget {
  final void Function(String) onSubmitted;
  final bool isEnabled;
  final FocusNode? focusNode;

  const AnswerInputField({
    super.key,
    required this.onSubmitted,
    this.isEnabled = true,
    this.focusNode,
  });

  @override
  State<AnswerInputField> createState() => _AnswerInputFieldState();
}

class _AnswerInputFieldState extends State<AnswerInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: widget.isEnabled,
      decoration: InputDecoration(
        hintText: '정답을 입력하세요',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        counterText: '',
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: widget.isEnabled
              ? () {
                  widget.onSubmitted(_controller.text);
                  _controller.clear();
                }
              : null,
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.name,
      maxLength: 10,
      autocorrect: false,
      enableSuggestions: false,
      onSubmitted: widget.isEnabled ? widget.onSubmitted : null,
      textCapitalization: TextCapitalization.none,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[ㄱ-ㅎ|ㅏ-ㅣ|가-힣|\s]')),
      ],
    );
  }
}
