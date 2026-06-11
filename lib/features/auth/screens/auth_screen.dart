import 'package:flutter/material.dart';

import '../../../core/api/api_client.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../models/auth_session.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.onAuthenticated});

  final ValueChanged<AuthSession> onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final api = ApiClient();
  final nameController = TextEditingController();
  final emailController = TextEditingController(text: 'admin@droneops.in');
  final passwordController = TextEditingController(text: 'password123');
  final organizationController = TextEditingController();
  bool isLoading = false;
  bool isRegistering = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    organizationController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    setState(() => isLoading = true);

    try {
      final session = isRegistering
          ? await api.signup(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text,
              organizationName: organizationController.text.trim(),
            )
          : await api.login(
              emailController.text.trim(),
              passwordController.text,
            );
      widget.onAuthenticated(session);
    } catch (error) {
      if (!mounted) {
        return;
      }
      showToast(context, error.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void switchMode(bool register) {
    setState(() {
      isRegistering = register;
      if (register) {
        emailController.clear();
        passwordController.clear();
      } else {
        emailController.text = 'admin@droneops.in';
        passwordController.text = 'password123';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'DRONE OPERATIONS',
                        style: TextStyle(
                          color: Color(0xff3f7b62),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isRegistering ? 'Create account' : 'Sign in',
                        style: TextStyle(
                          color: Color(0xff17212b),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isRegistering
                            ? 'Create an organization workspace and start managing drone operations.'
                            : 'Use your organization account to manage requests, missions, pilots, and fleet readiness.',
                        style: TextStyle(
                          color: Color(0xff536170),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(value: false, label: Text('Sign in')),
                          ButtonSegment(
                            value: true,
                            label: Text('Create account'),
                          ),
                        ],
                        selected: {isRegistering},
                        onSelectionChanged: isLoading
                            ? null
                            : (value) => switchMode(value.first),
                      ),
                      const SizedBox(height: 18),
                      if (isRegistering) ...[
                        TextField(
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Full name',
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        onSubmitted: (_) => submit(),
                      ),
                      if (isRegistering) ...[
                        const SizedBox(height: 14),
                        TextField(
                          controller: organizationController,
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            labelText: 'Organization name',
                            helperText: 'Optional',
                          ),
                          onSubmitted: (_) => submit(),
                        ),
                      ],
                      const SizedBox(height: 18),
                      FilledButton(
                        onPressed: isLoading ? null : submit,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          isLoading
                              ? isRegistering
                                    ? 'Creating account...'
                                    : 'Signing in...'
                              : isRegistering
                              ? 'Create account'
                              : 'Sign in',
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        isRegistering
                            ? 'Password must be at least 8 characters.'
                            : 'Demo users: admin@droneops.in or owner@example.com',
                        style: TextStyle(
                          color: Color(0xff6b7886),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
