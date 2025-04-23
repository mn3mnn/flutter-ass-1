import 'package:flutter/material.dart';

class StoreProvider with ChangeNotifier {
  Set<int> _favoriteStoreIds = {};

  Set<int> get favoriteStoreIds => _favoriteStoreIds;

  void toggleFavorite(int storeId) {
    if (_favoriteStoreIds.contains(storeId)) {
      _favoriteStoreIds.remove(storeId);
    } else {
      _favoriteStoreIds.add(storeId);
    }
    notifyListeners();
  }

  void setFavorites(Set<int> favorites) {
    _favoriteStoreIds = favorites;
    notifyListeners();
  }
}
