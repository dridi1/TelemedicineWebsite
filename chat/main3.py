import os
import logging
from typing import List
import tensorflow as tf
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from transformers import AutoTokenizer, TFAutoModelForSequenceClassification

# ─── 0) (Optional) Suppress TF INFO/WARNING logs ─────────────────────────────────
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'  # 0=DEBUG,1=INFO,2=WARNING,3=ERROR
tf.get_logger().setLevel('ERROR')

# ─── 1) Logging & Debug Mode ─────────────────────────────────────────────────────
logging.basicConfig(level=logging.DEBUG,
                    format="%(asctime)s %(levelname)s %(message)s")
app = FastAPI(debug=True)

# ─── 2) Pydantic Models ──────────────────────────────────────────────────────────
class SymptomQuery(BaseModel):
    texts: List[str]

class Prediction(BaseModel):
    label: str
    confidence: float

class PredictionResponse(BaseModel):
    predictions: List[Prediction]

# ─── 3) Load model + tokenizer ─────────────────────────────────────────────────
MODEL_DIR = "./bert_symptom2disease"
tokenizer = AutoTokenizer.from_pretrained(MODEL_DIR)
model     = TFAutoModelForSequenceClassification.from_pretrained(MODEL_DIR)

# Normalize id2label to use integer keys
raw_id2label = model.config.id2label
id2label = { int(k): v for k, v in raw_id2label.items() }

# ... (keep all your existing imports and setup code)

# ─── 4) Inference with confidence ────────────────────────────────────────────────
def predict_with_confidence(texts: List[str]) -> List[Prediction]:
    # Tokenize inputs
    encodings = tokenizer(
        texts,
        padding=True,
        truncation=True,
        return_tensors="tf"
    )
    # Run model
    outputs = model(encodings)
    logits  = outputs.logits                              # shape: (batch_size, num_labels)
    probs   = tf.nn.softmax(logits, axis=-1).numpy()      # convert logits → probabilities

    results: List[Prediction] = []
    for prob_vector in probs:
        pred_idx   = int(tf.math.argmax(prob_vector).numpy())
        label_name = id2label.get(pred_idx, f"UNKNOWN_{pred_idx}")
        confidence = float(prob_vector[pred_idx])
        results.append(Prediction(label=label_name, confidence=confidence))

    return results

def format_diagnosis_with_scores(
    texts: List[str],
    threshold_high: float = 0.75,
    threshold_mid: float = 0.5
) -> List[str]:
    """
    Runs texts through the model and returns human‑readable diagnostic messages
    including confidence percentages and advice to see a professional.
    """
    # Tokenize & predict
    encodings = tokenizer(
        texts,
        padding=True,
        truncation=True,
        return_tensors="tf"
    )
    outputs = model(encodings)
    probs = tf.nn.softmax(outputs.logits, axis=-1).numpy()
    
    formatted = []
    for text, prob_vector in zip(texts, probs):
        pred_idx = int(tf.math.argmax(prob_vector).numpy())
        score = float(prob_vector[pred_idx])
        label = id2label.get(pred_idx, f"UNKNOWN_{pred_idx}")
        pct = score * 100
        
        # Choose wording based on thresholds
        if score >= threshold_high:
            verdict = "very likely"
        elif score >= threshold_mid:
            verdict = "likely"
        elif score >= 0.3:
            verdict = "possible"
        else:
            formatted.append(
                "Your symptoms don’t strongly match any one condition. "
                "We recommend consulting a qualified healthcare professional for further evaluation."
            )
            continue
        
        formatted.append(
            f"After analysis, there is a {pct:.1f}% chance you have **{label}**, "
            f"which makes it {verdict} given your reported symptoms. "
            "Please consider seeking advice from a healthcare professional."
        )
    
    return formatted

# ─── 5) Health-check endpoint ───────────────────────────────────────────────────
@app.get("/ping")
async def ping():
    return {"status": "alive"}

# ─── 6) Prediction endpoints ──────────────────────────────────────────────────────
@app.post(
    "/predict",
    response_model=PredictionResponse,
    summary="Predict disease labels for symptom texts",
    description="Returns one predicted disease label per input text, along with its confidence score."
)
async def predict_disease(query: SymptomQuery):
    if not query.texts:
        raise HTTPException(status_code=400, detail="No texts provided")
    try:
        preds = predict_with_confidence(query.texts)
        return PredictionResponse(predictions=preds)
    except Exception as e:
        logging.exception("Prediction failed")
        raise HTTPException(status_code=500, detail=f"Internal error: {e}")

@app.post(
    "/predict/formatted",
    response_model=List[str],
    summary="Get formatted diagnosis predictions",
    description="Returns formatted diagnosis messages with likelihood indicators."
)
async def predict_disease_formatted(query: SymptomQuery, threshold: float = 0.75):
    if not query.texts:
        raise HTTPException(status_code=400, detail="No texts provided")
    try:
        formatted_preds = format_diagnosis_with_scores(query.texts, threshold)
        return formatted_preds
    except Exception as e:
        logging.exception("Formatted prediction failed")
        raise HTTPException(status_code=500, detail=f"Internal error: {e}")


# ─── 7) Run with:
# uvicorn main:app --reload --host 0.0.0.0 --port 8000