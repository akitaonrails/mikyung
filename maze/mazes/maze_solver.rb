require 'mikyung'

class EnterMaze
  def execute(maze)
    maze.start
  end
end

class Direction
  def execute(direction)
    direction.send class.name.downcase.to_sym
  end
end
class North < Direction
end
class South < Direction
end
class East < Direction
end
class West < Direction
end
class PickMaze
  def execute(mazes)
    mazes.maze
  end
end

class ExitTryingEverything < RelationDrivenObjective
  
  def completed?(resource)
    resource.respond_to?(:exit)
  end
  
  executes East, :when => has_relation(:east)
  executes West, :when => has_relation(:west)
  executes North, :when => has_relation(:north)
  executes South, :when => has_relation(:south)
  executes EnterMaze, :when => has_relation(:start)
  
  executes PickMaze, :when => has_relation(:maze)
  
  
end

Mikyung.new(ExitTryingEverything.new).run('http://amundsen.com/examples/mazes/2d/')
