class TaskRequestBody {
  int offset;
  int limit;
  String sortBy;
  bool isAsc;
  String status;

  TaskRequestBody({
    required this.offset,
    required this.limit,
    required this.sortBy,
    required this.isAsc,
    required this.status,
  });
}
