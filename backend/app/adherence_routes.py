from fastapi import APIRouter
from pydantic import BaseModel
from ml.adherence_model import predict_adherence

router = APIRouter()

class MedicineData(BaseModel):
    medicine: str
    time_of_day: str

@router.post("/predict-adherence")
def predict(data: MedicineData):
    result = predict_adherence(data.medicine, data.time_of_day)
    return result
