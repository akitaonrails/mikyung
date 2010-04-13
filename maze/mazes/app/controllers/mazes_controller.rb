class Maze
  
  def map
      [ 
      "S----",
      "-----",
      "-----",
      "----E"
      ]
  end
  
  def start_point
    [0,0]
  end
  def end_point
    [4,3]
  end
  
end

class MazesController < ApplicationController
  
  respond_to :room
  
  def entry
    redirect_to maze_position_url(Maze.new.start_point[0], Maze.new.start_point[1])
  end
  
  def position
    puts "at #{params[:x]}, #{params[:y]}"
  end
  
end
