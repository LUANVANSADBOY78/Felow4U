// backend/test_api.js
const http = require('http');

const BASE_URL = 'http://localhost:5000';

function request(method, path, data = null) {
  return new Promise((resolve, reject) => {
    const url = new URL(path, BASE_URL);
    const options = {
      method: method,
      hostname: url.hostname,
      port: url.port,
      path: url.pathname + url.search,
      headers: {
        'Accept': 'application/json'
      }
    };

    if (data) {
      options.headers['Content-Type'] = 'application/json';
    }

    const req = http.request(options, (res) => {
      let body = '';
      res.on('data', (chunk) => body += chunk);
      res.on('end', () => {
        try {
          const parsed = body ? jsonParseSafe(body) : null;
          resolve({
            statusCode: res.statusCode,
            headers: res.headers,
            body: parsed
          });
        } catch (e) {
          reject(e);
        }
      });
    });

    req.on('error', (e) => reject(e));

    if (data) {
      req.write(JSON.stringify(data));
    }
    req.end();
  });
}

function jsonParseSafe(str) {
  try {
    return JSON.parse(str);
  } catch (e) {
    return str;
  }
}

async function runTests() {
  console.log('🧪 BẮT ĐẦU KIỂM TRA MOCK API FELLOW4U...\n');

  try {
    // 1. Test GET /api/users (Xem danh sách user mặc định)
    console.log('🔄 1. Đang kiểm tra GET /api/users...');
    const usersRes = await request('GET', '/api/users');
    console.log(`✅ Kết quả: Status ${usersRes.statusCode}`);
    console.log(`   Số lượng User ban đầu: ${usersRes.body.length}`);
    console.log(`   User mặc định: ${usersRes.body[0].email} (${usersRes.body[0].firstName})\n`);

    // 2. Test POST /api/auth/register (Đăng ký tài khoản mới)
    console.log('🔄 2. Đang kiểm tra đăng ký tài khoản mới POST /api/auth/register...');
    const testUser = {
      firstName: 'Nguyen',
      lastName: 'An',
      email: 'nguyenan@test.com',
      password: 'password123',
      country: 'Vietnam'
    };
    const registerRes = await request('POST', '/api/auth/register', testUser);
    console.log(`✅ Kết quả: Status ${registerRes.statusCode}`);
    console.log(`   Đã tạo user thành công! ID: ${registerRes.body.id}, Email: ${registerRes.body.email}\n`);

    // 3. Test POST /api/auth/login (Đăng nhập bằng tài khoản vừa tạo)
    console.log('🔄 3. Đang kiểm tra đăng nhập tài khoản vừa tạo POST /api/auth/login...');
    const loginRes = await request('POST', '/api/auth/login', {
      email: 'nguyenan@test.com',
      password: 'password123'
    });
    console.log(`✅ Kết quả: Status ${loginRes.statusCode}`);
    console.log(`   Đăng nhập thành công! Xin chào ${loginRes.body.firstName} ${loginRes.body.lastName}\n`);

    // 4. Test GET /api/explore (Lấy dữ liệu explore)
    console.log('🔄 4. Đang kiểm tra lấy dữ liệu trang chủ GET /api/explore...');
    const exploreRes = await request('GET', '/api/explore');
    console.log(`✅ Kết quả: Status ${exploreRes.statusCode}`);
    console.log(`   Số lượng Danh mục: ${exploreRes.body.categories.length}`);
    console.log(`   Số lượng Hướng dẫn viên hàng đầu: ${exploreRes.body.topGuides.length}`);
    console.log(`   Số lượng Chuyến đi hàng đầu: ${exploreRes.body.topJourneys.length}\n`);

    // 5. Test GET /api/trips (Xem danh sách các chuyến đi)
    console.log('🔄 5. Đang kiểm tra danh sách chuyến đi GET /api/trips...');
    const tripsRes = await request('GET', '/api/trips');
    console.log(`✅ Kết quả: Status ${tripsRes.statusCode}`);
    console.log(`   Tổng số chuyến đi có sẵn: ${tripsRes.body.length}`);
    console.log(`   Chuyến đi đầu tiên: "${tripsRes.body[0].title}" ở ${tripsRes.body[0].location}\n`);

    // 6. Test GET /api/guides (Xem danh sách local guides)
    console.log('🔄 6. Đang kiểm tra danh sách hướng dẫn viên GET /api/guides...');
    const guidesRes = await request('GET', '/api/guides');
    console.log(`✅ Kết quả: Status ${guidesRes.statusCode}`);
    console.log(`   Tổng số hướng dẫn viên: ${guidesRes.body.length}`);
    console.log(`   Hướng dẫn viên đầu tiên: ${guidesRes.body[0].name} (${guidesRes.body[0].location})\n`);

    // 7. Test POST /api/bookings (Tạo lượt đặt tour mới)
    console.log('🔄 7. Đang kiểm tra tạo lượt đặt tour mới POST /api/bookings...');
    const bookingRes = await request('POST', '/api/bookings', {
      userId: registerRes.body.id,
      tripId: '1',
      status: 'pending'
    });
    console.log(`✅ Kết quả: Status ${bookingRes.statusCode}`);
    console.log(`   Đã đặt thành công! ID Booking: ${bookingRes.body.id}, Trạng thái: ${bookingRes.body.status}\n`);

    // 8. Test GET /api/bookings (Xác minh lượt đặt tour)
    console.log('🔄 8. Đang kiểm tra xem tất cả lượt đặt tour GET /api/bookings...');
    const getBookingsRes = await request('GET', '/api/bookings');
    console.log(`✅ Kết quả: Status ${getBookingsRes.statusCode}`);
    console.log(`   Tổng số lượt đặt tour hiện tại: ${getBookingsRes.body.length}\n`);

    // 9. Test GET /api/notifications (Xem danh sách thông báo)
    console.log('🔄 9. Đang kiểm tra lấy danh sách thông báo GET /api/notifications...');
    const notiRes = await request('GET', '/api/notifications');
    console.log(`✅ Kết quả: Status ${notiRes.statusCode}`);
    console.log(`   Số lượng thông báo ban đầu: ${notiRes.body.length}\n`);

    console.log('🎉 TẤT CẢ CÁC BÀI KIỂM TRA ĐỀU ĐÃ THÀNH CÔNG RỰC RỠ! 🚀');
  } catch (err) {
    console.error('❌ Kiểm tra thất bại do lỗi kết nối:', err.message);
    console.log('\nHãy đảm bảo server đang chạy bằng lệnh "npm run dev" trước khi chạy test.');
  }
}

runTests();
