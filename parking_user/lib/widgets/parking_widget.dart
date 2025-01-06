import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class ParkingWidget extends StatelessWidget {
  const ParkingWidget(
      {super.key,
      required this.item,
      required this.number,
      required this.isActive});

  final Parking item;
  final int number;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        title: Text(
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.bold),
            'Parking $number:'),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Address: ${item.parkinglot?.address.toString()}'),
              Text('Hourly price: ${item.parkinglot?.hourlyPrice}'),
              Text(
                  'Car: ${item.vehicle?.registrationNo} (${item.vehicle?.type.name})'),
              Text('Start time: ${item.startTime.parkingFormat()}'),
              Text('End time: ${item.endTime?.parkingFormat() ?? 'Ongoing'}'),
              Builder(
                builder: (context) {
                  if (isActive) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('End now'),
                          onPressed: () async {
                            String id = item.id;
                            item.endTime = DateTime.now();
                            context
                                .read<ParkingBloc>()
                                .add(EditParkingEvent(parking: item));
                          },
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ]),
      ),
    );
  }
}
