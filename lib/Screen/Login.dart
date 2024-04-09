import 'package:flutter/material.dart';
import 'package:wecare_patient_mobile/Functions/Firebase/AuthReg.dart';
import 'package:wecare_patient_mobile/Screen/SignUp.dart';

import '../Functions/Firebase/AuthServices.dart';
import 'ScreenLayout.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  FirebaseService firebaseService=FirebaseService();
 // Add this line
  @override
  Widget build(BuildContext context) {
    // Replace 'assets/illustration.svg' with your actual illustration file path
    String illustrationPath = 'assets/images/welcome1.png';

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 60), // Adjust the space as per your design
              Image.asset(illustrationPath, height: 200), // Set a height for the illustration
              const SizedBox(height: 40), // Adjust the space as per your design
              const Text(
                'WELCOME!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: const InputDecoration(

                  labelText: 'Email',
                  hintText: 'Enter email',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    AuthService authService = AuthService();
                    if(emailController.text.isNotEmpty) {
                      String result = await authService.sendPasswordResetEmail(
                          email: emailController.text);
                      const SnackBar(content: Text('Reset Link has been sent to your provided mail'));
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please Enter the email')),
                      );
                    }

                  },
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading // Check if it's loading
                  ? const CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                onPressed: () async {
                  setState(() => _isLoading = true); // Start loading


                  String result = await firebaseService.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);


                  // After login process is done, stop loading and navigate

                  setState(() => _isLoading = false);
                  if(result=='Login Success'){
                  Navigator.pushReplacement( // Use pushReplacement to replace the login screen
                    context,
                    MaterialPageRoute(builder: (context) => const ScreenLayout()),
                  );}else{ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result)),
                  );}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('LOGIN'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const SignUpScreen()), // Push the LoginScreen onto the stack
                  );
                },
                child: const Text('Don\'t have an account? Sign Up'),
              ),
              const SizedBox(height: 20),
              const Row(
                children: <Widget>[
                  Expanded(child: Divider(thickness: 2)),
                  SizedBox(width: 10),
                  Text('or login with'),
                  SizedBox(width: 10),
                  Expanded(child: Divider(thickness: 2)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    // Replace with your assets for Google and Facebook icons
                    icon: const Icon(Icons.g_mobiledata_outlined),
                    onPressed: () {
                      // Handle Google login
                    },
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.facebook_outlined),
                    onPressed: () {
                      // Handle Facebook login
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
