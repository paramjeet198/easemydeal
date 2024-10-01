import 'package:easemydeal/controller/home_page_controller.dart';
import 'package:easemydeal/models/event_response.dart';
import 'package:easemydeal/pages/widget/shorting_bottomsheet_content.dart';
import 'package:easemydeal/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'widget/filter_bottomsheet_content.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Events'),
        actions: _createActions(context),
      ),
      body:
          RefreshIndicator(onRefresh: _handleRefresh, child: _buildUI(context)),
    );
  }

  Future<void> _handleRefresh() async {
    // ref.invalidate(eventsProvider);
    ref.read(eventsProvider.notifier).refresh();
    ref.invalidate(filterByDateProvider);
    ref.invalidate(sortTypeNotifierProvider);

    //   ref.read(sortTypeNotifierProvider.notifier).update(SortBy.none);
    //     ref.read(filterByDateProvider.notifier).resetFilters();
  }

  List<Widget> _createActions(BuildContext context) {
    return [
      // Filter Button
      IconButton(
          tooltip: 'Filter',
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => FilterBottomSheetContent(
                onFilterSubmit: (FilterBy? filterAction) {
                  // ref.read(eventsProvider.notifier).sortEvents();
                },
              ),
            );
          },
          icon: const Icon(Icons.filter_alt_rounded)),

      // Short Button
      IconButton(
        tooltip: 'Sorting',
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SortingBottomSheetContent(
              onSort: (SortBy? shortingAction) {
                ref.read(eventsProvider.notifier).sortEvents();
              },
            ),
          );
        },
        icon: const Icon(Icons.sort_rounded),
      )
    ];
  }

  Widget _buildUI(BuildContext context) {
    return SafeArea(
        child: Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('All Events')),
          _fetchEvents(context)
        ],
      ),
    ));
  }

  Widget _fetchEvents(BuildContext context) {
    final AsyncValue<List<Event>?> events = ref.watch(eventsProvider);

    return events.when(
      data: (data) {
        if (data != null && data.isEmpty) {
          return const SizedBox(
            height: 600,
            child: Center(
              child: Text('O O P S . . .\nNothing Found',
                  style: TextStyle(fontSize: 18)),
            ),
          );
        }
        return _buildEventList(context, false, data);
      },
      error: (error, stackTrace) => _showErrorMsg(context, error),
      loading: () {
        return _buildEventList(context, true, null);
      },
    );
  }

  Widget _showErrorMsg(BuildContext context, Object error) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Center(child: Text('$error')))
        ],
      ),
    );
  }

  Widget _buildEventList(
      BuildContext context, bool isLoading, List<Event>? data) {
    return Expanded(
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data?.length ?? 10,
        itemBuilder: (context, index) {
          return _buildEventTile(context, isLoading, data?[index]);
        },
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, bool isLoading, Event? event) {
    return Skeletonizer(
      enabled: isLoading,
      child: Card.outlined(
        child: ListTile(
          title: Text(event?.title ?? 'Loading Title'),
          subtitle: Text(event?.description ?? 'Loading Description'),
          trailing: Text(Utils.dateFormatter(event?.date).toString()),
        ),
      ),
    );
  }
}
