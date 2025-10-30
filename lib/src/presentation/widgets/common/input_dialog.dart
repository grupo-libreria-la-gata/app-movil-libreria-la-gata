import 'package:flutter/material.dart';
import '../../../core/design/design_tokens.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String labelText;
  final String initialValue;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String confirmText;
  final String cancelText;

  const InputDialog({
    super.key,
    required this.title,
    required this.labelText,
    this.initialValue = '',
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.confirmText = 'Guardar',
    this.cancelText = 'Cancelar',
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String labelText,
    String initialValue = '',
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines = 1,
    String confirmText = 'Guardar',
    String cancelText = 'Cancelar',
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => InputDialog(
        title: title,
        labelText: labelText,
        initialValue: initialValue,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
              borderSide: BorderSide(color: DesignTokens.primaryColor),
            ),
          ),
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          autofocus: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: DesignTokens.textSecondaryColor,
          ),
          child: Text(widget.cancelText),
        ),
        ElevatedButton(
          onPressed: _onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: DesignTokens.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
            ),
          ),
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
