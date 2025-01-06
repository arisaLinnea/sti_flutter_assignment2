import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_user/blocs/vehicle/vehicle_bloc.dart';
import 'package:parking_user/utils/utils.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class VehicleWidget extends StatelessWidget {
  const VehicleWidget({super.key, required this.item, required this.number});

  final Vehicle item;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.bold),
                'Vehicle $number:'),
            const Spacer(),
            Align(
              alignment: Alignment.topRight,
              child: BlocBuilder<VehicleBloc, VehicleState>(
                builder: (context, state) {
                  return state is VehicleLoading
                      ? const CircularProgressIndicator()
                      : TextButton(
                          child: const Text('Remove'),
                          onPressed: () async {
                            context
                                .read<VehicleBloc>()
                                .add(RemoveVehicleEvent(vehicleId: item.id));
                          },
                        );
                },
              ),
            ),
          ],
        ),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Registration number: ${item.registrationNo}'),
              Text('Type: ${item.type.name}'),
            ]),
      ),
    );
  }
}
