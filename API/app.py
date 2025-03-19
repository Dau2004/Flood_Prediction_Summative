import joblib
import pandas as pd
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import uvicorn
model_path = 'models/rf_model.pkl'
scaler_path = 'models/scaler.pkl'
# Load the trained model and scaler
model = joblib.load(model_path)
scaler = joblib.load(scaler_path)

# Define the input data schema using Pydantic
class PredictionInput(BaseModel):
    MonsoonIntensity: int = Field(..., ge=0, le=15, description="Intensity of monsoon (0-15)")
    TopographyDrainage: int = Field(..., ge=0, le=15, description="Quality of topography drainage (0-15)")
    RiverManagement: int = Field(..., ge=0, le=15, description="Quality of river management (0-15)")
    Deforestation: int = Field(..., ge=0, le=15, description="Level of deforestation (0-15)")
    Urbanization: int = Field(..., ge=0, le=15, description="Level of urbanization (0-15)")
    ClimateChange: int = Field(..., ge=0, le=15, description="Impact of climate change (0-15)")
    DamsQuality: int = Field(..., ge=0, le=15, description="Quality of dams (0-15)")
    Siltation: int = Field(..., ge=0, le=15, description="Level of siltation (0-15)")
    AgriculturalPractices: int = Field(..., ge=0, le=15, description="Quality of agricultural practices (0-15)")
    Encroachments: int = Field(..., ge=0, le=15, description="Level of encroachments (0-15)")
    IneffectiveDisasterPreparedness: int = Field(..., ge=0, le=15, description="Level of ineffective disaster preparedness (0-15)")
    DrainageSystems: int = Field(..., ge=0, le=15, description="Quality of drainage systems (0-15)")
    CoastalVulnerability: int = Field(..., ge=0, le=15, description="Level of coastal vulnerability (0-15)")
    Landslides: int = Field(..., ge=0, le=15, description="Risk of landslides (0-15)")
    Watersheds: int = Field(..., ge=0, le=15, description="Quality of watersheds (0-15)")
    DeterioratingInfrastructure: int = Field(..., ge=0, le=15, description="Level of deteriorating infrastructure (0-15)")
    PopulationScore: int = Field(..., ge=0, le=15, description="Population density score (0-15)")
    WetlandLoss: int = Field(..., ge=0, le=15, description="Level of wetland loss (0-15)")
    InadequatePlanning: int = Field(..., ge=0, le=15, description="Level of inadequate planning (0-15)")
    PoliticalFactors: int = Field(..., ge=0, le=15, description="Impact of political factors (0-15)")

app = FastAPI(title="Flood Prediction API")

# Configure CORS middleware
origins = ["*"]  # Allows all origins. Adjust as needed

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post('/predict')
async def predict(input_data: PredictionInput):
    try:
        # Convert input data to DataFrame
        input_df = pd.DataFrame([input_data.dict()])
        
        # Scale input features
        input_scaled = scaler.transform(input_df)

        # Make prediction
        prediction = model.predict(input_scaled)[0]

        # Determine risk level
        if prediction < 0.3:
          risk_level = "Low"
        elif prediction < 0.5:
          risk_level = "Moderate"
        elif prediction < 0.7:
          risk_level = "High"
        else:
          risk_level = "Extreme"
        
        return {
          "flood_probability": round(prediction, 3),
          "risk_level": risk_level
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")

if __name__ == "__main__":
    import uvicorn
    import os
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("app:app" , host="0.0.0.0", port=port)