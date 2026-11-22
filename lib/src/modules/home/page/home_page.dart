
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/colors/app_colors.dart';
import '../../history/page/history_page.dart';
import '../controller/home_controller.dart';
import '../model/address_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  @override
  void dispose() {
    _cepController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  Future<void> _searchByCep() async {
    await _controller.searchByCep(_cepController.text.trim());
  }

  Future<void> _searchByAddress() async {
    await _controller.searchByAddress(
      state: _stateController.text.trim().toUpperCase(),
      city: _cityController.text.trim(),
      street: _streetController.text.trim(),
    );
  }

  // Obtém a localização atual e abre a rota até o endereço pesquisado.
  Future<void> _openRoute(AddressModel address) async {
    final destination = [
      address.street,
      address.neighborhood,
      address.city,
      address.state,
      address.cep,
    ].where((part) => part.trim().isNotEmpty).join(', ');

    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não há endereço suficiente para traçar a rota.'),
        ),
      );
      return;
    }

    try {
      // Verifica se o serviço de localização está ativado.
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ative a localização do dispositivo para continuar.',
              ),
            ),
          );
        }
        return;
      }

      // Verifica a permissão de localização.
      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (!mounted) return;

      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permissão de localização não concedida.',
            ),
          ),
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'A permissão foi bloqueada. '
              'Ative a localização nas configurações do aplicativo.',
            ),
          ),
        );
        await Geolocator.openAppSettings();
        return;
      }

      // Obtém as coordenadas GPS atuais do dispositivo.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      // Define a localização atual como origem da rota.
      final uri = Uri.https(
        'www.google.com',
        '/maps/dir/',
        {
          'api': '1',
          'origin': '${position.latitude},${position.longitude}',
          'destination': destination,
          'travelmode': 'driving',
        },
      );

      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível abrir o Google Maps.',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao obter localização: $e'),
          ),
        );
      }
    }
  }

  void _openHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const HistoryPage(),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
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
                onPressed: () => _openRoute(address),
                icon: const Icon(Icons.directions),
                label: const Text('Traçar rota no Google Maps'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FastLocation'),
        actions: [
          IconButton(
            tooltip: 'Histórico de pesquisas',
            icon: const Icon(Icons.history),
            onPressed: _openHistory,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encontre um endereço',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pesquise rapidamente informações de localização.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 25),

            const Text(
              'Pesquisar pelo CEP',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              maxLength: 9,
              decoration: const InputDecoration(
                labelText: 'Digite o CEP',
                hintText: 'Ex.: 89010025',
                prefixIcon: Icon(Icons.location_on),
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _searchByCep,
                icon: const Icon(Icons.search),
                label: const Text('Buscar CEP'),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            const Text(
              'Pesquisar pelo endereço',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _stateController,
              maxLength: 2,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Estado (UF)',
                hintText: 'Ex.: SC',
                counterText: '',
                prefixIcon: Icon(Icons.map),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Cidade',
                hintText: 'Ex.: Blumenau',
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _streetController,
              decoration: const InputDecoration(
                labelText: 'Logradouro',
                hintText: 'Ex.: Rua XV de Novembro',
                prefixIcon: Icon(Icons.signpost),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _searchByAddress,
                icon: const Icon(Icons.search),
                label: const Text('Buscar endereço'),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            const Text(
              'Resultados da pesquisa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Observer(
              builder: (_) {
                if (_controller.isLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (_controller.errorMessage != null) {
                  return Text(
                    _controller.errorMessage!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }

                if (_controller.results.isEmpty) {
                  return const Text(
                    'Nenhuma pesquisa realizada ainda.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  );
                }

                return Column(
                  children: _controller.results
                      .map(_buildAddressCard)
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
