import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easemydeal/services/http_service.dart';
import 'package:easemydeal/utils/api_url.dart';
import 'package:easemydeal/utils/logger.dart';
import 'package:easemydeal/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/date_filter_model.dart';
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

  ///Method to sort the events
  Future<void> sortEvents() async {
    SortBy sortBy = ref.read(sortTypeNotifierProvider);
    DateFormat dateFormat = DateFormat('yyyy-M-d');
    List<Event> eventsToSort = [];

    // Check if we have a filtered list in the state; if not, use the original events
    if (state.value == null || state.value!.isEmpty) {
      eventsToSort = originalEvents ?? [];
    } else {
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
    state = AsyncData([...eventsToSort]);
  }

  ///Filter
  Future<void> filterEvents() async {
    DateFilterModel filter = ref.read(filterByDateProvider);
    DateFormat dateFormat = Utils.apiDateFormatter();

    final events = originalEvents ?? [];
    Log.v('event: ${events.length}');
    Log.v('filter: ${filter.toString()}');

    List<Event> filteredEvents = events.where((event) {
      DateTime eventDate = dateFormat.parse(event.date!);
      Log.v(
          'Event Date: Year: ${eventDate.year} Month: ${eventDate.month}, Week: ${eventDate.weekday}');
      Log.v(
          'Selected Date: Year: ${filter.selectedYears} Month: ${filter.selectedMonths}, Week: ${filter.selectedWeeks}');

      bool matchesYear = filter.selectedYears?.contains(eventDate.year) ??
          true; // Check if year is in set
      bool matchesMonth = filter.selectedMonths?.contains(eventDate.month) ??
          true; // Check if month is in set

      int weekNumber = (eventDate.day + (eventDate.month - 1) * 30) ~/ 7;
      Log.v('Week Number: $weekNumber');
      bool matchesWeek = filter.selectedWeeks?.contains(weekNumber + 1) ??
          true; // Check if week is in set

      return matchesYear && matchesMonth && matchesWeek;
    }).toList();

    Log.v('filteredEvents: ${filteredEvents.length}');

    state = AsyncData([...filteredEvents]);
  }

  Future<void> refresh() async {
    Log.v('Refreshing...');
    state = const AsyncValue.loading();
    ref.invalidateSelf();
    var result = await future;
    state = AsyncValue.data(result);
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
        selectedWeeks:
            updatedWeeks); // this will assign a new instance of DateFilterModel due to immutability
  }

  void toggleMonth(int month) {
    final updatedMonths = Set<int>.from(state.selectedMonths ?? {});

    if (updatedMonths.contains(month)) {
      updatedMonths.remove(month); // Deselect the month
    } else {
      updatedMonths.add(month); // Select the month
    }

    state = state.copyWith(selectedMonths: updatedMonths);
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
  void resetFilters() {
    state = state.copyWith(
      selectedWeeks: {},
      selectedMonths: {},
      selectedYears: {},
    );

    state = DateFilterModel();
  }
}
