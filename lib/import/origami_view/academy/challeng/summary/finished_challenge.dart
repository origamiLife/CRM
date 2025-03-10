import 'package:http/http.dart' as http;

import '../../../../import.dart';
import '../challenge_menu.dart';

class FinishedChallenge extends StatefulWidget {
  FinishedChallenge({
    super.key,
    required this.employee,
    required this.Authorization,
    required this.challenge,
  });
  final Employee employee;
  final String Authorization;
  final GetChallenge challenge;

  @override
  _FinishedChallengeState createState() => _FinishedChallengeState();
}

class _FinishedChallengeState extends State<FinishedChallenge> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder<List<HistoryChallenge>>(
          future: fetchHistoryChallenge(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFFFF9900)),
                    SizedBox(
                        height: 12),
                    Text(
                      '$loadingTS...',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error,
                        color: Colors.red, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final history = snapshot.data!;
              return _tableWidget(history);
            } else {
              return const Center(
                child: Text(
                  'No data available.',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF555555),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _tableWidget(List<HistoryChallenge> historyList) {
    return ListView.builder(
      itemCount: historyList.length,
      itemBuilder: (context, index) {
        final history = historyList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF1F7F0),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Color(0xFF555555), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 24,
                  horizontalMargin: 0,
                  headingRowHeight: 40,
                  dataRowHeight: 40,
                  columns: <DataColumn>[
                    _buildDataColumn('$nameTS'),
                    _buildDataColumn('$correctAnswerTS'),
                    _buildDataColumn('$scoreTS'),
                    _buildDataColumn('$startTS'), // Capitalize for consistency
                    _buildDataColumn('$endTS'),
                    _buildDataColumn('$timeUsedTS'),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 150),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                history.challenge_name,
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontSize: (isAndroid || isIPhone)?16:24,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              // No need for ConstrainedBox if data is short
                              history.correct, // Consider making this dynamic if available
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone)?16:24,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              history.used_point, // Consider making this dynamic if available
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone)?16:24,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              history.challenge_start,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone)?16:24,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              history.challenge_end,
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone)?16:24,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              history.challenge_duration, // Consider making this dynamic if available
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone)?16:24,
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  DataColumn _buildDataColumn(String label) {
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Arial',
          fontSize: (isAndroid || isIPhone)?16:24,
          color: Color(0xFF555555),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Future<List<HistoryChallenge>> fetchHistoryChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/history-challenge.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> challengeJson = jsonResponse['challenge_data'];
        return challengeJson
            .map((json) => HistoryChallenge.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to load question data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching question data: $e');
      throw Exception('Error fetching question data: $e');
    }
  }
}

class HistoryChallenge {
  final String req_id;
  final String challenge_name;
  final String correct;
  final String used_point;
  final String challenge_start;
  final String challenge_end;
  final String challenge_duration;

  HistoryChallenge({
    required this.req_id,
    required this.challenge_name,
    required this.correct,
    required this.used_point,
    required this.challenge_start,
    required this.challenge_end,
    required this.challenge_duration,
  });

  factory HistoryChallenge.fromJson(Map<String, dynamic> json) {
    return HistoryChallenge(
      req_id: json['req_id'] ?? '',
      challenge_name: json['challenge_name'] ?? '',
      correct: json['correct'] ?? '0/0',
      used_point: json['used_point'] ?? '0',
      challenge_start: json['challenge_start'] ?? '',
      challenge_end: json['challenge_end'] ?? '',
      challenge_duration: json['challenge_duration'] ?? '00:00:00',
    );
  }
}
