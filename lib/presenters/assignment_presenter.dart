import '../models/assignment_model.dart';

class AssignmentPresenter {
    final List<Assignment> _assignments = [];

    List<Assignment> get assignments => _assignments;

    Future<void> loadAssignments() async{
      final fetched = await Assignment.fetchAssignments();
      _assignments..clear()..addAll(fetched);
    }
    
    Future<void> addAssignment(String title, String courseName, {DateTime? dateTime}) async {
      await Assignment.addAssignment(title, courseName, dateTime: dateTime);
      _assignments.add(Assignment(title: title, dateTime: dateTime, courseName: courseName,));
    }


    Future<void> toggleCompleted(int index) async {
        await Assignment.updateCompletionStatus(index, _assignments);
        _assignments[index].isCompleted = !_assignments[index].isCompleted;
    }
}