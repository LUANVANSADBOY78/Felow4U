import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../core/app_localizations.dart';
import 'edit_profile.dart';
import 'sign_in.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifEnabled = true;
  bool _emailNotif = true;
  bool _pushNotif = true;

  @override
  void initState() {
    super.initState();
    languageNotifier.addListener(_onLangChanged);
  }

  @override
  void dispose() {
    languageNotifier.removeListener(_onLangChanged);
    super.dispose();
  }

  void _onLangChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('settings'),
          style: const TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Profile banner ─────────────────────────────────────
          _buildProfileBanner(),
          const SizedBox(height: 20),

          // ── Notifications section ───────────────────────────────
          _buildSectionCard([
            _buildSwitchTile(
              icon: Icons.notifications_none,
              title: context.tr('notifications'),
              subtitle: 'Push & email alerts',
              value: _notifEnabled,
              onChanged: (v) {
                setState(() {
                  _notifEnabled = v;
                  _emailNotif = v;
                  _pushNotif = v;
                });
              },
            ),
            if (_notifEnabled) ...[
              const Divider(height: 1, indent: 56),
              _buildSwitchTile(
                icon: Icons.email_outlined,
                title: 'Email notifications',
                subtitle: 'Booking confirmations & news',
                value: _emailNotif,
                onChanged: (v) => setState(() => _emailNotif = v),
                isSubItem: true,
              ),
              const Divider(height: 1, indent: 56),
              _buildSwitchTile(
                icon: Icons.phone_android,
                title: 'Push notifications',
                subtitle: 'Real-time updates',
                value: _pushNotif,
                onChanged: (v) => setState(() => _pushNotif = v),
                isSubItem: true,
              ),
            ],
          ]),
          const SizedBox(height: 16),

          // ── App settings section ────────────────────────────────
          _buildSectionCard([
            _buildNavTile(
              icon: Icons.language,
              title: context.tr('languages'),
              subtitle: '${languageNotifier.language.flag} ${languageNotifier.language.label}',
              onTap: _showLanguagePicker,
            ),
            const Divider(height: 1, indent: 56),
            _buildNavTile(
              icon: Icons.payment,
              title: context.tr('payment'),
              subtitle: 'Cards, wallets & more',
              onTap: _showPaymentSheet,
            ),
            const Divider(height: 1, indent: 56),
            _buildNavTile(
              icon: Icons.privacy_tip_outlined,
              title: context.tr('privacy'),
              subtitle: 'Read our policies',
              onTap: _showPrivacyDialog,
            ),
            const Divider(height: 1, indent: 56),
            _buildNavTile(
              icon: Icons.feedback_outlined,
              title: context.tr('feedback'),
              subtitle: 'Share your thoughts',
              onTap: _showFeedbackDialog,
            ),
            const Divider(height: 1, indent: 56),
            _buildNavTile(
              icon: Icons.data_usage,
              title: context.tr('usage'),
              subtitle: '45 MB used',
              onTap: _showUsageDialog,
            ),
          ]),
          const SizedBox(height: 30),

          // ── Sign out ────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(
                context.tr('sign_out'),
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _confirmSignOut,
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // ── Widgets ───────────────────────────────────────────────────────────────
  Widget _buildProfileBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C897), Color(0xFF00A67C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: const Color(0xFF00C897).withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=100'),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Yoo Jin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                Text(context.tr('traveler'), style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: Text(context.tr('edit_profile'), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isSubItem = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(isSubItem ? 30 : 16, 4, 16, 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: isSubItem ? 13 : 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: hintColor, fontSize: 12)),
      trailing: Switch(value: value, activeColor: primaryColor, onChanged: onChanged),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: hintColor, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: hintColor),
    );
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              Text(context.tr('select_language'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                '${context.tr("current_language")}: ${languageNotifier.language.flag} ${languageNotifier.language.label}',
                style: const TextStyle(color: hintColor, fontSize: 13),
              ),
              const SizedBox(height: 20),
              ...AppLanguage.values.map((lang) {
                final isSelected = languageNotifier.language == lang;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor.withOpacity(0.08) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? primaryColor : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    leading: Text(lang.flag, style: const TextStyle(fontSize: 28)),
                    title: Text(lang.label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 16)),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: primaryColor)
                        : const Icon(Icons.circle_outlined, color: hintColor),
                    onTap: () {
                      languageNotifier.setLanguage(lang);
                      setModalState(() {}); // refresh checkmarks in modal
                      setState(() {}); // refresh subtitle on settings screen
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${lang.flag} Language changed to ${lang.label}'),
                        backgroundColor: primaryColor,
                        duration: const Duration(seconds: 2),
                      ));
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text(context.tr('payment'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildPaymentCard(Icons.credit_card, 'Visa •••• 4242', 'Expires 12/26', primaryColor),
            const SizedBox(height: 12),
            _buildPaymentCard(Icons.account_balance_wallet, 'PayPal', 'yoojin@email.com', Colors.blue),
            const SizedBox(height: 12),
            _buildPaymentCard(Icons.apple, 'Apple Pay', 'Linked device', Colors.black),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add, color: primaryColor),
                label: const Text('Add payment method', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add card feature coming soon!')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: hintColor, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: primaryColor, size: 20),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr('privacy'), style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('📋 Privacy & Policies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 10),
              Text('Fellow4U collects minimal data to provide the best experience:', style: TextStyle(fontSize: 13, height: 1.5)),
              SizedBox(height: 8),
              Text('• Location data is used only during active sessions\n• Payment info is encrypted and never stored\n• Your profile data is kept private and secure\n• You can delete your account at any time', style: TextStyle(fontSize: 13, height: 1.6, color: textColor)),
              SizedBox(height: 10),
              Text('Last updated: May 2026', style: TextStyle(color: hintColor, fontSize: 11)),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Got it', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog() {
    final controller = TextEditingController();
    int rating = 5;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(context.tr('feedback'), style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => GestureDetector(
                  onTap: () => setDialogState(() => rating = i + 1),
                  child: Icon(i < rating ? Icons.star : Icons.star_border, color: Colors.amber, size: 32),
                )),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: context.tr('feedback_hint'),
                  hintStyle: const TextStyle(color: hintColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: primaryColor)),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.tr('cancel'), style: const TextStyle(color: hintColor))),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('🙏 Thank you for your feedback!'),
                  backgroundColor: primaryColor,
                ));
              },
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text(context.tr('send'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showUsageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr('usage'), style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildUsageRow('Cache', '28 MB', 0.62),
            const SizedBox(height: 12),
            _buildUsageRow('Saved tours', '12 MB', 0.27),
            const SizedBox(height: 12),
            _buildUsageRow('Photos', '5 MB', 0.11),
            const SizedBox(height: 16),
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('45 MB', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared!'), backgroundColor: primaryColor));
            },
            child: const Text('Clear cache', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageRow(String label, String size, double ratio) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: textColor)),
            Text(size, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: Colors.grey.shade200,
            color: primaryColor,
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  void _confirmSignOut() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(context.tr('sign_out'), style: const TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.tr('cancel'), style: const TextStyle(color: hintColor))),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ApiService.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: Text(context.tr('sign_out'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
