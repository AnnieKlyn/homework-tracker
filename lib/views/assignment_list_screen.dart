import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';



class AssignmentListScreen extends StatefulWidget{
  const AssignmentListScreen({super.key});
  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();

void _showAddAssignmentDialog() {
  String newAssignmentTitle = '';
  DateTime? newAssignmentDate;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add Assignment'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter assignment title'),
          onChanged: (value) {
            newAssignmentTitle = value;
          },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
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
            onPressed: () {
              if (newAssignmentTitle.trim().isNotEmpty) {
                if (newAssignmentDate != null) {
                  setState(() {
                    _presenter.addAssignment(newAssignmentTitle.trim(), dateTime: newAssignmentDate);
                  });
                } else {
                  setState(() {
                    _presenter.addAssignment(newAssignmentTitle.trim());
                  });
                } 
              }
              Navigator.pop(context);
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
    final assignments = _presenter.assignments;
    return Scaffold(
      appBar:AppBar(title: const Text('Assignments')),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final assignment = assignments[index];
          return CheckboxListTile(
            title: Text('${assignment.title} (Due: ${assignment.dateTime != null ? assignment.dateTime!.toLocal().toString().split(' ')[0] : 'No due date'})',
            style: assignment.isCompleted == true ? 
            TextStyle( decoration: TextDecoration.lineThrough,): TextStyle()),
            value: assignment.isCompleted,
            onChanged: (value) {
              setState(() {
                _presenter.toggleCompleted(index);
              });
            },
          );
        },        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssignmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}