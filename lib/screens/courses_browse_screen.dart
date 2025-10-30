import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../providers/user_provider.dart';
import 'lesson_screen.dart';

class CoursesBrowseScreen extends StatefulWidget {
  const CoursesBrowseScreen({Key? key}) : super(key: key);

  @override
  State<CoursesBrowseScreen> createState() => _CoursesBrowseScreenState();
}

class _CoursesBrowseScreenState extends State<CoursesBrowseScreen> {
  String? _selectedLanguageId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer2<CourseProvider, UserProvider>(
        builder: (context, courseProvider, userProvider, _) {
          if (courseProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Courses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._buildLanguageCourses(courseProvider, userProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildLanguageCourses(
    CourseProvider courseProvider,
    UserProvider userProvider,
  ) {
    return courseProvider.languages.map((language) {
      final course = courseProvider.getCourseForLanguage(language.languageId);
      if (course == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    language.flagEmoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        language.scriptType,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Modules',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._buildModuleList(
                    course,
                    courseProvider,
                    userProvider,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildModuleList(
    dynamic course,
    CourseProvider courseProvider,
    UserProvider userProvider,
  ) {
    final modules = courseProvider.getModulesForCourse(course.courseId);
    final userLevel = userProvider.userStats?.currentLevel ?? 1;

    return modules.map((module) {
      final isUnlocked = module.isUnlocked(userLevel);
      final lessons = courseProvider.getLessonsForModule(module.moduleId);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isUnlocked ? Colors.grey.shade300 : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isUnlocked ? Colors.white : Colors.grey.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.moduleName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${lessons.length} lessons',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isUnlocked)
                  Chip(
                    label: Text(
                      'Level ${module.unlockLevel}',
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.grey.shade200,
                  )
                else
                  const Icon(Icons.arrow_forward),
              ],
            ),
            if (isUnlocked && lessons.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LessonScreen(lesson: lesson),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text('Lesson ${index + 1}'),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      );
    }).toList();
  }
}
