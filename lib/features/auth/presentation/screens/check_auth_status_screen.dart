import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckAuthStatusScreen extends ConsumerWidget {
  const CheckAuthStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Solo muestra el loader, la redirección la gestiona el router
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
