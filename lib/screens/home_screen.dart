import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService.instance;
  final ApiService _apiService = ApiService();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  bool _isLoading = true;
  bool _isGridView = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);

    try {
      // Check if storage has products
      final count = await _storage.getProductCount();
      
      if (count == 0) {
        // Fetch from API and save to storage (SQLite or Web)
        await _fetchAndSaveProducts();
      } else {
        // Load from storage (SQLite or Web)
        await _loadFromStorage();
      }
    } catch (e) {
      _showError('Error loading products: $e');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _fetchAndSaveProducts() async {
    try {
      final products = await _apiService.fetchProducts();
      
      // Save to storage (will use SQLite on mobile/desktop, localStorage on web)
      await _storage.saveProducts(products);
      
      await _loadFromStorage();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${products.length} products loaded from API!\n${_storage.storageType}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to fetch products from API: $e');
    }
  }

  Future<void> _loadFromStorage() async {
    final products = await _storage.getAllProducts();
    final categories = await _storage.getAllCategories();
    
    setState(() {
      _products = products;
      _filteredProducts = products;
      _categories = ['All', ...categories];
    });
    
    if (mounted && products.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('📦 Loaded ${products.length} products\n${_storage.storageType}'),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _selectedCategory == 'All'
            ? _products
            : _products.where((p) => p.category == _selectedCategory).toList();
      } else {
        _filteredProducts = _products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _searchController.clear();
      
      if (category == 'All') {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products.where((p) => p.category == category).toList();
      }
    });
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _refreshProducts() async {
    await _storage.clearAllProducts();
    await _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping App', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.orange,
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _filterProducts,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterProducts('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => _filterByCategory(category),
                    backgroundColor: Colors.grey[200],
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Product List/Grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                : _filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 100, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : _isGridView
                        ? _buildGridView()
                        : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: _filteredProducts[index],
          onTap: () => _navigateToDetail(_filteredProducts[index]),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return ProductCard(
          product: _filteredProducts[index],
          onTap: () => _navigateToDetail(_filteredProducts[index]),
          isListView: true,
        );
      },
    );
  }

  void _navigateToDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
