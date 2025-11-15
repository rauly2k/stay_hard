# StayHard App - UI Design System

**Complete UI/UX Reference Guide**

Version: 7.0 | Last Updated: 2025-11-15

This document serves as a comprehensive reference for recreating the exact UI/UX design of the StayHard app. It includes all colors, typography, components, animations, spacing, and interaction patterns used throughout the application.

---
 
## Table of Contents

1. [Color Palette](#color-palette)
2. [Typography System](#typography-system)
3. [Spacing & Layout](#spacing--layout)
4. [Component Library](#component-library)
5. [Animation Specifications](#animation-specifications)
6. [Navigation Patterns](#navigation-patterns)
7. [User Flows & Workflows](#user-flows--workflows)
8. [Icons & Imagery](#icons--imagery)

---
 
## Color Palette

### Primary Colors

**Primary (StayHard Orange)**
- Hex: `#FF6B35`
- Usage: Primary actions, highlights, brand identity, CTA buttons
- Opacity variants:
  - 100%: Main actions, selected states
  - 20%: Light backgrounds, hover states
  - 10%: Very light backgrounds, disabled states

**Surface Colors (Light Theme)**
- Background: `#FAFAFA` - Main app background
- Surface: `#FFFFFF` - Cards, sheets, elevated elements
- Surface Container: `#F5F5F5` - Slightly elevated containers
- Surface Container Highest: `#EEEEEE` - Highest elevation surfaces

**Surface Colors (Dark Theme)**
- Background: `#121212` - Main app background
- Surface: `#1E1E1E` - Cards, sheets, elevated elements
- Surface Container: `#2C2C2C` - Slightly elevated containers
- Surface Container Highest: `#383838` - Highest elevation surfaces

**Text Colors (Light Theme)**
- Primary Text: `#212121` - Main headings, important text
- Secondary Text: `#757575` - Body text, descriptions
- Tertiary Text: `#BDBDBD` - Hints, disabled text
 
**Text Colors (Dark Theme)**

- Primary Text: `#FFFFFF` - Main headings, important text
- Secondary Text: `#B0B0B0` - Body text, descriptions
- Tertiary Text: `#808080` - Hints, disabled text

 

### Secondary Colors
**Blue (Secondary)**
- Hex: `#277DA1`
- Usage: Information, secondary actions, links

**Green (Success/Accent)**
- Hex: `#90BE6D`
- Usage: Success states, completion indicators, positive feedback

**Red (Error/Warning)**
- Hex: `#F94144`
- Usage: Errors, deletions, warnings, overdue items 


### Gradient Backgrounds
 
**Primary Gradient (Hero Graphics)**

```dart

LinearGradient(

  begin: Alignment.topLeft,

  end: Alignment.bottomRight,

  colors: [

    theme.colorScheme.primary,

    theme.colorScheme.primary.withValues(alpha: 0.7),

  ],

)

```
 

### Font Family
 
**Primary Font**: Inter (Google Fonts)
- Source: `GoogleFonts.interTextTheme()`
- All text uses Inter with various weights
### Text Styles
#### Display Styles (Large Headings)
**Display Large**

- Size: 32px

- Weight: Bold (700)

- Usage: Welcome screens, major section headers

 

**Display Medium**

- Size: 28px

- Weight: SemiBold (600)

- Usage: Page titles, modal headers

 

**Display Small**

- Size: 24px

- Weight: SemiBold (600)

- Usage: Section headers, card titles

 

#### Headline Styles

 

**Headline Large**

- Size: 22px

- Weight: SemiBold (600)

- Usage: Important headers

 

**Headline Medium**

- Size: 20px

- Weight: SemiBold (600)

- Usage: Subsection headers

 

**Headline Small**

- Size: 18px

- Weight: SemiBold (600)

- Usage: Card headers, list section titles

 

#### Title Styles

 

**Title Large**

- Size: 16px

- Weight: SemiBold (600)

- Usage: List item titles, button text

 

**Title Medium**

- Size: 14px

- Weight: SemiBold (600)

- Usage: Secondary titles, tabs

 

**Title Small**

- Size: 12px

- Weight: Medium (500)

- Usage: Small headers, labels

 

#### Body Styles

 

**Body Large**

- Size: 16px

- Weight: Regular (400)

- Usage: Main body text, descriptions

 

**Body Medium**

- Size: 14px

- Weight: Regular (400)

- Usage: Secondary body text, captions

 

**Body Small**

- Size: 12px

- Weight: Regular (400)

- Usage: Fine print, hints, helper text

 






### Standard Spacing Scale

 

- **4px**: Tight spacing (icon-text gaps, chip padding)

- **8px**: Small spacing (between related elements)

- **12px**: Medium spacing (between cards, form fields)

- **16px**: Standard spacing (card padding, page margins)

- **24px**: Large spacing (section dividers, modal padding)

- **32px**: Extra large spacing (page padding, hero sections)

 

### Border Radius Scale

 

- **4px**: Progress bars, small indicators

- **6px**: Checkboxes, small chips

- **8px**: Small chips, tags, time-of-day labels

- **12px**: Cards, buttons, input fields, modals

- **16px**: Large cards, bottom sheets

- **20px**: Bottom sheet top corners, large modals

- **Circular**: Icon containers, avatar, completion buttons

 

### Padding Standards

 

**Cards**

- Standard: `EdgeInsets.all(16)`

- Compact: `EdgeInsets.all(12)`

- Expanded: `EdgeInsets.all(24)`

 

**Bottom Sheets**

- Header: `EdgeInsets.all(24)`

- Content: `EdgeInsets.symmetric(horizontal: 24)`

- Footer: `EdgeInsets.all(24)`

 

**Buttons**

- Horizontal: `24px`

- Vertical: `12px` (standard) or `16px` (large buttons)

 

**Input Fields**

- Horizontal: `16px`

- Vertical: `16px`

 

### Elevation & Shadows

 

**Card Elevation**

```dart

BoxShadow(

  color: theme.colorScheme.shadow.withValues(alpha: 0.05),

  blurRadius: 8,

  offset: const Offset(0, 2),

)

```

 

**Bottom Sheet Shadow**

```dart

BoxShadow(

  color: Colors.black.withValues(alpha: 0.05),

  offset: const Offset(0, -4),

  blurRadius: 8,

)

```

 

**Material Elevation**

- Cards: 2

- Buttons: 0 (flat design)

- App Bar: 0 (flat design)

 

---

 

## Component Library

 

### 1. Buttons

 

#### Elevated Button (Primary CTA)

 

**Visual Style**:

- Background: `theme.colorScheme.primary` (#FF6B35)

- Foreground: `theme.colorScheme.onPrimary` (white)

- Border Radius: 12px

- Padding: `horizontal: 24, vertical: 12`

- Elevation: 0 (flat)

- Font: 16px, SemiBold (600)

 

**Code Example**:

```dart

ElevatedButton.icon(

  onPressed: onActionPressed,

  icon: Icon(Icons.add),

  label: Text('Add Habit'),

  style: ElevatedButton.styleFrom(

    backgroundColor: theme.colorScheme.primary,

    foregroundColor: theme.colorScheme.onPrimary,

    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),

    shape: RoundedRectangleBorder(

      borderRadius: BorderRadius.circular(12),

    ),

    elevation: 0,

  ),

)

```

 

#### Outlined Button (Secondary Action)

 

**Visual Style**:

- Background: Transparent

- Foreground: `theme.colorScheme.primary`

- Border: 1px, `theme.colorScheme.primary`

- Border Radius: 12px

- Padding: `horizontal: 24, vertical: 16`

 

**Code Example**:

```dart

OutlinedButton(

  onPressed: onCancel,

  style: OutlinedButton.styleFrom(

    foregroundColor: theme.colorScheme.primary,

    side: BorderSide(color: theme.colorScheme.primary),

    padding: const EdgeInsets.symmetric(vertical: 16),

    shape: RoundedRectangleBorder(

      borderRadius: BorderRadius.circular(12),

    ),

  ),

  child: const Text('Cancel'),

)

```

 

#### Filled Button (Confirmation)

 

**Visual Style**:

- Background: `theme.colorScheme.primary`

- Foreground: White

- Border Radius: 12px

- Padding: `horizontal: 24, vertical: 16`

 

**Code Example**:

```dart

FilledButton(

  onPressed: onConfirm,

  style: FilledButton.styleFrom(

    padding: const EdgeInsets.symmetric(vertical: 16),

    shape: RoundedRectangleBorder(

      borderRadius: BorderRadius.circular(12),

    ),

  ),

  child: Text('Confirm'),

)

```

 

#### Social Login Buttons

 


 

### 2. Cards

 

#### Standard Habit Card

 

**Visual Structure**:

- Container with 16px padding

- Border Radius: 16px

- Border: 1px (completed: 2px with habit color)

- Shadow: 8px blur, offset (0, 2), alpha 0.05

- Background: `theme.colorScheme.surface`

 

**Layout**:

```

[Icon Circle] [Habit Name + Description + Time Chips] [Completion Button]

   48px                     Expanded                          40px

```

 

**Components**:

1. **Icon Container**:

   - Size: 48x48

   - Shape: Circle

   - Background: `habitColor.withValues(alpha: 0.2)`

   - Icon: 24px, `habitColor`

 

2. **Habit Info**:

   - Title: 14px, SemiBold, strikethrough if completed

   - Description: 14px, Regular, 2 lines max

   - Time chips: 8px radius, 8x2 padding

 

3. **Completion Button**:

   - Size: 40x40

   - Shape: Circle

   - Border: 2px, `habitColor`

   - Background: Filled if completed, transparent otherwise

   - Check icon: 24px

 

**Animation**:

- Scale on tap: 1.0 → 0.95 (100ms, easeInOut)

- Completion animation: 600ms duration

- Check icon scales with completion controller

 

#### Enhanced Habit Card (Dismissible)

 

**Additional Features**:

- Swipe to reveal actions (edit, archive, delete)

- Dismissible widget with custom background

- Gradient overlay when completed

 

#### Goal Card

 

**Visual Structure**:

- Card elevation: 2

- Margin: `horizontal: 16, vertical: 8`

- Padding: 16px all sides

- Border Radius: 12px

 

**Layout**:

```

[Icon 48px] [Title + Category] [Status Badge/Menu]

[Description - 2 lines max]

[Progress Bar]

[Stat Chips Row]

```

 

**Components**:

1. **Icon Container**:

   - Size: 48x48

   - Border Radius: 12px

   - Background: `goal.color.withValues(alpha: 0.1)`

   - Icon: 24px, `goal.color`

 

2. **Progress Bar**:

   - Height: 8px

   - Border Radius: 4px

   - Background: `surfaceContainerHighest`

   - Value Color: `goal.color`

 

3. **Stat Chips**:

   - Padding: `horizontal: 8, vertical: 4`

   - Border Radius: 8px

   - Background: `color.withValues(alpha: 0.1)`

   - Icon: 14px

   - Text: 12px, SemiBold

 

### 3. Input Fields

 

#### Standard Text Field

 

**Visual Style**:

- Border Radius: 12px

- Filled: true

- Fill Color: `surfaceContainerHighest`

- Border: None (filled style)

- Padding: `horizontal: 16, vertical: 16`

- Label: Floating

- Error border: Red, 1px

 

**Code Example**:

```dart

TextField(

  decoration: InputDecoration(

    labelText: 'Habit Name',

    hintText: 'Enter habit name',

    border: OutlineInputBorder(

      borderRadius: BorderRadius.circular(12),

      borderSide: BorderSide.none,

    ),

    filled: true,

    fillColor: theme.colorScheme.surfaceContainerHighest,

    contentPadding: const EdgeInsets.symmetric(

      horizontal: 16,

      vertical: 16,

    ),

  ),

)

```

 

### 4. Bottom Sheets

 

#### Standard Modal Bottom Sheet

 

**Visual Structure**:

- Height: 85% of screen height

- Top Border Radius: 20px

- Background: `theme.colorScheme.surface`

 

**Components**:

1. **Handle Bar**:

   - Width: 40px

   - Height: 4px

   - Border Radius: 2px

   - Color: `onSurface.withValues(alpha: 0.3)`

   - Margin: `top: 12, bottom: 8`

 

2. **Header**:

   - Padding: 24px all sides

   - Title: Headline Small, Bold

   - Subtitle: Body Medium, 70% opacity

 

3. **Content**:

   - Scrollable list

   - Padding: `horizontal: 24`

 

4. **Footer Actions**:

   - Padding: 24px all sides

   - Shadow: Top shadow (offset: 0, -4, blur: 8)

   - Buttons: Row with 12px gap

 

**Example (Add Extra Habits Sheet)**:

- Selected counter badge in header

- List items with checkbox + icon + text

- Animated container on selection (200ms)

- Cancel + Confirm buttons in footer

 

### 5. Chips & Tags

 

#### Time of Day Chips

 

**Visual Style**:

- Padding: `horizontal: 8, vertical: 2`

- Border Radius: 8px

- Background: `primaryContainer.withValues(alpha: 0.5)`

- Text: 12px, Medium (500), `onPrimaryContainer`

 

**Labels**: Morning, Afternoon, Evening, Anytime

 

#### Stat Chips (Goal Cards)

 

**Visual Style**:

- Padding: `horizontal: 8, vertical: 4`

- Border Radius: 8px

- Background: `color.withValues(alpha: 0.1)`

- Icon: 14px

- Text: 12px, SemiBold

- Icon-text gap: 4px

 

**Types**:

- Habits count: `Icons.checklist`

- Today's progress: `Icons.today`

- Days left: `Icons.calendar_today`

- Overdue: `Icons.warning_amber`

 

#### Filter Chips

 

**Visual Style**:

- Selected: Primary color background

- Unselected: Outlined

- Border Radius: 8px

- Padding: `horizontal: 12, vertical: 8`

 

### 6. Progress Indicators

 

#### Circular Progress (Completion Button)

 

**Visual Style**:

- Size: 40x40

- Border: 2px, `habitColor`

- Background: Transparent (uncompleted) or `habitColor` (completed)

- Check icon: 24px, scales with animation

 

#### Linear Progress Bar

 

**Visual Style**:

- Height: 8px

- Border Radius: 4px

- Background: `surfaceContainerHighest`

- Value Color: Dynamic (goal color, habit color, etc.)

 

#### Hero Graphic (Circular Ring)

 

**Visual Structure**:

- Custom painted circular progress

- Gradient background

- Center stats display

- Animated with curved animation (1500ms, easeOutCubic)

 

### 7. Empty States

 

#### AI Empty State

 

**Visual Structure**:

- Center aligned

- Padding: 32px all sides

- ScrollView for small screens

 

**Components**:

1. **Icon**:

   - Size: 64px

   - Color: `primary.withValues(alpha: 0.6)`

 

2. **Title**:

   - Headline Small, SemiBold

   - Color: `onSurfaceVariant`

   - Center aligned

 

3. **Subtitle**:

   - Body Large

   - Color: `onSurfaceVariant`

   - Center aligned

 

4. **Action Button**:

   - ElevatedButton with icon

   - Primary background

   - Border Radius: 12px

 

### 8. Dialogs & Modals

 

#### Standard Alert Dialog

 

**Visual Style**:

- Border Radius: 12px

- Title: Title Large, Bold

- Content: Body Medium

- Actions: Row with TextButton/ElevatedButton

 

#### Custom Configuration Dialogs

 

**Time Picker Dialog**:

- TimePicker with Material 3 design

- Confirm/Cancel buttons

 

**Duration Picker**:

- Custom slider or number picker

- Quick-select buttons (15, 30, 45, 60 minutes)

 

**Quantity Picker**:

- Number input with unit label

- +/- buttons

 

### 9. List Items

 

#### Habit List Item (Dismissible)

 

**Swipe Actions**:

- Left swipe: Red background (delete)

- Right swipe: Blue background (edit)

- Icon reveals on swipe

 

#### Checkbox List Item (Extra Habits Selection)

 

**Visual Style**:

- Padding: 16px

- Border Radius: 12px

- Border: 1px (selected: 2px, primary color)

- Background: Selected: `primaryContainer`, Unselected: `surfaceContainerHighest`

- Animated: 200ms duration

 

**Layout**:

```

[Checkbox 24px] [Icon Container] [Name + Category]

```

 

**Checkbox Animation**:

- Size: 24x24

- Border Radius: 6px

- Border: 2px

- Check icon: 16px, scales in

 

### 10. Navigation

 

#### Bottom Navigation Bar

 

**Visual Style**:

- Height: Default Material 3

- Background: `theme.colorScheme.surface`

- Selected: Primary color

- Unselected: `onSurface.withValues(alpha: 0.6)`

- Label Style: 12px

 

**Items** (5 tabs):

1. Home: `Icons.home`

2. Goals: `Icons.flag`

3. Stats: `Icons.bar_chart`

4. AI Insights: `Icons.psychology`

5. Profile: `Icons.person`

 

#### App Bar

 

**Visual Style**:

- Background: `theme.colorScheme.surface`

- Elevation: 0 (flat)

- Center Title: true (usually logo)

- Logo Height: 40px

- Actions: IconButton with `Icons.person_outline`

 

---

 

## Animation Specifications

 

### Standard Animations

 

#### Scale Animation (Button Press)

 

**Timing**:

- Duration: 100ms

- Curve: `Curves.easeInOut`

- Scale: 1.0 → 0.95

 

**Code**:

```dart

AnimationController(

  duration: const Duration(milliseconds: 100),

  vsync: this,

);

final scaleAnimation = Tween<double>(

  begin: 1.0,

  end: 0.95,

).animate(CurvedAnimation(

  parent: controller,

  curve: Curves.easeInOut,

));

```

 

#### Completion Animation

 

**Timing**:

- Duration: 600ms

- Curve: Default

 

**Behavior**:

- Check icon scales from 0.0 to 1.0

- Background color animates from transparent to habit color

- Border animates from 1px to 2px

 

#### Hero Graphic Animation

 

**Timing**:

- Duration: 1500ms

- Curve: `Curves.easeOutCubic`

 

**Behavior**:

- Circular progress ring draws from 0% to current completion

- Stats count up from 0

- Gradient background subtle pulse

 

#### Container Animation (Selection)

 

**Timing**:

- Duration: 200ms

- Curve: Default

 

**Properties Animated**:

- Background color

- Border width

- Border color

 

**Code**:

```dart

AnimatedContainer(

  duration: const Duration(milliseconds: 200),

  decoration: BoxDecoration(

    color: isSelected

      ? theme.colorScheme.primaryContainer

      : theme.colorScheme.surfaceContainerHighest,

    border: Border.all(

      color: isSelected

        ? theme.colorScheme.primary

        : theme.colorScheme.outline.withValues(alpha: 0.2),

      width: isSelected ? 2 : 1,

    ),

  ),

)

```

 

### Page Transitions

 

**Default**: Material page route (slide from bottom on Android)

**Modal**: Slide up from bottom with fade

**Bottom Sheet**: Slide up with scrim fade in

 

---

 

## Navigation Patterns

 

### Primary Navigation

 

**Bottom Navigation Bar** (MainShell):

- Always visible on main screens

- 5 tabs with icons + labels

- Selected state: Primary color fill

- Smooth tab switching (no animation between tabs)

 

### Secondary Navigation

 

**App Bar Navigation**:

- Back button: `Icons.arrow_back`

- Close button: `Icons.close` (for modals)

- Actions: Right-aligned icon buttons

 

**Modular Routes**:

- Feature-based routing

- Deep linking support

- Example: `/habits/edit/:id`, `/goals/:id`

 

### Modal Navigation

 

**Bottom Sheets**:

- Swipe down to dismiss

- Barrier dismissible

- Handle bar at top

 

**Dialogs**:

- Center screen

- Barrier dismissible (most cases)

- Confirmation dialogs: Not dismissible

 

---

 

## User Flows & Workflows

 

### 1. Habit Completion Flow

 

**Interaction**:

1. User taps checkmark button on habit card

2. Scale animation (100ms down, 100ms up)

3. Completion animation plays (600ms)

4. Check icon appears with scale

5. Background fills with habit color

6. Border thickens to 2px

7. Habit name gets strikethrough

 

**Undo**:

- Tap again to undo (reverse animation)

 

### 2. Swipe Actions (Dismissible Habits)

 

**Left Swipe (Delete)**:

- Red background reveals

- Trash icon appears

- Swipe threshold: 50%

- Confirm dialog appears

 

**Right Swipe (Edit)**:

- Blue background reveals

- Edit icon appears

- Navigates to edit page

 

### 3. Add Habit Flow

 

**Steps**:

1. Tap FAB or add button

2. Choice dialog appears: "Template" or "Custom"

3. If template:

   - Bottom sheet with habit templates

   - Grouped by category (Foundation, Body, Mind, Discipline)

   - Multi-select with checkboxes

   - Animated selection state

   - Confirm button shows count: "Add 3 Habits"

4. For each selected template:

   - Configuration dialog (time/duration/quantity picker)

   - User configures habit-specific settings

5. Habits created and appear in list

6. Success snackbar: "Added 3 habits successfully!"

 

### 4. Bottom Sheet Interaction

 

**Opening**:

- Slides up from bottom (300ms)

- Scrim fades in behind

 

**Scrolling**:

- Content scrolls independently

- Header/footer remain fixed

 

**Closing**:

- Swipe down on handle

- Tap scrim

- Cancel button

- Slides down (300ms)

 

### 5. Goal Progress Visualization

 

**Goal Card**:

- Shows progress bar (0-100%)

- Today's completion: "3/5 today"

- Days until target: "15 days left"

- Tap to view detail page

 

**Goal Detail**:

- Hero animation from card

- Full analytics:

  - Timeline roadmap

  - Progress chart (8 weeks)

  - Statistics cards

  - Habit performance matrix

 

### 6. Empty State → First Action

 

**Pattern**:

1. Empty state shows:

   - Large icon (64px, 60% opacity)

   - Title + subtitle

   - Primary CTA button

2. User taps CTA

3. Creation flow begins

4. Success feedback

5. New item appears (animated)

 

---

 

## Icons & Imagery

 

### App Logo

 

**File**: `assets/images/LOGO.png`

**Usage**: App bar center, splash screen

**Display Size**: 40px height (app bar)

**Format**: PNG with transparency

 

### Habit Icons

 

**Icon Set**: Material Icons

**Size**: 24px (in cards), 20px (in small chips)

 

**Common Habit Icons**:

- Fitness: `Icons.fitness_center`

- Reading: `Icons.menu_book`

- Water: `Icons.local_drink`

- Meditation: `Icons.self_improvement`

- Running: `Icons.directions_run`

- Sleep: `Icons.bedtime`

- Eating: `Icons.restaurant`

- Work: `Icons.work`

- Study: `Icons.school`

- Creative: `Icons.palette`

- Social: `Icons.people`

- Health: `Icons.health_and_safety`

 

### UI Icons

 

**Navigation**:

- Home: `Icons.home`

- Goals: `Icons.flag`

- Stats: `Icons.bar_chart`

- AI: `Icons.psychology`

- Profile: `Icons.person`

 

**Actions**:

- Add: `Icons.add`

- Edit: `Icons.edit`

- Delete: `Icons.delete`

- Archive: `Icons.archive`

- Check: `Icons.check`

- Close: `Icons.close`

- Back: `Icons.arrow_back`

- More: `Icons.more_vert`

 

**Status**:

- Complete: `Icons.check_circle`

- Warning: `Icons.warning_amber`

- Info: `Icons.info_outline`

- Calendar: `Icons.calendar_today`, `Icons.today`

 

### Lottie Animations

 

**Location**: `assets/animations/`

**Usage**: Loading states, success animations, empty states

**Format**: .json (Lottie)

 

### Placeholder Images

 

**Empty States**: Icon-based (no illustrations)

**Profile Pictures**: Circular, default avatar icon

 

---

 

## Design Principles

 

### 1. Material 3 Adherence

 

- Follow Material 3 design guidelines

- Use Material 3 components

- Respect elevation system

- Follow color token system

 

### 2. Accessibility

 

- Minimum touch target: 48x48 dp

- Color contrast: WCAG AA compliant

- Text scaling: Supports user font size preferences

- Screen reader support: Semantic labels

 

### 3. Consistency

 

- 12px border radius for most components

- Primary color (#FF6B35) for all CTAs

- Inter font throughout

- 16px standard padding

- 8px standard spacing between elements

 

### 4. Feedback & Animation

 

- Every interaction has visual feedback

- Loading states for async operations

- Success/error feedback via snackbars

- Smooth animations (200-600ms)

 

### 5. Mobile-First

 

- Touch-optimized (large tap targets)

- Swipe gestures (dismissible items)

- Bottom-aligned actions (reachability)

- Responsive to screen sizes

 

---

 

## Code Patterns

 

### Theme Usage

 

```dart

final theme = Theme.of(context);

// Use theme tokens instead of hardcoded colors

theme.colorScheme.primary

theme.colorScheme.surface

theme.textTheme.bodyLarge

```

 

### Color Opacity (New Flutter API)

 

```dart

// Use .withValues(alpha:) instead of .withOpacity()

color.withValues(alpha: 0.2)  // 20% opacity

color.withValues(alpha: 0.5)  // 50% opacity

```

 

### Border Radius Pattern

 

```dart

BorderRadius.circular(12)  // Standard for cards/buttons

BorderRadius.circular(16)  // Large cards

BorderRadius.circular(8)   // Small chips

```

 

### Shadow Pattern

 

```dart

BoxShadow(

  color: theme.colorScheme.shadow.withValues(alpha: 0.05),

  blurRadius: 8,

  offset: const Offset(0, 2),

)

```

 

---

 

## Responsive Behavior

 

### Small Screens (< 360dp width)

 

- Reduce horizontal padding to 12px

- Stack buttons vertically in dialogs

- Reduce font sizes slightly

 

### Medium Screens (360-600dp)

 

- Standard 16px padding

- Row-based button layouts

- Full component sizes

 

### Large Screens (> 600dp)

 

- Increase max width for cards (600dp)

- Center content with side margins

- Larger hit boxes

 

---

 

## Platform-Specific Adjustments

 

### Android

 

- Material 3 design

- Bottom navigation always visible

- Floating Action Button (FAB) for primary actions

- Ripple effects on taps

 

### iOS (Planned)

 

- Cupertino widgets where appropriate

- Tab bar at bottom (Cupertino style)

- iOS-specific navigation transitions

- Haptic feedback

 

---

 

## Summary Checklist

 

When recreating this UI, ensure you have:

 

- ✅ Inter font family from Google Fonts

- ✅ Primary color: #FF6B35 (StayHard Orange)

- ✅ 12px border radius for cards/buttons

- ✅ 16px standard padding

- ✅ 8px standard spacing

- ✅ Material 3 theme configuration

- ✅ Bottom navigation with 5 tabs

- ✅ Flat design (elevation: 0 for most components)

- ✅ Circular icon containers (48x48 with alpha: 0.2 background)

- ✅ Completion animations (600ms)

- ✅ Scale animations on tap (100ms)

- ✅ Bottom sheets with handle bar

- ✅ Swipe actions (dismissible)

- ✅ Empty states with 64px icons

- ✅ Gradient backgrounds where specified

- ✅ Stat chips with 8px radius

- ✅ Linear progress bars (8px height)

 

---

 

**End of UI Design System Document**

 

For implementation questions or clarification on any component, refer to the original source files in `lib/features/*/presentation/widgets/` and `lib/core/theme/`.