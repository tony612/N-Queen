## Four ways to solve N-Queen problem in ruby

This is one of my homework in face. It use fout styles in the Software Architecture to implement the [N-Queen problem](http://en.wikipedia.org/wiki/Eight_queens_puzzle):

### [Pipe](http://en.wikipedia.org/wiki/Pipes_and_filters)

User `IO.pipe`([doc](http://www.ruby-doc.org/core-1.9.3/IO.html#method-c-pipe)) as the pipe to fetch and send data.And there is a mutli-thread version as well.

But both don't work very well when N is larger than 8. Some reasons I think is that Ruby limit the volumn in the pipe to 1M.

### [Callback](http://en.wikipedia.org/wiki/Callback_(computer_programming))

I just use recursion to implement it.

### [Backtrack](http://en.wikipedia.org/wiki/Backtracking)

Yeah, Backtrack! 

### [Blackboard](http://en.wikipedia.org/wiki/Blackboard_(computing))

I use the observer in the ruby, you should `require 'observer' and the [doc](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/observer/rdoc/Observable.html) can be refered.`.

I use the observer as the controller, use a `Board` class as the blackboard. The controller observe the status of the board and notify the `Warn` class when there's change.'WarnGo' will work when the push action is ok, while 'WarnBack' will work when pop is needed.
