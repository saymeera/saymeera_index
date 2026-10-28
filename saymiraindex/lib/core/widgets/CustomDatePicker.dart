import 'package:flutter/material.dart';
import 'package:saymiraindex/core/constants/app_colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProCalendarPicker {
  static void show({
    required BuildContext context,
    required Function(DateTime) onDateSelected,
    DateTime? initialDate,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.offWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          child: Container(
            height: 450,
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.offWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // Professional Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Select Date",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 1),

                // Calendar Body
                Expanded(
                  child: SfDateRangePicker(
                    
                    onSelectionChanged: (args) {
                      if (args.value is DateTime) {
                        onDateSelected(args.value);
                        Navigator.pop(context);
                      }
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                    initialSelectedDate: DateTime(2000, 1, 1),
                    minDate: DateTime(1900, 1, 1),
                    // Header (Month/Year display)
                    headerStyle: const DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    // Selection Design
                    selectionColor: AppColors.primaryRed,
                    todayHighlightColor: Colors.green.shade600,
                    selectionTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),

                    // Month View Customization
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                        textStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    // Clean navigation icons
                    monthCellStyle: const DateRangePickerMonthCellStyle(
                      textStyle: TextStyle(fontSize: 14, color: Colors.black87),
                      todayTextStyle: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
