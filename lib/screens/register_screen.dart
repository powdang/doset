import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isRegistering = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _nicknameController.dispose();
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isRegistering = true);

    final error = await _authService.register(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      nickname: _nicknameController.text.trim(),
      userId: _userIdController.text.trim(),
    );

    setState(() => _isRegistering = false);

    if (error == null) {
      if (mounted) {
        Navigator.pop(context); // 회원가입 완료 → 로그인 화면으로 이동
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입 성공')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                validator: (value) =>
                value == null || !value.contains('@') ? '이메일을 입력하세요' : null,
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: '닉네임'),
                validator: (value) =>
                value == null || value.isEmpty ? '닉네임을 입력하세요' : null,
              ),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: '아이디'),
                validator: (value) =>
                value == null || value.isEmpty ? '아이디를 입력하세요' : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '비밀번호'),
                validator: (value) =>
                value == null || value.length < 6 ? '6자 이상 입력하세요' : null,
              ),
              const SizedBox(height: 24),
              _isRegistering
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _register,
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
