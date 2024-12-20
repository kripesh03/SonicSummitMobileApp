import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Text(
          "SonicSummit",
          // style: TextStyle(
          //   color: Colors.purple,
          //   fontSize: 20,
          //   fontWeight: FontWeight.bold,
          // ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8Lbj_SiI5iqUgGryvak6whMkg5Z8_4OMowQ&s'), // Replace with actual URL
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
                    "Aarav Sharma\nTraditional Fusion Artist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Navigation Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.music_note, "Music"),
                  _buildNavItem(Icons.palette, "Art"),
                  _buildNavItem(Icons.shopping_bag, "Merch"),
                  _buildNavItem(Icons.forum, "Forum"),
                ],
              ),

              SizedBox(height: 24),

              // Trending Tracks Section
              const Text(
                "Trending Tracks",
                style: TextStyle(
                  fontFamily: "Montserrat Bold",
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTrendingCard(
                    imageUrl:
                        'https://lastfm.freetls.fastly.net/i/u/300x300/1733a968889012d444fb73e3a59e7f72.jpg', // Replace with actual image URL
                    title: "Bimbaaakash",
                    artist: "Bartika Rai",
                    price: "\Rs 4.99",
                  ),
                  _buildTrendingCard(
                    imageUrl:
                        'https://f4.bcbits.com/img/a2306490384_5.jpg', // Replace with actual image URL
                    title: "Atti Bhayo",
                    artist: "Albatross",
                    price: "\Rs 3.99",
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Featured Artists Section
              Text(
                "Featured Artists",
                style: TextStyle(
                  fontFamily: "Montserrat Bold",
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
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
                        'https://media.gettyimages.com/id/537499231/photo/young-nepali-woman-in-traditional-dress-h%C4%81ku-pat%C4%81si-bhaktapur.jpg?s=612x612&w=gi&k=20&c=wHwHYS8YU6WUF1HxjAU-KDSBtsgZEVZbpyShGZZ1smY='), // Replace with actual URL
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
}
