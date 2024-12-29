import 'package:flutter/material.dart';
import 'package:parking_user/providers/auth_state.dart';
import 'package:parking_user/providers/parking_provider.dart';
import 'package:parking_user/providers/vehicle_provider.dart';
import 'package:parking_user/widgets/free_lots_widget.dart';
import 'package:parking_user/widgets/parking_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared/shared.dart';

class ParkingView extends StatefulWidget {
  const ParkingView({super.key});
  @override
  State<ParkingView> createState() => _ParkingViewState();
}

class _ParkingViewState extends State<ParkingView> {
  @override
  void initState() {
    super.initState();
    Owner? owner = Provider.of<AuthState>(context, listen: false).userInfo;
    context.read<ParkingProvider>().setOwner(owner);
    context.read<VehicleListProvider>().setOwner(owner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Parkings')),
        body: CustomScrollView(slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'FREE PARKING LOTS:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Selector<ParkingProvider, List<ParkingLot>>(
            selector: (context, provider) => provider.getFreeParkingLots(),
            builder: (context, freeParkingLots, child) {
              if (freeParkingLots.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No parkinglots available.')),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return FreeLotsWidget(
                        item: freeParkingLots[index], number: index + 1);
                  },
                  childCount: freeParkingLots.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'MY ACTIVE PARKINGS:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Selector<ParkingProvider, List<Parking>>(
            selector: (context, provider) => provider.getMyActiveParkings(),
            builder: (context, activeParkings, child) {
              if (activeParkings.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No active parkings.')),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ParkingWidget(
                        item: activeParkings[index],
                        number: index + 1,
                        isActive: true);
                  },
                  childCount: activeParkings.length,
                ),
              );
            },
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'MY CLOSED PARKINGS:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Selector<ParkingProvider, List<Parking>>(
            selector: (context, provider) => provider.getMyOldParkings(),
            builder: (context, closedParkings, child) {
              if (closedParkings.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('No ended parkings.')),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ParkingWidget(
                        item: closedParkings[index],
                        number: index + 1,
                        isActive: false);
                  },
                  childCount: closedParkings.length,
                ),
              );
            },
          ),
        ]));
  }
}
