%%%-------------------------------------------------------------------
%% @copyright Heroku 
%% @doc TLS Client Helper Module
%% @end
%%%-------------------------------------------------------------------

-module(logplex_tls).

% Public API
-export([connect_opts/0,
         max_depth/0,
         max_depth/1,
         cacertfile/0,
         cacertfile/1,
         approved_ciphers/0]).

% Internal API
-export([is_128_aes/1]).

connect_opts() ->
  [{verify, verify_peer},
   {depth, max_depth()},
   {cacertfile, cacertfile()},
   {ciphers, approved_ciphers()}]. 

max_depth() ->
  % OpenSSL defaults to a max depth of 100, it used to use 9.
  logplex_app:config(tls_max_depth).

max_depth(Depth) ->
  application:set_env(logplex, tls_max_depth, Depth).

cacertfile() ->
  filename:absname(logplex_app:config(tls_cacertfile), logplex_app:priv_dir()).

cacertfile(Path) ->
  application:set_env(logplex, tls_cacertfile, Path).

approved_ciphers() ->
  % TODO use a static list of ciphers
  lists:filter(fun is_128_aes/1, ssl:cipher_suites()).

is_128_aes({_, aes_128_cbc, _}) -> true;
is_128_aes({_, aes_128_gcm, _}) -> true;
is_128_aes(_) -> false.
