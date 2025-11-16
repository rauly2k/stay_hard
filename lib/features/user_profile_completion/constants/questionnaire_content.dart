import '../data/models/questionnaire_models.dart';

/// The 6 finalized program-matching questions for StayHard v2 onboarding.
/// These metaphorical, action-oriented questions provide rich data for AI analysis.
final List<QuestionnaireQuestion> programQuestions = [
  // Question 1: Life Chapter Title
  const QuestionnaireQuestion(
    id: 'chapter_title',
    question: 'If your life was a book, what would you title the current chapter?',
    type: QuestionType.singleChoice,
    options: [
      'Forging the Hero',
      'The Great Reset',
      'Reclaiming the Narrative',
      'Building from the Ashes',
      'The Ascent',
      'Declaring War on Mediocrity',
    ],
  ),

  // Question 2: Future Vision
  const QuestionnaireQuestion(
    id: 'future_vision',
    question: 'What vision for your future is driving you to start today?',
    type: QuestionType.singleChoice,
    options: [
      'To become the strongest version of myself, period.',
      'To build a legacy that outlasts me.',
      'To conquer my goals and build my vision.',
      'To live a life without what-ifs or regrets.',
      'To inspire others through my own transformation.',
    ],
  ),

  // Question 3: Accomplishment Feeling
  const QuestionnaireQuestion(
    id: 'accomplishment_feeling',
    question: 'Think back. When was the last moment you felt a true sense of accomplishment?',
    type: QuestionType.singleChoice,
    options: [
      'The feeling is still fresh and motivating me.',
      'It\'s a recent, but fading memory.',
      'It feels like a distant echo from the past.',
      'I have to search hard to remember the feeling.',
      'I\'m here because I need to feel it again.',
    ],
  ),

  // Question 4: Morning Mindset
  const QuestionnaireQuestion(
    id: 'morning_mindset',
    question: 'When you wake up, what\'s the first thing on your mind that pushes you to start?',
    type: QuestionType.singleChoice,
    options: [
      'The opportunity to compete and win the day.',
      'The pressure to perform and not fall behind.',
      'The promises I\'ve made to myself.',
      'The fear of staying stuck where I am.',
      'It feels more like a battle than a push.',
    ],
  ),

  // Question 5: Current Struggles (Multi-Choice)
  const QuestionnaireQuestion(
    id: 'current_struggles',
    question: 'Which of these feelings best describes your current struggle?',
    subtitle: 'Select up to 3 that apply',
    type: QuestionType.multiChoice,
    options: [
      'Running on empty with no fuel left',
      'Fighting an invisible, internal battle',
      'Carrying a weight I can\'t put down',
      'Lost in a fog without a map',
      'Adrift at sea without an anchor',
      'Watching my own life from the sidelines',
    ],
  ),

  // Question 6: Age Group
  const QuestionnaireQuestion(
    id: 'age_group',
    question: 'What is your age group?',
    type: QuestionType.singleChoice,
    options: [
      '13 - 17',
      '18 - 24',
      '25 - 34',
      '35 - 44',
      '45 - 54',
      '55+',
    ],
  ),
];
