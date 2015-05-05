-module(home_page_handler).
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

	Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=0&format=long",
	% io:format("movies url: ~p~n",[Url]),
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),
	
	Urlbusiness = "http://api.contentapi.ws/news?channel=us_business&limit=5&format=short&skip=0",
	% io:format("all news : ~p~n",[Url_all_news]),
	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Urlbusiness,[],get,[],[]),
	Resbusiness = jsx:decode(list_to_binary(ResponseAllNews)),
	Paramsbusinessnews = proplists:get_value(<<"articles">>, Resbusiness),

	Urleconomy = "http://api.contentapi.ws/news?channel=us_economy&limit=5&format=short&skip=0",
	% io:format("all news : ~p~n",[Url_all_news]),
	{ok, "200", _, ResponseAllNews1} = ibrowse:send_req(Urleconomy,[],get,[],[]),
	Reseconomy = jsx:decode(list_to_binary(ResponseAllNews1)),
	Paramseconomynews = proplists:get_value(<<"articles">>, Reseconomy),
	
	Urlhotstocks = "http://api.contentapi.ws/news?channel=us_stocks&limit=5&format=short&skip=0",
	% io:format("all news : ~p~n",[Url_all_news]),
	{ok, "200", _, ResponseAllNews2} = ibrowse:send_req(Urlhotstocks,[],get,[],[]),
	Reshotstocks = jsx:decode(list_to_binary(ResponseAllNews2)),
	Paramshotstocknews = proplists:get_value(<<"articles">>, Reshotstocks),
	
	Urlmoney = "http://api.contentapi.ws/news?channel=us_money&limit=5&format=short&skip=0",
	% io:format("all news : ~p~n",[Url_all_news]),
	{ok, "200", _, ResponseAllNews3} = ibrowse:send_req(Urlmoney,[],get,[],[]),
	Resmoney = jsx:decode(list_to_binary(ResponseAllNews3)),
	Paramsmoneynews = proplists:get_value(<<"articles">>, Resmoney),

	{ok, Body} = index_dtl:render([{<<"videoParam">>,Params},{<<"topUsBusinessNews">>,Paramsbusinessnews},{<<"topUsEconomyNews">>,Paramseconomynews},{<<"topUsHotstocksNews">>,Paramshotstocknews},{<<"topUsMoneyNews">>,Paramsmoneynews}]),
    {Body, Req, State}
.