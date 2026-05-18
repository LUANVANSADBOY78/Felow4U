import 'package:flutter/material.dart';
import '../core/constants.dart';

class TourDetailScreen extends StatefulWidget {
  final String title;
  final String price;
  final String imgUrl;

  const TourDetailScreen({
    super.key,
    required this.title,
    required this.price,
    required this.imgUrl,
  });

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  int _selectedDay = 1;
  bool _isLiked = false;
  bool _isBookmarked = false;
  int _travelers = 1;

  final List<Map<String, dynamic>> _reviews = [
    {'name': 'Yoo Jin', 'avatar': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop', 'rating': 5, 'comment': 'Amazing tour! The guide was very professional and the views were breathtaking.', 'date': 'Jan 15, 2020'},
    {'name': 'Tuan Tran', 'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop', 'rating': 4, 'comment': 'Great experience overall. Would definitely recommend to friends and family.', 'date': 'Jan 20, 2020'},
    {'name': 'Emmy Lee', 'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop', 'rating': 5, 'comment': 'Perfect trip! Everything was well-organized and the scenery was absolutely stunning.', 'date': 'Feb 2, 2020'},
  ];

  double get _totalPrice {
    final base = double.tryParse(widget.price.replaceAll('\$', '').replaceAll(',', '')) ?? 0;
    return base * _travelers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndPrice(),
                  const SizedBox(height: 25),
                  _buildSummaryCard(),
                  const SizedBox(height: 30),
                  _buildTravelersSection(),
                  const SizedBox(height: 30),
                  _buildScheduleSection(),
                  const SizedBox(height: 30),
                  _buildPriceSection(),
                  const SizedBox(height: 30),
                  _buildReviewsSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _showBookingDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('BOOK THIS TOUR', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.imgUrl,
          height: 280,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (ctx, e, s) => Container(
            height: 280,
            color: Colors.grey.shade200,
            child: const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
          ),
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.white),
                      onPressed: () => _showShareModal(context),
                    ),
                    IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          key: ValueKey(_isLiked),
                          color: _isLiked ? Colors.red : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() => _isLiked = !_isLiked);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(_isLiked ? '❤️ Added to favorites!' : 'Removed from favorites'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: _isLiked ? Colors.red : Colors.grey,
                        ));
                      },
                    ),
                    IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          key: ValueKey(_isBookmarked),
                          color: _isBookmarked ? Colors.amber : Colors.white,
                        ),
                      ),
                      onPressed: () {
                        setState(() => _isBookmarked = !_isBookmarked);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(_isBookmarked ? '🔖 Tour saved!' : 'Removed from saved'),
                          duration: const Duration(seconds: 1),
                          backgroundColor: _isBookmarked ? Colors.amber.shade700 : Colors.grey,
                        ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 15, left: 0, right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildDot(true), _buildDot(false), _buildDot(false)],
          ),
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showReviewsDialog,
                child: Row(
                  children: [
                    Row(children: List.generate(5, (i) => const Icon(Icons.star, color: Colors.amber, size: 14))),
                    const SizedBox(width: 8),
                    const Text('145 Reviews', style: TextStyle(color: primaryColor, fontSize: 12, decoration: TextDecoration.underline)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text('Provider    ', style: TextStyle(color: hintColor, fontSize: 13)),
                  Text('dulichviet', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(widget.price, style: const TextStyle(color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('\$450.00', style: TextStyle(color: hintColor, fontSize: 14, decoration: TextDecoration.lineThrough)),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _buildSummaryRow('Itinerary', widget.title),
          const SizedBox(height: 15),
          _buildSummaryRow('Duration', '2 days, 2 nights'),
          const SizedBox(height: 15),
          _buildSummaryRow('Departure Date', 'Feb 12'),
          const SizedBox(height: 15),
          _buildSummaryRow('Departure Place', 'Ho Chi Minh'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: hintColor, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTravelersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Travelers', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              Text('How many people?', style: TextStyle(color: hintColor, fontSize: 12)),
            ],
          ),
          Row(
            children: [
              _counterButton(Icons.remove, () {
                if (_travelers > 1) setState(() => _travelers--);
              }),
              Container(
                width: 45,
                alignment: Alignment.center,
                child: Text('$_travelers', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              _counterButton(Icons.add, () {
                if (_travelers < 10) setState(() => _travelers++);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Icon(Icons.map_outlined, size: 24, color: textColor),
          SizedBox(width: 10),
          Text('Schedule', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 15),
        Row(children: [
          _buildDayTab(1, 'Day 1'),
          const SizedBox(width: 10),
          _buildDayTab(2, 'Day 2'),
        ]),
        const SizedBox(height: 20),
        const Text('Ho Chi Minh - Da Nang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 15),
        if (_selectedDay == 1) ...[
          _buildTimelineItem('6:00AM', 'Departure from Ho Chi Minh City. Scenic drive through the mountains to Da Nang.'),
          _buildTimelineItem('10:00AM', 'Arrive at Da Nang. Check-in at hotel and freshen up.'),
          _buildTimelineItem('1:00PM', 'Visit Ba Na Hills and the famous Golden Bridge. Cable car ride included.'),
          _buildTimelineItem('8:00PM', 'Dinner at local restaurant. Traditional Vietnamese cuisine.', isLast: true),
        ] else ...[
          _buildTimelineItem('8:00AM', 'Morning visit to Hoi An Ancient Town. Guided walking tour.'),
          _buildTimelineItem('12:00PM', 'Lunch at riverside restaurant. Free time for shopping.'),
          _buildTimelineItem('4:00PM', 'Return to Da Nang. Visit Dragon Bridge at night.', isLast: true),
        ],
      ],
    );
  }

  Widget _buildDayTab(int dayIndex, String text) {
    bool isActive = _selectedDay == dayIndex;
    return GestureDetector(
      onTap: () => setState(() => _selectedDay = dayIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: isActive ? primaryColor : Colors.grey.shade300),
        ),
        child: Text(text, style: TextStyle(
          color: isActive ? Colors.white : hintColor,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        )),
      ),
    );
  }

  Widget _buildTimelineItem(String time, String content, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 14, height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                  border: Border.all(color: const Color(0xFFB2EFE0), width: 3),
                ),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey.shade200)),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(content, style: const TextStyle(color: textColor, height: 1.5, fontSize: 13)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Icon(Icons.monetization_on_outlined, size: 24, color: textColor),
          SizedBox(width: 10),
          Text('Price', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              _buildPriceRow('Adult (>10 years old)', widget.price),
              const Divider(height: 1, color: Colors.grey),
              _buildPriceRow('Child (5 - 10 years old)', '\$320.00'),
              const Divider(height: 1, color: Colors.grey),
              _buildPriceRow('Child (<5 years old)', 'Free'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String type, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type, style: const TextStyle(color: textColor, fontSize: 13)),
          Text(price, style: const TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Reviews', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: _showReviewsDialog,
              child: Text('SEE ALL', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Text('4.8', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: primaryColor)),
                  Row(children: List.generate(5, (i) => const Icon(Icons.star, color: Colors.amber, size: 16))),
                  const Text('145 reviews', style: TextStyle(color: hintColor, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildRatingBar(5, 0.78),
                    _buildRatingBar(4, 0.15),
                    _buildRatingBar(3, 0.05),
                    _buildRatingBar(2, 0.01),
                    _buildRatingBar(1, 0.01),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        ..._reviews.map((r) => _buildReviewCard(r)),
      ],
    );
  }

  Widget _buildRatingBar(int stars, double ratio) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$stars', style: const TextStyle(fontSize: 12, color: hintColor)),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: Colors.grey.shade200,
                color: primaryColor,
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(review['avatar']), radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(review['date'], style: const TextStyle(color: hintColor, fontSize: 11)),
                  ],
                ),
              ),
              Row(children: List.generate(review['rating'] as int, (i) => const Icon(Icons.star, color: Colors.amber, size: 14))),
            ],
          ),
          const SizedBox(height: 10),
          Text(review['comment'], style: const TextStyle(color: textColor, fontSize: 13, height: 1.5)),
        ],
      ),
    );
  }

  void _showReviewsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (ctx2, controller) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
            ),
            const Text('All Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: controller,
                padding: const EdgeInsets.all(20),
                itemCount: _reviews.length,
                itemBuilder: (context, i) => _buildReviewCard(_reviews[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirm Booking', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 12),
            _buildDialogRow('Travelers', '$_travelers person${_travelers > 1 ? 's' : ''}'),
            _buildDialogRow('Unit price', widget.price),
            const Divider(height: 24),
            _buildDialogRow('Total', '\$${_totalPrice.toStringAsFixed(2)}', isBold: true, isGreen: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: hintColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('🎉 Booked "${widget.title}" for $_travelers traveler${_travelers > 1 ? 's' : ''}!'),
                backgroundColor: primaryColor,
                duration: const Duration(seconds: 2),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('CONFIRM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogRow(String label, String value, {bool isBold = false, bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: hintColor)),
          Text(value, style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isGreen ? primaryColor : textColor,
            fontSize: isGreen ? 16 : 14,
          )),
        ],
      ),
    );
  }

  void _showShareModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share on', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareIcon(Icons.facebook, Colors.blue, 'Facebook'),
                _buildShareIcon(Icons.g_mobiledata, Colors.red, 'Google'),
                _buildShareIcon(Icons.chat_bubble, Colors.yellow[700]!, 'Kakao'),
                _buildShareIcon(Icons.message, Colors.green, 'WhatsApp'),
                _buildShareIcon(Icons.flutter_dash, Colors.lightBlue, 'Twitter'),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: const Text('Cancel', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareIcon(IconData icon, Color color, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing on $label...'), duration: const Duration(seconds: 1)),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, color: hintColor)),
        ],
      ),
    );
  }
}
