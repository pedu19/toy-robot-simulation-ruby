require 'spec_helper'

describe Robot do

  before(:each) do
    @table_top = TableTop.new 5, 5
    @toy_robo = Robot.new @table_top
  end

  it 'should be placed correctly' do
    expect(@toy_robo.place(0, 2, :north)).to eq(true)
    expect(@toy_robo.place(1, 2, :south)).to eq(true)
    expect(@toy_robo.place(7, 6, :west)).to eq(false)
    expect(@toy_robo.place(-1, 6, :east)).to eq(false)
  end

  it 'should raise exceptions' do
    expect { @toy_robo.place(nil, nil, :east) }.to raise_error(TypeError)
    expect { @toy_robo.place(1, 'abc', nil) }.to raise_error(TypeError)
    expect { @toy_robo.place(1, 0, :northeast) }.to raise_error(TypeError)
  end

  it 'should move on the table_top' do
    @toy_robo.place(0, 0, :north)

    expect(@toy_robo.move).to eq(true)
    expect(@toy_robo.position[:x]).to eq(0)
    expect(@toy_robo.position[:y]).to eq(1)
    expect(@toy_robo.direction).to eq(:north)

    @toy_robo.place(1, 2, :east)
    @toy_robo.move
    @toy_robo.move
    @toy_robo.rotate_left
    @toy_robo.move

    expect(@toy_robo.position[:x]).to eq(3)
    expect(@toy_robo.position[:y]).to eq(3)
    expect(@toy_robo.direction).to eq(:north)

  end

  it 'should rotate on its left' do
    @toy_robo.place(0, 0, :north)
    @toy_robo.rotate_left
    expect(@toy_robo.direction).to eq(:west)
    @toy_robo.rotate_left
    expect(@toy_robo.direction).to eq(:south)
    @toy_robo.rotate_left
    expect(@toy_robo.direction).to eq(:east)
    @toy_robo.rotate_left
    expect(@toy_robo.direction).to eq(:north)
    @toy_robo.rotate_left
    expect(@toy_robo.direction).to eq(:west)
  end

  it 'should rotate on its right' do
    @toy_robo.place(0, 0, :north)
    @toy_robo.rotate_right
    expect(@toy_robo.direction).to eq(:east)
    @toy_robo.rotate_right
    expect(@toy_robo.direction).to eq(:south)
    @toy_robo.rotate_right
    expect(@toy_robo.direction).to eq(:west)
    @toy_robo.rotate_right
    expect(@toy_robo.direction).to eq(:north)
    @toy_robo.rotate_right
    expect(@toy_robo.direction).to eq(:east)
  end


  it 'should not exit the table_top' do
    @toy_robo.place(1, 4, :north)
    expect(@toy_robo.move).to eq(true)
    expect(@toy_robo.move).to eq(false)
  end

  it 'should report its position' do
    @toy_robo.place(5, 5, :east)
    expect(@toy_robo.report).to eq("5,5,EAST")
    @toy_robo.move #this is going outside. Command is ignored and the report is the same as before
    expect(@toy_robo.report).to eq("5,5,EAST")
    @toy_robo.rotate_right
    @toy_robo.move
    expect(@toy_robo.report).to eq("5,4,SOUTH")
  end

  it 'should show commands' do
    @toy_robo.eval("PLACE 0,0,NORTH")
    expect(@toy_robo.report).to eq("0,0,NORTH")

    @toy_robo.eval("MOVE")
    @toy_robo.eval("RIGHT")
    @toy_robo.eval("MOVE")

    expect(@toy_robo.report).to eq("1,1,EAST")

    # if it goes out of the table_top it ignores the command
    for i in 0..10
      @toy_robo.eval("MOVE");
    end
    expect(@toy_robo.report).to eq("5,1,EAST")

    # rotate on itself
    for i in 0..3
      @toy_robo.eval("LEFT");
    end
    expect(@toy_robo.report).to eq("5,1,EAST")

  end

  it 'should ignore invalid commands' do
    expect { @toy_robo.eval("PLACE12NORTH") }.to raise_error(ArgumentError)
    expect { @toy_robo.eval("LEFFT") }.to raise_error(ArgumentError)
    expect { @toy_robo.eval("RIGHTT") }.to raise_error(ArgumentError)
  end

end