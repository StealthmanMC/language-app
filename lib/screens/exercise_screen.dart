import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course_model.dart';
import '../models/exercise_model.dart';
import '../providers/progress_provider.dart';
import '../providers/course_provider.dart';

class ExerciseScreen extends StatefulWidget {
  final Lesson lesson;
  final List<String> exerciseIds;

  const ExerciseScreen({
    Key? key,
    required this.lesson,
    required this.exerciseIds,
  }) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  int _currentExerciseIndex = 0;
  String? _selectedAnswer;
  String? _textAnswer;
  bool? _isAnswerCorrect;

  Exercise? get _currentExercise {
    if (_currentExerciseIndex >= widget.exerciseIds.length) return null;
    return context
        .read<CourseProvider>()
        .getLesson(widget.exerciseIds[_currentExerciseIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showExitDialog();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Exercise ${_currentExerciseIndex + 1}/${widget.exerciseIds.length}'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showExitDialog,
          ),
        ),
        body: _isAnswerCorrect == null
            ? _buildExerciseContent()
            : _buildFeedback(),
      ),
    );
  }

  Widget _buildExerciseContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: (_currentExerciseIndex + 1) / widget.exerciseIds.length,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(Colors.blue.shade600),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Question',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Exercise ${_currentExerciseIndex + 1}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildExerciseTypeContent(),
          const SizedBox(height: 32),
          _buildSubmitButton(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildExerciseTypeContent() {
    // This is a placeholder - in full implementation, would load from exercise data
    return Column(
      children: [
        // Multiple choice example
        const Text(
          'Select the correct answer:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ..._buildMultipleChoiceOptions(),
      ],
    );
  }

  List<Widget> _buildMultipleChoiceOptions() {
    return ['Option 1', 'Correct Answer', 'Option 3', 'Option 4']
        .map((option) {
      final isSelected = _selectedAnswer == option;
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedAnswer = option;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? Colors.blue.shade50 : Colors.white,
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey.shade300,
                    ),
                    color: isSelected ? Colors.blue : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Text(option),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _selectedAnswer != null ? _submitAnswer : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('Submit Answer'),
    );
  }

  void _submitAnswer() {
    // Check if answer is correct
    bool isCorrect = _selectedAnswer == 'Correct Answer';

    setState(() {
      _isAnswerCorrect = isCorrect;
    });

    // Record attempt in progress provider
    context.read<ProgressProvider>().recordExerciseAttempt(
          exerciseId: widget.exerciseIds[_currentExerciseIndex],
          lessonId: widget.lesson.lessonId,
          userAnswer: _selectedAnswer ?? '',
          isCorrect: isCorrect,
          xpEarned: isCorrect ? 10 : 0,
        );
  }

  Widget _buildFeedback() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isAnswerCorrect! ? Colors.green.shade100 : Colors.red.shade100,
              ),
              child: Icon(
                _isAnswerCorrect! ? Icons.check : Icons.close,
                size: 40,
                color: _isAnswerCorrect! ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _isAnswerCorrect! ? 'Correct!' : 'Incorrect',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _isAnswerCorrect! ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _isAnswerCorrect! ? '+10 XP' : '+0 XP',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            if (!_isAnswerCorrect!) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Correct Answer:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Correct Answer',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _nextExercise,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _currentExerciseIndex < widget.exerciseIds.length - 1
                    ? 'Next Exercise'
                    : 'Finish Lesson',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextExercise() {
    if (_currentExerciseIndex < widget.exerciseIds.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _selectedAnswer = null;
        _textAnswer = null;
        _isAnswerCorrect = null;
      });
    } else {
      _completeLesson();
    }
  }

  Future<void> _completeLesson() async {
    final progressProvider = context.read<ProgressProvider>();

    // Check if lesson is complete (enough exercises answered)
    if (!progressProvider.isLessonComplete()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete more exercises to finish the lesson'),
        ),
      );
      return;
    }

    // In full implementation, would save to database here
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lesson completed! +${progressProvider.currentSessionXp} XP earned',
          ),
        ),
      );
    }
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Exercise?'),
        content: const Text('Your progress will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
