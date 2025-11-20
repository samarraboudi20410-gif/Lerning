import '../models/course_model.dart';

class CourseController {
  List<Course> courses = [
    Course(title: "Cours 1", type: "Texte"),
    Course(title: "Cours 2", type: "Vidéo"),
    Course(title: "Cours 3", type: "Quiz"),
  ];

  List<Course> getAllCourses() {
    return courses;
  }
}
