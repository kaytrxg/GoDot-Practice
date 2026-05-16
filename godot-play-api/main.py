import os
import pymysql
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

def get_db_connection():    #pulls your database credentials and opens a connection to CloudSQL
    return pymysql.connect(
        host=os.environ.get("DB_HOST"),
        user=os.environ.get("DB_USER"),
        password=os.environ.get("DB_PASS"),
        database=os.environ.get("DB_NAME"),
        cursorclass=pymysql.cursors.DictCursor
    )

@app.route("/log/<game_name>", methods=["POST"]) 
#/log/<game_name> --> the endpoint GoDot hits when a game launcches. 
def log_play(game_name): #/log/alphabet-warp --> "alphabet-warp" in the table row
    conn = get_db_connection()
    with conn: 
        with conn.cursor() as cursor: 
            cursor.execute(
                "INSERT INTO play_sessions (game_name) VALUES (%s)", 
                (game_name,)
            )
        conn.commit()
    return jsonify({"status": "ok", "game": game_name})

@app.route("/stats", methods=["GET"])
#/stats --> endpoint that returns how many time each game has been played 
def get_stats(): 
    conn = get_db_connection()
    with conn: 
        with conn.cursor() as cursor: 
            cursor.execute(
                "SELECT game_name, Count(*) as total_plays FROM play_sessions GROUP BY game_name"
            )
            results = cursor.fetchall()
    return jsonify(results)

@app.route("/leaderboard/<game_name>", methods=["GET"])
#/leaderboard --> currently has test data for testing reasons
def get_leaderboard(game_name):
    conn = get_db_connection()
    with conn: 
        with conn.cursor() as cursor: 
            cursor.execute(
                "SELECT player_name, score, played_at FROM scores WHERE game_name = %s ORDER BY score DESC LIMIT 10",
                (game_name,)
            )
            results = cursor.fetchall()
    return jsonify(results)

@app.route("/leaderboard/<game_name>", methods=["POST"])
def post_score(game_name):
    data = request.get_json()
    player_name = data.get("player_name")
    score = data.get("score")
    conn = get_db_connection()
    with conn: 
        with conn.cursor() as cursor: 
            cursor.execute(
                "INSERT INTO scores (game_name, player_name, score) VALUES (%s, %s, %s)",
                (game_name, player_name, score)
            )
        conn.commit()
    return jsonify({"status": "ok", "game": game_name, "player": player_name, "score": score})


if __name__ == "__main__": 
    app.run(host="0.0.0.0", port=8080)

# LIVE GCLOUD Link: https://godot-play-api-831129541610.us-east1.run.app