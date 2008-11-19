-module(test_erlcfg_parser).
-include_lib("eunit/include/eunit.hrl").


parse_integer_assignment_test() ->
    Tokens = [{atom, 1, foo}, {'=', 1}, {integer, 1, 51}, {';', 1}],
    Result = erlcfg_parser:parse(Tokens),
    Expected = {ok, [{set, foo, {val, 51}}, []]},
    ?assertEqual(Expected, Result).

parse_float_assignment_test() ->
    Tokens = [{atom, 1, foo}, {'=', 1}, {float, 1, -51.0e-10}, {';', 1}],
    Result = erlcfg_parser:parse(Tokens),
    Expected = {ok, [{set, foo, {val, -51.0e-10}}, []]},
    ?assertEqual(Expected, Result).

parse_atom_assignment_test() ->
    Tokens = [{atom, 1, foo}, {'=', 1}, {atom, 1, foo51}, {';', 1}],
    Result = erlcfg_parser:parse(Tokens),
    Expected = {ok, [{set, foo, {val, foo51}}, []]},
    ?assertEqual(Expected, Result).

parse_string_assignment_test() ->
    Tokens = [{atom, 1, foo}, {'=', 1}, {string, 1, "A String"}, {';', 1}],
    Result = erlcfg_parser:parse(Tokens),
    Expected = {ok, [{set, foo, {val, "A String"}}, []]},
    ?assertEqual(Expected, Result).

parse_mixed_assignment_test() ->
    Tokens = [
        {atom, 1, foo}, {'=', 1}, {integer, 1, 51}, {';', 1},
        {atom, 1, foo}, {'=', 1}, {float, 1, -51.0e-10}, {';', 1},
        {atom, 1, foo}, {'=', 1}, {atom, 1, foo51}, {';', 1},
        {atom, 1, foo}, {'=', 1}, {string, 1, "A String"}, {';', 1}
    ],
    Result = erlcfg_parser:parse(Tokens),
    Expected = {ok, 
        [{set, foo, {val, 51}},
            [{set, foo, {val, -51.0e-10}}, 
                [{set, foo, {val, foo51}}, 
                    [{set, foo, {val, "A String"}}, []]
                ]
            ]
        ]
    },
    ?assertEqual(Expected, Result).
