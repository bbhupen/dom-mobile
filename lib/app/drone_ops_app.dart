import 'package:flutter/material.dart';

import '../core/session/session_store.dart';
import '../features/auth/models/auth_session.dart';
import '../features/auth/screens/auth_screen.dart';
import '../shell/org_shell.dart';
import 'theme.dart';

class DroneOpsApp extends StatefulWidget {
  const DroneOpsApp({super.key});

  @override
  State<DroneOpsApp> createState() => _DroneOpsAppState();
}

class _DroneOpsAppState extends State<DroneOpsApp> {
  final sessionStore = SessionStore();
  AuthSession? session;
  bool isRestoringSession = true;

  @override
  void initState() {
    super.initState();
    restoreSession();
  }

  Future<void> restoreSession() async {
    final storedSession = await sessionStore.load();

    if (!mounted) {
      return;
    }

    setState(() {
      session = storedSession;
      isRestoringSession = false;
    });
  }

  Future<void> setAuthenticatedSession(AuthSession value) async {
    await sessionStore.save(value);

    if (!mounted) {
      return;
    }

    setState(() => session = value);
  }

  Future<void> signOut() async {
    await sessionStore.clear();

    if (!mounted) {
      return;
    }

    setState(() => session = null);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drone Operations',
      theme: buildTheme(),
      home: isRestoringSession
          ? const AppLoadingScreen()
          : session == null
          ? AuthScreen(onAuthenticated: setAuthenticatedSession)
          : OrgShell(session: session!, onSignOut: signOut),
    );
  }
}

class AppLoadingScreen extends StatelessWidget {
  const AppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: CircularProgressIndicator())),
    );
  }
}
