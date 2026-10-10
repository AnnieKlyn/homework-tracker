import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';
import '../presenters/course_presenter.dart';
import '../widgets/add_fab.dart';
import '../widgets/cancel.dart';

class AssignmentListScreen extends StatefulWidget{
  const AssignmentListScreen({super.key});
  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _assignmentPresenter = AssignmentPresenter();
  final CoursePresenter _coursePresenter = CoursePresenter();

  bool _isLoading = true;
  String? _selectedCourseFilter;
  String? _newAssignmentCourse;
  List<String> _courseNames = [];
  @override
  void initState(){
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _assignmentPresenter.loadAssignments();
    await _coursePresenter.loadCourses();
    setState(() {
      _isLoading = false;
      _courseNames = _coursePresenter.courses.map((c) => c.name).toList();
    });
    
  }

void _showAddAssignmentDialog() {
  String newAssignmentTitle = '';
  DateTime? newAssignmentDate;
  _newAssignmentCourse = _courseNames.isNotEmpty ? _courseNames.first : null;
  
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Assignment'),
        
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter assignment title',
              ),
              onChanged: (value) => newAssignmentTitle = value,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value:_newAssignmentCourse,
              items:
                _courseNames.map((name) {
                  return DropdownMenuItem(value: name, child: Text(name));
                }).toList(),
                onChanged:
                  (value) => setState(() => _newAssignmentCourse = value),
              ),
            ],
        ),
            actions: [
            CancelButton(),
            TextButton(
              onPressed: (){
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    setState(() {
                      newAssignmentDate = selectedDate;
                    });
                  }
                });
              },
              child: const Text('Select Due Date'),
          ),
          TextButton(
            onPressed: () async {
              if (newAssignmentTitle.trim().isNotEmpty &&
                  _newAssignmentCourse != null) {
                await _assignmentPresenter.addAssignment(newAssignmentTitle.trim(), _newAssignmentCourse!, dateTime: newAssignmentDate);
                setState(() {});
              Navigator.pop(context);
                  }
            },
            child: const Text('Add'),
          ),
        ],
      );
    },
  );
}



@override
  Widget build(BuildContext context) {
    final assignments = _assignmentPresenter.assignments;
    final displayedAssignments =
        _selectedCourseFilter == null
            ? assignments
            : assignments.where((a) => a.courseName == _selectedCourseFilter).toList();
    return Scaffold(
      appBar:AppBar(
        title: const Text('Assignments'),
        actions: [
          if (_courseNames.isNotEmpty)
            DropdownButton<String>(
              hint: const Text(
                'Filter by course',
                style: TextStyle(color: Colors.white),
              ),
              dropdownColor: Colors.blue,
              value: _selectedCourseFilter,
              onChanged: (value) {
                setState(() {
                  _selectedCourseFilter = value;
                });
              },
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Courses'),
                ),
                ..._courseNames.map(
                  (name) => DropdownMenuItem(value: name, child: Text(name)),
                ),
              ],
            ),
        ],
      ),
      body: 
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: displayedAssignments.length,
                itemBuilder: (context, index) {
                  final assignment = displayedAssignments[index];
                  return CheckboxListTile(
                    title: Text("${assignment.title} Due: ${assignment.dateTime}"),
                    subtitle: Text("Course: ${assignment.courseName}"),
                    value: assignment.isCompleted,
                    onChanged: (_) async {
                      await _assignmentPresenter.toggleCompleted(index);
                      setState(() {});
                    },
                  );
                },
              ),
    floatingActionButton: AddFAB(onPressed: _showAddAssignmentDialog),
    );
  }
}