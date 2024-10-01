class DateFilterModel {
  final Set<int>? selectedWeeks;
  final Set<int>? selectedMonths;
  final Set<int>? selectedYears;

  DateFilterModel({
    this.selectedWeeks,
    this.selectedMonths,
    this.selectedYears,
  });

  DateFilterModel copyWith({
    Set<int>? selectedWeeks,
    Set<int>? selectedMonths,
    Set<int>? selectedYears,
  }) {
    return DateFilterModel(
      selectedWeeks: selectedWeeks ?? this.selectedWeeks,
      selectedMonths: selectedMonths ?? this.selectedMonths,
      selectedYears: selectedYears ?? this.selectedYears,
    );
  }

  @override
  String toString() {
    return 'DateFilterModel{selectedWeeks: $selectedWeeks, selectedMonths: $selectedMonths, selectedYears: $selectedYears}';
  }
}
