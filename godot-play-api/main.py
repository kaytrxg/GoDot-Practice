import os
import pymysql
from flask import Flask, jsonify
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
                "INSERT INTO play_sessions (game_name) VALUE (%s)", 
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


if __name__ == "__main__": 
    app.run(host="0.0.0.0", port=8080)