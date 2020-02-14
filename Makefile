
plot.png: random-walk.data plot.gpl
	gnuplot plot.gpl

random-walk.data: rw.beam
	erl -noshell -eval 'Results = lists:sort(rw:run(1, 10000)),file:write_file("random-walk.data", [list_to_binary(io_lib:format("~B~n", [X])) || X <- Results]),init:stop().'

rw.beam: rw.erl
	erlc rw.erl

.PHONY: clean
clean:
	-rm -f rw.beam random-walk.data
