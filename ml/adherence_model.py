import random

def predict_adherence(medicine, time_of_day):
    
    
    risk_times = ["night", "afternoon"]
    
    if time_of_day.lower() in risk_times:
        probability = random.randint(60, 90)
    else:
        probability = random.randint(20, 50)

    if probability > 70:
        suggestion = "High chance of missing dose. Enable smart reminders."
    else:
        suggestion = "Adherence looks good."

    return {
        "miss_probability": f"{probability}%",
        "suggestion": suggestion
    }
