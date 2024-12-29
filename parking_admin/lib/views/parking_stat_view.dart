import 'package:flutter/material.dart';
import 'package:parking_admin/providers/parking_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared/shared.dart';

class ParkingStatView extends StatefulWidget {
  const ParkingStatView({super.key});

  @override
  State<ParkingStatView> createState() => _ParkingStatViewState();
}

class _ParkingStatViewState extends State<ParkingStatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text("Parking statistics"),
        ),
        body: CustomScrollView(slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Popular Parkings:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Selector<ParkingProvider, List<ParkingLot>>(
            selector: (context, provider) => provider.getPopularParkingLots(),
            builder: (context, popularLots, child) {
              if (popularLots.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No popular parkings')),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60.0, vertical: 2.0),
                      child: Text(popularLots[index].address.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                  childCount: popularLots.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Sum parking: (for ended parkings)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Selector<ParkingProvider, double>(
            selector: (context, provider) => provider.sumParking,
            builder: (context, data, child) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60.0, vertical: 2.0),
                  child: Text(
                    'Sum $data',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ]));
  }
}
