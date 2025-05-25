import sys
import os
import pytest

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from app import app, db
from models import User

@pytest.fixture
def client():
    app.config["TESTING"] = True
    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///:memory:"
    app.config["JWT_SECRET_KEY"] = "test-secret"
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client
        with app.app_context():
            db.drop_all()

def test_signup(client):
    response = client.post("/signup", json={
        "email": "testuser@example.com",
        "password": "securepass"
    })
    assert response.status_code == 201
    assert b"User created" in response.data

def test_login(client):
    # First sign up
    client.post("/signup", json={
        "email": "testuser@example.com",
        "password": "securepass"
    })

    # Then try login
    response = client.post("/login", json={
        "email": "testuser@example.com",
        "password": "securepass"
    })
    assert response.status_code == 200
    assert b"access_token" in response.data

def test_generate_plan(client):
    # Sign up + login to get JWT token
    client.post("/signup", json={"email": "testuser@example.com", "password": "securepass"})
    login_resp = client.post("/login", json={"email": "testuser@example.com", "password": "securepass"})
    token = login_resp.get_json()["access_token"]

    # Send auth request
    headers = {"Authorization": f"Bearer {token}"}
    response = client.post("/generate-plan", json={
        "bmi": 22.5,
        "goal": "lean muscular"
    }, headers=headers)

    assert response.status_code == 200
    assert isinstance(response.get_json(), list)
    assert "day" in response.get_json()[0]
    assert "workout" in response.get_json()[0]
