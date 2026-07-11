from pathlib import Path

scene = """[gd_scene format=3]

[node name="FpsScene" type="Node3D"]

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]

[node name="DirectionalLight3D" type="DirectionalLight3D" parent="."]
transform = Transform3D(0.7, -0.5, 0.5, 0, 0.7, 0.7, -0.7, -0.5, 0.5, 0, 10, 0)

[node name="Floor" type="MeshInstance3D" parent="."]

[node name="Player" type="CharacterBody3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0)

[node name="CollisionShape3D" type="CollisionShape3D" parent="Player"]

[node name="Head" type="Node3D" parent="Player"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.7, 0)

[node name="Camera3D" type="Camera3D" parent="Player/Head"]
"""

output_path = Path(__file__).resolve().parent / "scenes" / "fps_scene.tscn"
output_path.parent.mkdir(parents=True, exist_ok=True)

with open(output_path, "w") as f:
    f.write(scene)

print("fps_scene.tscn generated successfully")
