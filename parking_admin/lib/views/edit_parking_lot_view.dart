import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class EditParkingLotView extends StatefulWidget {
  final String lotId;

  const EditParkingLotView({super.key, required this.lotId});

  @override
  State<EditParkingLotView> createState() => _ParkingLotViewState();
}

class _ParkingLotViewState extends State<EditParkingLotView> {
  late Future<ParkingLot> parkingLot;
  final _formKey = GlobalKey<FormState>();
  String? street = '';
  String? zipcode = '';
  String? city = '';
  double? price;
  int maxValue = 50;

  @override
  void initState() {
    super.initState();
    parkingLot = ParkingLotRepository().getElementById(id: widget.lotId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Parking Lot'),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: FutureBuilder<ParkingLot>(
        future: parkingLot,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error: Parking Lot could not be fetched'));
          } else if (snapshot.hasData) {
            ParkingLot parkingLotData = snapshot.data!;
            // Build UI with the parking lot data
            return Form(
              key: _formKey,
              child: Scrollbar(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ...[
                              TextFormField(
                                decoration: const InputDecoration(
                                  filled: true,
                                  labelText: 'Street',
                                ),
                                initialValue: parkingLotData.address?.street,
                                onChanged: (value) {
                                  setState(() {
                                    street = value;
                                  });
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  filled: true,
                                  labelText: 'ZipCode',
                                ),
                                initialValue: parkingLotData.address?.zipCode,
                                onChanged: (value) {
                                  setState(() {
                                    zipcode = value;
                                  });
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  filled: true,
                                  labelText: 'City',
                                ),
                                initialValue: parkingLotData.address?.city,
                                onChanged: (value) {
                                  setState(() {
                                    city = value;
                                  });
                                },
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Price',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    intl.NumberFormat.currency(
                                            symbol: "\$", decimalDigits: 0)
                                        .format(price ??
                                            parkingLotData.hourlyPrice),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Slider(
                                    min: 0,
                                    max: maxValue.toDouble(),
                                    divisions: maxValue,
                                    value: price ?? parkingLotData.hourlyPrice,
                                    onChanged: (value) {
                                      setState(() {
                                        price = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ].expand(
                              (widget) => [
                                widget,
                                const SizedBox(
                                  height: 24,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
