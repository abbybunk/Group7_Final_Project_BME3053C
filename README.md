# Diabetes Glucose Control Game

An educational biomedical game built in LÖVE 2D that teaches diabetes management through blood glucose control.

## Biomedical Context

This game is designed to help players understand the challenge of managing type 1 diabetes. Players must balance insulin injections and food intake to keep a virtual patient's blood glucose within a safe range (70-150 mg/dL). The game illustrates the dynamic nature of glucose homeostasis and the consequences of poor glycemic control.

## Quick Start Instructions

### Play the Game in Your Browser

**The easiest way to play:** Open the web version directly in your browser
- Simply open `index.html` in any modern web browser
- The game is fully playable with mouse clicks or keyboard controls

### Running the LÖVE 2D Version Locally

If you have LÖVE 2D installed on your computer, run the game with:
```bash
DISPLAY=:0 love /path/to/Group7_Final_Project_BME3053C
```

Or if you're in the game directory:
```bash
DISPLAY=:0 love .
```

## Usage Guide

### Objective
Keep your virtual patient's blood glucose between **70–150 mg/dL** for **30 seconds** to win.

### Game Mechanics

**Controls:**
- **A** - Give Insulin (decreases glucose by ~25 mg/dL)
- **S** - Give Snack (increases glucose by ~35 mg/dL)
- **D** - Do Nothing (glucose changes naturally)
- **R** - Restart (after win/lose)

**Glucose Dynamics:**
- Glucose naturally decreases slightly each tick (metabolic drift: -2 mg/dL)
- Random variations (+/- up to 8 mg/dL) simulate natural fluctuations
- Insulin action: G(t+1) = G(t) - 25
- Snack action: G(t+1) = G(t) + 35
- No action: G(t+1) = G(t) + M + R (metabolism + random)

**Win Condition:**
Maintain safe glucose (70-150 mg/dL) for the full 30-second timer.

**Lose Conditions:**
- **Hypoglycemia:** Glucose falls below 60 mg/dL (dangerous low blood sugar)
- **Hyperglycemia:** Glucose exceeds 300 mg/dL (dangerous high blood sugar)

### Game Strategy Tips
- Insulin takes effect immediately, so use it when glucose is rising
- Snacks have a stronger effect than insulin, so be careful not to overcorrect
- Small adjustments often work better than large ones
- Pay attention to glucose trends—anticipate changes before they happen

## Biomedical Accuracy

The game implements simplified but realistic glucose dynamics:
- **Basal metabolism** causes slight glucose decrease (like fasting metabolism)
- **Random variations** represent natural physiological variation
- **Insulin resistance** and **carbohydrate absorption** are simplified but captured through fixed effect values
- The safe range (70-150 mg/dL) reflects clinical targets for glycemic control
- Danger thresholds (60 and 300) represent clinically significant extremes

## Project Structure

- `main.lua` - Complete game implementation with all game logic, rendering, and input handling
- `README.md` - This documentation file
- `.devcontainer/` - Configuration for GitHub Codespaces environment
- `.vscode/` - VS Code settings

## Requirements

- LÖVE 2D framework (pre-installed in Codespaces)
- Lua runtime (included with LÖVE)
- X11 display server (for headless Codespaces environments)
