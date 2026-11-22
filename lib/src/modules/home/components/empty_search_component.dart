
import 'package:flutter/material.dart';

import '../../../shared/colors/app_colors.dart';

class EmptySearchComponent extends StatelessWidget {
  const EmptySearchComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Nenhuma pesquisa realizada ainda.',
      style: TextStyle(
        color: AppColors.textSecondary,
      ),
    );
  }
}
