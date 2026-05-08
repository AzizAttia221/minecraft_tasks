import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'widgets/minecraft_background.dart';
import 'widgets/minecraft_button.dart';
import 'widgets/minecraft_text_field.dart';
import 'pending_tasks_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = authProvider.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PendingTasksPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid credentials. Please register first.'),
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
                    constraints: const BoxConstraints(maxWidth: 420),
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
                        const Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'monospace',
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        MinecraftTextField(
                          controller: _usernameController,
                          hintText: 'username ...',
                          icon: Icons.person,
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
                          text: 'login',
                          onPressed: _login,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const RegisterPage()),
                            );
                          },
                          child: const Text(
                            'Don\'t have an account? Register',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
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

class CreeperFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final pixelSize = size.width / 8;

    // Eyes
    canvas.drawRect(
      Rect.fromLTWH(pixelSize, pixelSize * 2, pixelSize, pixelSize * 2),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(pixelSize * 5, pixelSize * 2, pixelSize, pixelSize * 2),
      paint,
    );

    // Mouth
    canvas.drawRect(
      Rect.fromLTWH(pixelSize * 3, pixelSize * 4, pixelSize, pixelSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(pixelSize * 2, pixelSize * 5, pixelSize, pixelSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(pixelSize * 4, pixelSize * 5, pixelSize, pixelSize),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(pixelSize * 3, pixelSize * 6, pixelSize, pixelSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}