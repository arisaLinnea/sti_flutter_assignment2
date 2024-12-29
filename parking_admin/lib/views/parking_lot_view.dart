import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parking_admin/providers/parking_provider.dart';
import 'package:parking_admin/widgets/parking_lot_widget.dart';
import 'package:provider/provider.dart';

class ParkingLotView extends StatefulWidget {
  const ParkingLotView({super.key});

  @override
  State<ParkingLotView> createState() => _ParkingLotViewState();
}

class _ParkingLotViewState extends State<ParkingLotView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text("Available parking lots"),
      ),
      body: Consumer<ParkingProvider>(builder: (context, provider, child) {
        if (provider.isLotsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.parkingsLots.isEmpty) {
          return const Text('No parking lots available.');
        }
        return ListView.builder(
          itemCount: provider.parkingsLots.length,
          itemBuilder: (context, index) {
            return ParkingLotWidget(
                item: provider.parkingsLots[index], number: index + 1);
          },
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add new parking lot',
        onPressed: () {
          context.go('/parkinglot/addParkinglot');
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
