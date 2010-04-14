class Room
  attr_reader :position, :x, :y, :rooms
  def initialize(position, del)
    @x = del[0]
    @y = del[1]
    @position = position
    @rooms = []
  end
  def <<(room)
    @rooms << room
  end
end

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
  
  def room(x,y)
    raise Error "You are out of the maze" unless contains(x,y)
    room = Room.new('', [x,y])
    {'north' => [0, -1], 'south' => [0, 1], 'east' => [1, 0], 'west' => [-1, 0]}.each do |position, v|
      nx = x + v[0]
      ny = y + v[1]
      room << Room.new(position, [nx, ny]) if contains(nx, ny)
    end
    room
  end
  
end

class MazesController < ApplicationController
  
  include Restfulie::Server::ActionController::Base

  respond_to :maze
  
  def entry
    @maze = Maze.new
    redirect_to maze_position_url(@maze.start_point[0], @maze.start_point[1])
  end
  
  def position
    @maze = Maze.new
    y = params[:y].to_i
    x = params[:x].to_i
    raise Error "There is a wall at #{x}, #{y}" if @maze.map[y][x..x]=='*'
    respond_with @room = @maze.room(x,y)
  end
  
end
