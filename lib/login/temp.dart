import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    // Using the same blue from the "Order Details" screen
    const Color primaryBlue = Color(0xFF2D63FF);
    const Color scaffoldBg = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. Delivery-Themed Header
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: const Icon(Icons.delivery_dining_rounded,
                      color: primaryBlue, size: 50),
                ),
                const SizedBox(height: 32),

                // 2. Consistent Typography
                const Text(
                  "Driver Portal",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B), // Dark slate
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your credentials to start delivering",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                ),
                const SizedBox(height: 40),

                // 3. Elegant Input Fields (Matching the Order Cards)
                _buildModernTextField(
                  controller: _usernameController,
                  label: "Username",
                  icon: Icons.person_2_outlined,
                  validator: (value) => value == null || value.isEmpty ? "Enter username" : null,
                ),
                const SizedBox(height: 20),

                _buildModernTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onSuffixTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  validator: (value) => value == null || value.isEmpty ? "Enter password" : null,
                ),

                const SizedBox(height: 12),

                // 4. Subtle Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Forgot Password?",
                        style: TextStyle(color: primaryBlue.withOpacity(0.8), fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),

                // 5. High-Gloss Action Button (Matching "Pick Up" Button)
                _buildLoginButton(primaryBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.blueGrey, fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF2D63FF), size: 22),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
            onPressed: onSuffixTap,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildLoginButton(Color color) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFF2D63FF), Color(0xFF003CC5)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _loading ? null : () => _login(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: _loading
            ? const SizedBox(height: 24, width: 24,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : const Text(
          "LOGIN TO SHIFT",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      // Your existing Logic for OneSignal & API here...
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _loading = false);
    }
  }
}