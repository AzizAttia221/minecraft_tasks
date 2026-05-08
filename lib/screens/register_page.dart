import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'widgets/minecraft_background.dart';
import 'widgets/minecraft_button.dart';
import 'widgets/minecraft_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_usernameController.text.isEmpty || 
        _passwordController.text.isEmpty ||
        _fullNameController.text.isEmpty ||
        _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = authProvider.register(
      _usernameController.text,
      _fullNameController.text,
      _emailController.text,
      _phoneController.text,
      _passwordController.text,
    );

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username already exists'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MinecraftBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 460),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.14),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white24, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.35),
                          offset: Offset(4, 4),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'REGISTER',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'monospace',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        MinecraftTextField(
                          controller: _usernameController,
                          hintText: 'username ...',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 16),
                        MinecraftTextField(
                          controller: _fullNameController,
                          hintText: 'full name ...',
                          icon: Icons.badge,
                        ),
                        const SizedBox(height: 16),
                        MinecraftTextField(
                          controller: _emailController,
                          hintText: 'email ...',
                          icon: Icons.email,
                        ),
                        const SizedBox(height: 16),
                        MinecraftTextField(
                          controller: _phoneController,
                          hintText: 'number ...',
                          icon: Icons.phone,
                        ),
                        const SizedBox(height: 16),
                        MinecraftTextField(
                          controller: _passwordController,
                          hintText: 'password ...',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: 28),
                        MinecraftButton(
                          text: 'register',
                          onPressed: _register,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF3DBB4F),
            border: Border.all(color: Colors.black, width: 3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.grid_on, color: Colors.black, size: 32),
        ),
        const SizedBox(width: 14),
        const Text(
          'MINECRAFT TASKS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.8,
          ),
        ),
      ],
    );
  }
}