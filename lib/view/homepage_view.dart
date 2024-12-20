import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: Colors.grey),
                    hintText: "Search...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Header Section Slider with Dots
              Column(
                children: [
                  Container(
                    height: 200,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      children: [
                        _buildHeaderSliderItem(
                          imageUrl:
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8Lbj_SiI5iqUgGryvak6whMkg5Z8_4OMowQ&s',
                          title: "Aarav Sharma",
                          subtitle: "Traditional Fusion Artist",
                        ),
                        _buildHeaderSliderItem(
                          imageUrl:
                              'https://media.gettyimages.com/id/537499231/photo/young-nepali-woman-in-traditional-dress-h%C4%81ku-pat%C4%81si-bhaktapur.jpg?s=612x612&w=gi&k=20&c=wHwHYS8YU6WUF1HxjAU-KDSBtsgZEVZbpyShGZZ1smY=',
                          title: "Maya Gurung",
                          subtitle: "Melody Innovator",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        height: 8.0,
                        width: _currentPage == index ? 16.0 : 8.0,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.purple
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Navigation Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.music_note, "Music"),
                  _buildNavItem(Icons.palette, "Art"),
                  _buildNavItem(Icons.shopping_bag, "Merch"),
                  _buildNavItem(Icons.event, "Events"),
                ],
              ),

              SizedBox(height: 24),

              // Trending Tracks Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Trending Tracks",
                    style: TextStyle(
                      fontFamily: "Montserrat Bold",
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle "Browse More" click
                    },
                    child: Text(
                      "Browse More",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTrendingCard(
                      imageUrl:
                          'https://lastfm.freetls.fastly.net/i/u/300x300/1733a968889012d444fb73e3a59e7f72.jpg',
                      title: "Bimbaaakash",
                      artist: "Bartika Rai",
                      price: "\Rs 499",
                    ),
                    _buildTrendingCard(
                      imageUrl: 'https://f4.bcbits.com/img/a2306490384_5.jpg',
                      title: "Atti Bhayo",
                      artist: "Albatross",
                      price: "\Rs 399",
                    ),
                    _buildTrendingCard(
                      imageUrl: 'https://f4.bcbits.com/img/a2306490384_5.jpg',
                      title: "Atti Bhayo",
                      artist: "Albatross",
                      price: "\Rs 399",
                    ),
                    _buildTrendingCard(
                      imageUrl: 'https://f4.bcbits.com/img/a2306490384_5.jpg',
                      title: "Atti Bhayo",
                      artist: "Albatross",
                      price: "\Rs 399",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // New Releases Section
              Text(
                "New Releases",
                style: TextStyle(
                  fontFamily: "Montserrat Bold",
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTrendingCard(
                      imageUrl: 'https://f4.bcbits.com/img/a2306490384_5.jpg',
                      title: "Atti Bhayo",
                      artist: "Albatross",
                      price: "\Rs 399",
                    ),
                    _buildTrendingCard(
                      imageUrl: 'https://f4.bcbits.com/img/a2306490384_5.jpg',
                      title: "Atti Bhayo",
                      artist: "Albatross",
                      price: "\Rs 399",
                    ),
                    _buildTrendingCard(
                      imageUrl: 'https://f4.bcbits.com/img/a2306490384_5.jpg',
                      title: "Atti Bhayo",
                      artist: "Albatross",
                      price: "\Rs 399",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Artist Spotlight Section
              Text(
                "Artist Spotlight",
                style: TextStyle(
                  fontFamily: "Montserrat Bold",
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://media.gettyimages.com/id/537499231/photo/young-nepali-woman-in-traditional-dress-h%C4%81ku-pat%C4%81si-bhaktapur.jpg?s=612x612&w=gi&k=20&c=wHwHYS8YU6WUF1HxjAU-KDSBtsgZEVZbpyShGZZ1smY='),
                  ),
                  title: Text(
                    "Maya Gurung",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Blending traditional Nepalese melodies with modern arrangements. Latest album \"Valley Dreams\" out now.",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: TextButton(
                    onPressed: () {},
                    child: Text(
                      "View Profile",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.purple.withOpacity(0.2),
          child: Icon(icon, color: Colors.purple),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildTrendingCard({
    required String imageUrl,
    required String title,
    required String artist,
    required String price,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    artist,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSliderItem({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.black54,
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Text(
          "$title\n$subtitle",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
