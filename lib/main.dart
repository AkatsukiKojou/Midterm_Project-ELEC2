import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _todoList = [];
  Color _backgroundColor = Colors.white;
  AudioPlayer _player = AudioPlayer();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _addToDo() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _todoList.add(_controller.text);
        _controller.clear();
      }
    });
  }

  void _playMusic(String asset) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(asset));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void _stopMusic() async {
    try {
      await _player.stop();
    } catch (e) {
      print("Error stopping audio: $e");
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeBackgroundSwipeVertical(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity != null) {
        if (details.primaryVelocity! > 0) {
          _backgroundColor = Colors.blue; // Swipe Down
        } else if (details.primaryVelocity! < 0) {
          _backgroundColor = Colors.red; // Swipe Up
        }
      }
    });
  }

  void _changeBackgroundSwipeHorizontal(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity != null) {
        if (details.primaryVelocity! > 0) {
          _backgroundColor = Colors.green; // Swipe Right
        } else if (details.primaryVelocity! < 0) {
          _backgroundColor = Colors.orange; // Swipe Left
        }
      }
    });
  }

  Widget _buildTodoScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Enter task",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addToDo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Add Task", style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _todoList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title:
                        Text(_todoList[index], style: TextStyle(fontSize: 18)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundScreen() {
    return GestureDetector(
      onVerticalDragEnd: _changeBackgroundSwipeVertical,
      onHorizontalDragEnd: _changeBackgroundSwipeHorizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: double.infinity,
        width: double.infinity,
        color: _backgroundColor,
        alignment: Alignment.center,
        child: Text(
          "Swipe Up, Down, Left, or Right to Change Background",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMusicScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Icon(Icons.music_note, size: 100, color: Colors.deepPurple),
        ),
        Text("Play Music",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _playMusic("coldplay.mp3"),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: Text("Coldplay", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () => _playMusic("salamin.mp3"),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: Text("Salamin", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _stopMusic,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("Stop Music", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      _buildTodoScreen(),
      _buildBackgroundScreen(),
      _buildMusicScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("ELEC-2 Midterm Project"),
        backgroundColor: Colors.deepPurple,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
        selectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "To-Do List"),
          BottomNavigationBarItem(
              icon: Icon(Icons.color_lens), label: "Background"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Music"),
        ],
      ),
    );
  }
}
