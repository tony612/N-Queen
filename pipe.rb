require 'timeout'

class IO
  def readline_nonblock
    @rlnb_buffer ||= ""
    ch = nil
    while ch = self.read_nonblock(1) 
      @rlnb_buffer += ch
      if ch == "\n" then
        result = @rlnb_buffer
        @rlnb_buffer = ""
        return result
      end
    end     
  end
end

p 'Please input n:'
N = gets.strip.to_i - 1
$pipe = IO.pipe
$find_arr = []
t_begin = Time.now
$pipe[1].puts ""
over = false
until over do
  str = ""
  arr = []
  begin
    if N < 8
      timeout(0.00001) { str = $pipe[0].readline;arr = str.strip.split(',').map(&:to_i) }
    else
      timeout(0.0001) {str = $pipe[0].readline_nonblock;arr = str.strip.split(',').map(&:to_i)}
    end
  rescue
    over = true
  end
  l = arr.length
  $find_arr << str if l == N + 1
  (0..N).each do |i|
    unless arr.select{|c| c == i || i - l + arr.index(c) == c || i + l - arr.index(c) == c}.length > 0
      #print (arr+[i])*','
      $pipe[1].puts (arr + [i]) * ','
    end
  end
end
t_end = Time.now

p "Num of Results:#{$find_arr.length}"
p "Time:#{(t_end.to_f * 1000.0).to_i - (t_begin.to_f * 1000.0).to_i}ms"
