import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/themes/app_colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onCancel;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 41,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, size: 16, color: AppColors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    textInputAction: TextInputAction.search,
                    cursorColor: AppColors.accent,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Type title, categories, years, etc',
                      hintStyle: TextStyle(color: AppColors.grey, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isEmpty
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: onCancel,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Text('Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
        ),
      ],
    );
  }
}