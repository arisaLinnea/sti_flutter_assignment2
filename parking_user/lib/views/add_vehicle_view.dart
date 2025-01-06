import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_user/blocs/auth/auth_bloc.dart';
import 'package:parking_user/blocs/vehicle/vehicle_bloc.dart';
import 'package:parking_user/utils/utils.dart';
import 'package:shared/shared.dart';
import 'package:shared_client/shared_client.dart';

class AddVehicleView extends StatelessWidget {
  const AddVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final loggedInUser = context.read<AuthBloc>().state.user;
    String? regNo;
    CarBrand type = CarBrand.None;
    return BlocListener<VehicleBloc, VehicleState>(
        listener: (context, state) {
          print('vehicleState add vehicle listener: $state');
          if (state is VehicleFailure) {
            Utils.toastMessage(state.error);
          }
          if (state is VehicleSuccess) {
            Utils.toastMessage(state.message);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Add new vehicle",
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
                          onSaved: (newValue) => regNo = newValue,
                          decoration: const InputDecoration(
                            labelText: 'Registration number',
                          ),
                          validator: (value) => value?.isValidRegNo() ?? true
                              ? null
                              : 'Enter a valid registration number',
                          onFieldSubmitted: (_) {
                            if (formKey.currentState!.validate()) {}
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 8.0),
                        child: DropdownButtonFormField<CarBrand>(
                          decoration: const InputDecoration(
                            labelText: 'Car brand',
                          ),
                          value: type,
                          hint: const Text('Select a vehicle type'),
                          onSaved: (newValue) => type = newValue!,
                          onChanged: (CarBrand? value) {},
                          validator: (value) {
                            if (value == null || value == CarBrand.None) {
                              return 'Please select a car brand';
                            }
                            return null;
                          },
                          items:
                              // CarBrand
                              CarBrand.values.map<DropdownMenuItem<CarBrand>>(
                                  (CarBrand value) {
                            return DropdownMenuItem<CarBrand>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
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

                                Vehicle newVehicle = Vehicle(
                                    registrationNo: regNo!,
                                    type: type,
                                    owner: loggedInUser);

                                // String? id = await VehicleRepository()
                                //     .addToList(item: newVehicle);
                                // if (id != null) {
                                //   Utils.toastMessage('Vehicle added');
                                // } else {
                                //   Utils.toastMessage('Failed to add vehicle');
                                // }
                                context
                                    .read<VehicleBloc>()
                                    .add(AddVehicleEvent(vehicle: newVehicle));
                                formKey.currentState?.reset();
                                // if (context.mounted) {
                                //   context
                                //       .read<VehicleListProvider>()
                                //       .updateVehicleList();
                                // }
                              }
                            },
                            child: const Text('Add'),
                          )),
                    ),
                  ],
                ))));
  }
}
