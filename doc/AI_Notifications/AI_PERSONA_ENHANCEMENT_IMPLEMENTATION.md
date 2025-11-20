# AI Persona Enhancement Implementation Plan

## Executive Summary

This document outlines the high-level architecture for enhancing the existing AI notification system in StayHard to incorporate the comprehensive 8-persona framework with detailed personality traits, reference materials, and context-aware messaging as described in `ai_notif_sources.md`.

**Goal**: Transform the current basic persona system into a rich, context-aware AI notification engine that generates highly personalized messages using LLM integration with persona-specific training data.

**Approach**: User selects one default persona that generates dynamic, contextually relevant messages across all intervention categories.

---

## Current System Analysis

### Existing Components
- **8 Persona Types** (AIArchetype enum): Already defined but with basic personality descriptions
- **AI Message Generator**: Uses Gemini API with simple prompts
- **Intervention Categories**: 7 categories (morning motivation, missed habit recovery, low morale boost, streak celebration, evening check-in, comeback support, progress insights)
- **Notification Context**: Rich context snapshot (streaks, completion rate, pending habits, time of day)
- **User Preferences**: Per-category settings with quiet hours and daily limits

### Current Limitations
1. **Shallow Persona Definition**: Basic personality descriptions lack depth
2. **Generic Prompts**: LLM prompts don't leverage persona-specific reference materials (books, figures, quotes)
3. **Limited Training Data**: No pre-written example messages per persona per scenario
4. **Weak Persona Voice**: Generated messages don't authentically capture persona personalities
5. **No Reference Quotes**: Missing the 20+ reference quotes per persona for voice training

---

## Enhancement Architecture

### Component Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    User Interface Layer                      │
│  - Persona Selection (choose 1 default)                     │
│  - Preview persona messages before selection                │
└───────────────────┬─────────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────────┐
│              Notification Orchestration                      │
│  - Intervention trigger detection                           │
│  - Context building (user state, time, habits)              │
│  - Persona + Context combination                            │
└───────────────────┬─────────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────────┐
│           Enhanced Persona System (NEW)                      │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Persona Definition Repository                       │   │
│  │ - System prompts (detailed personality)             │   │
│  │ - Reference materials (books, figures, characters)  │   │
│  │ - Training quotes (20+ per persona)                 │   │
│  │ - Per-scenario example messages                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Prompt Engineering Engine                           │   │
│  │ - Context injection (user data → prompt)            │   │
│  │ - Persona instruction loading                       │   │
│  │ - Reference quote sampling (5 random quotes)        │   │
│  │ - Example message injection                         │   │
│  │ - Dynamic template building                         │   │
│  └─────────────────────────────────────────────────────┘   │
└───────────────────┬─────────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────────┐
│            LLM Message Generation                            │
│  - Gemini API call with enhanced prompts                    │
│  - Fallback to template messages on failure                 │
│  - Message caching and optimization                         │
└───────────────────┬─────────────────────────────────────────┘
                    │
┌───────────────────▼─────────────────────────────────────────┐
│            Message Delivery                                  │
│  - Local notifications                                       │
│  - In-app overlays                                          │
│  - User interaction tracking                                │
└─────────────────────────────────────────────────────────────┘
```

---

## Data Model Enhancements

### 1. Enhanced Persona Definition Model

**New File**: `lib/features/ai_notifications/data/models/persona_definition.dart`

```dart
class PersonaDefinition {
  final AIArchetype archetype;
  final String systemPrompt;           // Detailed personality instruction
  final List<String> referenceQuotes;  // 20+ training quotes
  final Map<String, String> influences; // Books, figures, characters
  final Map<InterventionCategory, List<String>> scenarioExamples;
}
```

**Purpose**:
- Store comprehensive persona personality data
- Provide rich training material for LLM prompts
- Enable authentic voice generation per persona

### 2. Prompt Template Model

**New File**: `lib/features/ai_notifications/data/models/prompt_template.dart`

```dart
class PromptTemplate {
  final String roleDefinition;      // System prompt
  final List<String> referenceExamples; // Sampled quotes
  final Map<String, dynamic> currentContext; // User state
  final String taskInstruction;     // What to generate
}
```

**Purpose**:
- Structure LLM prompts with all necessary components
- Inject context dynamically
- Ensure consistent prompt format

---

## Core Enhancements

### Enhancement 1: Persona Definition Repository

**Location**: `lib/features/ai_notifications/data/repositories/persona_repository.dart`

**Responsibilities**:
1. Load comprehensive persona definitions (system prompts, reference quotes, influences)
2. Provide scenario-specific example messages per persona
3. Sample random reference quotes for prompt training
4. Serve as single source of truth for persona data

**Key Methods**:
```dart
PersonaDefinition getPersonaDefinition(AIArchetype archetype)
List<String> getReferenceSamples(AIArchetype archetype, int count)
List<String> getScenarioExamples(AIArchetype archetype, InterventionCategory category)
String getSystemPrompt(AIArchetype archetype)
```

**Data Source**:
- All persona data from `ai_notif_sources.md` structured into Dart constants
- 8 personas × (1 system prompt + 20 reference quotes + 7 scenario categories × 5 examples)

---

### Enhancement 2: Advanced Prompt Engineering Engine

**Location**: `lib/features/ai_notifications/domain/services/prompt_builder.dart`

**Responsibilities**:
1. Build comprehensive LLM prompts following the template in ai_notif_sources.md
2. Inject persona instructions, reference quotes, and user context
3. Sample 5 random reference quotes per generation for voice variety
4. Apply scenario-specific guidance (morning vs evening vs celebration)
5. Enforce message constraints (character limit, emoji usage, tone)

**Prompt Structure** (based on ai_notif_sources.md Part 2):
```
[ROLE DEFINITION]
{System Prompt - e.g., "You are 'The Drill Sergeant'..."}

