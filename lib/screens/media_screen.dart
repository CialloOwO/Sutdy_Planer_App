import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentIndex = 0;
  
  // 这里已经替换为你队友上传的真实歌曲数据
  final List<Map<String, String>> _playlist = [
    {
      'title': 'Glitter & Gold',
      'subtitle': 'Barns Courtney',
      'path': 'Barns Courtney - Glitter & Gold.mp3', 
    },
    {
      'title': 'Running In The Dark',
      'subtitle': 'MONKEY MAJIK, 塞壬唱片-MSR',
      'path': 'MONKEY MAJIK,塞壬唱片-MSR - Running In The Dark.mp3',
    },
    {
      'title': 'Just Like Fire',
      'subtitle': 'P!nk',
      'path': 'P!nk - Just Like Fire (From the Original Motion Picture Alice Through The Looking Glass).mp3',
    },
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    // 监听当前歌曲播放完毕，自动播放下一首
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        _playNext();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // 播放/暂停当前选中的歌曲
  void _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // 使用 AssetSource 播放本地 assets 文件夹中的资源
      await _audioPlayer.play(AssetSource(_playlist[_currentIndex]['path']!));
    }
  }

  // 停止播放
  void _stopPlayback() async {
    await _audioPlayer.stop();
    setState(() => _isPlaying = false);
  }

  // 点击歌单切歌
  void _playSong(int index) async {
    if (_currentIndex == index && _isPlaying) return; // 如果点的就是正在播放的，不作反应
    
    await _audioPlayer.stop();
    setState(() {
      _currentIndex = index;
    });
    await _audioPlayer.play(AssetSource(_playlist[_currentIndex]['path']!));
  }

  // 自动播放下一首
  void _playNext() async {
    int nextIndex = (_currentIndex + 1) % _playlist.length;
    _playSong(nextIndex);
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前正在播放的歌曲信息
    final currentSong = _playlist[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Focus Music')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 顶部播放器主卡片
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: _isPlaying ? const Color(0xFFC5CAE9) : const Color(0xFFE8EAF6),
                    child: Icon(
                      _isPlaying ? Icons.equalizer : Icons.music_note,
                      color: const Color(0xFF3F51B5),
                      size: 58,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 动态显示当前歌曲名称
                  Text(
                    currentSong['title']!,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isPlaying
                        ? 'Now Playing...'
                        : 'Ready to focus? Press Play.',
                    style: TextStyle(
                      color: _isPlaying ? const Color(0xFF3F51B5) : Colors.black54,
                      fontWeight: _isPlaying ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _togglePlayback,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        label: Text(_isPlaying ? 'Pause' : 'Play'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: _stopPlayback,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        icon: const Icon(Icons.stop),
                        label: const Text('Stop'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Playlist',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          
          // 动态生成歌单列表
          ..._playlist.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, String> song = entry.value;
            bool isSelected = _currentIndex == index;

            return Card(
              elevation: isSelected ? 2 : 0,
              color: isSelected ? const Color(0xFFE8EAF6) : Colors.white,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Icon(
                  isSelected && _isPlaying ? Icons.volume_up : Icons.music_note,
                  color: isSelected ? const Color(0xFF3F51B5) : Colors.grey,
                ),
                title: Text(
                  song['title']!,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFF3F51B5) : Colors.black87,
                  ),
                ),
                subtitle: Text(song['subtitle']!),
                trailing: isSelected 
                  ? const Icon(Icons.play_circle_filled, color: Color(0xFF3F51B5))
                  : null,
                onTap: () => _playSong(index), // 点击切歌
              ),
            );
          }),
        ],
      ),
    );
  }
}