import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart';
import 'guide_detail.dart';
import 'tour_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;
  bool _isSearching = false;
  Map<String, dynamic>? _searchResults;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _hasSearched = false;
          _searchResults = null;
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
      _hasSearched = true;
    });

    final results = await ApiService.search(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
      _searchResults = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            Expanded(
              child: _isSearching
                  ? const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : _hasSearched
                      ? _buildSearchResults()
                      : _buildPopularDestinations(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: textColor),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Where you want to explore',
                  hintStyle: const TextStyle(color: hintColor, fontSize: 14),
                  border: InputBorder.none,
                  suffixIcon: _hasSearched
                      ? IconButton(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: _clearSearch,
                        )
                      : null,
                ),
              ),
            ),
          ),
          if (_hasSearched) ...[
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.tune, color: textColor),
              onPressed: _showFilterBottomSheet,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPopularDestinations() {
    final List<Map<String, dynamic>> popularPlaces = [
      {'label': 'Danang, Vietnam', 'icon': Icons.location_on},
      {'label': 'Ho Chi Minh, Vietnam', 'icon': Icons.location_on},
      {'label': 'Hanoi, Vietnam', 'icon': Icons.location_on},
      {'label': 'Hoi An, Vietnam', 'icon': Icons.location_on},
      {'label': 'Phu Quoc, Vietnam', 'icon': Icons.location_on},
      {'label': 'Bali, Indonesia', 'icon': Icons.location_on},
      {'label': 'Seoul, Korea', 'icon': Icons.location_on},
      {'label': 'Venice, Italy', 'icon': Icons.location_on},
      {'label': 'Thailand', 'icon': Icons.location_on},
      {'label': 'Tuan Tran', 'icon': Icons.person},
      {'label': 'Emmy', 'icon': Icons.person},
      {'label': 'Linh Hana', 'icon': Icons.person},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Popular destinations', style: TextStyle(color: hintColor, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          const Text('Tip: search by city, country, tour name or guide name', style: TextStyle(color: hintColor, fontSize: 11)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: popularPlaces.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
              itemBuilder: (context, index) {
                final place = popularPlaces[index];
                return InkWell(
                  onTap: () {
                    _searchController.text = place['label'];
                    _performSearch(place['label']);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(place['icon'] as IconData, color: primaryColor, size: 16),
                        ),
                        const SizedBox(width: 14),
                        Text(place['label'], style: const TextStyle(color: textColor, fontSize: 15, fontWeight: FontWeight.w500)),
                        const Spacer(),
                        const Icon(Icons.north_west, size: 16, color: hintColor),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final trips = _searchResults?['trips'] as List? ?? [];
    final guides = _searchResults?['guides'] as List? ?? [];

    if (trips.isEmpty && guides.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 70, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('No results found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Text(
              'Try searching: "Vietnam", "Danang", "Beach"\nor a guide name like "Tuan Tran"',
              textAlign: TextAlign.center,
              style: const TextStyle(color: hintColor, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: _clearSearch,
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                side: const BorderSide(color: primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Clear search'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (guides.isNotEmpty) ...[
            _buildSectionHeader('Guides', guides.length),
            const SizedBox(height: 15),
            _buildGuideGrid(guides),
            const SizedBox(height: 30),
          ],
          if (trips.isNotEmpty) ...[
            _buildSectionHeader('Tours', trips.length),
            const SizedBox(height: 15),
            _buildTourList(trips),
            const SizedBox(height: 30),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$title ($count)',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Text(
          'SEE MORE',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildGuideGrid(List guides) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: guides.length,
      itemBuilder: (context, index) {
        final guide = guides[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuideDetailScreen(
                  name: guide['name'],
                  location: guide['location'],
                  avatar: guide['avatar'],
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    guide['avatar'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                guide['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 12, color: primaryColor),
                  Expanded(
                    child: Text(
                      guide['location'],
                      style: const TextStyle(fontSize: 11, color: primaryColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTourList(List trips) {
    return Column(
      children: trips.map((trip) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildTourCard(
            trip['title'],
            trip['price'],
            trip['image'],
            trip['date'] ?? 'Jan 30, 2026',
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTourCard(
    String title,
    String price,
    String imgUrl,
    String date,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TourDetailScreen(title: title, price: price, imgUrl: imgUrl),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imgUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 12,
                              color: hintColor,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: hintColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        price,
                        style: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterBottomSheet(),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int _tabIndex = 0;
  List<String> _selectedLanguages = ['Vietnamese'];

  final List<String> _languages = [
    'Vietnamese',
    'English',
    'Korean',
    'Spanish',
    'French',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Expanded(child: _buildToggleButton(0, 'Guides')),
                Expanded(child: _buildToggleButton(1, 'Tours')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Date",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          TextField(
            decoration: const InputDecoration(
              hintText: 'mm/dd/yy',
              hintStyle: TextStyle(color: hintColor),
              prefixIcon: Icon(
                Icons.calendar_today,
                color: hintColor,
                size: 18,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            "Guide's Language",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _languages.map((lang) {
              final isSelected = _selectedLanguages.contains(lang);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedLanguages.remove(lang);
                    } else {
                      _selectedLanguages.add(lang);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    lang,
                    style: TextStyle(
                      color: isSelected ? Colors.white : textColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 25),
          const Text(
            "Fee",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Text('\$', style: TextStyle(color: hintColor)),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Fee',
                    hintStyle: TextStyle(color: hintColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  '(\$/hour)',
                  style: TextStyle(color: hintColor, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'APPLY FILTERS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildToggleButton(int index, String title) {
    bool isActive = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : textColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
