-- pong game

-- constants
PADDLE_WIDTH = 20
PADDLE_HEIGHT = 150
BALL_RADIUS = 10


function love.draw()
  -- paddles
  love.graphics.rectangle("line", p1_x, p1_y, PADDLE_WIDTH, PADDLE_HEIGHT)
  love.graphics.rectangle("line", p2_x, p2_y, PADDLE_WIDTH, PADDLE_HEIGHT)

  -- ball
  love.graphics.circle("fill", ball_x, ball_y, BALL_RADIUS)

  -- score
  love.graphics.print(p1_score, 80, 10)
  love.graphics.print(p2_score, love.graphics.getWidth() - 80 - PADDLE_WIDTH/2, 10)

  -- print when someone scores
  if (P1_LOSS) then
    love.graphics.print("Player 2 Scores!!", love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/2)
  end
  if (P2_LOSS) then
    love.graphics.print("Player 1 Scores!!", love.graphics.getWidth()/2 - 50, love.graphics.getHeight()/2)
  end
end

function love.load()

  love.window.setTitle("Pong")

  -- init scoring
  p1_score = 0
  p2_score = 0

  -- position paddles and ball
  p1_x = 100
  p1_y = 50

  p2_x = love.graphics.getWidth() - 100 - PADDLE_WIDTH
  p2_y = 50

  ball_x = p2_x - (PADDLE_WIDTH + 20)
  ball_y = p1_y
  
  -- init ball moving
  downwards = true
  forwards = true
  flip = false
  flip_v = false

  -- loss state
  P1_LOSS = false
  P2_LOSS = false

end

function love.update()
  -- esc to quit game
  if (love.keyboard.isDown("escape")) then
    love.event.quit()
  end

  -- pause for the 'player scores' message
  if (P1_LOSS or P2_LOSS) then
    love.timer.sleep(2)
  end
  -- reset loss state
  P1_LOSS = false
  P2_LOSS = false
  
  -- ball bouncing horiz
  if (flip) then
    forwards = not forwards
    flip = false
  end
  -- ball bouncing vert
  if (flip_v) then
    downwards = not downwards
    flip_v = false
  end

  -- ball movement horiz
  if (forwards) then
    ball_x = ball_x + 3
  else
    ball_x = ball_x - 3
  end
  -- ball movement vert
  if (downwards) then
    ball_y = ball_y + 3
  else
    ball_y = ball_y - 3
  end

  -- player input and paddle movement
  if love.keyboard.isDown("w") then
    p1_y = p1_y - 5
  end
  if love.keyboard.isDown("s") then
    p1_y = p1_y + 5
  end
  if love.keyboard.isDown("up") then
    p2_y = p2_y - 5
  end
  if love.keyboard.isDown("down") then
    p2_y = p2_y + 5
  end

  -- keep paddles in bounds
  if (p1_y < 0) then
    p1_y = 0
  end
  if (p1_y > love.graphics.getHeight() - PADDLE_HEIGHT) then
    p1_y = love.graphics.getHeight() - PADDLE_HEIGHT
  end
  if (p2_y < 0) then
    p2_y = 0
  end
  if (p2_y > love.graphics.getHeight() - PADDLE_HEIGHT) then
    p2_y = love.graphics.getHeight() - PADDLE_HEIGHT
  end

  -- keep ball in bounds
  if (ball_y < 0) then
    ball_y = 0
    flip_v = true
  end
  if (ball_y > love.graphics.getHeight() - BALL_RADIUS*2) then
    ball_y = love.graphics.getHeight() - BALL_RADIUS*2
    flip_v = true
  end

  -- calculate bodies of paddles and ball
  p1_left_edge = p1_x
  p1_right_edge = p1_x + PADDLE_WIDTH + BALL_RADIUS
  p1_top_edge = p1_y
  p1_bottom_edge = p1_y + PADDLE_HEIGHT
  
  p2_left_edge = p2_x
  p2_right_edge = p2_x + PADDLE_WIDTH - BALL_RADIUS
  p2_top_edge = p2_y
  p2_bottom_edge = p2_y + PADDLE_HEIGHT
 
  ball_left_edge = ball_x
  ball_right_edge = ball_x + BALL_RADIUS*2
  ball_top_edge = ball_y
  ball_bottom_edge = ball_y + BALL_RADIUS*2
  ball_center_y = ball_y + BALL_RADIUS

  -- collisions
  -- ball is in p1 x region
  if (ball_left_edge > p1_left_edge and ball_left_edge <= p1_right_edge) then
    ball_x = p1_right_edge + BALL_RADIUS + 3
    -- ball is OOB on p1 y
    if (ball_bottom_edge < p1_top_edge or ball_top_edge > p1_bottom_edge) then
      P1_LOSS = true
    end 
    flip = true
  end
  -- ball is in p2 x region
  if (ball_right_edge >= p2_left_edge and ball_right_edge < p2_right_edge) then
    ball_x = p2_left_edge - BALL_RADIUS*2 + 2

    -- ball is OOB on p2 y
    if (ball_bottom_edge < p2_top_edge or ball_top_edge > p2_bottom_edge) then
      P2_LOSS = true
    end
    flip = true
  end

  -- score and reset positions
  if (P1_LOSS) then
    p2_score = p2_score + 1
    p1_y = 50
    p2_y = 50
    ball_x = p1_right_edge + 20
    ball_y = 70
  end
  if (P2_LOSS) then
    p1_score = p1_score + 1
    p1_y = 50
    p2_y = 50
    ball_x = p2_left_edge - 20
    ball_y = 70
  end
end