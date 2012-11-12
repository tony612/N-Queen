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
$pipes = N.times.map{IO.pipe}
$readers, $writers = $pipes.map(&:first), $pipes.map(&:last)
t_begin = Time.now
t_end = nil
$results = []
threads = []
(0..N).each do |ind|
  thread = Thread.new do
    sleep(0.00001)
    index = ind
    over = false
    until over do
      arr = []
      if index == 0
        arr = []
      else
        begin
          if N < 8 || index < 15 - N - 1
            timeout(0.0001) {arr = $readers[index - 1].readline.strip.split(',').map(&:to_i)}
          else
            timeout(0.0001) {arr = $readers[index - 1].readline_nonblock.strip.split(',').map(&:to_i)}
          end
        rescue
          if index == 1 or (index > 1 and $readers[index - 2] == nil and $writers[index - 2] == nil)
            $readers[index - 1] = nil
            $writers[index - 1] = nil
            over = true
            if index == N
              t_end = Time.now
              #p "Num of Results:#{$results.length}"
              #p "Time:#{(t_end.to_f * 1000.0).to_i - (t_begin.to_f * 1000.0).to_i}ms"
              #p "Time:#{t_end.to_i * 1000 - t_begin.to_i * 1000}"
            end
          end
        end
      end
      l = arr.length
      (0..N).each do |i|
        unless arr.select{|c| c == i || i - l + arr.index(c) == c || i + l - arr.index(c) == c}.length > 0
          #p "INDEX[#{index}] : #{arr+[i]}"
          if index < N 
            begin
              $writers[index].puts (arr + [i]) * ','
            rescue NoMethodError
              p "NoMethod#{index}, #{arr}, #{i}"
            end
          elsif arr.length == N
            begin
              $results << (arr + [i]) unless $results.include?(arr + [i])
            rescue NoMethodError
            end
          end
          over = true if i == N and index == 0
        end   
      end
    end
  end
  thread.join
  threads << thread
end

#p "Results:#{$result.length}"
p "Num of Results:#{$results.length}"
p "Time:#{(t_end.to_f * 1000.0).to_i - (t_begin.to_f * 1000.0).to_i}ms"
