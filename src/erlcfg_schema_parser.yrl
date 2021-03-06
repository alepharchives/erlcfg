%% 
%% Copyright (c) 2008-2010, Essien Ita Essien
%% All rights reserved.
%% 
%% Redistribution and use in source and binary forms, 
%% with or without modification, are permitted 
%% provided that the following conditions are met:
%%
%%    * Redistributions of source code must retain the 
%%      above copyright notice, this list of conditions 
%%      and the following disclaimer.
%%    * Redistributions in binary form must reproduce 
%%      the above copyright notice, this list of 
%%      conditions and the following disclaimer in the 
%%      documentation and/or other materials provided with 
%%      the distribution.
%%    * Neither the name "JsonEvents" nor the names of its 
%%      contributors may be used to endorse or promote 
%%      products derived from this software without 
%%      specific prior written permission.
%%
%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
%% CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
%% WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
%% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
%% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
%% HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
%% INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
%% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE 
%% GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
%% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
%% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
%% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
%% THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
%% OF SUCH DAMAGE.
%% 

Nonterminals
schema items item typedef typedef_options data block block_contents block_data declaration type_signature list elements element.

Terminals
keyword_type datatype integer float atom quoted_atom string bool '=' ';' '{' '}' '[' ']' '|' ',' '(' ')'.

Rootsymbol schema.

schema -> '$empty' : [].
schema -> items : '$1'.

items -> item : ['$1'].
items -> item items: ['$1' | '$2'].

item -> typedef : '$1'.
item -> block : '$1'.
item -> declaration : '$1'.

typedef -> keyword_type atom '=' typedef_options ';' : {typedef, get_value('$2'), '$4'}.
block -> atom '{' block_contents '}' : {block, get_value('$1'), '$3'}.
block -> atom '{' '}' : {block, get_value('$1'), []}.
declaration -> type_signature atom ';' : {declaration, '$1', get_value('$2'), ?ERLCFG_SCHEMA_NIL}.
declaration -> type_signature atom '=' data ';' : {declaration, '$1', get_value('$2'), '$4'}.

block_contents -> block_data : ['$1'].
block_contents -> block_data block_contents : ['$1' | '$2'].

block_data -> block : '$1'.
block_data -> declaration : '$1'.

typedef_options -> data : {cons, '$1', nil}.
typedef_options -> data '|' typedef_options : {cons, '$1', '$3'}.

type_signature -> datatype : get_value('$1').
type_signature -> atom : get_value('$1').
type_signature -> '[' type_signature ']' : list_of_type('$2').

data -> list       : '$1'.
data -> integer    : get_value('$1').
data -> float      : get_value('$1').
data -> atom       : get_value('$1').
data -> quoted_atom: get_value('$1').
data -> string     : get_value('$1').
data -> bool       : get_value('$1').

list -> '(' elements ')' : '$2'.
elements -> element ',' elements    : {cons, '$1', '$3'}.
elements -> element     : {cons, '$1', nil}.
elements -> '$empty' : nil.
element -> data : '$1'.

Erlang code.
%nothing
-include("schema.hrl").

get_value({_Type, _Line, Value}) ->
    Value.

list_of_type(Type) ->
    #listof{type=Type}.
