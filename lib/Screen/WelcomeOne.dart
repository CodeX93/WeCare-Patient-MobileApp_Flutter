import 'package:flutter/material.dart';

import 'Login.dart';
class WelcomeOne extends StatefulWidget {
  const WelcomeOne({Key? key}) : super(key: key);

  @override
  _WelcomeOneState createState() => _WelcomeOneState();
}

class _WelcomeOneState extends State<WelcomeOne> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _imagePaths = [
    "assets/images/welcome1.png",
    "assets/images/welcome2.png",
    "assets/images/welcome3.png",
    // Add more image paths as required
  ];

  // Add a list of corresponding texts for each image
  final List<String> _imageTexts = [
    "The Most advanced EMR System of Pakistan",

    "WeCare cares for you for everything you need in your Health",
    "Manage your appointments, medication, health vitals and much more",

    // Add more texts as required
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            // The PageView takes up the maximum vertical space available
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        _imagePaths[index],
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Show text only when the current page index matches the image index
                    if (_currentPage == index)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _imageTexts[index],
                          style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _imagePaths.length,
                  (index) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor:
                  _currentPage == index ? Colors.blue : Colors.blue[200],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('GET STARTED'),
            ),
          ),
        ],
      ),
    );
  }
}
