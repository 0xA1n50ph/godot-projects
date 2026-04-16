# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

A classic Breakout/Block Breaker game built in **Godot 4** using GDScript.

## Running the Game

Open the project in Godot 4 and press **F5** (Run Project) or **F6** (Run Current Scene). There is no CLI build system — all development is done through the Godot editor.

## Architecture

### Autoload (Singleton)
`Scripts/game_manager.gd` is the global autoload singleton (`GameManager`). It owns all shared game state: `score`, `level`, `lives`. It exposes two signals used for cross-node communication:
- `brick_hit` — emitted by `brick.gd`, consumed by `ball.gd` to trigger speed increase
- `gameover` — emitted when lives hit 0, consumed by `level.gd` to reload the scene

### Scene Structure (`Levels/level.tscn`)
```
Level (Node2D) — level.gd
├── Camera2D
├── Player (S_Player.tscn) — player.gd
├── Ball (S_Ball.tscn) — ball.gd
├── BorderLimits (StaticBody2D) — left/right/top walls
├── DeathZone (Area2D) — triggers ball death at bottom
├── Background (ColorRect, z_index=-1) — ShaderMaterial using background_waves.gdshader
└── UI (Control) — ScoreLabel, LevelLabel, LivesIcon1/2/3
```

The `Ball` node looks up `Player` via `get_parent().get_node("Player")` in `_ready()`, so both must be siblings under the same parent.

The `DeathZone` signal `body_entered` connects directly to `Ball._on_death_zone_body_entered` in the scene file.

### Ball (`Scripts/ball.gd`)
- `isActive` flag gates movement; when false the ball tracks the paddle and previews launch angle
- Launch angle is calculated from mouse X offset relative to paddle center, capped at `maxBounceAngleDeg`
- Same angle formula is used for both launch preview and paddle bounce
- Speed increases by `speedIncrement` per brick hit, capped at `maxSpeed`, and resets on death

### Brick (`Scripts/brick.gd`)
On `hit()`: hides sprite, disables collision, adds 100 score, emits `GameManager.brick_hit`, then `queue_free()` after a 1-second timer.

### Level Setup (`Scripts/level.gd`)
Bricks are spawned procedurally in an 18×7 grid. Row color tiers: rows 0–6 = color[0], rows 0–5 = color[1], rows 0–2 = color[2] (later rows override earlier assignments top-to-bottom). Colors are shuffled each load.

`setup_background_shader()` is called from `_ready()` after `setupLevel()`. It randomizes all shader uniforms on the `Background` node's `ShaderMaterial`: emitter count (3–6), emitter positions, per-emitter frequency/speed/amplitude/phase, and one of 5 curated dark color palettes. Runs on every scene load, including after game over.

### Background Shader (`Shaders/background_waves.gdshader`)
A `canvas_item` shader producing an animated water-disturbance aesthetic:
- Up to 6 radial sine wave emitters; interference patterns emerge from summing all waves
- Aspect-ratio corrected so waves are circular (uniform `aspect_ratio = 1152/648`)
- Normalized wave sum mapped through a 3-stop color gradient (`color_deep → color_mid → color_bright`)
- All parameters are uniforms set from GDScript — no hardcoded values in the shader itself
- `TIME` built-in drives continuous seamless animation with no GDScript per-frame cost
