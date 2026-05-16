# GoDot Practice

A collection of Godot 4 games connected to a live cloud backend — built to learn game development while practicing real backend infrastructure.

**Stack:** Python · Flask · MySQL · Google Cloud Run · Cloud SQL · Docker · GDScript · REST APIs

---

## Backend — godot-play-api

A Flask/Python REST API containerized with Docker and deployed on **Google Cloud Run**, backed by **MySQL via Cloud SQL**. Games in this repo POST to it on launch and query it for stats.

**Live API:** `https://godot-play-api-831129541610.us-east1.run.app`

| Endpoint | Method | Description |
|---|---|---|
| `/log/<game_name>` | POST | Logs a play session for the given game |
| `/stats` | GET | Returns total play counts grouped by game |

**Architecture:**
```
[Godot Game]
     |
     | POST /log/<game_name>
     v
[Flask API — Google Cloud Run]
     |
     | INSERT / SELECT
     v
[MySQL — Cloud SQL]
     |
     | GET /stats
     v
[JSON response]
```

---

## Games

### twinkle_twinkle
A creative beginner project themed around the "Twinkle Twinkle Little Star" lullaby. Features a hand-built bedroom environment using polygon-based scene design, user interactivity, and database-tracked play sessions connected to the shared API. Experiments with leaderboard setup and progress tracking.

**Connected to API:** yes — logs on launch via `HTTPRequest`

---

### moving_character-ai
A multi-level 2D platformer with gravity-based physics and collision mechanics. Three levels with standard platforms, bouncy platforms with high restitution, and breakable platforms that disappear on landing. Includes a closing victory screen with restart support. Built alongside Claude to understand Godot's physics and scene-switching systems.

**Levels:** world → level_2 → level_3 → closing screen

---

### alphabet-detailed
An alphabet navigation game built from a detailed AI prompt using Warp terminal. Arrow keys move through the 26-letter alphabet by different step sizes — right (+1), up (+2), left (−1), down (−3). Tracks which letters have been visited and awards points for each new discovery. Wraps from Z back to A.

**Connected to API:** yes — logs on launch via `HTTPRequest`

---

### alphabet-warp
A letter-catching game created from a single minimal prompt to Warp terminal — testing the AI's creativity with no direction given. Letters fall from the top of the screen and you control a catcher at the bottom. The goal is to catch the letters spelling "WARP" in order, with a combo scoring system that rewards streaks and penalizes wrong catches.

**Connected to API:** yes — logs on launch via `HTTPRequest`

---

## Notes

- `alphabet-detailed`, `alphabet-warp`, and `twinkle_twinkle` all log play sessions to the shared API on launch
- Projects reflect a progression: simple input handling → physics-based multi-scene gameplay → live cloud-connected backend
- AI tools used across the repo include Claude (code understanding, physics logic) and Warp terminal (scene generation from prompts)
