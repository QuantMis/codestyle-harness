// Composite reference — 3 files, marked by headers. Not a single compilable unit.

// =====================================================================
// features/authentication/logic/providers/auth_view_model.dart
// =====================================================================
import 'package:flutter/foundation.dart'; // ChangeNotifier — NOT material

import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';

// Async status surfaced explicitly, so the UI can render each state.
enum AuthStatus { idle, loading, success, error }

/// State class: ChangeNotifier subclass, named *ViewModel.
/// No BuildContext, no widgets, no material imports. Depends on data/, not presentation/.
class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repository);

  final AuthRepository _repository;

  // Private state — UI never sees mutable fields.
  User? _user;
  AuthStatus _status = AuthStatus.idle;
  String? _errorMessage;

  // Read-only getters.
  User? get user => _user;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Mutate only via public methods; every path ends with notifyListeners().
  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.login(email, password);
      _status = AuthStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    _status = AuthStatus.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    // Release owned controllers / streams / subscriptions here.
    super.dispose();
  }
}

// =====================================================================
// app.dart — only app-wide, app-lifetime view-models at the root.
// =====================================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Global state only — feature-local VMs are registered per feature.
        ChangeNotifierProvider(create: (_) => SessionViewModel()),
      ],
      child: MaterialApp(/* routerConfig / home … */),
    );
  }
}

// =====================================================================
// features/authentication/presentation/screens/login_screen.dart
// =====================================================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../logic/providers/auth_view_model.dart';

// Feature-scoped registration: the VM lives only above this subtree.
class LoginRoute extends StatelessWidget {
  const LoginRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthViewModel(context.read<AuthRepository>()),
      child: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Column(
        children: [
          // Selector — rebuilds ONLY when `status` changes, not on every notify.
          Selector<AuthViewModel, AuthStatus>(
            selector: (_, vm) => vm.status,
            builder: (context, status, _) {
              return status == AuthStatus.loading
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink();
            },
          ),

          // Consumer — subtree that reacts to the error message.
          Consumer<AuthViewModel>(
            builder: (context, vm, child) {
              if (vm.status == AuthStatus.error) {
                return Text(vm.errorMessage ?? 'Login failed');
              }
              return child!;
            },
            child: const SizedBox.shrink(),
          ),

          ElevatedButton(
            // Action → context.read (no rebuild). Never watch/Consumer to call a method.
            onPressed: () =>
                context.read<AuthViewModel>().login('user@example.com', 'secret'),
            child: const Text('Log in'),
          ),
        ],
      ),
    );
  }
}
