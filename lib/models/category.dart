class Category {
  final String name;
  final bool isLocked;
  final List<String> questions;
  final List<String> challenges;

  Category({
    required this.name,
    this.isLocked = false,
    this.questions = const [],
    this.challenges = const []
  });
}
