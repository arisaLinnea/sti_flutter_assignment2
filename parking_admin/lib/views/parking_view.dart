import 'package:flutter/material.dart';
import 'package:parking_admin/widgets/parking_widget.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class ParkingView extends StatefulWidget {
  const ParkingView({super.key});

  @override
  State<ParkingView> createState() => _ParkingViewState();
}

class _ParkingViewState extends State<ParkingView> {
  Future<List<Parking>> getList = ParkingRepository().getList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text("Parkings"),
        ),
        body: FutureBuilder<List<Parking>>(
          future: getList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // filter active parkings
              var activeList =
                  snapshot.data!.where((parking) => parking.isActive).toList();
              // filter inactive parkings
              var inactiveList =
                  snapshot.data!.where((parking) => !parking.isActive).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      'ACTIVE PARKINGS:'),
                  Expanded(
                      child: ListView.builder(
                          itemCount: activeList.length,
                          itemBuilder: (context, index) {
                            return ParkingWidget(
                                item: activeList[index], number: index + 1);
                          })),
                  const Text(
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      'INACTIVE PARKINGS:'),
                  Expanded(
                      child: inactiveList.isEmpty
                          ? const Text('Empty List')
                          : ListView.builder(
                              itemCount: inactiveList.length,
                              itemBuilder: (context, index) {
                                return ParkingWidget(
                                    item: inactiveList[index],
                                    number: index + 1);
                              }))
                ],
              );
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            return const CircularProgressIndicator();
          },
        ));
  }
}
