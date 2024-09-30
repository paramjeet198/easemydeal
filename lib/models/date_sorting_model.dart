class DateSortingModel {
  final int? year;
  final int? month;
  final int? week;

  DateSortingModel({this.year, this.month, this.week});

  DateSortingModel copyWith({int? year, int? month, int? week}) {
    return DateSortingModel(
      year: year ?? this.year,
      month: month ?? this.month,
      week: week ?? this.week,
    );
  }
}
