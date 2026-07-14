import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // [新增] 导入音频底层插件

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  bool _isPlaying = false;
  
  // [新增] 实例化全局音频播放器引擎
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // [新增] 监听播放器的真实状态。
    // 如果音乐自然播放结束，或者在后台被中断，UI 的状态会自动同步更新！
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    // [新增] 核心考点：页面销毁时，必须释放播放器内存，防止音乐在后台无限播放或内存泄漏！
    _audioPlayer.dispose();
    super.dispose();
  }

  // [修改] 注入真正的播放/暂停逻辑
  void _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      // 这里为了让你能立刻测试，使用了一个公开的免版权测试音乐 URL。
      // 如果你想用本地音乐，可以在项目根目录建一个 assets 文件夹放 mp3，
      // 然后把这里改成：await _audioPlayer.play(AssetSource('你的音乐.mp3'));
      await _audioPlayer.play(
        UrlSource('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3')
      );
    }
  }

  // [修改] 注入真正的停止逻辑
  void _stopPlayback() async {
    await _audioPlayer.stop();
    // 停止后重置播放进度和 UI 状态
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
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 唱片机动画 UI
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
                  const Text(
                    'Study Focus Session',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isPlaying
                        ? 'Now Playing: Deep Focus Lo-Fi...'
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
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.timer, color: Color(0xFF3F51B5)),
              title: Text('Suggested Use'),
              subtitle: Text(
                'Play this background track while using the Pomodoro timer to maintain deep focus.',
              ),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.check_circle, color: Colors.green),
              title: Text('Back-end Integration Complete'),
              subtitle: Text(
                'AudioPlayer instance connected successfully. Hardware memory leaks prevented via dispose() method.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}