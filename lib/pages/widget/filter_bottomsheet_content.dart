import 'package:easemydeal/controller/home_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FilterBy { day, month, year, none }

class FilterBottomSheetContent extends ConsumerStatefulWidget {
  const FilterBottomSheetContent({required this.onFilterSubmit, super.key});

  final Function(FilterBy) onFilterSubmit;

  @override
  ConsumerState createState() => _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState
    extends ConsumerState<FilterBottomSheetContent> {
  int _selectedIndex = 0;

  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final List<int> years = [2023, 2024, 2025];

  // final Set<int> _selectedWeeks = {};
  // final Set<int> _selectedMonths = {};
  // final Set<int> _selectedYears = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _createHeader(),
          const Divider(height: 0, thickness: .5, indent: 15),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NavigationRail(
                  destinations: _createDestinations(),
                  selectedIndex: _selectedIndex,
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (value) {
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                ),
                const VerticalDivider(thickness: 1, width: 1),
                _getSelectedDestinationContent(_selectedIndex),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildClearBtn(),
              _buildApplyBtn(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildApplyBtn() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, right: 15),
        child: ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                elevation: WidgetStateProperty.all(0),
                backgroundColor: const WidgetStatePropertyAll(Colors.green)),
            onPressed: () {
              ref.read(eventsProvider.notifier).filterEvents();
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Apply',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )),
      ),
    );
  }

  Widget _buildClearBtn() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 5, right: 15),
        child: ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                elevation: WidgetStateProperty.all(0),
                backgroundColor: WidgetStatePropertyAll(Colors.redAccent[400])),
            onPressed: () {
              ref.read(filterByDateProvider.notifier).resetFilters();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'Clear Filters',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )),
      ),
    );
  }

  Widget _getSelectedDestinationContent(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return _createWeekDestinationContent();
      case 2:
        return _createYearDestinationContent();
      default:
        return _createMonthDestinationContent();
    }
  }

  Widget _createWeekDestinationContent() {
    return Expanded(
        child: ListView.builder(
      itemCount: 52,
      shrinkWrap: true,
      itemBuilder: (context, int index) {
        int week = index + 1; // Adjusting to 1-based index (1 to 52)

        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value:
              ref.watch(filterByDateProvider).selectedWeeks?.contains(week) ??
                  false,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text('Week ${index + 1}'),
          onChanged: (value) {
            ref.read(filterByDateProvider.notifier).toggleWeek(week);
          },
        );
      },
    ));
  }

  Widget _createMonthDestinationContent() {
    return Expanded(
        child: ListView.builder(
      itemCount: monthNames.length,
      shrinkWrap: true,
      itemBuilder: (context, int index) {
        int monthNumber = index + 1; // Adjusting to 1-based index (1 to 12)

        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: ref
                  .watch(filterByDateProvider)
                  .selectedMonths
                  ?.contains(monthNumber) ??
              false,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: Text(monthNames[index]),
          onChanged: (value) {
            ref.read(filterByDateProvider.notifier).toggleMonth(monthNumber);
          },
        );
      },
    ));
  }

  Widget _createYearDestinationContent() {
    return Expanded(
      child: ListView.builder(
        itemCount: years.length,
        shrinkWrap: true,
        itemBuilder: (context, int index) {
          return CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: ref
                    .watch(filterByDateProvider)
                    .selectedYears
                    ?.contains(years[index]) ??
                false,
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text('${years[index]}'),
            onChanged: (value) {
              ref.read(filterByDateProvider.notifier).toggleYear(years[index]);
            },
          );
        },
      ),
    );
  }

  Widget _createHeader() {
    return const Padding(
      padding: EdgeInsets.all(18),
      child: Text('FILTER BY',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
    );
  }

  List<NavigationRailDestination> _createDestinations() {
    return [
      const NavigationRailDestination(
        icon: Icon(Icons.calendar_view_week_rounded),
        label: Text('Week'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.calendar_month),
        label: Text('Month'),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.calendar_today),
        label: Text('Year'),
      ),
    ];
  }
}