[REFERENCE EXAMPLES]
{5 randomly sampled reference quotes from the 20+ training quotes}

[CURRENT CONTEXT]
- User Name: {user_name}
- Time of Day: {morning/afternoon/night}
- Habit to Complete: {habit_name}
- Current Streak: {streak_count} days
- User Goal: {linked_goal_name}
- Difficulty Level: {difficulty_level}
- Total Habits Today: {total}
- Completed: {completed_count}
- Pending: {pending_habit_names}

[TASK]
Generate a short, punchy notification (under 140 chars) urging the user to complete {context}.
Use the specific tone of the persona.
Reference their streak if high (>3).
Reference their goal explicitly if relevant.
Add 1 relevant emoji at the end.
```

**Key Methods**:
```dart
String buildPrompt(AIArchetype archetype, NotificationContext context, InterventionCategory category)
String injectContext(String template, NotificationContext context)
List<String> sampleReferenceQuotes(AIArchetype archetype)
```

---

### Enhancement 3: Enhanced AI Message Generator

**Location**: Update existing `lib/features/ai_notifications/domain/services/ai_message_generator.dart`

**Changes**:
1. **Replace simple prompts** with comprehensive prompt templates from PromptBuilder
2. **Inject reference quotes** for voice training on every generation
3. **Use scenario-specific examples** as few-shot learning
4. **Add fallback to template messages** using actual examples from ai_notif_sources.md
5. **Implement voice consistency validation** (optional: check if generated message matches persona tone)

**Updated Flow**:
```
1. Receive (archetype, context, intervention category)
2. Load persona definition from repository
3. Build comprehensive prompt using PromptBuilder
4. Call Gemini API with enhanced prompt
5. If success: return generated message
6. If failure: return pre-written example from scenario templates
7. Cache result for similar contexts
```

---

### Enhancement 4: Persona Data Constants

**New File**: `lib/features/ai_notifications/data/constants/persona_data.dart`

**Purpose**: Store all persona data from `ai_notif_sources.md` as Dart constants

**Structure**:
```dart
// System Prompts (Part 2 from document)
const Map<AIArchetype, String> PERSONA_SYSTEM_PROMPTS = {
  AIArchetype.drillSergeant: """You are 'The Drill Sergeant.' Your voice is a combination of...""",
  AIArchetype.wiseMentor: """You are 'The Wise Mentor.' Your voice blends...""",
  // ... all 8 personas
};

// Reference Training Quotes (20 per persona)
const Map<AIArchetype, List<String>> PERSONA_REFERENCE_QUOTES = {
  AIArchetype.drillSergeant: [
    "Nobody cares what you did yesterday...",
    "Discipline equals freedom...",
    // ... 20 total
  ],
  // ... all 8 personas
};

// Scenario-Specific Examples (Part 2 from document)
const Map<AIArchetype, Map<InterventionCategory, List<String>>> PERSONA_SCENARIO_EXAMPLES = {
  AIArchetype.drillSergeant: {
    InterventionCategory.morningMotivation: [
      "Feet on the floor, recruit!...",
      "Sun's up. Excuses are zero...",
      // ... 5 examples per category
    ],
    InterventionCategory.missedHabitRecovery: [...],
    // ... all 7 categories
  },
  // ... all 8 personas
};

