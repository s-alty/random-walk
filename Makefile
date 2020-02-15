
plots/trials.png: data/random-walk.data plot.gpl
	-mkdir plots
	gnuplot plot.gpl

data/random-walk.data: rw.beam
	-mkdir data
	erl -noshell -eval 'Results = lists:sort(rw:run(1, 10000)),file:write_file("data/random-walk.data", [list_to_binary(io_lib:format("~B~n", [X])) || X <- Results]),init:stop().'

rw.beam: rw.erl
	erlc rw.erl

.PHONY: clean
clean:
	-rm -f rw.beam data/* plots/*
