import 'package:flutter/material.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  bool _isPlaying = false;

  void _togglePlayback() {
    setState(() => _isPlaying = !_isPlaying);
  }

  void _stopPlayback() {
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Music')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: const Color(0xFFE8EAF6),
                    child: Icon(
                      _isPlaying ? Icons.equalizer : Icons.music_note,
                      color: const Color(0xFF3F51B5),
                      size: 58,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Study Focus Session',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isPlaying
                        ? 'Preview state: music is playing'
                        : 'Preview state: music is paused',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _togglePlayback,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        label: Text(_isPlaying ? 'Pause' : 'Play'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _stopPlayback,
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.timer, color: Color(0xFF3F51B5)),
              title: Text('Suggested Use'),
              subtitle: Text(
                'Use this page during study sessions to play background music or a learning video.',
              ),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.handyman, color: Color(0xFF3F51B5)),
              title: Text('Back-end Member Area'),
              subtitle: Text(
                'Connect audioplayers or video_player here, configure assets in pubspec.yaml, and replace the preview state with real playback events.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
