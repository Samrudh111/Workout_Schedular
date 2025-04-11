from flask import Flask, request, jsonify
from flask_cors import CORS
import openai
from openai import OpenAI
import os
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)
CORS(app)  # Allows calls from your SwiftUI frontend

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
#openai.api_key = os.getenv("OPENAI_API_KEY")  # Set your key via env var

@app.route("/generate-plan", methods=["POST"])
def generate_plan():
    # return jsonify([
    #     {"day": "Monday", "workout": "Chest + HIIT"},
    #     {"day": "Tuesday", "workout": "Back + Cardio"},
    #     {"day": "Wednesday", "workout": "Legs"},
    #     {"day": "Thursday", "workout": "Shoulders + Abs"},
    #     {"day": "Friday", "workout": "Arms + Core"},
    #     {"day": "Saturday", "workout": "Full Body Stretch"},
    #     {"day": "Sunday", "workout": "Rest"}
    # ])
    data = request.json
    bmi = data.get("bmi")
    goal = data.get("goal")

    prompt = f"""
    Create a 7-day personalized gym workout plan for someone with a BMI of {bmi}, aiming for a {goal} physique.
    Output in JSON format like:
    [
      {{"day": "Monday", "workout": "Chest + 20 min cardio"}},
      ...
    ]
    """

    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[{"role": "user", "content": prompt}],
            temperature=0.7
        )
        reply = response.choices[0].message.content
        
        # Evaluate response as JSON list
        workout_plan = eval(reply) if reply.strip().startswith("[") else []

        return jsonify(workout_plan)

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
