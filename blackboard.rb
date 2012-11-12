require 'observer'

class Judger
  include Observable

  def initialize board, limit
    @board = board
    @limit = limit
    @result = []
  end

  def run
    lastArr = nil
    t_begin = Time.now
    loop do
      #p "Fetch : #{@board.arr} #{@board.object_id}"
      arr, pos = @board.fetch
      #p "Last arr: #{lastArr}, Current arr: #{arr},  Pos: #{pos}, Observer: #{count_observers}"
      @result << @board.arr.dup if @board.arr.length == @limit + 1
      if arr != lastArr
        changed
        lastArr = arr.dup
        if is_over?
          delete_observers
          t_end = Time.now
          p "Num of Results:#{@result.length}"
          p "Time:#{(t_end.to_f * 1000.0).to_i - (t_begin.to_f * 1000.0).to_i}ms"
          break
        else
          if it = check
            notify_observers @board, "GO", it
          else
            notify_observers @board, "BACK", it
          end
        end
      end
    end
  end

  def check
    l = @board.arr.length
    (@board.pos..@limit).each do |i|
      unless @board.arr.select{|c| c == i || i - l + @board.arr.index(c) == c || i + l - @board.arr.index(c) == c}.length > 0
        return i
      end
    end
    false
  end

  def is_over?
    @board.arr.empty? and !check
  end
end

class Board
  attr_accessor :arr, :pos
  def initialize
    @arr = [0]
    @pos = 1
  end
  def fetch
    [@arr, @pos]
  end
end

class Warner
  def initialize judger
    @judger = judger
    @judger.add_observer self
  end

end

class WarnGo < Warner
  def update board, flag, it
    if flag == "GO"
      board.arr.push it
      board.pos = 0
      #p "GO: #{board.arr}, id: #{board.object_id}"
    end
  end
end

class WarnBack < Warner
  def update board, flag, it
    if flag == "BACK"
      board.pos = board.arr.pop + 1
      #p "BACK: #{board.arr}, id: #{board.object_id}"
    end
  end
end


p 'Please input n:'
N = gets.strip.to_i - 1
t_begin = Time.now

blackboard = Board.new
judger = Judger.new blackboard, N
WarnGo.new judger
WarnBack.new judger
judger.run
