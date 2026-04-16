class ResponseInitializedRegister {
  final bool success;
  final String message;
  final String userId;

  ResponseInitializedRegister({
    required this.success,
    required this.message,
    required this.userId,
  });

  factory ResponseInitializedRegister.fromJson(Map<String, dynamic> json) {
    return ResponseInitializedRegister(
        success: json['success'],
        message: json['message'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "userId": userId,
    };
  }
}

class VerificationResponse {
  final String userId;
  final bool showVerifyPinModal;

  VerificationResponse({
    required this.userId,
    required this.showVerifyPinModal,
  });
  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      userId: json['userId'],
      showVerifyPinModal: json['showVerifyPinModal'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'showVerifyPinModal': showVerifyPinModal,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'showVerifyPinModal': showVerifyPinModal,
    };
  }
}
