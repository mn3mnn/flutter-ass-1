import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  final int id;
  final String name;
  final String address;

  Store({required this.id, required this.name, required this.address});
}

class StoreListPage extends StatefulWidget {
  const StoreListPage({Key? key}) : super(key: key);

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

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      // Profile tab
      Navigator.pushNamed(context, '/profile');
    } else if (index == 2) {
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
