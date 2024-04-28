from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import pandas as pd
import re
import random
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.metrics import accuracy_score
from joblib import load

app = FastAPI()

class TextData(BaseModel):
    message: str

model_bundle = load('model.joblib')
model = model_bundle['model']
vectorizer = model_bundle['vectorizer']

def normalize_text(text):
    return re.sub(r"\s+", "", text)

@app.post("/predict/")
async def predict_profanity(data: TextData):
    normalized_text = normalize_text(data.message)
    transformed_text = vectorizer.transform([normalized_text])
    prediction = model.predict(transformed_text)
    is_profanity = prediction[0] == 1 
    return {"profanity": bool(is_profanity)}

@app.get("/health-check")
async def health_check():
    return {"status": "ok"}