class Question {
  final String id;
  final String question;
  final String difficulty;
  // final LevelQuestion level;
  final int status;
  final bool isOrdering;
  final List<Answer> answers;
  final List<Answer>? timeline;

  Question({
    required this.id,
    required this.question,
    required this.difficulty,
    // required this.level,
    required this.status,
    required this.answers,
    this.timeline,
    required this.isOrdering,
  });

  Question copyWith({String? id, String? question}) {
    return Question(
        id: id ?? this.id,
        question: question ?? this.question,
        answers: answers,
        isOrdering: isOrdering,
        status: status,
        timeline: timeline,
        difficulty: difficulty);
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    List<Answer> listAnswer = [];
    if (json['isOrdering']) {
      listAnswer =
          (json['timeline'] as List).map((e) => Answer.fromJson(e)).toList();
    } else {
      listAnswer =
          (json['answers'] as List).map((e) => Answer.fromJson(e)).toList();
    }
    return Question(
      id: json['id'],
      question: json['question'],
      difficulty: json['difficulty'],
      status: json['status'] ?? 1,
      answers: listAnswer,
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
  final int? correctOrder;
  String? option;
  final int status;

  Answer({
    required this.id,
    required this.answer,
    required this.isCorrect,
    required this.questionId,
    this.correctOrder = 0,
    required this.status,
    this.option = '',
  });

  Answer copyWith({
    String? answer
  }){
    return Answer(
      id: id, 
      answer: answer ?? this.answer, 
      isCorrect: isCorrect, 
      questionId: questionId, 
      status: status);
  }


  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answer: json['answer'],
      isCorrect: json['isCorrect'] ?? false,
      questionId: json['questionId'],
      correctOrder: json['correctOrder'] ?? 0,
      status: json['status'] ?? 1,
      option: json['option'] ?? '',
    );
  }
}

class TimeLine {
  final String id;
  final String eventText;
  final String questionId;
  final int? correctOrder;
  String? option;
  final int status;

  TimeLine({
    required this.id,
    required this.eventText,
    required this.questionId,
    this.correctOrder = 0,
    required this.status,
    this.option = '',
  });

  factory TimeLine.fromJson(Map<String, dynamic> json) {
    return TimeLine(
      id: json['id'],
      eventText: json['eventText'],
      questionId: json['questionId'],
      correctOrder: json['correctOrder'] ?? 0,
      status: json['status'],
      option: json['option'] ?? '',
    );
  }
}
