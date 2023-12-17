require_relative 'table_top'
require_relative 'robot'

class Simulator

  def initialize
    @table_top = TableTop.new 4, 4
    @robot = Robot.new @table_top
  end

  def execute(command)
    begin
      puts @robot.eval(command)
    rescue Exception => e
      puts e.message
    end
  end

end