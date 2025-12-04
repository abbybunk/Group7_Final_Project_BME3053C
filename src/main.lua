function love.load()
  love.window.setTitle("Diabetes Glucose Control Game")
  width, height = 900, 700
  love.window.setMode(width, height)
  
  -- Game state
  gameState = "playing" -- "playing", "win", "lose"
  
  -- Glucose parameters (mg/dL)
  glucose = 120
  minGlucose = 70
  maxGlucose = 150
  dangerLow = 60
  dangerHigh = 300
  
  -- Action effects
  insulinEffect = -25  -- glucose decrease
  snackEffect = 35     -- glucose increase
  metabolicDrift = -2  -- slight decrease
  randomVariation = 8  -- +/- max
  
  -- Timing
  gameTime = 0
  targetTime = 30
  actionCooldown = 0
  actionCooldownMax = 0.5  -- seconds between actions
  
  -- UI
  font = love.graphics.getFont()
  
  -- Action history for display
  lastAction = ""
  actionDisplayTime = 0
end

function love.update(dt)
  if gameState == "playing" then
    gameTime = gameTime + dt
    actionCooldown = actionCooldown - dt
    actionDisplayTime = actionDisplayTime - dt
    
    -- Check for player input
    if actionCooldown <= 0 then
      if love.keyboard.isDown("a") then
        applyAction("insulin")
        actionCooldown = actionCooldownMax
      elseif love.keyboard.isDown("s") then
        applyAction("snack")
        actionCooldown = actionCooldownMax
      elseif love.keyboard.isDown("d") then
        applyAction("nothing")
        actionCooldown = actionCooldownMax
      end
    end
    
    -- Update glucose (only on timer ticks, every 0.5 seconds)
    if gameTime % 0.5 < dt then
      updateGlucose()
    end
    
    -- Check win condition
    if gameTime >= targetTime then
      gameState = "win"
    end
    
    -- Check lose conditions
    if glucose < dangerLow or glucose > dangerHigh then
      gameState = "lose"
    end
  elseif gameState == "win" or gameState == "lose" then
    -- Press R to restart
    if love.keyboard.isDown("r") then
      love.load()
    end
  end
end

function updateGlucose()
  local random = love.math.random() * randomVariation * 2 - randomVariation
  glucose = glucose + metabolicDrift + random
  glucose = math.max(0, glucose)
end

function applyAction(action)
  if action == "insulin" then
    glucose = glucose + insulinEffect
    lastAction = "Insulin given"
  elseif action == "snack" then
    glucose = glucose + snackEffect
    lastAction = "Snack given"
  else
    lastAction = "No action"
  end
  actionDisplayTime = 1.5
  glucose = math.max(0, glucose)
end

function love.draw()
  -- Background
  love.graphics.setColor(0.1, 0.1, 0.15)
  love.graphics.rectangle("fill", 0, 0, width, height)
  
  -- Title
  love.graphics.setColor(0.9, 0.9, 1)
  love.graphics.printf("Diabetes Glucose Control Game", 0, 30, width, "center")
  
  -- Main glucose display
  love.graphics.setFont(love.graphics.newFont(80))
  
  -- Color based on glucose level
  if glucose < minGlucose or glucose > maxGlucose then
    love.graphics.setColor(1, 0.3, 0.3)  -- Red for danger
  elseif glucose < 80 or glucose > 140 then
    love.graphics.setColor(1, 0.8, 0.2)  -- Yellow for caution
  else
    love.graphics.setColor(0.3, 0.8, 0.3)  -- Green for safe
  end
  
  love.graphics.printf(string.format("%.0f", glucose), 0, 150, width, "center")
  
  love.graphics.setFont(love.graphics.newFont(20))
  love.graphics.setColor(0.7, 0.7, 0.8)
  love.graphics.printf("mg/dL", 0, 240, width, "center")
  
  -- Safe range indicator
  love.graphics.setColor(0.5, 0.5, 0.6)
  love.graphics.printf(string.format("Safe Range: %d - %d mg/dL", minGlucose, maxGlucose), 50, 300, width - 100, "center")
  
  -- Timer
  love.graphics.setColor(0.9, 0.9, 1)
  love.graphics.printf(string.format("Time: %.1f / %.0f seconds", gameTime, targetTime), 50, 350, width - 100, "center")
  
  -- Last action display
  if actionDisplayTime > 0 then
    love.graphics.setColor(1, 1, 0.6)
    love.graphics.printf(lastAction, 50, 400, width - 100, "center")
  end
  
  -- Instructions
  love.graphics.setColor(0.6, 0.6, 0.7)
  love.graphics.printf("Press A for Insulin | S for Snack | D for Nothing", 50, 480, width - 100, "center")
  
  -- Status messages and end screen
  if gameState == "playing" then
    if glucose < minGlucose then
      love.graphics.setColor(1, 0.4, 0.4)
      love.graphics.printf("WARNING: Glucose too low!", 50, 550, width - 100, "center")
    elseif glucose > maxGlucose then
      love.graphics.setColor(1, 0.4, 0.4)
      love.graphics.printf("WARNING: Glucose too high!", 50, 550, width - 100, "center")
    end
  end
  
  -- Win/Lose screen
  if gameState == "win" then
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setColor(0.3, 1, 0.3)
    love.graphics.setFont(love.graphics.newFont(60))
    love.graphics.printf("YOU WIN!", 0, 200, width, "center")
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(0.7, 1, 0.7)
    love.graphics.printf("You maintained safe glucose control for 30 seconds!", 50, 300, width - 100, "center")
    love.graphics.printf("Final glucose: " .. string.format("%.0f", glucose) .. " mg/dL", 50, 340, width - 100, "center")
    love.graphics.setColor(0.9, 0.9, 1)
    love.graphics.printf("Press R to restart", 50, 420, width - 100, "center")
  elseif gameState == "lose" then
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, width, height)
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.setFont(love.graphics.newFont(60))
    love.graphics.printf("GAME OVER", 0, 200, width, "center")
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.setColor(1, 0.7, 0.7)
    if glucose < dangerLow then
      love.graphics.printf("Hypoglycemia! Glucose dropped below 60 mg/dL", 50, 300, width - 100, "center")
    else
      love.graphics.printf("Hyperglycemia! Glucose exceeded 300 mg/dL", 50, 300, width - 100, "center")
    end
    love.graphics.printf("Final glucose: " .. string.format("%.0f", glucose) .. " mg/dL", 50, 340, width - 100, "center")
    love.graphics.printf("Time survived: " .. string.format("%.1f", gameTime) .. " seconds", 50, 380, width - 100, "center")
    love.graphics.setColor(0.9, 0.9, 1)
    love.graphics.printf("Press R to restart", 50, 460, width - 100, "center")
  end
  
  love.graphics.setColor(1, 1, 1)
end