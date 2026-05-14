# GoDot Practice

A collection of Godot 4 projects built while learning game development with the help of AI tools like Claude and Warp.

## Projects

### alphabet-detailed
An alphabet navigation game built from a detailed AI prompt. Use arrow keys to move through the 26-letter alphabet — each key moves a different number of steps. Tracks which letters you've visited and awards points for discovering new ones. Wraps around from Z back to A.

### alphabet-warp
A letter-catching game inspired by Warp terminal's creative interpretation of a minimal prompt. Letters fall from the top of the screen and you control a catcher at the bottom. The goal is to catch the letters that spell "WARP" in order, with a combo scoring system.

### godot-play-api
A Flask/Python backend API deployed on Google Cloud that tracks play session stats for the games in this repo. Games log to it on launch, and it exposes a `/stats` endpoint to view play counts. Uses a MySQL database via Cloud SQL.

### moving_character-ai-
A multi-level 2D platformer with gravity-based jumping and collision mechanics. Features three levels with standard platforms, bouncy platforms (extra jump height), and breakable platforms that disappear on landing. Built with help from Claude to understand the physics code.

### twinkle_twinkle
A beginner development level, with the theme being the "Twinkle Twinkle Little Star" lullably. Involves an artistic freedom through the character and the game environment. Experiments with user interactivity, database setup with tracking progress, and leaderboard setups within the game. 

## Notes

- All games that log play sessions use the shared `godot-play-api` backend.
- Projects vary in complexity and reflect a progression from simple input handling to multi-scene physics-based gameplay.
