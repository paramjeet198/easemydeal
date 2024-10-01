// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$eventsHash() => r'44ffc1bb79b5a3120939daefe3877df0ce3a5b2a';

/// This will generate the "eventsProvider" with return type [List<Event>?]
/// It fetch data from API and return the same.
///
/// Copied from [Events].
@ProviderFor(Events)
final eventsProvider = AsyncNotifierProvider<Events, List<Event>?>.internal(
  Events.new,
  name: r'eventsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$eventsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Events = AsyncNotifier<List<Event>?>;
String _$sortTypeNotifierHash() => r'd7cec8fde5cc9987c9c8528bd61600f413b74277';

/// Sort type Notifier
///
/// Copied from [SortTypeNotifier].
@ProviderFor(SortTypeNotifier)
final sortTypeNotifierProvider =
    NotifierProvider<SortTypeNotifier, SortBy>.internal(
  SortTypeNotifier.new,
  name: r'sortTypeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sortTypeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SortTypeNotifier = Notifier<SortBy>;
String _$filterByDateHash() => r'64c2ae0bf1af4934d4d14c07d5e163af5f6ed298';

/// Filter Notifier
///
/// Copied from [FilterByDate].
@ProviderFor(FilterByDate)
final filterByDateProvider =
    NotifierProvider<FilterByDate, DateFilterModel>.internal(
  FilterByDate.new,
  name: r'filterByDateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$filterByDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FilterByDate = Notifier<DateFilterModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
