-module(rw).
-export([trial/1, run/2]).

simulate(Target)                      -> simulate(Target, 0, 0).
simulate(Target, Target, Iterations)  -> Iterations;
simulate(Target, Current, Iterations) ->
    Increment = case rand:uniform() < 0.5 of
                    true  -> -1;
                    false -> 1
    end,
    simulate(Target, Current + Increment, Iterations + 1).

trial(Target) ->
    Result = simulate(Target),
    receive
        {From, report} -> From ! {self(), Result}
    end.

run(Target, Count) ->
    Pids = for(Count, fun() -> spawn(?MODULE, trial, [Target]) end),
    lists:map(fun(Pid) ->
                      Pid ! {self(), report},
                      receive
                          {Pid, Result} -> Result
                      end
              end, Pids).

for(Stop, F)       -> for(0, Stop, F).
for(Stop, Stop, _) -> [];
for(N, Stop, F)    -> [F()|for(N+1, Stop, F)].
