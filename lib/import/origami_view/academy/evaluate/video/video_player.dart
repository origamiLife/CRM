import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../../../import.dart';
import '../../academy.dart';
import '../curriculum/curriculum.dart';
import '../evaluate_module.dart';

class NetworkVideoPlayer extends StatefulWidget {
  NetworkVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.employee,
    required this.academy,
    required this.Authorization,
    required this.topic,
    required this.learning_seq,
    required this.courseId,
  });
  final String videoUrl;
  final Employee employee;
  final AcademyRespond academy;
  final String Authorization;
  final Topic topic;
  final String learning_seq;
  final String courseId;

  @override
  _NetworkVideoPlayerState createState() => _NetworkVideoPlayerState();
}

class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  Duration _startTime = const Duration(milliseconds: 5568);
  Duration _currentPosition = Duration.zero;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  bool _isFullScreen = false;
  bool iconStop = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _begin(widget.topic.topicDuration);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.landscapeRight]);

    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _videoPlayerController
            ..seekTo(_startTime)
            ..play();
        });
        _startHideControlsTimer();
      });
    _videoPlayerController.addListener(_videoListener);
  }

  void _videoListener() {
    if (_videoPlayerController.value.isPlaying) {
      setState(() {
        _currentPosition = _videoPlayerController.value.position;
        Timer(Duration(seconds: 5), () {
          fetchStatus(_currentPosition.inMilliseconds);
        });
        print('start - stop : ${_currentPosition.inMilliseconds}');
        iconStop = false;
      });
    } else {
      iconStop = true;
    }
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) {
      _startHideControlsTimer();
    } else {
      _hideControlsTimer?.cancel();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
        // stop = false;
      });
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  void _changeSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _videoPlayerController.setPlaybackSpeed(speed);
    });
  }

  void _begin(String topicDuration) {
    String time = topicDuration;
// ใช้ regex ดึงตัวเลขจาก h, m, s
    final regex = RegExp(r'(\d+)h (\d+)m (\d+)s');
    final match = regex.firstMatch(time);

    if (match != null) {
      int hours = int.parse(match.group(1)!);
      int minutes = int.parse(match.group(2)!);
      int seconds = int.parse(match.group(3)!);

      // กำหนดค่า Duration
      _startTime = Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      );

      print(_startTime); // ✅ แสดงค่า Duration
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _hideControlsTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _videoPlayerController.removeListener(_videoListener);
    fetchStatus(_currentPosition.inMilliseconds);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop) fetchStatus(_currentPosition.inMilliseconds);
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: GestureDetector(
              onTap: _toggleControls,
              child: Center(
                child: _videoPlayerController.value.isInitialized
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: Center(
                                child: VideoPlayer(_videoPlayerController)),
                          ),
                          Container(
                              color: (_showControls || iconStop == true)
                                  ? Colors.black38
                                  : Colors.transparent),
                          if (_showControls || iconStop == true)
                            Center(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _videoPlayerController.value.isPlaying
                                        ? _videoPlayerController.pause()
                                        : _videoPlayerController.play();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Icon(
                                    _videoPlayerController.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 54,
                                  ),
                                ),
                              ),
                            ),
                          if (_showControls || iconStop == true)
                            Positioned(
                              top: 10,
                              left: 20,
                              right: 20,
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EvaluateModule(
                                                    employee: widget.employee,
                                                    academy: widget.academy,
                                                    Authorization:
                                                        widget.Authorization,
                                                    selectedPage:1,
                                                  ))),
                                      child: Icon(Icons.keyboard_arrow_down,
                                          color: Colors.white, size: 28)),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${widget.topic.topicName}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_showControls) _buildControls(),
                        ],
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          )),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 0,
      left: 20,
      right: 20,
      child: Row(
        children: [
          Text(
            '${_formatDuration(_videoPlayerController.value.position)}  ',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          Flexible(
              child: VideoProgressIndicator(_videoPlayerController,
                  allowScrubbing: true)),
          Text(
            ' - ${_formatDuration(_videoPlayerController.value.duration)}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          PopupMenuButton<double>(
            icon: Icon(Icons.speed, color: Colors.white, size: 18),
            onSelected: _changeSpeed,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 0.25,
                  child: Text(
                    "0.25x",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
              PopupMenuItem(
                  value: 0.5,
                  child: Text(
                    "0.5x",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
              PopupMenuItem(
                  value: 0.75,
                  child: Text(
                    "0.75x",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
              PopupMenuItem(
                  value: 1.0,
                  child: Text(
                    "Normal",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
              PopupMenuItem(
                  value: 1.25,
                  child: Text(
                    "1.25x",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
              PopupMenuItem(
                  value: 1.5,
                  child: Text(
                    "1.5x",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
              PopupMenuItem(
                  value: 1.75,
                  child: Text(
                    "1.75x",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
              PopupMenuItem(
                  value: 2.0,
                  child: Text(
                    "2.0x",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )),
            ],
          ),
          InkWell(
            onTap: _toggleFullScreen,
            child: Icon(
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchStatus(int videoViewedInMillisec) async {
    final uri = Uri.parse("$host/api/origami/academy/save.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'academy_id': widget.academy.academy_id,
          'academy_type': widget.academy.academy_type,
          'course_id': widget.courseId,
          'topic_id': widget.topic.topicId,
          'topic_no': widget.topic.topicNo,
          'topic_option': widget.topic.topicOption,
          'topic_item': widget.topic.topicItem,
          'learning_seq': widget.learning_seq,
          'video_viewed': '$videoViewedInMillisec',
          'video_duration': widget.topic.topicDuration,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Status Response: $jsonResponse');
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    }
  }
}
