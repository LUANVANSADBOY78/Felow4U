import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../services/api_service.dart';

class CreateNewTripScreen extends StatefulWidget {
  const CreateNewTripScreen({super.key});

  @override
  State<CreateNewTripScreen> createState() => _CreateNewTripScreenState();
}

class _CreateNewTripScreenState extends State<CreateNewTripScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromTimeController = TextEditingController();
  final TextEditingController _toTimeController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  int _travelerCount = 1;
  bool _isCreating = false;

  final List<Map<String, dynamic>> _attractions = [
    {
      'name': 'Dragon Bridge',
      'img': 'https://picsum.photos/seed/dragon/400/250',
      'selected': true,
    },
    {
      'name': 'Cham Museum',
      'img': 'https://picsum.photos/seed/cham/400/250',
      'selected': false,
    },
    {
      'name': 'My Khe Beach',
      'img': 'https://picsum.photos/seed/beach/400/250',
      'selected': true,
    },
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _dateController.dispose();
    _fromTimeController.dispose();
    _toTimeController.dispose();
    _feeController.dispose();
    _languageController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateTrip() async {
    if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter location')),
      );
      return;
    }

    setState(() => _isCreating = true);

    final tripData = {
      'location': _locationController.text,
      'date': _dateController.text,
      'time': '${_fromTimeController.text} - ${_toTimeController.text}',
      'travelers': _travelerCount,
      'fee': _feeController.text,
      'language': _languageController.text,
      'attractions': _attractions
          .where((a) => a['selected'] == true)
          .map((a) => a['name'])
          .toList(),
    };

    final success = await ApiService.createTrip(tripData);

    if (mounted) {
      setState(() => _isCreating = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip created successfully!')),
        );
        Navigator.pop(context, true); // Return true to refresh list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create trip')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: textColor, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Trip',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabeledTextField(
              label: 'Where you want to explore',
              hint: 'Danang, Vietnam',
              icon: Icons.location_on_outlined,
              controller: _locationController,
            ),
            const SizedBox(height: 20),
            _buildLabeledTextField(
              label: 'Date',
              hint: 'mm/dd/yy',
              icon: Icons.calendar_today_outlined,
              controller: _dateController,
            ),
            const SizedBox(height: 20),
            const Text(
              'Time',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _buildTextFieldOnly(
                    hint: 'From',
                    icon: Icons.access_time,
                    controller: _fromTimeController,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextFieldOnly(
                    hint: 'To',
                    icon: Icons.access_time,
                    controller: _toTimeController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Number of travelers',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildCounterButton(Icons.remove, () {
                  if (_travelerCount > 1) setState(() => _travelerCount--);
                }),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      '$_travelerCount',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                _buildCounterButton(Icons.add, () {
                  setState(() => _travelerCount++);
                }),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Fee',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: _buildTextFieldOnly(
                    hint: 'Fee',
                    icon: Icons.monetization_on_outlined,
                    controller: _feeController,
                  ),
                ),
                const SizedBox(width: 15),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '(\$/hour)',
                    style: TextStyle(color: textColor, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabeledTextField(
              label: "Guide's Language",
              hint: 'Korean, English',
              icon: Icons.public,
              controller: _languageController,
            ),
            const SizedBox(height: 25),
            const Text(
              'Attractions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: textColor,
              ),
            ),
            const SizedBox(height: 15),
            _buildAttractionsGrid(),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isCreating ? null : _handleCreateTrip,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: _isCreating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'DONE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: textColor,
          ),
        ),
        _buildTextFieldOnly(hint: hint, icon: icon, controller: controller),
      ],
    );
  }

  Widget _buildTextFieldOnly({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: textColor),
        prefixIcon: Icon(icon, color: hintColor, size: 20),
        prefixIconConstraints: const BoxConstraints(minWidth: 30, minHeight: 0),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 0.5),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: primaryColor, size: 24),
      ),
    );
  }

  Widget _buildAttractionsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.5,
      ),
      itemCount: _attractions.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: primaryColor),
                  SizedBox(height: 5),
                  Text(
                    'Add New',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final attr = _attractions[index - 1];
        return GestureDetector(
          onTap: () {
            setState(() {
              attr['selected'] = !attr['selected'];
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(attr['img']),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Text(
                    attr['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: attr['selected']
                          ? primaryColor
                          : Colors.black.withOpacity(0.3),
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      Icons.check,
                      size: 14,
                      color: attr['selected'] ? Colors.white : Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
