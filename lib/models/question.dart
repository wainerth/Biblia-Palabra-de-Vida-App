class Question {
  final String id;
  final String question;
  final String difficulty;
  final LevelQuestion level;
  final int status;
  final bool isOrdering;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.question,
    required this.difficulty,
    required this.level,
    required this.status,
    required this.answers,
    required this.isOrdering,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    // List<Answer> listAnswer = json['answers'].map((answer) =>  Answer.fromJson(answer) );
    return Question(
      id: json['id'],
      question: json['question'],
      difficulty: json['difficulty'],
      level: LevelQuestion.fromJson(json['level']),
      status: json['status'],
      answers: (json['answers'] as List).map((e) =>
       Answer.fromJson(e)).toList(), 
      isOrdering: json['isOrdering'],
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
  final int? orderInAnswer;
  final int? correctOrder;
  String? option;
  final int status;

  Answer(  {
    required this.id,
    required this.answer,
    required this.isCorrect,
    required this.questionId,
    this.orderInAnswer = 0,
    this.correctOrder = 0,
    required this.status,
    this.option = '',
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answer: json['answer'],
      isCorrect: json['isCorrect'],
      questionId: json['questionId'],
      orderInAnswer: json['orderInAnswer'] ?? 0,
      correctOrder: json['correctOrder'] ?? 0,
      status: json['status'],
      option: json['option'] ?? '',
    );
  }
}