// Influence References (Part 1 from document)
const Map<AIArchetype, Map<String, List<String>>> PERSONA_INFLUENCES = {
  AIArchetype.drillSergeant: {
    'figures': ['David Goggins', 'Jocko Willink', 'R. Lee Ermey'],
    'books': ['Can\'t Hurt Me', 'Extreme Ownership', 'Discipline Equals Freedom'],
    'characters': ['Gny. Sgt. Hartman', 'Terence Fletcher'],
  },
  // ... all 8 personas
};
```

---

## User Experience Flow

### 1. Persona Selection (Settings)

**Location**: `lib/features/ai_notifications/presentation/pages/ai_notifications_settings_page.dart`

**Enhancement**:
- Update "AI Style" section to show detailed persona cards
- Display persona emoji, name, tagline, traits, and sample message
- Add "Preview Messages" button per persona to see examples across scenarios
- Allow user to select one default persona
- Show current persona selection prominently

### 2. Message Preview Dialog

**New Component**: `lib/features/ai_notifications/presentation/widgets/persona_preview_dialog.dart`

**Purpose**:
- Show 7 example messages (one per intervention category) for selected persona
- Allow user to experience the persona voice before committing
- Help user make informed choice

### 3. In-App Notification Display

**Update**: `lib/features/ai_notifications/presentation/widgets/ai_notification_overlay.dart`

**Enhancement**:
- Display persona emoji alongside message
- Show which intervention triggered the notification
- Track user interaction (dismissed, acted upon, ignored)

---

## Implementation Phases

### Phase 1: Data Layer (Foundation)
**Effort**: Medium | **Impact**: High

1. Create `persona_data.dart` constants file with all data from ai_notif_sources.md
   - 8 system prompts
   - 8 × 20 reference quotes (160 total)
   - 8 × 7 × 5 scenario examples (280 messages)
   - Influence references

2. Create `PersonaDefinition` model
3. Create `PersonaRepository` to serve persona data
4. Write unit tests for data access

**Deliverables**:
- Complete persona data in code
- Repository pattern for data access
- Test coverage for all personas

---

### Phase 2: Prompt Engineering (Core Intelligence)
**Effort**: High | **Impact**: High

1. Create `PromptBuilder` service
2. Implement prompt template structure from ai_notif_sources.md
3. Build context injection logic
4. Implement reference quote sampling (5 random per generation)
5. Add scenario-specific guidance
6. Test prompt generation for all persona × scenario combinations

**Deliverables**:
- Comprehensive prompt builder
- Context-aware prompt templates
- Validation that prompts match expected format

---

### Phase 3: LLM Integration Enhancement (Message Generation)
**Effort**: Medium | **Impact**: High

1. Update `AIMessageGenerator` to use `PromptBuilder`
2. Implement fallback to template messages from persona_data
3. Add message quality validation (optional)
4. Enhance caching strategy
5. Add A/B testing framework (optional: LLM vs templates)

**Deliverables**:
- Enhanced message generator with rich prompts
- Reliable fallback system
- Production-ready LLM integration

---

### Phase 4: UI/UX Enhancement (User Control)
**Effort**: Medium | **Impact**: Medium

1. Update AI Settings page with detailed persona cards
2. Create persona preview dialog
3. Add persona selection UI
4. Update notification overlay with persona branding
5. Add persona switching functionality

**Deliverables**:
- Intuitive persona selection
- Message preview capability
- Enhanced notification display

---

### Phase 5: Testing & Refinement (Quality Assurance)
**Effort**: Medium | **Impact**: High

1. Test all 8 personas × 7 categories (56 combinations)
2. Validate message authenticity to persona voice
3. Gather user feedback on persona effectiveness
4. A/B test LLM-generated vs template messages
5. Optimize prompt templates based on results
6. Fine-tune reference quote selection algorithm

**Deliverables**:
- Comprehensive test coverage
- Voice authenticity validation
- Data-driven optimization

---

## Technical Considerations

### 1. LLM Prompt Optimization

**Challenge**: Ensuring consistent, authentic persona voice
**Solution**:
- Use 5 randomly sampled reference quotes per generation
- Include scenario-specific examples as few-shot learning
- Implement prompt template versioning for A/B testing

### 2. Fallback Strategy

**Challenge**: LLM API failures or rate limits
**Solution**:
- Pre-written template messages (280 total from ai_notif_sources.md)
- Smart template selection based on context
- Graceful degradation without user-facing errors

### 3. Performance & Caching

**Challenge**: Minimize API calls and costs
**Solution**:
- Cache generated messages by (persona + context + scenario) key
- Implement TTL-based cache expiration
- Pre-generate common scenarios during low-usage periods

### 4. Personalization vs Privacy

**Challenge**: Using user data in prompts while respecting privacy
**Solution**:
- Only inject essential context (streaks, habit names, goals)
- Never send PII to LLM (no email, phone, etc.)
- Allow users to opt out of LLM generation (templates only)

### 5. Message Quality Validation

**Challenge**: Ensuring generated messages match persona tone
**Solution** (Optional):
- Second LLM call to validate message authenticity
- User feedback mechanism ("This doesn't sound like [persona]")
- Statistical analysis of message characteristics (length, emoji usage, keywords)

---

## Success Metrics

### Quantitative
1. **Message Authenticity Score**: User ratings on how well messages match persona
2. **Engagement Rate**: % of notifications acted upon (by persona)
3. **Persona Retention**: % of users who stick with chosen persona vs switching
4. **Completion Rate Improvement**: Habit completion rate before/after enhancement

### Qualitative
1. **User Testimonials**: "The Drill Sergeant really pushes me!" style feedback
2. **Persona Preference Distribution**: Which personas are most popular
3. **Scenario Effectiveness**: Which intervention categories drive most action

---

## File Structure Summary

```
lib/features/ai_notifications/
├── data/
│   ├── models/
│   │   ├── persona_definition.dart          [NEW]
│   │   ├── prompt_template.dart              [NEW]
│   │   └── (existing models...)
│   ├── repositories/
│   │   ├── persona_repository.dart           [NEW]
│   │   └── (existing repositories...)
│   └── constants/
│       └── persona_data.dart                 [NEW - 800+ lines]
├── domain/
│   └── services/
│       ├── prompt_builder.dart               [NEW]
│       └── ai_message_generator.dart         [UPDATED]
└── presentation/
    ├── pages/
    │   └── ai_notifications_settings_page.dart [UPDATED]
    └── widgets/
        └── persona_preview_dialog.dart        [NEW]
