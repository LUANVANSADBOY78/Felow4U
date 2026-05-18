// lib/services/mock_data.dart

class MockData {
  // 1. Dữ liệu người dùng (User Profile)
  static Map<String, dynamic> user = {
    'id': '1',
    'email': 'vanluan78@gmail.com',
    'password': '12345678',
    'firstName': 'Luan',
    'lastName': 'Van',
    'avatar': 'https://i.pravatar.cc/150?u=vanluan',
    'country': 'Vietnam',
    'phone': '+84 123 456 789',
  };

  // 2. Danh sách Danh mục (Categories)
  static List<Map<String, dynamic>> categories = [
    {'id': 'c1', 'name': 'Beach', 'icon': 'beach_access'},
    {'id': 'c2', 'name': 'Mountain', 'icon': 'terrain'},
    {'id': 'c3', 'name': 'Food', 'icon': 'restaurant'},
    {'id': 'c4', 'name': 'Adventure', 'icon': 'directions_run'},
    {'id': 'c5', 'name': 'City', 'icon': 'location_city'},
    {'id': 'c6', 'name': 'Culture', 'icon': 'museum'},
  ];

  // 3. Danh sách Chuyến đi (Trips/Tours)
  static List<Map<String, dynamic>> trips = [
    {
      'id': '1',
      'title': 'Da Nang - Ba Na - Hoi An',
      'price': '\$400.00',
      'image': 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=800&q=80',
      'location': 'Danang, Vietnam',
      'duration': '3 days',
      'date': 'Jan 30, 2020',
      'likes': '1.2k likes',
      'rating': 5,
      'description': 'Khám phá vẻ đẹp kỳ vĩ của Bà Nà Hills, Cầu Vàng và nét cổ kính của Phố cổ Hội An.',
      'guideId': 'g1',
    },
    {
      'id': '2',
      'title': 'Thailand Temple Tour',
      'price': '\$600.00',
      'image': 'https://images.unsplash.com/photo-1506197603485-d7e8d055430e?w=800&q=80',
      'location': 'Bangkok, Thailand',
      'duration': '5 days',
      'date': 'Feb 10, 2020',
      'likes': '980 likes',
      'rating': 4.8,
      'description': 'Hành trình tâm linh qua những ngôi chùa vàng rực rỡ và nền ẩm thực đường phố độc đáo tại Bangkok.',
      'guideId': 'g2',
    },
    {
      'id': '3',
      'title': 'Melbourne - Sydney City',
      'price': '\$850.00',
      'image': 'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?w=800&q=80',
      'location': 'Australia',
      'duration': '4 days',
      'date': 'Mar 15, 2020',
      'likes': '1.5k likes',
      'rating': 5,
      'description': 'Trải nghiệm cuộc sống hiện đại và năng động tại hai thành phố lớn nhất nước Úc.',
      'guideId': 'g3',
    },
    {
      'id': '4',
      'title': 'Hanoi - Ha Long Bay',
      'price': '\$350.00',
      'image': 'https://images.unsplash.com/photo-1528127269322-539801943592?w=800&q=80',
      'location': 'Hanoi, Vietnam',
      'duration': '2 days',
      'date': 'Jan 20, 2020',
      'likes': '2.1k likes',
      'rating': 5,
      'description': 'Nghỉ dưỡng trên du thuyền 5 sao và khám phá kỳ quan thiên nhiên thế giới Vịnh Hạ Long.',
      'guideId': 'g2',
    },
    {
      'id': '5',
      'title': 'Phu Quoc Island Escape',
      'price': '\$450.00',
      'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&q=80',
      'location': 'Phu Quoc, Vietnam',
      'duration': '3 days',
      'date': 'Apr 10, 2020',
      'likes': '3.2k likes',
      'rating': 4.9,
      'description': 'Tận hưởng nắng vàng, biển xanh và hải sản tươi ngon tại đảo ngọc Phú Quốc.',
      'guideId': 'g4',
    }
  ];

  // 4. Danh sách Hướng dẫn viên (Guides)
  static List<Map<String, dynamic>> guides = [
    {
      'id': 'g1',
      'name': 'Tuan Tran',
      'location': 'Danang, Vietnam',
      'avatar': 'https://i.pravatar.cc/150?u=g1',
      'rating': 5,
      'reviews': '127 Reviews',
      'languages': ['Vietnamese', 'English'],
    },
    {
      'id': 'g2',
      'name': 'Emmy Nguyen',
      'location': 'Hanoi, Vietnam',
      'avatar': 'https://i.pravatar.cc/150?u=g2',
      'rating': 4.9,
      'reviews': '89 Reviews',
      'languages': ['Vietnamese', 'English', 'French'],
    },
    {
      'id': 'g3',
      'name': 'Linh Hana',
      'location': 'Danang, Vietnam',
      'avatar': 'https://i.pravatar.cc/150?u=g3',
      'rating': 4.8,
      'reviews': '110 Reviews',
      'languages': ['Vietnamese', 'English'],
    },
    {
      'id': 'g4',
      'name': 'Khai Ho',
      'location': 'Ho Chi Minh, Vietnam',
      'avatar': 'https://i.pravatar.cc/150?u=g4',
      'rating': 4.7,
      'reviews': '56 Reviews',
      'languages': ['Vietnamese', 'English'],
    }
  ];

  // 5. Danh sách Thông báo (Notifications)
  static List<Map<String, dynamic>> notifications = [
    {
      'id': '1',
      'type': 'system',
      'title': 'Welcome to Fellow-4U!',
      'content': 'Chúc mừng bạn đã gia nhập cộng đồng du lịch Fellow-4U. Hãy bắt đầu chuyến hành trình đầu tiên của mình ngay nhé!',
      'createdAt': '2024-05-13T08:00:00',
      'read': true
    },
    {
      'id': '2',
      'type': 'promo',
      'title': 'Sale 20% cho Tour Thái Lan',
      'content': 'Duy nhất trong tuần này, Tour Thái Lan giảm giá 20%. Đừng bỏ lỡ!',
      'createdAt': '2024-05-13T09:30:00',
      'read': false
    },
    {
      'id': '3',
      'type': 'booking',
      'title': 'Booking Confirmed',
      'content': 'Yêu cầu đặt tour Da Nang của bạn đã được xác nhận thành công.',
      'createdAt': '2024-05-12T15:00:00',
      'read': true
    }
  ];

  // 6. Danh sách Bookings (My Trips)
  static List<Map<String, dynamic>> bookings = [
    {
      'id': 'b1',
      'tripId': '1',
      'status': 'Ongoing',
      'date': 'Jan 30, 2020',
      'time': '13:00 - 15:00',
      'guideName': 'Tuan Tran',
    }
  ];

  // 7. Tin tức du lịch (Travel News)
  static List<Map<String, dynamic>> travelNews = [
    {
      'id': 'n1',
      'title': 'New Destination in Danang City',
      'image': 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=800&q=80',
      'date': 'Feb 5, 2020'
    },
    {
      'id': 'n2',
      'title': '\$1 Flight Ticket',
      'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=800&q=80',
      'date': 'Feb 5, 2020'
    }
  ];
}
