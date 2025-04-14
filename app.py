from flask import Flask, request, jsonify
from flask_cors import CORS
from models import db, User
import openai
from openai import OpenAI
import os
from dotenv import load_dotenv

if os.getenv("RENDER") is None:
    load_dotenv()
    
app = Flask(__name__)
CORS(app)  # Allows calls from your SwiftUI frontend

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# Configure DB
#app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://workout_schedular_db_user:8QcxamQr9BvuLF7Vo0djxbflKNV4O5wL@dpg-cvu70qvgi27c73af1l10-a/workout_schedular_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv("DATABASE_URL")
app.config['SQLALCHEMY_ENGINE_OPTIONS'] = {
    "connect_args": {"sslmode": "require"}
}

db.init_app(app)

# Run once to initialize the DB
#with app.app_context():
#    db.create_all()

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


# Route: Sign Up
@app.route("/signup", methods=["POST"])
def signup():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        return jsonify({"error": "Missing email or password"}), 400

    # Check if user exists
    if User.query.filter_by(email=email).first():
        return jsonify({"error": "User already exists"}), 409

    # Create and save new user
    user = User(email=email)
    user.set_password(password)
    db.session.add(user)
    db.session.commit()

    return jsonify({"message": "User created"}), 201

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    app.run(debug=True)
