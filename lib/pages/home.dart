import 'package:easemydeal/controller/home_page_controller.dart';
import 'package:easemydeal/models/event_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Events'),
      ),
      body: _buildUI(context),
    );
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
        children: [const Text('All Events'), _fetchEvents(context)],
      ),
    ));
  }

  Widget _fetchEvents(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final AsyncValue<List<Event>?> events = ref.watch(eventsProvider);

        return events.when(
          data: (data) {
            return _buildEventList(context, false, data);
          },
          error: (error, stackTrace) => Text('Error: $error'),
          loading: () {
            return _buildEventList(context, false, null);
          },
        );
      },
    );
  }

  Widget _buildEventList(
      BuildContext context, bool isLoading, List<Event>? data) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data?.length ?? 0,
        itemBuilder: (context, index) {
          return _buildEventTile(context, isLoading, data?[index]);
        },
      ),
    );
  }

  Widget _buildEventTile(BuildContext context, bool isLoading, Event? data) {
    return Skeletonizer(
      enabled: isLoading,
        child: Card.outlined(
      child: ListTile(
        title: Text(data?.title ?? ''),
        trailing: Text(data?.date ?? ''),
        subtitle: Text(data?.description ?? ''),
      ),
    ));
  }
}
