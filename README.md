# Flood Prediction System

# Link to Video
https://youtu.be/tm3QBt2KKpg

## Overview
This project provides a comprehensive flood risk assessment and prediction system using machine learning. It consists of a FastAPI backend that serves predictions from a trained random forest model and a cross-platform Flutter application for data input and result visualization.

## Problem Statement
Flooding is one of the most devastating natural disasters worldwide, causing loss of life, property damage, and long-term economic impact. Factors contributing to flood risk include:

- Environmental conditions (monsoon intensity, climate change)
- Infrastructure quality (drainage systems, dams)
- Human activities (deforestation, urbanization)
- Geographic factors (coastal vulnerability, watersheds)

Early prediction and risk assessment can help communities prepare, allocate resources effectively, and implement mitigation strategies before flooding occurs.

## Solution Components

### 1. Prediction API (Python/FastAPI)
- Machine learning model trained on flood risk factors
- REST API endpoint for flood probability predictions
- Risk categorization (Low, Moderate, High, Extreme)

### 2. Mobile/Web Application (Flutter)
- User-friendly interface for data input
- Intuitive visualization of flood risk results
- Cross-platform functionality (Android, iOS, Web)

## Technologies Used

- **Backend**: Python, FastAPI, scikit-learn, pandas, joblib
- **Frontend**: Flutter, Dart
- **Deployment**: Render (API hosting)
- **Machine Learning**: Random Forest algorithm

## Installation and Setup

### API Setup
```bash
# Clone the repository
git clone [repository-url]
cd Flood_Prediction_Summative/API

# Create and activate a virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the API locally
python app.py
```

### Deployment API Endpoint 
https://flood-prediction-summative.onrender.com
