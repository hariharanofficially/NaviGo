import 'package:EquineApp/app/route/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/signin_bloc.dart';
import '../../../utils/constants/appreance_definition.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state is SigninForgotPasswordSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Reset password link sent. Please check your email.'),
              backgroundColor: Colors.green,
            ),
          );
          context.goNamed(RoutePath.signin);
        } else if (state is SigninFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? 'Failed to send reset link.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (BuildContext context, SigninState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Forgot Password'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        fontSize: getTextSize20Value(buttonTextSize),
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w100,
                        color: const Color(0xFF8B48DF),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<SigninBloc>().add(
                              SigninForgotPasswordEvent(
                                  email: emailController.text),
                            );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: state is SigninSubmittingState
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Send Reset Link'),
                  ),
                  if (state is SigninSubmittingState)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
