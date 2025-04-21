import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ass1/database/database_helper.dart';
import 'package:ass1/pages/profile_page.dart';

class Store {
  final int id;
  final String name;
  final String address;

  Store({required this.id, required this.name, required this.address});
}

class StoreListPage extends StatefulWidget {
  const StoreListPage({super.key});

  @override
  State<StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  List<Store> allStores = [
    Store(id: 1, name: "Town Team", address: "12 Haram St."),
    Store(id: 2, name: "Wahmy", address: "88 Doki St"),
    Store(id: 3, name: "Blbn ", address: "345 October St."),
    Store(id: 4, name: "H&M", address: "22 Haram St."),
  ];

  



  Set<int> favoriteStoreIds = {};

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedIds = prefs.getStringList('favorite_stores');
    if (savedIds != null) {
      setState(() {
        favoriteStoreIds = savedIds.map((id) => int.parse(id)).toSet();
      });
    }
  }

  Future<void> toggleFavorite(int storeId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteStoreIds.contains(storeId)) {
        favoriteStoreIds.remove(storeId);
      } else {
        favoriteStoreIds.add(storeId);
      }
    });
    await prefs.setStringList(
      'favorite_stores',
      favoriteStoreIds.map((id) => id.toString()).toList(),
    );
  }

  void onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });

    // DatabaseHelper dbHelper = DatabaseHelper();
    // final prefs = await SharedPreferences.getInstance();
    // final email = prefs.getString('loggedInEmail'); // Retrieve logged-in email
    // if (email != null) {
    //   final userData = await dbHelper.getUserByEmail(email);
    //   if (userData != null) {
    //     Navigator.pushReplacementNamed(
    //       context,
    //       '/profile',
    //       arguments: userData,
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('User data not found')),
    //     );
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('No user is logged in')),
    //   );
    // }

    // final userData = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    //   if (userData != null) {
    //     Navigator.pushReplacementNamed(
    //       context,
    //       '/profile',
    //       arguments: userData,
    //     );
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('User data not found')),
    //     );
    //   }



    if (index == 0) {
      // Profile tab
      DatabaseHelper dbHelper = DatabaseHelper();
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('loggedInEmail'); // Retrieve logged-in email
    if (email != null) {
      final userData = await dbHelper.getUserByEmail(email);
      if (userData != null) {
        Navigator.pushReplacementNamed(
          context,
          '/profile',
          arguments: userData,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user is logged in')),
      );
    }
      
    
    } else if (index == 1) {
      // Stores tab
      Navigator.pushReplacementNamed(context, '/store-list');
    }
    else if (index == 2) {
      // Favorites tab
      Navigator.pushNamed(context, '/favorite-stores');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      appBar: AppBar(
        title: const Text(
          "All Stores",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: allStores.length,
          itemBuilder: (context, index) {
            final store = allStores[index];
            final isFav = favoriteStoreIds.contains(store.id);

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.store, color: Colors.teal),
                ),
                title: Text(
                  store.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  store.address,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => toggleFavorite(store.id),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Stores'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
