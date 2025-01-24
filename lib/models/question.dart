class Question {
  final String id;
  final String question;
  final String difficulty;
  final LevelQuestion level;
  final int status;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.question,
    required this.difficulty,
    required this.level,
    required this.status,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      difficulty: json['difficulty'],
      level: LevelQuestion.fromJson(json['level']),
      status: json['status'],
      answers: (json['answers'] as List).map((e) => Answer.fromJson(e)).toList(),
    );
  }
}

class LevelQuestion {
  final int levelNumber;

  LevelQuestion({required this.levelNumber});

  factory LevelQuestion.fromJson(Map<String, dynamic> json) {
    return LevelQuestion(levelNumber: json['levelNumber']);
  }
}

class Answer {
  final String id;
  final String answer;
  final bool isCorrect;
  final String questionId;
  final int scoreForAnswer;
  final int orderInAnswer;
  String? option;
  final int status;

  Answer(  {
    required this.id,
    required this.answer,
    required this.isCorrect,
    required this.questionId,
    required this.scoreForAnswer,
    this.orderInAnswer = 0,
    required this.status,
    this.option = '',
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answer: json['answer'],
      isCorrect: json['isCorrect'],
      questionId: json['questionId'],
      scoreForAnswer: json['scoreForAnswer'],
      orderInAnswer: json['orderInAnswer'],
      status: json['status'],
      option: json['option'] ?? '',
    );
  }
}