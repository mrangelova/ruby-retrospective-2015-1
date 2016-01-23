def create_board(dimensions)
  xs = (0...dimensions[:width]).to_a
  ys = (0...dimensions[:height]).to_a
  xs.product(ys)
end

def move_head(snake, direction)
  head = snake.last
  head.zip(direction).map { |x, y| x + y }
end

def new_food(food, snake, dimensions)
  board = create_board(dimensions)
  free_positions = board - food - snake
  free_positions.sample
end

def move(snake, direction)
  grow(snake, direction).drop(1)
end

def grow(snake, direction)
  snake + [move_head(snake, direction)]
end

def obstacle_ahead?(snake, direction, dimensions)
  board = create_board(dimensions)
  next_head_position = move_head(snake, direction)
  snake.include? next_head_position or !board.include? next_head_position
end

def danger?(snake, direction, dimensions)
  obstacle_ahead?(snake, direction, dimensions) or
    obstacle_ahead?(move(snake, direction), direction, dimensions)
end