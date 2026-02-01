import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import 'seed_lite.dart';

class SeedLiteScreen extends ConsumerStatefulWidget {
  const SeedLiteScreen({super.key});

  @override
  ConsumerState<SeedLiteScreen> createState() => _SeedLiteScreenState();
}

class _SeedLiteScreenState extends ConsumerState<SeedLiteScreen> {
  bool _isSeeding = false;
  String _status = '';
  final List<String> _logs = [];

  Future<void> _seedLiteData() async {
    setState(() {
      _isSeeding = true;
      _status = 'Seeding LITE data...';
      _logs.clear();
    });

    final firestore = FirebaseFirestore.instance;
    try {
      // 1. Seed Agency
      // Override ownerUid with CURRENT USER if logged in, else keep demo
      final currentUser = FirebaseAuth.instance.currentUser;
      final agencyData = Map<String, dynamic>.from(sampleAgency);
      if (currentUser != null) {
        agencyData['ownerUid'] = currentUser.uid;
      }

      await firestore
          .collection('agencies')
          .doc(agencyData['agencyId'])
          .set(agencyData);

      setState(() => _logs.add('✅ Added Agency: ${agencyData['businessName']}'));
      await Future.delayed(const Duration(milliseconds: 200));

      // 2. Seed Trip
      await firestore.collection('trips').doc('trip-123').set(sampleTrip);
      setState(() => _logs.add('✅ Added Trip: ${sampleTrip['title']}'));
       await Future.delayed(const Duration(milliseconds: 200));

      // 3. Seed Booking
      await firestore.collection('bookings').doc('booking-123').set(sampleBooking);
      setState(() => _logs.add('✅ Added Booking: booking-123'));
       await Future.delayed(const Duration(milliseconds: 200));

      // 4. Seed Chat Metadata
      await firestore
          .collection('chats') // Note: Realtime DB usually better for chats, but using Firestore for seed demo as per some patterns
          .doc(sampleChatMetadata['chatId'] as String)
          .set(sampleChatMetadata); // Assuming Firestore structure for now or just generic object
      
      // Note: If using Realtime DB for chats, we'd use FirebaseDatabase.instance
      // keeping simple for this lite seed to mainly enable the Agency Dashboard flows
      
      setState(() {
        _status = 'Lite Seed Complete!';
        _isSeeding = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isSeeding = false;
        _logs.add('❌ Error: $e');
      });
    }
  }

  Future<void> _promoteToAgency() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _logs.add('❌ No user logged in'));
      return;
    }

    setState(() {
      _isSeeding = true;
      _status = 'Promoting user...';
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'role': 'agency',
        'agencyId': 'wanderlust-travels',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      setState(() {
        _status = 'User promoted!';
        _isSeeding = false;
        _logs.add('✅ User ${user.email} is now an AGENCY');
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isSeeding = false;
        _logs.add('❌ Error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        title: const Text('Seed Lite Data'),
        backgroundColor: AppColors.bgSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Quick Setup for Agency Dev',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 8),
            Text(
              'Use this screen to quickly populate connected data for Agency Dashboard testing.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            
            // ACTION BUTTONS
            _SeedButton(
              label: '1. Seed Lite Data',
              subtitle: 'Create Agency, Trip & Booking Docs',
              color: AppColors.primary,
              icon: Icons.cloud_upload_outlined,
              onPressed: _isSeeding ? null : _seedLiteData,
            ),
            const SizedBox(height: 16),
             _SeedButton(
              label: '2. Promote to Agency',
              subtitle: 'Make current user an Agency Owner',
              color: AppColors.accentYellow,
              icon: Icons.star_border,
              textColor: Colors.black,
              onPressed: _isSeeding ? null : _promoteToAgency,
            ),

            const SizedBox(height: 32),
            
            // LOGS
            if (_status.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(_status, style: const TextStyle(color: AppColors.textPrimary)),
              ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: ListView.builder(
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeedButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final VoidCallback? onPressed;
  final Color color;
  final IconData icon;
  final Color textColor;

  const _SeedButton({
    required this.label,
    required this.subtitle,
    required this.onPressed,
    required this.color,
    required this.icon,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 28),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.h3.copyWith(
                  color: textColor,
                  fontSize: 18,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
