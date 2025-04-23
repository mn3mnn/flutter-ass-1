import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';
import '../providers/store_provider.dart';
import '../permissions_helper.dart';

class Store {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class StoreListPage extends StatefulWidget {
  const StoreListPage({super.key});

  @override
  State<StoreListPage> createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  final List<Store> allStores = [
    Store(
      id: 1,
      name: "Town Team",
      address: "12 Haram St.",
      latitude: 29.9765,
      longitude: 31.1313,
    ),
    Store(
      id: 2,
      name: "Wahmy",
      address: "88 Doki St",
      latitude: 30.0444,
      longitude: 31.2357,
    ),
    Store(
      id: 3,
      name: "Blbn",
      address: "345 October St.",
      latitude: 29.9825,
      longitude: 31.2001,
    ),
    Store(
      id: 4,
      name: "H&M",
      address: "22 Haram St.",
      latitude: 29.9765,
      longitude: 31.1313,
    ),
  ];

  int _currentIndex = 1;
  Position? userPosition;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    determinePosition()
        .then((position) {
          setState(() {
            userPosition = position;
          });
        })
        .catchError((e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        });
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedIds = prefs.getStringList('favorite_stores');
    if (savedIds != null) {
      final favoriteIds = savedIds.map((id) => int.parse(id)).toSet();
      Provider.of<StoreProvider>(
        context,
        listen: false,
      ).setFavorites(favoriteIds);
    }
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) /
        1000; // Distance in kilometers
  }

  Future<void> _toggleFavorite(int storeId) async {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    storeProvider.toggleFavorite(storeId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorite_stores',
      storeProvider.favoriteStoreIds.map((id) => id.toString()).toList(),
    );
  }

  void _onTabTapped(int index) async {
    setState(() {
      _currentIndex = index;
    });

    if (index == 0) {
      // Profile tab
      DatabaseHelper dbHelper = DatabaseHelper();
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(
        'loggedInEmail',
      ); // Retrieve logged-in email
      if (email != null) {
        final userData = await dbHelper.getUserByEmail(email);
        if (userData != null) {
          Navigator.pushReplacementNamed(
            context,
            '/profile',
            arguments: userData,
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('User data not found')));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No user is logged in')));
      }
    } else if (index == 1) {
      // Stores tab
      Navigator.pushReplacementNamed(context, '/store-list');
    } else if (index == 2) {
      // Favorites tab
      Navigator.pushNamed(context, '/favorite-stores');
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteStoreIds =
        Provider.of<StoreProvider>(context).favoriteStoreIds;

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
            final distance =
                userPosition != null
                    ? _calculateDistance(
                      userPosition!.latitude,
                      userPosition!.longitude,
                      store.latitude,
                      store.longitude,
                    ).toStringAsFixed(2)
                    : '...';

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
                  '${store.address}\nDistance: $distance km',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(store.id),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
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
