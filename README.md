quiz_app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── app/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── quiz_question.dart  # Question model
│   │   │   │   └── quiz_result.dart    # Result model
│   │   │   ├── providers/
│   │   │   │   └── groq_provider.dart  # GROQ API interface
│   │   │   └── services/
│   │   │       └── storage_service.dart # Local storage service
│   │   ├── modules/
│   │   │   ├── home/
│   │   │   │   ├── controllers/
│   │   │   │   │   └── home_controller.dart
│   │   │   │   └── views/
│   │   │   │       └── home_view.dart
│   │   │   ├── quiz/
│   │   │   │   ├── controllers/
│   │   │   │   │   └── quiz_controller.dart
│   │   │   │   └── views/
│   │   │   │       └── quiz_view.dart
│   │   │   └── results/
│   │   │       ├── controllers/
│   │   │       │   └── results_controller.dart
│   │   │       └── views/
│   │   │           └── results_view.dart
│   │   ├── routes/
│   │   │   └── app_pages.dart     # App routes
│   │   └── utils/
│   │       ├── constants.dart     # App constants
│   │       └── theme.dart         # App theme
│   └── generated/               # Generated localization files
├── pubspec.yaml                 # Project dependencies
└── README.md                    # Project documentation