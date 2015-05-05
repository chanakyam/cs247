-module(slideshow_handler).
-author("tapanp@koderoom.com").

-export([init/3]).

-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).

%% Init
init(_Transport, _Req, []) ->
	{upgrade, protocol, cowboy_rest}.

%% Callbacks
content_types_provided(Req, State) ->
	{[		
		{<<"text/html">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{[{Name,Value}], Req2} = cowboy_req:bindings(Req),
	Url_single_slide_show =  cs247_util:news_single_slideshow(Value),
	{ok, "200", _, ResponseSingleSlide} = ibrowse:send_req(Url_single_slide_show,[],get,[],[]),
	%io:format("response ~s ~n ",[ResponseSingleSlide]),
	ResSingle = string:sub_string(ResponseSingleSlide, 1, string:len(ResponseSingleSlide) -1 ),
	FirstSlide = jsx:decode(list_to_binary(ResSingle)),
	%io:format("params ~p ~n",[FirstSlide]),
	Url = cs247_util:news_slideshow_url("100"),
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	[{<<"total_rows">>,_},{<<"offset">>,_},{<<"rows">>,Params}] = jsx:decode(list_to_binary(Res)),
	%io:format("params ~p ~n",[Params]),
	{ok, Body} = slideshow_dtl:render([{<<"firstslide">>,FirstSlide},{<<"params">>,Params}]),
    {Body, Req, State}.
