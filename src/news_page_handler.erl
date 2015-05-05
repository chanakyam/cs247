-module(news_page_handler).
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

	Video_Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=5&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_Video} = ibrowse:send_req(Video_Url,[],get,[],[]),
	ResponseParams_Video = jsx:decode(list_to_binary(Response_Video)),	
	[VideoParams] = proplists:get_value(<<"articles">>, ResponseParams_Video),

	% Url = cs247_util:news_db_url(binary_to_list(Value)),
	Url = string:concat("http://api.contentapi.ws/t?id=",binary_to_list(Value) ),
	% io:format("url ~p ~n",[Url]), 
	{ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	Params = jsx:decode(list_to_binary(Res)),
	% io:format("Data ~p ~n",[Params]),

	Urlbusiness = "http://api.contentapi.ws/news?channel=us_business&limit=20&format=short&skip=0",
	% io:format("all news : ~p~n",[Url_all_news]),
	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Urlbusiness,[],get,[],[]),
	Resbusiness = jsx:decode(list_to_binary(ResponseAllNews)),
	Paramsbusinessnews = proplists:get_value(<<"articles">>, Resbusiness),

	% {ok, Body} = news_page_dtl:render(Params),
	{ok, Body} = news_page_dtl:render([{<<"videoParam">>,VideoParams},{<<"news">>,Params},{<<"topUsBusinessNews">>,Paramsbusinessnews}]),
    {Body, Req2, State}.


