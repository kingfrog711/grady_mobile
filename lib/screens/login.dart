import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:grady/screens/menu.dart';
import 'package:grady/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  bool _isLoading = false;
  String? _serverStatus;

  // Test server connectivity
  Future<bool> _testServerConnection() async {
    try {
      final url = Uri.parse('http://localhost:8000/json/');
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Server connection test timed out');
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Server connection test failed: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to Grady',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (_serverStatus != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _serverStatus!,
                    style: TextStyle(color: Colors.red[900]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                            _serverStatus = null;
                          });
                          
                          // First, test server connectivity
                          print('Testing server connectivity...');
                          final isServerReachable = await _testServerConnection();
                          
                          if (!isServerReachable) {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                                _serverStatus = 'Server not reachable';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Cannot connect to Django server.\n\nPlease check:\n'
                                    '1. Django server is running (python manage.py runserver)\n'
                                    '2. Server is accessible at http://localhost:8000\n'
                                    '3. Open http://localhost:8000/json/ in browser to verify',
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 8),
                                ),
                              );
                            }
                            return;
                          }
                          
                          try {
                            print('Server is reachable. Attempting login for user: $_username');
                            print('Login URL: http://localhost:8000/auth/login/');
                            
                            // Wrap the login call in a timeout
                            final response = await Future.any([
                              request.login(
                                "http://localhost:8000/auth/login/",
                                {
                                  'username': _username,
                                  'password': _password,
                                },
                              ),
                              Future.delayed(const Duration(seconds: 10)).then((_) {
                                throw TimeoutException('Login request timed out after 10 seconds');
                              }),
                            ]).catchError((error) {
                              print('Login request error: $error');
                              throw error;
                            });

                            // Debug: print response
                            print('Login response received: $response');
                            print('Response type: ${response.runtimeType}');

                            // Handle response
                            if (response != null) {
                              // Check if response is a Map
                              if (response is Map<String, dynamic>) {
                                if (response['status'] == true || response['status'] == 'true') {
                                  // Save username for filtering
                                  if (response['username'] != null) {
                                    await AuthService.saveUsername(response['username']);
                                  }
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(response['message'] ?? 'Login successful!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyHomePage(),
                                      ),
                                    );
                                  }
                                } else {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(response['message'] ?? 'Login failed. Please try again.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              } else {
                                print('Unexpected response type: ${response.runtimeType}');
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Unexpected response format. Please try again.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            } else {
                              print('Response is null');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No response from server. Please check if Django server is running.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } on TimeoutException catch (e) {
                            print('Login timeout: $e');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Connection timeout. Please check if Django server is running at http://localhost:8000'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            }
                          } catch (e, stackTrace) {
                            print('Login error: $e');
                            print('Error type: ${e.runtimeType}');
                            print('Stack trace: $stackTrace');
                            if (mounted) {
                              String errorMessage = 'Error: ';
                              if (e.toString().contains('timeout') || e.toString().contains('Timeout')) {
                                errorMessage = 'Connection timeout. Please check if Django server is running at http://localhost:8000';
                              } else if (e.toString().contains('Failed host lookup') || e.toString().contains('SocketException')) {
                                errorMessage = 'Cannot connect to server. Please check:\n1. Django server is running\n2. Open http://localhost:8000/json/ in browser to verify';
                              } else if (e.toString().contains('Failed to fetch') || e.toString().contains('CORS')) {
                                errorMessage = 'CORS error: Request blocked by browser.\nCheck Django console - request should show 200 status.\nThis might be a CORS header issue.';
                              } else if (e.toString().contains('FormatException')) {
                                errorMessage = 'Invalid response from server. Please check Django server logs.';
                              } else {
                                errorMessage += e.toString();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 8),
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        }
                      },
                      child: const Text('Login'),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

