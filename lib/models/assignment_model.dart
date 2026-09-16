class Assignment {
    final String title;
    bool isCompleted;
    final DateTime? dateTime;
    Assignment({
        required this.title,
        this.dateTime,
        this.isCompleted = false,
    });
}