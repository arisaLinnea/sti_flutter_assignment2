import 'package:flutter/material.dart';
import 'package:parking_admin/providers/parking_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class ParkingLotWidget extends StatelessWidget {
  const ParkingLotWidget({super.key, required this.item, required this.number});

  final ParkingLot item;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        title: Text(
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold),
            'PARKING LOT $number:'),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(item.address.toString()),
              Text('Price per hour: ${item.hourlyPrice}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Remove'),
                    onPressed: () async {
                      bool success =
                          await ParkingLotRepository().remove(id: item.id);
                      if (success) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Parking lot removed'),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to remove parking lot'),
                            ),
                          );
                        }
                      }
                      if (context.mounted) {
                        context.read<ParkingProvider>().updateParkingsLots();
                      }
                    },
                  ),
                ],
              )
              // TODO implement edit later
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     TextButton(
              //       child: const Text('Edit'),
              //       onPressed: () => context.go('/parkinglot/edit/${item.id}'),
              //     ),
              //   ],
              // )
            ]),

        // tileColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}
