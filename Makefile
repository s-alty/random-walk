plots/pmf.png: data/pmf.data pmf.gpl
	-mkdir plots
	gnuplot pmf.gpl

plots/trials.png: data/random-walk.data trials.gpl
	-mkdir plots
	gnuplot trials.gpl

data/pmf.data: data/random-walk.data
	uniq -c data/random-walk.data | awk '{print $$2, $$1, $$1 / 10000}' > data/pmf.data

data/random-walk.data: rw.beam
	-mkdir data
	erl -noshell -eval 'Results = lists:sort(rw:run(1, 10000)),file:write_file("data/random-walk.data", [list_to_binary(io_lib:format("~B~n", [X])) || X <- Results]),init:stop().'

rw.beam: rw.erl
	erlc rw.erl

.PHONY: clean
clean:
	-rm -f rw.beam data/* plots/*
