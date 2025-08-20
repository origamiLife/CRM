import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProjectListPage extends StatefulWidget {
  final String compId;
  final String empId;
  const ProjectListPage({super.key, required this.compId, required this.empId});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  List<dynamic> projects = [];
  int pageIndex = 1;
  bool isLoading = false;
  bool hasMore = true;
  String searchText = "";

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProjects(); // โหลดครั้งแรก
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoading && hasMore) {
        fetchProjects();
      }
    }
  }

  Future<void> fetchProjects({bool reset = false}) async {
    if (isLoading) return;
    setState(() => isLoading = true);

    if (reset) {
      pageIndex = 1;
      projects.clear();
      hasMore = true;
    }

    final uri = Uri.parse("https://your-domain.com/api/origami/crm/project/get_project.php");

    final response = await http.post(uri, body: {
      'comp_id': widget.compId,
      'emp_id': widget.empId,
      'index': pageIndex.toString(),
      'search': searchText,
    }, headers: {
      "Authorization": "Bearer YOUR_TOKEN_HERE" // ต้องส่ง token ตาม PHP เช็ค
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == true) {
        final List<dynamic> newProjects = data['project_data'] ?? [];

        setState(() {
          pageIndex++;
          if (newProjects.length < 20) {
            hasMore = false;
          }
          projects.addAll(newProjects);
        });
      }
    } else {
      debugPrint("Error: ${response.statusCode}");
    }

    setState(() => isLoading = false);
  }

  void _onSearch() {
    setState(() {
      searchText = _searchController.text;
    });
    fetchProjects(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Project List")),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "ค้นหาโครงการ...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _onSearch,
                ),
              ],
            ),
          ),

          // Project List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: projects.length + 1,
              itemBuilder: (context, index) {
                if (index < projects.length) {
                  final project = projects[index];
                  return ListTile(
                    title: Text(project['project_name'] ?? "ไม่มีชื่อ"),
                    subtitle: Text("ID: ${project['project_id']}"),
                  );
                } else {
                  return hasMore
                      ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                      : const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text("ไม่มีข้อมูลเพิ่มเติม")),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
