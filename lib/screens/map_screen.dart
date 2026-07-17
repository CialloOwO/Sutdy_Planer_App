import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// 将 StatefulWidget 用于状态管理，以便我们可以使用 MapController 控制地图视角
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 地图控制器，用于在点击列表时移动地图
  final MapController _mapController = MapController();

  // 定义厦大马来西亚分校 (XMUM) 附近的几个学习点经纬度数据
  final List<Map<String, dynamic>> _studySpots = [
    {
      'title': 'Campus Library',
      'subtitle': 'Quiet study area for revision and assignments.',
      'icon': Icons.local_library,
      'location': const LatLng(2.8315, 101.7065), // 图书馆大概坐标
    },
    {
      'title': 'Study Lounge',
      'subtitle': 'Good place for group discussion and project meetings.',
      'icon': Icons.groups,
      'location': const LatLng(2.8322, 101.7058), // 讨论室大概坐标
    },
    {
      'title': 'Computer Lab',
      'subtitle': 'Useful for Flutter development and testing.',
      'icon': Icons.computer,
      'location': const LatLng(2.8310, 101.7072), // 机房大概坐标
    },
  ];

  // 队友设计的精致卡片 UI，这里添加了 onTap 点击事件
  Widget _locationCard(Map<String, dynamic> spot) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE8EAF6),
          child: Icon(spot['icon'] as IconData, color: const Color(0xFF3F51B5)),
        ),
        title: Text(spot['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(spot['subtitle'] as String),
        trailing: const Icon(Icons.place, color: Color(0xFF3F51B5)),
        // 核心交互：点击卡片时，让地图视角飞过去！
        onTap: () {
          _mapController.move(spot['location'] as LatLng, 18.0);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Viewing ${spot['title']} on map'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
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
          // 真正的地图容器
          Container(
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF3F51B5), width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            // 使用 ClipRRect 保证地图不会超出圆角边框
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  // 默认中心点：XMUM
                  initialCenter: const LatLng(2.8315, 101.7065),
                  initialZoom: 16.5,
                ),
                children: [
                  // OpenStreetMap 免费瓦片图层 (无需 API Key)
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.study_planner_app',
                  ),
                  // 将我们定义的 _studySpots 渲染为地图上的红点
                  MarkerLayer(
                    markers: _studySpots.map((spot) => Marker(
                      point: spot['location'] as LatLng,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Recommended Study Spots',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          
          // 使用循环动态生成点击卡片
          ..._studySpots.map((spot) => _locationCard(spot)),
        ],
      ),
    );
  }
}