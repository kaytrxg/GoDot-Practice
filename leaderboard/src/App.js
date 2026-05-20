import { useState, useEffect } from "react"; 
import "./App.css";

const API_BASE = "https://godot-play-api-831129541610.us-east1.run.app"; 

const GAMES = [
  { id: "alphabet-warp", label: "Alphabet Warp" }, 
  { id: "alphabet-detailed", label: "Alphabet Detailed" },
];


function App() {
  const [activeGame, setActiveGame] = useState("alphabet-warp");
  const [scores, setScores] = useState([]);
  const [loading, setLoading] = useState(true); 

  useEffect(() => {
    setLoading(true);
    fetch(`${API_BASE}/leaderboard/${activeGame}`)
      .then((res) => res.json())
      .then((data) => {
        setScores(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, [activeGame]);


  return (
    <div className="app">
      <h1> GoDot Practice </h1>
      <p className="subtitle">Leaderboard</p>

      <div className="tabs">
        {GAMES.map((game) => (
          <button
          key = {game.id}
          className = {activeGame === game.id ? "tab active" : "tab"}
          onClick={() => setActiveGame(game.id)}
          >
            {game.label}
          </button>
        ))}
      </div>
      {loading ? (
        <p className = "loading">Loading...</p>
      ) : (
        <table className="leaderboard">
          <thead>
            <tr>
              <th>#</th>
              <th>Player</th>
              <th>Score</th>
              <th>Date</th>
            </tr>
          </thead>
          <tbody>
            {scores.map((score, index) => (
              <tr key = {index} className = {index < 3 ? `rank-${index + 1}` : ""}>
                <td> {index + 1} </td>
                <td> {score.player_name}</td>
                <td> {score.score}</td>
                <td> {new Date(score.played_at).toLocaleDateString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

export default App;
