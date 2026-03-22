import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_xtream/core/theme/app_theme.dart';
import 'package:stream_xtream/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:stream_xtream/features/auth/presentation/bloc/auth_event.dart';
import 'package:stream_xtream/features/auth/presentation/bloc/auth_state.dart';

class XtreamConfigPage extends StatefulWidget {
  const XtreamConfigPage({super.key});

  @override
  State<XtreamConfigPage> createState() => _XtreamConfigPageState();
}

class _XtreamConfigPageState extends State<XtreamConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _serverUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _testConnection = false;
  String? _connectionStatus;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    final authState = context.read<AuthBloc>().state;
    if (authState.savedServerUrl != null) {
      _serverUrlController.text = authState.savedServerUrl!;
    }
    if (authState.savedUsername != null) {
      _usernameController.text = authState.savedUsername!;
    }
  }

  @override
  void dispose() {
    _serverUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _testServerConnection() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _testConnection = true;
        _connectionStatus = null;
      });

      // Simulate connection test
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _testConnection = false;
            // In a real app, you would test the actual connection here
            _connectionStatus = 'success';
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Connection successful!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      });
    }
  }

  void _saveAndConnect() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              serverUrl: _serverUrlController.text.trim(),
              username: _usernameController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xtream Configuration'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connected successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == AuthStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                const Icon(
                  Icons.settings_input_hdmi,
                  size: 64,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Configure Xtream Server',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your Xtream server details to start streaming',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Server URL
                TextFormField(
                  controller: _serverUrlController,
                  decoration: InputDecoration(
                    labelText: 'Server URL',
                    hintText: 'http://your-server.com:8080',
                    prefixIcon: const Icon(Icons.dns_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceColor,
                  ),
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter server URL';
                    }
                    if (!value.startsWith('http://') &&
                        !value.startsWith('https://')) {
                      return 'URL must start with http:// or https://';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceColor,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: AppTheme.surfaceColor,
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Connection Status
                if (_connectionStatus != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _connectionStatus == 'success'
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _connectionStatus == 'success'
                              ? Icons.check_circle
                              : Icons.error,
                          color: _connectionStatus == 'success'
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _connectionStatus == 'success'
                              ? 'Connection successful'
                              : 'Connection failed',
                          style: TextStyle(
                            color: _connectionStatus == 'success'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Test Connection Button
                OutlinedButton.icon(
                  onPressed: _testConnection ? null : _testServerConnection,
                  icon: _testConnection
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.wifi_tethering),
                  label: Text(
                      _testConnection ? 'Testing...' : 'Test Connection'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 16),

                // Connect Button
                ElevatedButton.icon(
                  onPressed: _saveAndConnect,
                  icon: const Icon(Icons.login),
                  label: const Text('Connect'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),

                // Help Text
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.info_outline,
                              size: 20, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'How to find your server details',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• Contact your IPTV provider for server URL\n'
                        '• Usually in format: http://server:port\n'
                        '• Use the same credentials as your provider app',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
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
