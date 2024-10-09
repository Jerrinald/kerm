import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flash_event/core/services/auth_services.dart';
import 'package:flutter_flash_event/core/models/user.dart';
import 'package:flutter_flash_event/myAccount/my_account_screen.dart';
import 'package:flutter_flash_event/myAccount/newKid/bloc/new_kid_bloc.dart';

class NewKidScreen extends StatelessWidget {

  static const String routeName = '/register-kid';

  static navigateTo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider<NewKidBloc>(
          create: (_) => NewKidBloc(),
          child: NewKidScreen(),
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  NewKidScreen({Key? key}) : super(key: key);

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Trigger the BLoC event
      context.read<NewKidBloc>().add(
        SubmitFormEvent(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          onSuccess: () {
            // Navigate to MyAccountScreen on success
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyAccountScreen()),
            );
          },
          onError: (errorMessage) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Inscription Enfant',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    _emailController,
                    'Entrez votre email',
                    'Email',
                    validator: _validateEmail,
                  ),
                  _buildTextField(
                    _firstNameController,
                    'Entrez votre prénom',
                    'Prénom',
                    validator: _validateName,
                  ),
                  _buildTextField(
                    _lastNameController,
                    'Entrez votre nom',
                    'Nom',
                    validator: _validateName,
                  ),
                  _buildTextField(
                    _usernameController,
                    'Entrez votre nom d’utilisateur',
                    'Nom d’utilisateur',
                    validator: _validateUsername,
                  ),
                  _buildTextField(
                    _passwordController,
                    'Entrez votre mot de passe',
                    'Mot de passe',
                    isPassword: true,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6058E9),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => _register(context),
                    child: const Text('S\'inscrire'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String hintText,
      String labelText, {
        bool isPassword = false,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre prénom';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre nom d’utilisateur';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    } else if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }
}