import 'package:easemydeal/controller/home_page_controller.dart';
import 'package:easemydeal/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortBy { day, month, year, none }

class SortingBottomSheetContent extends ConsumerStatefulWidget {
  const SortingBottomSheetContent({required this.onSort, super.key});

  final Function(SortBy) onSort;

  @override
  ConsumerState createState() => _SortingBottomSheetContentState();
}

class _SortingBottomSheetContentState
    extends ConsumerState<SortingBottomSheetContent> {
  @override
  Widget build(BuildContext context) {
    // _shortBy = ref.watch(sortTypeProvider);

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.35,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text('SHORT BY',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey)),
          ),
          const Divider(height: 0, thickness: .5, indent: 15),
          _buildRadioListTile(SortBy.day, 'Day', 'Sort by the day'),
          _buildRadioListTile(
              SortBy.month, 'Month', 'Sort by the month (default)'),
          _buildRadioListTile(SortBy.year, 'Year', 'Sort by the year'),
        ],
      ),
    );
  }

  Widget _buildRadioListTile(SortBy value, String title, String subtitle) {
    return RadioListTile.adaptive(
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      controlAffinity: ListTileControlAffinity.platform,
      value: value,
      groupValue: ref.watch(sortTypeNotifierProvider),
      onChanged: (SortBy? newValue) {
        ref.read(sortTypeNotifierProvider.notifier).update(newValue!);
        widget.onSort(newValue);
        setState(() {});
        Navigator.of(context).pop();
      },
    );
  }
}
