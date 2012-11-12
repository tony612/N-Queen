p 'Please input n:'
N = gets.strip.to_i - 1

$stack = [0]
result = []

def find_it k
  l = $stack.length
  (k..N).each do |i|
    unless $stack.select{|c| c == i || i - l + $stack.index(c) == c || i + l - $stack.index(c) == c}.length > 0
      return i
    end
  end
  false
end

t_begin = Time.now

pos = 1
until $stack.empty? and !find_it(pos)
  if it = find_it(pos)
    $stack.push it
    result.push($stack.dup) if $stack.length == N + 1
    pos = 0
  else
    pos = $stack.pop + 1
  end
end
t_end = Time.now

#p "Results:#{$stack}"
p "Num of Results:#{result.length}"
p "Time:#{(t_end.to_f * 1000.0).to_i - (t_begin.to_f * 1000.0).to_i}ms"
