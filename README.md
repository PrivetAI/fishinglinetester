# Fishing Line Tester

An educational iOS app that simulates fishing scenarios to help users understand line strength relative to fish size.

## Features

### Core Features
- **Line Selection** - Choose from 4 line types (Monofilament, Braided, Fluorocarbon, Hybrid) with adjustable diameter
- **Fishing Simulator** - Interactive simulation with animated water, fishing rod, line tension, and fish
- **Advanced Factors** - Account for knot type, line wear, fish behaviour, and water temperature

### Educational Content
- **Knowledge Base** - Encyclopedia of line types with pros/cons, recommended uses
- **Reference Tables** - Line strength by diameter, recommended line per fish species
- **Tips & Facts** - Pro tips and interesting facts about fishing lines
- **Knot Guide** - Different knot types and their impact on line strength

### Tools
- **Line Calculator** - Get recommendations based on target fish, conditions, and budget
- **Quiz System** - Test your fishing line knowledge with 15 questions

### Tracking
- **Test History** - Journal of all tests with success rate statistics
- **Achievements** - Unlock badges for milestones and accomplishments
- **Records** - Track largest catch, closest call, best safety margin

## Technical Requirements

- iOS 15.6+
- iPhone and iPad support
- Swift 5.0
- SwiftUI
- No external dependencies

## Project Structure

```
FishingLineTester/
├── App/
│   └── FishingLineTesterApp.swift
├── Models/
│   ├── LineType.swift
│   ├── FishingLine.swift
│   ├── Fish.swift
│   ├── SimulationResult.swift
│   ├── Achievement.swift
│   ├── Quiz.swift
│   └── Statistics.swift
├── ViewModels/
│   └── DataManager.swift
├── Engine/
│   └── SimulationEngine.swift
├── Views/
│   ├── Main/MainTabView.swift
│   ├── LineSelection/LineSelectionView.swift
│   ├── Simulator/SimulatorView.swift
│   ├── Knowledge/KnowledgeBaseView.swift
│   ├── Calculator/CalculatorView.swift
│   ├── Quiz/QuizView.swift
│   ├── History/HistoryView.swift
│   └── Achievements/AchievementsView.swift
├── Components/
│   ├── Icons/CustomIcons.swift
│   ├── Buttons/PrimaryButton.swift
│   ├── Cards/InfoCard.swift
│   └── Animations/
│       ├── WaterView.swift
│       ├── LineAnimationView.swift
│       └── FishAnimationView.swift
├── Utilities/
│   ├── Colors.swift
│   ├── Constants.swift
│   └── SoundManager.swift
└── Assets.xcassets/
```

## Design Features

- Custom vector icons (no SF Symbols or system emojis)
- Fixed light theme
- Animated water with waves and bubbles
- Fishing rod bending animation
- Line tension with shake effect
- Fish movement with splash effects
- Tension gauge with colour coding

## Data Storage

All data is stored locally using UserDefaults:
- Test history
- Quiz results
- Achievements progress
- Saved line combinations
- User preferences

## Build & Run

1. Open `FishingLineTester.xcodeproj` in Xcode 15+
2. Select target device (iPhone/iPad)
3. Build and run (⌘R)

## Language

Interface language: English (UK)
