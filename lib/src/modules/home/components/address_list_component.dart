
import 'package:flutter/material.dart';

import '../model/address_model.dart';
import 'address_card_component.dart';

class AddressListComponent extends StatelessWidget {
  final List<AddressModel> addresses;
  final Function(AddressModel) onRoutePressed;

  const AddressListComponent({
    super.key,
    required this.addresses,
    required this.onRoutePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: addresses.map((address) {
        return AddressCardComponent(
          address: address,
          onRoutePressed: () => onRoutePressed(address),
        );
      }).toList(),
    );
  }
}
