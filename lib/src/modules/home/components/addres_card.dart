
import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';
import '../model/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onOpenRoute;

  const AddressCard({
    super.key,
    required this.address,
    required this.onOpenRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              address.cep.isEmpty ? 'CEP não informado' : address.cep,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Text('Logradouro: ${address.street}'),
            Text('Bairro: ${address.neighborhood}'),
            Text('Cidade: ${address.city} - ${address.state}'),
            if (address.complement != null &&
                address.complement!.isNotEmpty)
              Text('Complemento: ${address.complement}'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onOpenRoute,
                icon: const Icon(Icons.directions),
                label: const Text('Traçar rota no Google Maps'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
