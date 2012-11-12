p 'Please input n:'
N = gets.strip.to_i - 1

$result = []
def recurse arr
  l = arr.length
  (0..N).each do |i|
    unless arr.select{|c| c == i || i - l + arr.index(c) == c || i + l - arr.index(c) == c}.length > 0
      if arr.length == N
        $result.push arr + [i]
      else
        recurse arr + [i]
      end
    end
  end
end

t_begin = Time.now
recurse []
t_end = Time.now

#p "Results:#{$result}"
p "Num of Results:#{$result.length}"
p "Time:#{(t_end.to_f * 1000.0).to_i - (t_begin.to_f * 1000.0).to_i}ms"
