import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/app/core/utils/app_styles.dart';

class CounterTextField extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final String hintText;
  final String labelText;
  final ValueChanged<int> onChanged;

  const CounterTextField({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.hintText = "Enter value",
    this.labelText = "",
  });

  @override
  State<CounterTextField> createState() => _CounterTextFieldState();
}

class _CounterTextFieldState extends State<CounterTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController(
      text: widget.value == 0 ? "" : widget.value.toString(),
    );
    _focusNode.addListener(() {
      // When focus lost, clamp and emit
      if (!_focusNode.hasFocus) {
        final parsed = int.tryParse(_controller.text) ?? widget.min;
        final clamped = parsed.clamp(widget.min, widget.max);
        _controller.text = clamped == 0 ? "" : clamped.toString();
        widget.onChanged(clamped);
      }
    });
  }

  @override
  void didUpdateWidget(CounterTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync external value changes (e.g. clear all)
    if (oldWidget.value != widget.value && !_focusNode.hasFocus) {
      _controller.text = widget.value == 0 ? "" : widget.value.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _increment() {
    final current = int.tryParse(_controller.text) ?? 0;
    final next = (current + 1).clamp(widget.min, widget.max);
    _controller.text = next.toString();
    widget.onChanged(next);
  }

  void _decrement() {
    final current = int.tryParse(_controller.text) ?? 0;
    final next = (current - 1).clamp(widget.min, widget.max);
    _controller.text = next == 0 ? "" : next.toString();
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final bool canDecrement =
        (int.tryParse(_controller.text) ?? 0) > widget.min;
    final bool canIncrement =
        (int.tryParse(_controller.text) ?? 0) < widget.max;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15,
      children: [
        if (widget.labelText.isNotEmpty)
          Text(
            widget.labelText,
            style: AppStyles.customTextStyle(
              color: AppColors.whiteColor,
              size: 15,
              weight: FontWeight.w700,
            ),
          ),
        Container(
          constraints: const BoxConstraints(minHeight: 55),
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) {
              final parsed = int.tryParse(v) ?? 0;
              widget.onChanged(parsed.clamp(widget.min, widget.max));
              setState(() {}); // rebuild +/- enabled state
            },
            style: AppStyles.customTextStyle(
              fontFamily: "Roboto",
              color: AppColors.whiteColor,
              size: 15,
              weight: FontWeight.w500,
            ),
            cursorColor: AppColors.primaryColor,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppStyles.customTextStyle(
                fontFamily: "Roboto",
                color: AppColors.greyColor,
                size: 15,
                weight: FontWeight.w500,
              ),
              filled: true,
              isDense: true,
              fillColor: AppColors.fieldBgColor,
              counterText: "",
              contentPadding: const EdgeInsets.symmetric(
                vertical: 22,
                horizontal: 18,
              ),
              // ── suffix: decrement | divider | increment ──────────────
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Divider
                  // Container(
                  //   width: 1,
                  //   height: 24,
                  //   color: AppColors.fieldBorderColor,
                  // ),
                  // Decrement
                  _CounterButton(
                    icon: Icons.remove,
                    enabled: canDecrement,
                    onTap: () {
                      _decrement();
                      setState(() {});
                    },
                  ),
                  // Divider
                  Container(
                    width: 1,
                    height: 24,
                    color: AppColors.fieldBorderColor,
                  ),
                  // Increment
                  _CounterButton(
                    icon: Icons.add,
                    enabled: canIncrement,
                    onTap: () {
                      _increment();
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 6),
                ],
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                const BorderSide(color: AppColors.fieldBorderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide:
                const BorderSide(color: AppColors.fieldBorderColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _CounterButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: SizedBox(
        width: 40,
        height: 55,
        child: Icon(
          icon,
          size: 20,
          color: enabled ? AppColors.primaryColor : AppColors.fieldBorderColor,
        ),
      ),
    );
  }
}