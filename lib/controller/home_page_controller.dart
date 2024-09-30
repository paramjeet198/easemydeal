import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easemydeal/services/http_service.dart';
import 'package:easemydeal/utils/api_url.dart';
import 'package:easemydeal/utils/logger.dart';
import 'package:easemydeal/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/date_filter_model.dart';
import '../models/date_sorting_model.dart';
import '../models/event_response.dart';
import '../pages/widget/shorting_bottomsheet_content.dart';

part 'home_page_controller.g.dart';

/// This will generate the "eventsProvider" with return type [List<Event>?]
/// It fetch data from API and return the same.
@Riverpod(keepAlive: true)
class Events extends _$Events {
  List<Event>? originalEvents;

  @override
  FutureOr<List<Event>?> build() async {
    Log.v('Build triggered');
    HttpService httpService = ref.read(httpServicesProvider);
    originalEvents = await _fetchEvenData(httpService);
    return originalEvents;
  }

  /// This method fetches the event list from API with endpoint [/flutter/task1]
  Future<List<Event>?> _fetchEvenData(HttpService httpService) async {
    Log.v('Fetching Data...');
    Response? res = await httpService.get(ApiUrl.task1);

    if (res != null) {
      if (res.statusCode! >= 200 || res.statusCode! < 300) {
        final json = jsonDecode(res.data) as Map<String, dynamic>;
        return EventResponse.fromJson(json).data;
      } else {
        throw Exception('Something went wrong');
      }
    } else {
      throw Exception('Something went wrong');
    }
  }

  ///update the STATE manually.
  Future<void> sortEvents() async {
    SortBy sortBy = ref.read(sortTypeNotifierProvider);
    DateFormat dateFormat = DateFormat('yyyy-M-d');
    List<Event> eventsToSort = [];
    // Check if we have a filtered list in the state; if not, use the original events
    if (state.value == null || state.value!.isEmpty) {
      Log.v('if');
      eventsToSort = originalEvents ?? [];
    } else {
      Log.v('else');
      eventsToSort = state.value ?? [];
    }

    Log.v('events to sort: ${eventsToSort.length}, ');

    switch (sortBy) {
      case SortBy.day:
        {
          // Sort by day
          eventsToSort.sort((a, b) {
            DateTime dateA = dateFormat.parse(a.date!);
            DateTime dateB = dateFormat.parse(b.date!);
            return dateA.day.compareTo(dateB.day); // Compare by day
          });
        }
        break;
      case SortBy.month:
        {
          // Sort by month
          eventsToSort.sort((a, b) {
            DateTime dateA = dateFormat.parse(a.date!);
            DateTime dateB = dateFormat.parse(b.date!);
            return dateA.month.compareTo(dateB.month); // Compare by month
          });
        }
        break;
      case SortBy.year:
        {
          // Sort by year
          eventsToSort.sort((a, b) {
            DateTime dateA = dateFormat.parse(a.date!);
            DateTime dateB = dateFormat.parse(b.date!);

            var yearComparison = dateA.year.compareTo(dateB.year);
            return yearComparison == 0
                ? dateA.month.compareTo(dateB.month)
                : yearComparison;
          });
        }
        break;
      case SortBy.none:
        break;
    }

    // Update the state with the sorted list
    state = AsyncData([...eventsToSort]); // This updates the sorted events
  }

  ///Filter
  /*Future<void> filterEvents() async {
    final filter = ref.read(filterByDateProvider);
    DateFormat dateFormat = Utils.apiDateFormatter();

    final events = originalEvents ?? [];
    Log.v('event: ${events.length}');

    List<Event> filteredEvents = events.where((event) {
      DateTime eventDate = dateFormat.parse(event.date!);

      bool matchesYear = filter.year == null || eventDate.year == filter.year;
      bool matchesMonth =
          filter.month == null || eventDate.month == filter.month;
      bool matchesWeek =
          filter.week == null || eventDate.weekday == filter.week;

      return matchesYear && matchesMonth && matchesWeek;
    }).toList();

    state = AsyncData([...filteredEvents]);
  }*/

  ///Reset Filters....
  void removeFilter() {
    DateFilterModel filterModel = ref.read(filterByDateProvider);

    // Check if filters are null (indicating no filters applied)
    if (filterModel.selectedWeeks == null &&
        filterModel.selectedMonths == null &&
        filterModel.selectedYears == null) {
      state = AsyncData([...originalEvents!]); // Reset to original events
      return;
    }
  }
}

/// Sort type Notifier
@Riverpod(keepAlive: true)
class SortTypeNotifier extends _$SortTypeNotifier {
  @override
  SortBy build() {
    Log.v('SortTypeNotifier Build Called');
    return SortBy.none;
  }

  void update(SortBy newState) {
    state = newState;
  }
}

/// Filter Notifier
@Riverpod(keepAlive: true)
class FilterByDate extends _$FilterByDate {
  @override
  DateFilterModel build() {
    return DateFilterModel();
  }

  void toggleWeek(int week) {
    final updatedWeeks = Set<int>.from(state.selectedWeeks ?? {});

    if (updatedWeeks.contains(week)) {
      updatedWeeks.remove(week); // Deselect the week
    } else {
      updatedWeeks.add(week); // Select the week
    }

    state = state.copyWith(
      selectedWeeks: updatedWeeks, // Update only the selected weeks
    );
  }

  void toggleMonth(int month) {
    final updatedMonths = Set<int>.from(state.selectedMonths ?? {});

    if (updatedMonths.contains(month)) {
      updatedMonths.remove(month); // Deselect the month
    } else {
      updatedMonths.add(month); // Select the month
    }

    state = state.copyWith(
      selectedMonths: updatedMonths, // Update only the selected weeks
    );
  }

  void toggleYear(int year) {
    final updatedYear = Set<int>.from(state.selectedYears ?? {});

    if (updatedYear.contains(year)) {
      updatedYear.remove(year); // Deselect the year
    } else {
      updatedYear.add(year); // Select the year
    }

    state = state.copyWith(selectedYears: updatedYear);
  }

  // Reset all selections to empty
  void reset() {
    state = state.copyWith(
      selectedWeeks: {},
      selectedMonths: {},
      selectedYears: {},
    );

    state = DateFilterModel();

  }
}
