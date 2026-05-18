import 'package:flutter/material.dart';

// ── Supported languages ───────────────────────────────────────────────────────
enum AppLanguage { english, vietnamese, french, korean, japanese }

extension AppLanguageExt on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:    return 'en';
      case AppLanguage.vietnamese: return 'vi';
      case AppLanguage.french:     return 'fr';
      case AppLanguage.korean:     return 'ko';
      case AppLanguage.japanese:   return 'ja';
    }
  }

  String get label {
    switch (this) {
      case AppLanguage.english:    return 'English';
      case AppLanguage.vietnamese: return 'Tiếng Việt';
      case AppLanguage.french:     return 'Français';
      case AppLanguage.korean:     return '한국어';
      case AppLanguage.japanese:   return '日本語';
    }
  }

  String get flag {
    switch (this) {
      case AppLanguage.english:    return '🇺🇸';
      case AppLanguage.vietnamese: return '🇻🇳';
      case AppLanguage.french:     return '🇫🇷';
      case AppLanguage.korean:     return '🇰🇷';
      case AppLanguage.japanese:   return '🇯🇵';
    }
  }
}

// ── Translations map ──────────────────────────────────────────────────────────
const Map<String, Map<String, String>> _translations = {
  'en': {
    // App
    'app_name': 'Fellow4U',
    // Explore
    'explore': 'Explore',
    'hi_where': 'Hi, where do you want to explore?',
    'top_journeys': 'Top Journeys',
    'best_guides': 'Best Guides',
    'top_experiences': 'Top Experiences',
    'featured_tours': 'Featured Tours',
    'travel_news': 'Travel News',
    'see_more': 'SEE MORE',
    // Settings
    'settings': 'Settings',
    'edit_profile': 'EDIT PROFILE',
    'notifications': 'Notifications',
    'languages': 'Languages',
    'payment': 'Payment',
    'privacy': 'Privacy & Policies',
    'feedback': 'Feedback',
    'usage': 'Usage',
    'sign_out': 'Sign out',
    'select_language': 'Select Language',
    'current_language': 'Current language',
    // Auth
    'sign_in': 'Sign In',
    'sign_up': 'Sign Up',
    'terms_conditions': 'By Signing Up, you agree to our ',
    'email': 'Email',
    'password': 'Password',
    'forgot_password': 'Forgot Password?',
    'no_account': "Don't have an account?",
    'have_account': 'Already have an account?',
    // Search
    'search_hint': 'Where you want to explore',
    'popular_destinations': 'Popular destinations',
    'search_tip': 'Search by city, tour name or guide name',
    'no_results': 'No results found',
    // Tour Detail
    'book_tour': 'BOOK THIS TOUR',
    'summary': 'Summary',
    'schedule': 'Schedule',
    'price': 'Price',
    'reviews': 'Reviews',
    'travelers': 'Travelers',
    'how_many': 'How many people?',
    'confirm_booking': 'Confirm Booking',
    'confirm': 'CONFIRM',
    'cancel': 'CANCEL',
    'share_on': 'Share on',
    'see_all': 'SEE ALL',
    // My Trips
    'my_trips': 'My Trips',
    'current': 'Current',
    'next': 'Next',
    'past': 'Past',
    'wishlist': 'Wishlist',
    // Notification
    'notifications_title': 'Notifications',
    // Profile
    'profile': 'Profile',
    'traveler': 'Traveler',
    // Payment
    'payment_soon': 'Payment methods coming soon!',
    // Feedback
    'feedback_hint': 'Tell us your thoughts...',
    'send': 'SEND',
    // Usage
    'storage_usage': 'Storage usage: 45MB',
  },
  'vi': {
    'app_name': 'Fellow4U',
    'explore': 'Khám phá',
    'hi_where': 'Xin chào, bạn muốn khám phá đâu?',
    'top_journeys': 'Hành trình nổi bật',
    'best_guides': 'Hướng dẫn viên xuất sắc',
    'top_experiences': 'Trải nghiệm hàng đầu',
    'featured_tours': 'Tour nổi bật',
    'travel_news': 'Tin tức du lịch',
    'see_more': 'XEM THÊM',
    'settings': 'Cài đặt',
    'edit_profile': 'SỬA HỒ SƠ',
    'notifications': 'Thông báo',
    'languages': 'Ngôn ngữ',
    'payment': 'Thanh toán',
    'privacy': 'Quyền riêng tư & Chính sách',
    'feedback': 'Góp ý',
    'usage': 'Sử dụng',
    'sign_out': 'Đăng xuất',
    'select_language': 'Chọn ngôn ngữ',
    'current_language': 'Ngôn ngữ hiện tại',
    'sign_in': 'Đăng nhập',
    'sign_up': 'Đăng ký',
    'terms_conditions': 'Khi đăng ký, bạn đồng ý với ',
    'email': 'Email',
    'password': 'Mật khẩu',
    'forgot_password': 'Quên mật khẩu?',
    'no_account': 'Chưa có tài khoản?',
    'have_account': 'Đã có tài khoản?',
    'search_hint': 'Bạn muốn khám phá đâu?',
    'popular_destinations': 'Điểm đến phổ biến',
    'search_tip': 'Tìm theo thành phố, tên tour hoặc hướng dẫn viên',
    'no_results': 'Không tìm thấy kết quả',
    'book_tour': 'ĐẶT TOUR NÀY',
    'summary': 'Tóm tắt',
    'schedule': 'Lịch trình',
    'price': 'Giá',
    'reviews': 'Đánh giá',
    'travelers': 'Số người đi',
    'how_many': 'Bao nhiêu người?',
    'confirm_booking': 'Xác nhận đặt tour',
    'confirm': 'XÁC NHẬN',
    'cancel': 'HỦY',
    'share_on': 'Chia sẻ lên',
    'see_all': 'XEM TẤT CẢ',
    'my_trips': 'Chuyến đi của tôi',
    'current': 'Hiện tại',
    'next': 'Sắp tới',
    'past': 'Đã qua',
    'wishlist': 'Yêu thích',
    'notifications_title': 'Thông báo',
    'profile': 'Hồ sơ',
    'traveler': 'Du khách',
    'payment_soon': 'Phương thức thanh toán sắp ra mắt!',
    'feedback_hint': 'Hãy chia sẻ suy nghĩ của bạn...',
    'send': 'GỬI',
    'storage_usage': 'Dung lượng sử dụng: 45MB',
  },
  'fr': {
    'app_name': 'Fellow4U',
    'explore': 'Explorer',
    'hi_where': 'Bonjour, où voulez-vous explorer ?',
    'top_journeys': 'Meilleurs voyages',
    'best_guides': 'Meilleurs guides',
    'top_experiences': 'Meilleures expériences',
    'featured_tours': 'Tours en vedette',
    'travel_news': 'Actualités voyage',
    'see_more': 'VOIR PLUS',
    'settings': 'Paramètres',
    'edit_profile': 'MODIFIER PROFIL',
    'notifications': 'Notifications',
    'languages': 'Langues',
    'payment': 'Paiement',
    'privacy': 'Confidentialité & Politiques',
    'feedback': 'Commentaires',
    'usage': 'Utilisation',
    'sign_out': 'Se déconnecter',
    'select_language': 'Choisir la langue',
    'current_language': 'Langue actuelle',
    'sign_in': 'Se connecter',
    'sign_up': "S'inscrire",
    'terms_conditions': 'En vous inscrivant, vous acceptez nos ',
    'email': 'E-mail',
    'password': 'Mot de passe',
    'forgot_password': 'Mot de passe oublié ?',
    'no_account': "Pas de compte ?",
    'have_account': 'Déjà un compte ?',
    'search_hint': 'Où voulez-vous explorer ?',
    'popular_destinations': 'Destinations populaires',
    'search_tip': 'Recherche par ville, tour ou guide',
    'no_results': 'Aucun résultat trouvé',
    'book_tour': 'RÉSERVER CE TOUR',
    'summary': 'Résumé',
    'schedule': 'Programme',
    'price': 'Prix',
    'reviews': 'Avis',
    'travelers': 'Voyageurs',
    'how_many': 'Combien de personnes ?',
    'confirm_booking': 'Confirmer la réservation',
    'confirm': 'CONFIRMER',
    'cancel': 'ANNULER',
    'share_on': 'Partager sur',
    'see_all': 'VOIR TOUT',
    'my_trips': 'Mes voyages',
    'current': 'En cours',
    'next': 'À venir',
    'past': 'Passés',
    'wishlist': 'Liste de souhaits',
    'notifications_title': 'Notifications',
    'profile': 'Profil',
    'traveler': 'Voyageur',
    'payment_soon': 'Méthodes de paiement bientôt disponibles !',
    'feedback_hint': 'Partagez vos pensées...',
    'send': 'ENVOYER',
    'storage_usage': 'Utilisation du stockage : 45 Mo',
  },
  'ko': {
    'app_name': 'Fellow4U',
    'explore': '탐색',
    'hi_where': '안녕하세요, 어디를 탐색하고 싶으신가요?',
    'top_journeys': '인기 여행',
    'best_guides': '최고의 가이드',
    'top_experiences': '인기 체험',
    'featured_tours': '추천 투어',
    'travel_news': '여행 뉴스',
    'see_more': '더 보기',
    'settings': '설정',
    'edit_profile': '프로필 편집',
    'notifications': '알림',
    'languages': '언어',
    'payment': '결제',
    'privacy': '개인정보 & 정책',
    'feedback': '피드백',
    'usage': '사용량',
    'sign_out': '로그아웃',
    'select_language': '언어 선택',
    'current_language': '현재 언어',
    'sign_in': '로그인',
    'sign_up': '회원가입',
    'terms_conditions': '회원가입 시, 약관에 동의하는 것으로 간주합니다. ',
    'email': '이메일',
    'password': '비밀번호',
    'forgot_password': '비밀번호를 잊으셨나요?',
    'no_account': '계정이 없으신가요?',
    'have_account': '이미 계정이 있으신가요?',
    'search_hint': '어디를 탐색하고 싶으신가요?',
    'popular_destinations': '인기 여행지',
    'search_tip': '도시, 투어명 또는 가이드명으로 검색',
    'no_results': '결과를 찾을 수 없습니다',
    'book_tour': '이 투어 예약하기',
    'summary': '요약',
    'schedule': '일정',
    'price': '가격',
    'reviews': '리뷰',
    'travelers': '여행자',
    'how_many': '몇 명이 가시나요?',
    'confirm_booking': '예약 확인',
    'confirm': '확인',
    'cancel': '취소',
    'share_on': '공유하기',
    'see_all': '전체 보기',
    'my_trips': '내 여행',
    'current': '현재',
    'next': '다음',
    'past': '과거',
    'wishlist': '위시리스트',
    'notifications_title': '알림',
    'profile': '프로필',
    'traveler': '여행자',
    'payment_soon': '결제 방법 출시 예정!',
    'feedback_hint': '의견을 알려주세요...',
    'send': '전송',
    'storage_usage': '저장공간 사용량: 45MB',
  },
  'ja': {
    'app_name': 'Fellow4U',
    'explore': '探索',
    'hi_where': 'こんにちは、どこを探索しますか？',
    'top_journeys': '人気の旅行',
    'best_guides': '最高のガイド',
    'top_experiences': '人気の体験',
    'featured_tours': 'おすすめツアー',
    'travel_news': '旅行ニュース',
    'see_more': 'もっと見る',
    'settings': '設定',
    'edit_profile': 'プロフィール編集',
    'notifications': '通知',
    'languages': '言語',
    'payment': '支払い',
    'privacy': 'プライバシー＆ポリシー',
    'feedback': 'フィードバック',
    'usage': '使用状況',
    'sign_out': 'サインアウト',
    'select_language': '言語を選択',
    'current_language': '現在の言語',
    'sign_in': 'サインイン',
    'sign_up': '新規登録',
    'terms_conditions': 'サインアップすると、利用規約に同意したものとみなします。',
    'email': 'メール',
    'password': 'パスワード',
    'forgot_password': 'パスワードを忘れた方',
    'no_account': 'アカウントをお持ちでない方',
    'have_account': '既にアカウントをお持ちの方',
    'search_hint': 'どこを探索しますか？',
    'popular_destinations': '人気の目的地',
    'search_tip': '都市名、ツアー名、ガイド名で検索',
    'no_results': '結果が見つかりません',
    'book_tour': 'このツアーを予約',
    'summary': '概要',
    'schedule': 'スケジュール',
    'price': '料金',
    'reviews': 'レビュー',
    'travelers': '旅行者',
    'how_many': '何名で行きますか？',
    'confirm_booking': '予約確認',
    'confirm': '確認',
    'cancel': 'キャンセル',
    'share_on': 'シェア',
    'see_all': 'すべて見る',
    'my_trips': '私の旅行',
    'current': '現在',
    'next': '次回',
    'past': '過去',
    'wishlist': 'ウィッシュリスト',
    'notifications_title': '通知',
    'profile': 'プロフィール',
    'traveler': '旅行者',
    'payment_soon': '決済方法は近日公開！',
    'feedback_hint': 'ご意見をお聞かせください...',
    'send': '送信',
    'storage_usage': 'ストレージ使用量: 45MB',
  },
};

// ── Language State ─────────────────────────────────────────────────────────────
class LanguageNotifier extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;

  String get code => _language.code;

  void setLanguage(AppLanguage lang) {
    if (_language != lang) {
      _language = lang;
      notifyListeners();
    }
  }

  String t(String key) {
    return _translations[_language.code]?[key] ?? _translations['en']?[key] ?? key;
  }
}

// Global singleton so every screen can access it easily
final languageNotifier = LanguageNotifier();

// ── Helper extension for easy access in widgets ────────────────────────────────
extension ContextLang on BuildContext {
  String tr(String key) => languageNotifier.t(key);
  AppLanguage get currentLang => languageNotifier.language;
}

/// Add `with LanguageAware<YourWidget>` to any State to auto-rebuild on lang change.
mixin LanguageAware<T extends StatefulWidget> on State<T> {
  void _onLangChange() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    languageNotifier.addListener(_onLangChange);
  }

  @override
  void dispose() {
    languageNotifier.removeListener(_onLangChange);
    super.dispose();
  }
}

