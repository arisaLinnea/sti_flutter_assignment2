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
    return
        // BlocProvider(
        //   create: (context) => VehicleBloc(vehicleRepository: VehicleRepository()),
        //   child:
        // BlocListener<VehicleBloc, VehicleState>(
        //     listener: (context, state) {
        //       print('vehicleState widget listener: $state');
        //       if (state is VehicleSuccess) {
        //         Utils.toastMessage(state.message);
        //       }
        //       if (state is VehicleFailure) {
        //         Utils.toastMessage(state.error);
        //       }
        //     },
        //     child:
        Card(
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
              // child: TextButton(
              //   child: const Text('Remove'),
              //   onPressed: () async {
              //     bool success = await VehicleRepository().remove(id: item.id);
              //     if (success) {
              //       Utils.toastMessage('Vehicle removed');
              //     } else {
              //       Utils.toastMessage('Failed to remove vehicle');
              //     }
              //     if (context.mounted) {
              //       context.read<VehicleListProvider>().updateVehicleList();
              //     }
              //   },
              // ),
            ),
          ],
        ),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Registration number: ${item.registrationNo}'),
              Text('Type: ${item.type.name}'),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     TextButton(
              //       child: const Text('Remove'),
              //       onPressed: () async {
              //         bool success =
              //             await VehicleRepository().remove(id: item.id);
              //         if (success) {
              //           Utils.toastMessage('Vehicle removed');
              //         } else {
              //           Utils.toastMessage('Failed to remove vehicle');
              //         }
              //         if (context.mounted) {
              //           context.read<VehicleListProvider>().updateVehicleList();
              //         }
              //       },
              //     ),
              //   ],
              // )
            ]),
      ),
      // )
    );
    // );
  }
}
