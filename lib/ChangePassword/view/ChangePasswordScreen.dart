import 'package:debs_driver_app/ChangePassword/controller/ChangePasswordController.dart';
import 'package:debs_driver_app/ChangePassword/model/ChangePasswordRequest.dart';
import 'package:debs_driver_app/Utils/color.dart';
import 'package:flutter/material.dart';

class Changepasswordscreen extends StatefulWidget {
  const Changepasswordscreen({super.key});

  @override
  State<Changepasswordscreen> createState() => _ChangepasswordscreenState();
}

class _ChangepasswordscreenState extends State<Changepasswordscreen> {
  final TextEditingController _oldPswdController = TextEditingController();
  final TextEditingController _newPswdController = TextEditingController();
  final TextEditingController _confirmPswdController = TextEditingController();

  // Boolean logic for password visibility toggles
  bool _oldPswdVisible = false;
  bool _newPswdVisible = false;
  bool _confirmPswdVisible = false;
  bool isloading = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ColorTheme().colorPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Matches @dimen/size
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10), // Matches guideline3 (10dp)

              // Old Password Field
              _buildPasswordField(
                controller: _oldPswdController,
                label: "Old Password",
                isVisible: _oldPswdVisible,
                onToggle: () =>
                    setState(() => _oldPswdVisible = !_oldPswdVisible),
              ),

              const SizedBox(height: 16), // Matches layout_margin

              // New Password Field
              _buildPasswordField(
                controller: _newPswdController,
                label: "New Password",
                isVisible: _newPswdVisible,
                onToggle: () =>
                    setState(() => _newPswdVisible = !_newPswdVisible),
              ),

              const SizedBox(height: 16),

              // Confirm Password Field
              _buildPasswordField(
                controller: _confirmPswdController,
                label: "Confirm New Password",
                isVisible: _confirmPswdVisible,
                onToggle: () =>
                    setState(() => _confirmPswdVisible = !_confirmPswdVisible),
              ),

              const SizedBox(height: 16),

              // Change Button
              SizedBox(
                height: 60, // Matches android:layout_height="60dp"
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        ColorTheme().colorPrimary, // Matches colorPrimary
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          5), // Matches cornerRadius="05dp"
                    ),
                  ),
                  onPressed: isloading
                      ? null
                      : () {
                          // 1. Basic Client-side Validation
                          if (_oldPswdController.text.isEmpty ||
                              _newPswdController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please fill in all fields')),
                            );
                            return;
                          }

                          if (_newPswdController.text !=
                              _confirmPswdController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('New passwords do not match!')),
                            );
                            return;
                          }

                          // 2. Prepare Request
                          ChangePasswordRequest request =
                              ChangePasswordRequest();
                          request.currentPassword = _oldPswdController.text;
                          request.newPassword = _newPswdController.text;
                          request.confirmPassword = _confirmPswdController.text;

                          callChangePasswordApi(request);
                        },
                  // 3. Show Spinner if loading
                  child: isloading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          "Change",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to keep the UI code clean
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(), // Matches OutlinedBox style
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Future<void> callChangePasswordApi(
      ChangePasswordRequest changePasswordRequest) async {
    try {
      setState(() {
        isloading = true;
      });
      final data = await ChangePasswordController()
          .changePassowrdApi(changePasswordRequest);

      if (data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully!')),
        );
_oldPswdController.clear();
  _newPswdController.clear();
  _confirmPswdController.clear();
          setState(() => isloading = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to update password. Please try again.')),
        );
         setState(() => isloading = false);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isloading = false);
      }
    }
  }
}
