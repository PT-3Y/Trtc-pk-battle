import 'package:socialv/models/common_models/common_message_response.dart';
import 'package:socialv/models/lms/course_list_model.dart';
import 'package:socialv/models/lms/course_review_model.dart';
import 'package:socialv/models/lms/lesson_model.dart';
import 'package:socialv/models/lms/lms_order_model.dart';
import 'package:socialv/models/lms/lms_payment_model.dart';
import 'package:socialv/models/lms/quiz_model.dart';
import 'package:socialv/models/lms/start_quiz_model.dart';
import 'package:socialv/network/network_utils.dart';
import 'package:socialv/utils/app_constants.dart';

Future<List<CourseListModel>> getCourseList({int page = 1, bool myCourse = false, String? status, int? categoryId}) async {
  Iterable it = [];
  if (myCourse) {
    it = await handleResponse(await buildHttpResponse('${APIEndPoint.courses}?learned=true&course_filter=$status&page=$page&per_page=$PER_PAGE'));
  } else if (categoryId != null) {
    it = await handleResponse(await buildHttpResponse('${APIEndPoint.courses}?category=$categoryId&page=$page&per_page=$PER_PAGE'));
  } else {
    it = await handleResponse(await buildHttpResponse('${APIEndPoint.courses}?page=$page&per_page=$PER_PAGE'));
  }
  return it.map((e) => CourseListModel.fromJson(e)).toList();
}

Future<CourseListModel> getCourseById({required int courseId}) async {
  return CourseListModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.courses}/$courseId')));
}

Future<CourseReviewModel> getCourseReviews({required int courseId}) async {
  return CourseReviewModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.courseReview}/$courseId')));
}

Future<LessonModel> getLessonById({required int lessonId}) async {
  return LessonModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.lessons}/$lessonId')));
}

Future<CommonMessageResponse> finishLesson({required int lessonId}) async {
  Map request = {"id": lessonId};

  return CommonMessageResponse.fromJson(await handleResponse(
    await buildHttpResponse(APIEndPoint.finishLessons, request: request, method: HttpMethod.POST),
  ));
}

Future<QuizModel> getQuizById({required int quizId}) async {
  return QuizModel.fromJson(await handleResponse(await buildHttpResponse('${APIEndPoint.quiz}/$quizId')));
}

Future<CommonMessageResponse> enrollCourse({required int courseId}) async {
  Map request = {"id": courseId};

  return CommonMessageResponse.fromJson(await handleResponse(
    await buildHttpResponse(APIEndPoint.enrollCourse, request: request, method: HttpMethod.POST),
  ));
}

Future<CommonMessageResponse> retakeCourse({required int courseId}) async {
  Map request = {"id": courseId};

  return CommonMessageResponse.fromJson(await handleResponse(
    await buildHttpResponse(APIEndPoint.retakeCourse, request: request, method: HttpMethod.POST),
  ));
}

Future<StartQuizModel> startQuiz({required int quizId}) async {
  Map request = {"id": quizId};
  return StartQuizModel.fromJson(await handleResponse(
    await buildHttpResponse(APIEndPoint.startQuiz, method: HttpMethod.POST, request: request),
  ));
}

Future<QuizModel> finishQuiz({required Map request}) async {
  return QuizModel.fromJson(await handleResponse(await buildHttpResponse(APIEndPoint.finishQuiz, request: request, method: HttpMethod.POST)));
}

Future<CommonMessageResponse> finishCourse({required int courseId}) async {
  Map request = {"id": courseId};

  return CommonMessageResponse.fromJson(await handleResponse(
    await buildHttpResponse(APIEndPoint.finishCourse, request: request, method: HttpMethod.POST),
  ));
}

Future<CommonMessageResponse> submitCourseReview({required int courseId, required int rating, required String title, required String content}) async {
  Map request = {"id": courseId, "rate": rating, "title": title, "content": content};

  return CommonMessageResponse.fromJson(await handleResponse(
    await buildHttpResponse(APIEndPoint.submitCourseReview, request: request, method: HttpMethod.POST),
  ));
}

Future<List<LmsPaymentModel>> getLmsPayments() async {
  Iterable it = await handleResponse(await buildHttpResponse(APIEndPoint.lmsPayments));

  return it.map((e) => LmsPaymentModel.fromJson(e)).toList();
}

Future<LmsOrderModel> lmsPlaceOrder({
  required List<int> courseIds,
  required double subTotal,
  required double total,
  required String paymentMethod,
  String? notes,
}) async {
  Map request = {
    "course_ids": courseIds,
    "subtotal": subTotal,
    "total": total,
    "payment_method": paymentMethod,
    "customer_note": notes,
  };

  return LmsOrderModel.fromJson(await handleResponse(
    await buildHttpResponse(APIEndPoint.lmsPlaceOrder, request: request, method: HttpMethod.POST),
  ));
}
