import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [
    Center(child: Text('Home Page')),
    Center(child: Text('Categories Page')),
    Center(child: Text('Deals Page')),
    Center(child: Text('Cart Page')),
    Center(child: Text('Profile Page')),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'Search here',
            filled: true,
            fillColor: Colors.grey.shade300,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer( // Added side drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text('Deals'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Cart'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200.0,
              color: Colors.red,
              child: PageView(
                children: [
                  Image.network('https://via.placeholder.com/350x150', fit: BoxFit.cover),
                  Image.network('https://via.placeholder.com/350x150', fit: BoxFit.cover),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text(
                    'KYC Pending',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'You need to provide the required documents for your account activation.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Click Here',
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Category section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildCategoryIcon(Icons.phone_android, 'Mobile'),
                  buildCategoryIcon(Icons.laptop, 'Laptop'),
                  buildCategoryIcon(Icons.camera_alt, 'Camera'),
                  buildCategoryIcon(Icons.lightbulb_outline, 'LED'),
                ],
              ),
            ),

            // Exclusive Section
            Container(
              color: Colors.blue.shade50,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXCLUSIVE FOR YOU',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildProductCard('https://via.placeholder.com/100', '32% OFF'),
                        buildProductCard('https://via.placeholder.com/100', '14% OFF'),
                        buildProductCard('https://via.placeholder.com/100', '20% OFF'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Custom Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Deals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Helper method
  Widget buildCategoryIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade300,
          child: Icon(icon, color: Colors.black),
        ),
        SizedBox(height: 4.0),
        Text(label),
      ],
    );
  }

  // Helper method for product card
  Widget buildProductCard(String imageUrl, String discount) {
    return Container(
      margin: EdgeInsets.only(right: 16.0),
      child: Stack(
        children: [
          Image.network(imageUrl, width: 100, height: 100),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4.0),
              color: Colors.green,
              child: Text(
                discount,
                style: TextStyle(color: Colors.white),
              )))]));
  }
}
