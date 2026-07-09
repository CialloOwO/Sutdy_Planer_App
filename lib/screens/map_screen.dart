import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  Widget _locationCard(String title, String subtitle, IconData icon) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8EAF6),
          child: Icon(icon, color: const Color(0xFF3F51B5)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.place, color: Color(0xFF3F51B5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Locations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAF6),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF3F51B5), width: 1.2),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _MapPlaceholderPainter()),
                ),
                const Center(
                  child: Icon(
                    Icons.location_on,
                    color: Color(0xFF3F51B5),
                    size: 52,
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Map container ready for OpenStreetMap integration',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recommended Study Spots',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _locationCard(
            'Campus Library',
            'Quiet study area for revision and assignments.',
            Icons.local_library,
          ),
          _locationCard(
            'Study Lounge',
            'Good place for group discussion and project meetings.',
            Icons.groups,
          ),
          _locationCard(
            'Computer Lab',
            'Useful for Flutter development and testing.',
            Icons.computer,
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Back-end member: replace this placeholder with flutter_map, OpenStreetMap tiles, fixed coordinates, and optional location permission.',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.25),
      Offset(size.width * 0.9, size.height * 0.7),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.85),
      Offset(size.width * 0.75, size.height * 0.15),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.05, size.height * 0.55),
      Offset(size.width * 0.95, size.height * 0.48),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
