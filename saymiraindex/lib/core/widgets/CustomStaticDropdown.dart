import 'package:flutter/material.dart';
import 'package:saymiraindex/core/constants/app_colors.dart';

class CustomStaticDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final Function(T?) onChanged;
  final String Function(T) itemAsString;

  const CustomStaticDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemAsString,
    // Removed 'label' from constructor
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(
        hint,
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
      dropdownColor: AppColors.offWhite,
      style: const TextStyle(color: Colors.black87, fontSize: 15),
      decoration: InputDecoration(
        isDense: true, // Makes it match your other input fields
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6), // Matches your _input style
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
      ),
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(itemAsString(item)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
