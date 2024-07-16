import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_logic/loginProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                loginProvider.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          loginProvider.login(email, password, context);
                        },
                        child: Text('Login'),
                      ),
                // if (loginProvider.message != null)
                //   Text(
                //     loginProvider.message!,
                //     style: TextStyle(color: Colors.red),
                //   ),
              ],
            ),
          ),
        );
      },
    );
  }
}