```

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| LLM API costs too high | Medium | High | Aggressive caching, template fallback, cost monitoring |
| Generated messages feel "off-voice" | Medium | High | Extensive testing, user feedback, template fallback |
| User confusion with 8 personas | Low | Medium | Clear UI, preview functionality, onboarding guide |
| Prompt engineering complexity | Low | Medium | Modular prompt builder, version control, A/B testing |
| Performance degradation | Low | Medium | Background generation, caching, async processing |

---

## Next Steps

1. **Review & Approval**: Stakeholder review of this architecture
2. **Spike: Prompt Testing**: Test 2-3 personas with Gemini to validate approach
3. **Phase 1 Kickoff**: Begin persona data extraction and modeling
4. **Weekly Iterations**: Implement phases incrementally with testing
5. **User Beta**: Test with small user group before full rollout

---

## Appendix A: Example Prompt (Drill Sergeant + Morning Motivation)

```
[ROLE DEFINITION]
You are 'The Drill Sergeant.' Your voice is a combination of David Goggins, Jocko Willink, and R. Lee Ermey. You do not coddle. You believe that comfort is the enemy and suffering is the forge of character. You speak in short, punchy sentences. You demand 'Extreme Ownership.' You often refer to the user as 'recruit' or 'soldier.' Your goal is to callous their mind against weakness. Use military terminology where appropriate. Do not be polite. Be effective.

[REFERENCE EXAMPLES]
- "Discipline equals freedom. Motivation is fickle. Discipline remains."
- "Don't stop when you're tired. Stop when you're done."
- "While you sleep, the enemy is training. Wake up."
- "Drop the victim mentality. Take ownership of your world."
- "Callous your mind. Stay Hard."

[CURRENT CONTEXT]
- User Name: Alex
- Time of Day: Morning (7:15 AM)
- Total Habits Today: 8
- Completed: 0
- Pending Habits: Meditation, Workout, Read 20 pages
- Current Streak: 12 days
- User Goal: Build discipline

[TASK]
Generate a short, punchy notification (under 140 chars) for morning motivation. Use the drill sergeant tone. Reference the 12-day streak and the goal of building discipline. Add 1 relevant emoji at the end.
```

**Expected Output**:
"Feet on the floor, recruit! 12 days strong but today isn't won yet. 8 missions. Zero excuses. Build that discipline NOW! 🎖️"

---

## Appendix B: Data Volume Summary

| Component | Count | Notes |
|-----------|-------|-------|
| Personas | 8 | Each with unique voice |
| System Prompts | 8 | One per persona, ~150 words each |
| Reference Quotes | 160 | 20 per persona |
| Scenario Categories | 7 | Morning, missed habit, low morale, streak, evening, comeback, progress |
| Scenario Examples | 280 | 8 personas × 7 categories × 5 examples |
| Influence References | 24 | 8 personas × ~3 influences each |
| **Total Data Points** | **480+** | Comprehensive persona framework |

---

## Document Version

**Version**: 1.0
**Date**: 2025-11-20
**Author**: AI Assistant (Claude Code)
**Status**: Ready for Implementation
**Next Review**: After Phase 1 completion
