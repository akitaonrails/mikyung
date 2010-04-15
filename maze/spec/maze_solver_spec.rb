require 'spec_helper'
require 'mikyung'

class Maze::Enter
  def initialize
    debugger
  end
  def execute(maze)
    maze.start
  end
end

class Maze::Move
  def initialize(name)
    @name = name
  end
  def execute(direction)
    direction.send name
  end
end

class Maze::Pick
  def execute(mazes)
    mazes.maze
  end
end
class Maze::Back
  def initialize(list)
    @previous = list.delete_at(list.length-1)
  end
  def visited(actual)
    @previous
  end
end

class ExitTryingEverything
  
  def completed?(resource)
    resource.respond_to?(:exit)
  end
  
  def initialize
    @visited = []
  end
  
  def next_step(resource)
    direction = [:east, :west, :north, :south].find do |direction|
      resource.respond_to?(direction) && !@visited.include?(resource.links(direction).uri)
    end
    if direction
      Maze::Move.new(direction) 
    elsif resource.respond_to?(:start)
      Maze::Enter.new
    elsif resource.respond_to?(:maze)
      Maze::Pick.new 
    else
      Maze::Back.new(@visited)
    end
  end
  
end

context Mikyung do
#  Mikyung.new(ExitTryingEverything.new).run('http://localhost:3000/maze/0/0')
  # Mikyung.new(ExitTryingEverything.new).run('http://amundsen.com/examples/mazes/2d')
Mikyung.new(ExitTryingEverything.new).run('http://amundsen.com/examples/mazes/2d/five-by-five/')
end
