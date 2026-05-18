import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/app_localizations.dart';
import '../services/api_service.dart';
import 'guide_detail.dart';
import 'tour_detail.dart';
import 'search_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with LanguageAware<ExploreScreen> {
  Map<String, dynamic>? _exploreData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await ApiService.getExploreData();
    if (mounted) {
      setState(() {
        _exploreData = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: primaryColor)),
      );
    }

    if (_exploreData == null) {
      return const Scaffold(
        body: Center(child: Text('Failed to load data')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeaderSection(),
              const SizedBox(height: 10),
              _CategoriesSection(categories: _exploreData!['categories'] ?? []),
              _TopJourneysSection(trips: _exploreData!['topJourneys'] ?? []),
              _BestGuidesSection(guides: _exploreData!['topGuides'] ?? []),
              _TopExperiencesSection(
                experiences: _exploreData!['recentExperiences'] ?? [],
              ),
              _FeaturedToursSection(trips: _exploreData!['featuredTours'] ?? []),
              _TravelNewsSection(news: _exploreData!['travelNews'] ?? []),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Header & Thanh tìm kiếm
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 240,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=1200&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Explore',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Da Nang',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.wb_cloudy_outlined, color: Colors.white, size: 20),
                        SizedBox(width: 5),
                        Text(
                          '26°C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -25,
          left: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
            child: Container(
              height: 55,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: hintColor),
                  SizedBox(width: 12),
                  Text(
                    'Hi, where do you want to explore?',
                    style: TextStyle(color: hintColor, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  final List categories;
  const _CategoriesSection({required this.categories});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'beach_access': return Icons.beach_access;
      case 'terrain': return Icons.terrain;
      case 'restaurant': return Icons.restaurant;
      case 'directions_run': return Icons.directions_run;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: const EdgeInsets.only(top: 45),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
            child: Container(
              margin: const EdgeInsets.only(right: 30),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(_getIcon(cat['icon']?.toString() ?? ''), color: primaryColor, size: 28),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cat['name']?.toString() ?? '',
                    style: const TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TopJourneysSection extends StatefulWidget {
  final List trips;
  const _TopJourneysSection({required this.trips});

  @override
  State<_TopJourneysSection> createState() => _TopJourneysSectionState();
}

class _TopJourneysSectionState extends State<_TopJourneysSection> {
  final Set<int> _bookmarked = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Journeys', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
                  child: Text('SEE MORE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 360,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.trips.length,
              itemBuilder: (context, index) {
                final trip = widget.trips[index];
                if (trip is! Map) return const SizedBox();
                return _buildJourneyCard(
                  context, index,
                  trip['title']?.toString() ?? 'No Title',
                  trip['price']?.toString() ?? '\$0.00',
                  trip['image']?.toString() ?? '',
                  trip['duration']?.toString() ?? '3 days',
                  trip['date']?.toString() ?? 'Jan 30, 2026',
                  trip['likes']?.toString() ?? '',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(BuildContext context, int index, String title, String price, String imgUrl, String duration, String date, String likes) {
    final isBookmarked = _bookmarked.contains(index);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TourDetailScreen(title: title, price: price, imgUrl: imgUrl))),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 15, bottom: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imgUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                      'https://images.unsplash.com/photo-1555921015-5532091f6026?w=800&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10, right: 10,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      isBookmarked ? _bookmarked.remove(index) : _bookmarked.add(index);
                    }),
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: Colors.white, size: 24,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      Row(
                        children: List.generate(5, (i) => const Icon(Icons.star, color: Colors.amber, size: 12)),
                      ),
                      if (likes.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Text(likes, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: hintColor),
                      const SizedBox(width: 4),
                      Text(date, style: const TextStyle(fontSize: 12, color: hintColor)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 12, color: hintColor),
                      const SizedBox(width: 4),
                      Text(duration, style: const TextStyle(fontSize: 12, color: hintColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(price, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 17)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _BestGuidesSection extends StatelessWidget {
  final List guides;
  const _BestGuidesSection({required this.guides});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Best Guides', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
                  child: Text('SEE MORE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: guides.length,
              itemBuilder: (context, index) {
                final guide = guides[index];
                if (guide is! Map) return const SizedBox();
                return _buildGuideCard(context, guide['name']?.toString() ?? '', guide['location']?.toString() ?? '', guide['avatar']?.toString() ?? '', guide['reviews']?.toString() ?? '');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(BuildContext context, String name, String location, String imgUrl, String reviews) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GuideDetailScreen(name: name, location: location, avatar: imgUrl))),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imgUrl, 
                    height: 150, 
                    width: double.infinity, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&h=200&fit=crop',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 12)),
                      ),
                      if (reviews.isNotEmpty)
                        Text(reviews, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: primaryColor),
                const SizedBox(width: 2),
                Text(location, style: const TextStyle(fontSize: 12, color: primaryColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopExperiencesSection extends StatelessWidget {
  final List experiences;
  const _TopExperiencesSection({required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Experiences', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
                  child: Text('SEE MORE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 360,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: experiences.length,
              itemBuilder: (context, index) {
                final exp = experiences[index];
                if (exp is! Map) return const SizedBox();
                return _buildExpCard(context, exp['title']?.toString() ?? '', exp['guide']?.toString() ?? '', exp['image']?.toString() ?? '', exp['avatar']?.toString() ?? '', exp['location']?.toString() ?? 'Vietnam');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpCard(BuildContext context, String title, String guideName, String bgImg, String avatarImg, String location) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TourDetailScreen(title: title, price: '\$100.00', imgUrl: bgImg))),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    bgImg, 
                    height: 160, 
                    width: double.infinity, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                      'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?w=800&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(avatarImg), 
                        radius: 22, 
                        backgroundColor: Colors.white,
                        onBackgroundImageError: (e, s) {},
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
                        child: Text(guideName, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: primaryColor, size: 14),
                      const SizedBox(width: 4),
                      Flexible(child: Text(location, style: const TextStyle(color: primaryColor, fontSize: 12), overflow: TextOverflow.ellipsis)),
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
}

class _FeaturedToursSection extends StatefulWidget {
  final List trips;
  const _FeaturedToursSection({required this.trips});

  @override
  State<_FeaturedToursSection> createState() => _FeaturedToursSectionState();
}

class _FeaturedToursSectionState extends State<_FeaturedToursSection> {
  final Set<int> _liked = {};
  final Set<int> _bookmarked = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Featured Tours', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
                child: Text('SEE MORE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...List.generate(widget.trips.length, (index) {
            final trip = widget.trips[index];
            if (trip is! Map) return const SizedBox();
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: _buildFeatureCard(context, index, trip['title']?.toString() ?? '', trip['price']?.toString() ?? '', trip['image']?.toString() ?? '', trip['duration']?.toString() ?? '3 days', trip['date']?.toString() ?? 'Jan 30, 2026', trip['likes']?.toString() ?? '1247 likes'),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, int index, String title, String price, String imgUrl, String duration, String date, String likes) {
    final isLiked = _liked.contains(index);
    final isBookmarked = _bookmarked.contains(index);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TourDetailScreen(title: title, price: price, imgUrl: imgUrl))),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imgUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800&q=80',
                      height: 180, width: double.infinity, fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12, right: 12,
                  child: GestureDetector(
                    onTap: () => setState(() { isBookmarked ? _bookmarked.remove(index) : _bookmarked.add(index); }),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        size: 22, color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12, left: 12,
                  child: Row(
                    children: [
                      Row(children: List.generate(5, (i) => const Icon(Icons.star, color: Colors.amber, size: 16))),
                      const SizedBox(width: 8),
                      Text(likes, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      GestureDetector(
                        onTap: () => setState(() {
                          if (isLiked) {
                            _liked.remove(index);
                          } else {
                            _liked.add(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Added "$title" to favorites!'), duration: const Duration(seconds: 1)),
                            );
                          }
                        }),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey(isLiked),
                            color: isLiked ? Colors.red : primaryColor,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [const Icon(Icons.calendar_today, size: 14, color: hintColor), const SizedBox(width: 6), Text(date, style: const TextStyle(fontSize: 13, color: hintColor))]),
                          const SizedBox(height: 8),
                          Row(children: [const Icon(Icons.access_time, size: 14, color: hintColor), const SizedBox(width: 6), Text(duration, style: const TextStyle(fontSize: 13, color: hintColor))]),
                        ],
                      ),
                      Text(price, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
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
}

class _TravelNewsSection extends StatelessWidget {
  final List news;
  const _TravelNewsSection({required this.news});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Travel News', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
                child: Text('SEE MORE', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...news.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: _buildNewsCard(context, item['title']?.toString() ?? '', item['date']?.toString() ?? '', item['image']?.toString() ?? ''),
              )),
        ],
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, String title, String date, String imgUrl) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchScreen())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontSize: 13, color: hintColor)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imgUrl, 
              height: 160, 
              width: double.infinity, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.network(
                'https://images.unsplash.com/photo-1509030450976-969fb204680d?w=800&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
