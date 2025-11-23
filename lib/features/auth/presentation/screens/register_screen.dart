import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/auth/presentation/providers/register_form_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Icon Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (!context.canPop()) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 40, color: Colors.white)),
                const Spacer(flex: 1),
                Text('Crear cuenta',
                    style:
                        textStyles.titleLarge?.copyWith(color: Colors.white)),
                const Spacer(flex: 2),
              ],
            ),

            const SizedBox(height: 50),

            Container(
              height: size.height * 0.75, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _RegisterForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  void showSnackbar(BuildContext context, String message) {
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerFormState = ref.watch(registerFormProvider);
    final textStyles = Theme.of(context).textTheme;
    ref.listen<AuthState>(
        authProvider, (_, next) => showSnackbar(context, next.errorMessage));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Text('Nueva cuenta', style: textStyles.titleMedium),
          const Spacer(flex: 2),
          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.emailAddress,
            errorMessage: registerFormState.fullName.errorMessage,
            onChanged: (value) =>
                ref.read(registerFormProvider.notifier).fullNameChanged(value),
          ),
          const Spacer(),
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            errorMessage: registerFormState.email.errorMessage,
            onChanged: (value) =>
                ref.read(registerFormProvider.notifier).emailChanged(value),
          ),
          const Spacer(),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            errorMessage: registerFormState.password.errorMessage,
            onChanged: (value) =>
                ref.read(registerFormProvider.notifier).passwordChanged(value),
          ),
          const Spacer(),
          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            errorMessage: registerFormState.password.errorMessage,
            onChanged: (value) =>
                ref.read(registerFormProvider.notifier).passwordChanged(value),
          ),
          const Spacer(),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Crear',
                buttonColor: Colors.black,
                onPressed: () =>
                    ref.read(registerFormProvider.notifier).formSubmitted(),
              )),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                  onPressed: () =>
                      ref.read(registerFormProvider.notifier).formPosted(),
                  child: const Text('Ingresa aquí'))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
