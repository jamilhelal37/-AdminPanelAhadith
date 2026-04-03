import 'package:flutter/material.dart';


class AskQuestionFloatingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const AskQuestionFloatingButton({
    super.key,
    required this.onPressed,
    this.label = 'اطرح سؤالك',
  });

  @override
  State<AskQuestionFloatingButton> createState() =>
      _AskQuestionFloatingButtonState();
}

class _AskQuestionFloatingButtonState extends State<AskQuestionFloatingButton> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.12),
      colorScheme.surface,
    );
    final borderColor = Color.alphaBlend(
      colorScheme.primary.withValues(alpha: 0.16),
      colorScheme.surface,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            color: buttonColor,
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


