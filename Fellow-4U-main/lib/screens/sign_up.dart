import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/widgets.dart';
import '../services/api_service.dart';
import '../core/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with LanguageAware<SignUpScreen> {
  int _roleValue = 0; // 0: Traveler, 1: Guide
  
  // Controllers for text fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    // Validate inputs
    if (_firstNameController.text.trim().isEmpty) {
      _showError('Please enter your first name');
      return;
    }
    if (_lastNameController.text.trim().isEmpty) {
      _showError('Please enter your last name');
      return;
    }
    if (_countryController.text.trim().isEmpty) {
      _showError('Please enter your country');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (!_emailController.text.contains('@')) {
      _showError('Please enter a valid email');
      return;
    }
    if (_passwordController.text.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'country': _countryController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
        'role': _roleValue == 0 ? 'Traveler' : 'Guide',
      };

      final success = await ApiService.signUp(userData);

      setState(() => _isLoading = false);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        _showError('Failed to create account. Please try again.');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('An error occurred. Please try again.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CurvedHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('sign_up'),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Radio Buttons
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        groupValue: _roleValue,
                        activeColor: primaryColor,
                        onChanged: (val) =>
                            setState(() => _roleValue = val as int),
                      ),
                      const Text(
                        'Traveler',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: 1,
                        groupValue: _roleValue,
                        activeColor: primaryColor,
                        onChanged: (val) =>
                            setState(() => _roleValue = val as int),
                      ),
                      const Text(
                        'Guide',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          labelText: 'First Name',
                          hintText: 'Yoo',
                          controller: _firstNameController,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: CustomTextField(
                          labelText: 'Last Name',
                          hintText: 'Jin',
                          controller: _lastNameController,
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    labelText: 'Country',
                    hintText: 'Country',
                    controller: _countryController,
                  ),
                  CustomTextField(
                    labelText: 'Email',
                    hintText: 'Type email',
                    controller: _emailController,
                  ),
                  CustomTextField(
                    labelText: 'Password',
                    hintText: 'Type password',
                    isPassword: true,
                    helperText: 'Password has more than 6 letters',
                    controller: _passwordController,
                  ),
                  CustomTextField(
                    labelText: 'Confirm Password',
                    hintText: '••••••',
                    isPassword: true,
                    controller: _confirmPasswordController,
                  ),

                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: context.tr('terms_conditions'),
                        style: const TextStyle(color: hintColor, fontSize: 11),
                        children: const [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : PrimaryButton(text: context.tr('sign_up'), onPressed: _signUp),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.tr('have_account'),
                        style: const TextStyle(color: hintColor, fontSize: 13),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          context.tr('sign_in'),
                          style: const TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
