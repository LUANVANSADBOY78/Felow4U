import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart';
import 'create_new_trip.dart';
import 'trip_detail.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  int _selectedTab = 0; // 0: Current, 1: Next, 2: Past, 3: Wish List
  final List<String> _tabs = [
    'Current Trips',
    'Next Trips',
    'Past Trips',
    'Wish List',
  ];

  bool _isLoading = true;
  Map<String, dynamic>? _myTripsData;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    final data = await ApiService.getMyTrips();
    setState(() {
      _myTripsData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : RefreshIndicator(
                    onRefresh: _loadTrips,
                    color: primaryColor,
                    child: _buildListContent(),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateNewTripScreen(),
            ),
          );
          if (result == true) {
            _loadTrips();
          }
        },
        backgroundColor: primaryColor,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        Image.network(
          'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=1000&q=80', // Golden Bridge
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 160,
          color: Colors.black.withOpacity(0.3),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Trips',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            bool isActive = _selectedTab == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: isActive ? Colors.white : hintColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildListContent() {
    if (_myTripsData == null) {
      return const Center(child: Text('Failed to load trips'));
    }

    if (_selectedTab == 0) {
      final current = _myTripsData!['current'] as List? ?? [];
      return current.isEmpty
          ? const Center(child: Text('No current trips'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: current.length,
              itemBuilder: (context, index) {
                final trip = current[index];
                return _buildTripCard(
                  title: trip['title'],
                  date: trip['date'],
                  time: trip['time'],
                  guideName: trip['guideName'],
                  location: trip['location'],
                  imgUrl: trip['image'],
                  avatars: List<String>.from(trip['avatars'] ?? []),
                  badge: _buildBadge(
                    trip['status'],
                    color: Colors.black.withOpacity(0.6),
                    icon: Icons.check,
                  ),
                  buttons: [
                    _buildOutlineButton(
                      'Detail',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetailScreen(tripData: trip),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
    } else if (_selectedTab == 1) {
      final next = _myTripsData!['next'] as List? ?? [];
      return next.isEmpty
          ? const Center(child: Text('No upcoming trips'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: next.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final trip = next[index];
                final status = trip['status'];
                return _buildTripCard(
                  title: trip['title'],
                  date: trip['date'],
                  time: trip['time'],
                  guideName: trip['guideName'],
                  location: trip['location'],
                  imgUrl: trip['image'],
                  avatars: List<String>.from(trip['avatars'] ?? []),
                  extraAvatars: trip['extraAvatars'] ?? 0,
                  badge: _buildBadge(
                    status,
                    color: status == 'Bidding' ? Colors.orange : Colors.blue,
                  ),
                  buttons: [
                    _buildOutlineButton(
                      'Detail',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetailScreen(tripData: trip),
                        ),
                      ),
                    ),
                    if (status == 'Pay') _buildOutlineButton('Chat'),
                    if (status == 'Pay') _buildFilledButton('Pay'),
                    if (status == 'Bidding') _buildOutlineButton('Chat'),
                  ],
                );
              },
            );
    } else if (_selectedTab == 2) {
      final past = _myTripsData!['past'] as List? ?? [];
      return past.isEmpty
          ? const Center(child: Text('No past trips'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: past.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final trip = past[index];
                return _buildTripCard(
                  title: trip['title'],
                  date: trip['date'],
                  time: trip['time'],
                  guideName: trip['guideName'],
                  location: trip['location'],
                  imgUrl: trip['image'],
                  avatars: List<String>.from(trip['avatars'] ?? []),
                  buttons: [
                    _buildOutlineButton(
                      'Detail',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetailScreen(tripData: trip),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
    } else {
      final wishlist = _myTripsData!['wishlist'] as List? ?? [];
      return wishlist.isEmpty
          ? const Center(child: Text('Wish list is empty'))
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: wishlist.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final item = wishlist[index];
                return _buildWishListCard(
                  item['title'],
                  item['price'],
                  item['image'],
                );
              },
            );
    }
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _buildTripCard({
    required String title,
    required String date,
    required String time,
    required String guideName,
    required String location,
    required String imgUrl,
    List<String> avatars = const [],
    int extraAvatars = 0,
    bool isPlaceholderAvatar = false,
    Widget? badge,
    required List<Widget> buttons,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Image.network(
                  imgUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 15,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null) Positioned(top: 10, left: 15, child: badge),
              Positioned(
                bottom: -20,
                right: 15,
                child: _buildAvatarStack(
                  avatars,
                  extraAvatars,
                  isPlaceholderAvatar,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 25,
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.calendar_today, date),
                const SizedBox(height: 5),
                _buildInfoRow(Icons.access_time, time),
                const SizedBox(height: 5),
                _buildInfoRow(
                  isPlaceholderAvatar
                      ? Icons.person_add_alt_1
                      : Icons.person_outline,
                  guideName,
                  color: isPlaceholderAvatar ? textColor : hintColor,
                  isBold: isPlaceholderAvatar,
                ),
                if (buttons.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFEEEEEE), height: 1),
                  ),
                  Row(
                    children: buttons
                        .map(
                          (btn) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: btn,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarStack(
    List<String> urls,
    int extraCount,
    bool isPlaceholder,
  ) {
    if (isPlaceholder) {
      return CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: Icon(Icons.person_outline, color: primaryColor, size: 30),
        ),
      );
    }
    List<Widget> stackChildren = [];
    double rightPos = 0;
    if (extraCount > 0) {
      stackChildren.add(
        Positioned(
          right: rightPos,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: primaryColor,
              child: Text(
                '+$extraCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
      rightPos += 30;
    }
    for (int i = urls.length - 1; i >= 0; i--) {
      stackChildren.add(
        Positioned(
          right: rightPos,
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(urls[i]),
            ),
          ),
        ),
      );
      rightPos += 30;
    }
    return SizedBox(
      width: rightPos + 22,
      height: 52,
      child: Stack(clipBehavior: Clip.none, children: stackChildren),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text, {
    Color color = hintColor,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, {required Color color, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineButton(String text, {VoidCallback? onTap}) {
    return OutlinedButton(
      onPressed: onTap ?? () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: primaryColor, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text == 'Detail')
            const Icon(Icons.info_outline, size: 14, color: primaryColor),
          if (text == 'Chat')
            const Icon(
              Icons.chat_bubble_outline,
              size: 14,
              color: primaryColor,
            ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledButton(String text, {VoidCallback? onTap}) {
    return ElevatedButton(
      onPressed: onTap ?? () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text == 'Pay')
            const Icon(Icons.payment, size: 14, color: Colors.white),
          if (text == 'Pay') const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishListCard(String title, String price, String imgUrl) {
    return Container(
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
          Stack(
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
              Positioned(
                top: 10,
                right: 10,
                child: const Icon(
                  Icons.bookmark,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 15,
                child: Row(
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '1247 likes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        Icon(Icons.calendar_today, size: 12, color: hintColor),
                        SizedBox(width: 5),
                        Text(
                          'Jan 30, 2020',
                          style: TextStyle(fontSize: 12, color: hintColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: const [
                        Icon(Icons.access_time, size: 12, color: hintColor),
                        SizedBox(width: 5),
                        Text(
                          '3 days',
                          style: TextStyle(fontSize: 12, color: hintColor),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.favorite, color: primaryColor, size: 20),
                    const SizedBox(height: 10),
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
    );
  }
}
