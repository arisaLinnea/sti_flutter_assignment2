import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class AddParkingLotView extends StatelessWidget {
  const AddParkingLotView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    String? street;
    String? city;
    String? zip;
    String? price;

    return BlocListener<ParkingLotBloc, ParkingLotState>(
        listener: (context, state) {
          if (state is ParkingLotFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
          if (state is ParkingLotSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Add new parking lot",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            body: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 8.0),
                        child: TextFormField(
                          onSaved: (newValue) => street = newValue,
                          decoration: const InputDecoration(
                            labelText: 'Street address:',
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Enter a valid registration number'
                              : null,
                          onFieldSubmitted: (_) {
                            if (formKey.currentState!.validate()) {}
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 8.0),
                        child: TextFormField(
                          onSaved: (newValue) => zip = newValue,
                          decoration: const InputDecoration(
                            labelText: 'Zip code:',
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Enter a zip number'
                              : null,
                          onFieldSubmitted: (_) {
                            if (formKey.currentState!.validate()) {}
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 8.0),
                        child: TextFormField(
                          onSaved: (newValue) => city = newValue,
                          decoration: const InputDecoration(
                            labelText: 'City: ',
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Enter a city name'
                              : null,
                          onFieldSubmitted: (_) {
                            if (formKey.currentState!.validate()) {}
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 8.0),
                        child: TextFormField(
                          onSaved: (newValue) => price = newValue,
                          decoration: const InputDecoration(
                            labelText: 'Price per hour: ',
                          ),
                          validator: (value) => (value == null ||
                                  value.isEmpty ||
                                  double.tryParse(value) == null)
                              ? 'Enter a valid double/int/float value'
                              : null,
                          onFieldSubmitted: (_) {
                            if (formKey.currentState!.validate()) {}
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 24.0),
                      child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                Address address = Address(
                                    street: street!,
                                    zipCode: zip!,
                                    city: city!);
                                double hourlyPrice =
                                    double.tryParse(price!) == null
                                        ? 0
                                        : double.parse(price!);
                                ParkingLot newLot = ParkingLot(
                                    address: address, hourlyPrice: hourlyPrice);

                                context
                                    .read<ParkingLotBloc>()
                                    .add(AddParkingLotEvent(lot: newLot));
                                formKey.currentState?.reset();
                              }
                            },
                            child: const Text('Add'),
                          )),
                    ),
                  ],
                ))));
  }
}
