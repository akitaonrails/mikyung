require 'spec_helper'
require 'mikyung'

class Maze::Enter
  def execute(maze)
    maze.start.get
  end
end

class Maze::Move
  def initialize(direction)
    @direction = direction
  end
  def execute(room)
    room.item.send(@direction).get
  end
end

class Maze::Pick
  def execute(mazes)
    mazes.maze.get
  end
end

class Maze::Back
  def initialize(path)
    @path = path
  end
  def execute(actual)
    return nil if @path.empty
    last = @path.delete_at(path.length-1)
    Restfulie.at(last).get
  end
end

class ExitTryingEverything
  
  def completed?(resource)
    resource.respond_to?(:exit)
  end
  
  def initialize
    @path = []
    @visited = []
  end
  
  def next_step(resource)
    direction = [:east, :west, :north, :south].find do |direction|
      resource.respond_to?(direction) && !@visited.include?(resource.links(direction).href)
    end
    if direction
      @path << resource.links(direction).href
      @visited << resource.links(direction).href
      Maze::Move.new(direction) 
    elsif resource.respond_to?(:start)
      Maze::Enter.new
    elsif resource.respond_to?(:maze)
      Maze::Pick.new 
    else
      Maze::Back.new(@path)
    end
  end
  
end

context Mikyung do
#  Mikyung.new(ExitTryingEverything.new).run('http://localhost:3000/maze/0/0')
  # Mikyung.new(ExitTryingEverything.new).run('http://amundsen.com/examples/mazes/2d')
Mikyung.new(ExitTryingEverything.new).run('http://amundsen.com/examples/mazes/2d/five-by-five/')
end
