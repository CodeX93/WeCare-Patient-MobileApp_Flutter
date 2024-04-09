import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class SymptomsGrid extends StatefulWidget {
  const SymptomsGrid({super.key});

  @override
  _SymptomsGridState createState() => _SymptomsGridState();
}

class _SymptomsGridState extends State<SymptomsGrid> {
  final List<Map<String, String>> symptoms = [
    {'title': 'Cough', 'image': 'assets/images/welcome1.png'},
    {'title': 'Fever', 'image': 'assets/images/welcome1.png'},
    {'title': 'Headache', 'image': 'assets/images/welcome1.png'},
    {'title': 'Fatigue', 'image': 'assets/images/welcome1.png'},
    {'title': 'Sore Throat', 'image': 'assets/images/welcome1.png'},
    {'title': 'Cough', 'image': 'assets/images/welcome1.png'},
    {'title': 'Fever', 'image': 'assets/images/welcome1.png'},
    {'title': 'Headache', 'image': 'assets/images/welcome1.png'},
    {'title': 'Fatigue', 'image': 'assets/images/welcome1.png'},
    {'title': 'Sore Throat', 'image': 'assets/images/welcome1.png'},
    {'title': 'Loss of Taste', 'image': 'assets/images/welcome1.png'},
    {'title': 'Loss of Taste', 'image': 'assets/images/welcome1.png'},
    // Add more symptoms as necessary
  ];

  final int pageSize = 8; // 2 rows * 4 columns
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page! as int;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (symptoms.length / pageSize).ceil();

    _pageController.addListener(() {
      int nextPage = _pageController.page!
          .round(); // This will give you the nearest integer value.
      if (_currentPage != nextPage) {
        // Check if the page index actually changed
        setState(() {
          _currentPage = nextPage;
        });
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Feeling ill?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Let\'s check out what\'s happening?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 200, // Adjust based on your item size
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalPages,
                  itemBuilder: (context, pageIndex) {
                    int startIndex = pageIndex * pageSize;
                    int endIndex = startIndex + pageSize;
                    List<Map<String, String>> pageItems = symptoms.sublist(
                        startIndex,
                        endIndex > symptoms.length
                            ? symptoms.length
                            : endIndex);

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1 / 1,
                      ),
                      itemCount: pageItems.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          child: GridTile(
                            footer: Center(
                                child: Text(pageItems[index]['title']!,
                                    textAlign: TextAlign.center)),
                            child: Image.asset(pageItems[index]['image']!),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Center(
                child: DotsIndicator(
                  dotsCount: totalPages,
                  position: _currentPage,
                  decorator: DotsDecorator(
                    size: const Size.square(9.0),
                    activeSize: const Size(9.0,9.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
