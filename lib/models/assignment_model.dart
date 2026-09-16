class Assignment {
    final String title;
    bool isCompleted;
    final dateTime;
    Assignment({
        required this.title,
        required this.dateTime,
        this.isCompleted = false,
    });
}