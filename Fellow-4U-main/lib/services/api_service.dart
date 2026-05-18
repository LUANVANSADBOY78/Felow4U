import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // CẤU HÌNH ĐƯỜNG DẪN BACKEND (Đồng bộ với Postman)
  // - iOS Simulator / Web / Desktop: sử dụng 'http://localhost:5000'
  // - Android Emulator: sử dụng 'http://10.0.2.2:5000' (Do Android xem localhost là chính nó)
  // - Thiết bị thật: sử dụng địa chỉ IP của máy tính (ví dụ: 'http://192.168.1.15:5000')
  static const String baseUrl = 'http://10.0.2.2:5000'; // <<< Thay đổi ở đây nếu chạy iOS/Thiết bị thật

  // 1. Đăng ký (Sign Up) - POST /api/auth/register
  static Future<bool> signUp(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error in signUp: $e');
      return false;
    }
  }

  // 2. Đăng nhập (Sign In) - POST /api/auth/login
  static Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setString(
          'userName',
          (user['firstName'] ?? '') + ' ' + (user['lastName'] ?? ''),
        );
        return user;
      }
      return null;
    } catch (e) {
      print('Error in signIn: $e');
      return null;
    }
  }

  // 3. Lấy dữ liệu tổng hợp (Explore) - GET /api/explore
  static Future<Map<String, dynamic>?> getExploreData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/explore'));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error in getExploreData: $e');
      return null;
    }
  }

  // 4. Tìm kiếm (Search)
  static Future<Map<String, dynamic>> search(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/data'));
      if (response.statusCode == 200) {
        List<dynamic> allData = jsonDecode(response.body);
        final q = query.toLowerCase();
        
        final filteredTrips = allData.where((t) {
          return (t['title'] as String).toLowerCase().contains(q) ||
                 (t['location'] as String).toLowerCase().contains(q);
        }).toList();

        return {'trips': filteredTrips, 'guides': []};
      }
      return {'trips': [], 'guides': []};
    } catch (e) {
      return {'trips': [], 'guides': []};
    }
  }

  // 5. Lấy danh sách chuyến đi của tôi (My Trips)
  static Future<Map<String, dynamic>?> getMyTrips() async {
    try {
      return {
        // 1. Current Trips (Đang diễn ra)
        'current': [
          {
            'id': 't1',
            'title': 'Dragon Bridge Trip',
            'location': 'Danang, Vietnam',
            'date': 'Jan 30, 2020',
            'time': '13:00 - 15:00',
            'guideName': 'Tuan Tran',
            'status': 'Ongoing',
            'image': 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?w=800&q=80',
            'avatars': ['https://i.pravatar.cc/150?u=g1'],
          }
        ],
        // 2. Next Trips (Sắp tới)
        'next': [
          {
            'id': 't2',
            'title': 'Ho Guom Trip',
            'location': 'Hanoi, Vietnam',
            'date': 'Feb 2, 2020',
            'time': '8:00 - 10:00',
            'guideName': 'Emmy Nguyen',
            'status': 'Pay',
            'image': 'https://images.unsplash.com/photo-1528127269322-539801943592?w=800&q=80',
            'avatars': ['https://i.pravatar.cc/150?u=g2'],
          },
          {
            'id': 't3',
            'title': 'Ho Chi Minh Mausoleum',
            'location': 'Hanoi, Vietnam',
            'date': 'Feb 2, 2020',
            'time': '8:00 - 10:00',
            'guideName': 'Emmy Nguyen',
            'status': 'Waiting',
            'image': 'https://images.unsplash.com/photo-1555217088-2d51bc3e1d93?w=800&q=80',
            'avatars': ['https://i.pravatar.cc/150?u=g2'],
          },
          {
            'id': 't4',
            'title': 'Duc Ba Church',
            'location': 'Ho Chi Minh, Vietnam',
            'date': 'Feb 2, 2020',
            'time': '8:00 - 10:00',
            'guideName': 'Waiting for offers',
            'status': 'Bidding',
            'image': 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&q=80',
            'avatars': [],
          }
        ],
        // 3. Past Trips (Đã đi)
        'past': [
          {
            'id': 't5',
            'title': 'Quoc Tu Giam Temple',
            'location': 'Hanoi, Vietnam',
            'date': 'Dec 20, 2019',
            'time': '10:00 - 12:00',
            'guideName': 'Emmy Nguyen',
            'status': 'Completed',
            'image': 'https://images.unsplash.com/photo-1509062522246-3755977927d7?w=800&q=80',
            'avatars': ['https://i.pravatar.cc/150?u=g2'],
          },
          {
            'id': 't6',
            'title': 'Dinh Doc Lap',
            'location': 'Ho Chi Minh, Vietnam',
            'date': 'Feb 2, 2020',
            'time': '8:00 - 10:00',
            'guideName': 'Khai Ho',
            'status': 'Completed',
            'image': 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?w=800&q=80',
            'avatars': ['https://i.pravatar.cc/150?u=g4'],
          }
        ],
        // 4. Wish List (Yêu thích)
        'wishlist': [
          {
            'id': 'w1',
            'title': 'Melbourne - Sydney',
            'price': '\$850.00',
            'location': 'Australia',
            'image': 'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?w=800&q=80',
            'rating': 5,
          },
          {
            'id': 'w2',
            'title': 'Hanoi - Ha Long Bay',
            'price': '\$350.00',
            'location': 'Hanoi, Vietnam',
            'image': 'https://images.unsplash.com/photo-1528127269322-539801943592?w=800&q=80',
            'rating': 5,
          }
        ],
      };
    } catch (e) {
      return null;
    }
  }

  // 6. Tạo chuyến đi mới
  static Future<bool> createTrip(Map<String, dynamic> tripData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/data'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tripData),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // 7. Đăng xuất (Sign Out)
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
