<div align="center">
  <img src="docs/logo/ic_logo_sigap.png" alt="SIGAP Logo" width="200"/>

  # SIGAP

  *Smart Intervention for Guarding Against Stroke*

  [![Deployed API](https://img.shields.io/badge/API%20Deployed-Live-success.svg)](http://69.62.82.146:3000/api)
  [![Flutter](https://img.shields.io/badge/Built%20with-Flutter-02569B.svg)](https://flutter.dev/)
  [![Go](https://img.shields.io/badge/Backend-Golang-00ADD8.svg)](https://golang.org/)
  [![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
</div>

## 🌟 About SIGAP

**SIGAP** is an AI-powered gamified health platform designed to prevent stroke through personalized risk assessments, engaging gamification elements, and community support. Our solution addresses the critical need for effective stroke prevention in Indonesia, where stroke prevalence has reached 8.3 per 1,000 population and accounts for 18.5% of total deaths.

<div align="center">
  <img src="docs/ui/ui-design-main-future.png" alt="SIGAP UI" width="800"/>
</div>

### 🔑 Key Features

- 🔮 Personalized Stroke Risk Prediction  
- 🎮 Gamified Health Improvement Journey  
- 🍎 AI-Based Nutrition Monitoring  
- 🏃‍♀️ Activity Tracking  
- 🤖 Personalized Health Chatbot  

---

## 🌊 Background & Motivation

Stroke remains a leading cause of death and disability worldwide, with a significant impact on Indonesia. Despite the availability of various health applications, many lack personalization and engaging elements, leading to suboptimal user adherence. Research indicates that gamification can effectively facilitate behavior change and enhance user engagement in health interventions. However, there is a scarcity of platforms that integrate AI-driven personalized risk assessments with gamified health promotion strategies specifically targeting stroke prevention.

---

## 💡 Feature Details

### 🔮 Personalized Stroke Risk Prediction
- AI-powered algorithms analyze individual health data, lifestyle habits, and known risk factors  
- Tailored recommendations and action plans to mitigate identified risks  
- Regular progress tracking and risk reassessment  

### 🎮 Gamified Health Improvement Journey
- Engaging challenges, rewards, and progress tracking  
- Points and badges for completing health-related activities  
- Achievement system fostering continuous engagement  

### 🍎 AI-Based Nutrition Monitoring
- Photo-based food logging  
- AI analysis of caloric and nutritional content  
- Personalized dietary feedback and recommendations  
- Healthy food suggestions  

### 🏃‍♀️ Activity Tracking
- Jogging and yoga tracking with real-time metrics  
- Personalized workout recommendations  
- Activity history and progress visualization  

### 🤖 Personalized Health Chatbot
- AI-powered health assistant  
- Answers to health questions  
- Reminders and tips  

---

## 🌐 Access the API

The SIGAP backend API is live at:  
👉 **http://69.62.82.146:3000/api**

---

## 🚀 Local Development

### 1. Clone the Repository
```bash
git clone https://github.com/habdil/sigap-app.git
cd sigap-app
2. Backend Setup
bash
Copy
Edit
cd backend
cp .env.example .env
# Edit the .env file with your configuration

go run main.go

3. Frontend Setup
bash
Copy
Edit
cd ../frontend
flutter pub get
flutter run
🧰 Technology Stack
<div align="center"> <img src="docs/logo/flutter.png" alt="Flutter" height="50"/> <img src="docs/logo/golang.png" alt="Golang" height="50"/> <img src="docs/logo/gemini.png" alt="Gemini AI" height="50"/> <img src="docs/logo/supabase.png" alt="Supabase" height="50"/> <img src="docs/logo/posgre.png" alt="PostgreSQL" height="50"/> <img src="docs/logo/docker.png" alt="Docker" height="50"/> </div>
🖥️ Frontend
Flutter: Cross-platform UI toolkit

BLoC Pattern: For state management

RESTful API Integration

🖧 Backend
Golang: High-performance API

Supabase: Auth & database service

PostgreSQL: Robust relational database

Gemini AI: Personalized health insights

Docker: Containerization

📁 Application Structure
Backend
bash
Copy
Edit
📁 backend/
├── config/         # Configuration
├── controllers/    # Request handlers
├── middlewares/    # Middleware functions
├── models/         # Data models
├── repository/     # Data access logic
├── routes/         # API routes
├── services/       # Business logic
├── utils/          # Helper functions
└── main.go         # Entry point
Frontend
bash
Copy
Edit
📁 frontend/
├── assets/         # Static files
└── lib/
    ├── blocs/      # BLoC architecture
    ├── config/     # App config
    ├── models/     # Data models
    ├── providers/  # State providers
    ├── services/   # API interaction
    ├── shared/     # Shared widgets
    ├── ui/         # UI components
    └── main.dart   # Entry point
🔌 API Endpoints
Main endpoints:

GET /api/auth – User authentication

GET /api/profile – Profile management

POST /api/assessment – Stroke risk prediction

POST /api/activity – Activity tracking

POST /api/food – Nutrition logging

POST /api/chatbot – AI assistant

GET /api/coin – Reward system

👥 Development Team
UII INFORVATION TEAM
Name	Role	Position
Habdil Iqrawardana	Product Owner	Hustler
Rakha Dzikra Guevara	UI/UX Designer	Hipster
Khoirul Rizal Kalam	Frontend Developer	Hacker
Abdullah Alhwyji	Backend Developer	Hacker

📄 License
This project is licensed under the MIT License – see the LICENSE file for details.

🙏 Acknowledgements
Google Solution Challenge 2025

Ministry of Health Indonesia

All beta testers and early supporters

<div align="center"> Made with ❤️ by the SIGAP Team </div> ```