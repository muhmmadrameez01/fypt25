// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../welcome/network_handler.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    String? token = await storage.read(key: 'auth_token');
    if (token == null) {
      // Navigate to the sign-in page
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }

  String? _validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Old password can't be empty";
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "New password can't be empty";
    }
    return null;
  }

  InputDecoration inputDecoration(String labelText, {IconData? icon}) {
    return InputDecoration(
      hintText: labelText,
      hintStyle: TextStyle(color: Colors.white),
      prefixIcon: icon != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(icon, color: Colors.white, size: 20),
            )
          : null,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String? token = await storage.read(key: 'auth_token');
      if (token != null) {
        print("Auth token: $token");

        Map<String, String> data = {
          "email": _emailController.text,
          "oldPassword": _oldPasswordController.text,
          "newPassword": _newPasswordController.text,
        };

        try {
          var response = await NetworkHandler()
              .updatepassword('/user/update', data, token);
          print("Received response: ${response.statusCode} ${response.body}");

          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Password changed successfully!')));
          } else if (response.statusCode == 401) {
            print("Unauthorized access. Token might be invalid or expired.");
            print(response.body);
            await storage.delete(key: 'auth_token'); // Clear invalid token
          } else if (response.statusCode == 400) {
            print("Bad request. There might be an issue with the data sent.");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Bad request. Please check your input.')));
          } else {
            print(
                "Error changing password: ${response.statusCode} ${response.body}");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Error changing password: ${response.reasonPhrase}')));
          }
        } catch (e) {
          print("Exception occurred: $e");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Exception: $e')));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print("No token found. Please log in again.");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No token found. Please log in again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000428), Color(0xFF004e92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Change Password',
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration:
                                inputDecoration('Email', icon: Icons.email),
                            validator: _validateUsername,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _oldPasswordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: inputDecoration('Old Password',
                                icon: Icons.lock_outline),
                            validator: _validateOldPassword,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white),
                            decoration: inputDecoration('New Password',
                                icon: Icons.lock),
                            validator: _validateNewPassword,
                          ),
                          const SizedBox(height: 16.0),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _changePassword,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text('Save Password'),
                                ),
                          const SizedBox(height: 20),
                        ],
                      ),
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
}
