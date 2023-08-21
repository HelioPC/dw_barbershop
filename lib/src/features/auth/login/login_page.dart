import 'package:dw_barbershop/src/core/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/helpers/messages.dart';
import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
import 'package:dw_barbershop/src/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginVM(:login) = ref.watch(loginVMProvider.notifier);

    ref.listen(loginVMProvider, (_, state) {
      switch (state) {
        case LoginState(status: LoginStateStatus.initial):
          break;
        case LoginState(status: LoginStateStatus.error, :final errorMessage?):
          Messages.showError(errorMessage, context);
        case LoginState(status: LoginStateStatus.error):
          Messages.showError('Erro durante a autenticação', context);
        case LoginState(status: LoginStateStatus.admLogin):
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home/adm',
            (route) => false,
          );
        case LoginState(status: LoginStateStatus.employeeLogin):
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/home/employee',
            (route) => false,
          );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_image_chair.jpg'),
              fit: BoxFit.cover,
              opacity: .2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/imgLogo.png'),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: emailEC,
                            onTapOutside: (event) {
                              context.unfocus();
                            },
                            validator: Validatorless.multiple([
                              Validatorless.required('Campo obrigatório'),
                              Validatorless.email('Email inválido'),
                            ]),
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              label: Text('Email'),
                              hintText: 'Email',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: passwordEC,
                            onTapOutside: (event) {
                              context.unfocus();
                            },
                            validator: Validatorless.multiple([
                              Validatorless.required('Campo obrigatório'),
                              Validatorless.min(
                                6,
                                'Senha deve conter 6 carateres no mínimo',
                              ),
                            ]),
                            obscureText: true,
                            decoration: const InputDecoration(
                              label: Text('Senha'),
                              hintText: 'Senha',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: TextStyle(color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorsConstants.brown,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                            ),
                            onPressed: () {
                              switch (formKey.currentState?.validate()) {
                                case (false || null):
                                  Messages.showError(
                                    'Campos inválidos',
                                    context,
                                  );
                                  break;
                                case true:
                                  login(emailEC.text, passwordEC.text);
                                  break;
                              }
                            },
                            child: const Text('ACESSAR'),
                          ),
                        ],
                      ),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Criar conta',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
