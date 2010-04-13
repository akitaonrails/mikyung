class Maze
  
  def map
      [ 
      "S****",
      "-****",
      "-****",
      "----X"
      ]
  end
  
  def start_point
    [0,0]
  end
  def end_point
    [4,3]
  end
  def contains(x,y)
    x>=0 && y>=0 && y<map.length && x<map[y].length
  end
  
end

class MazesController < ApplicationController
  
  respond_to :room
  
  def entry
    @maze = Maze.new
    redirect_to maze_position_url(@maze.start_point[0], @maze.start_point[1])
  end
  
  def position
    @maze = Maze.new
    y = params[:y].to_i
    x = params[:x].to_i
    raise Error "You are out of the maze" unless @maze.contains(x,y)
    raise Error "There is a wall at #{x}, #{y}" if @maze.map[y][x..x]=='*'
  end
  
end
