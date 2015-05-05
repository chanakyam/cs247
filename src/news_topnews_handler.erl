-module(news_topnews_handler).
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
		{<<"application/json">>, welcome}	
	], Req, State}.

terminate(_Reason, _Req, _State) ->
	ok.

%% API
welcome(Req, State) ->
	{Count, _ } = cowboy_req:qs_val(<<"n">>, Req),
	{Skip, _ } = cowboy_req:qs_val(<<"s">>, Req),
	{Category, _ } = cowboy_req:qs_val(<<"c">>, Req),
	% lager:info("Top 10 News items requested"),

	Url_all_news = case binary_to_list(Category) of 
		"text_us_business" ->
			%Category = "US",
			string:concat("http://api.contentapi.ws/news?channel=us_business&limit=10&format=short&skip=",binary_to_list(Skip));
			% cs247_util:news_top_text_news_by_category_with_limit_and_skip("text_us_business","by_id_title_desc_thumb_date",integer_to_list(?NEWS_PER_PAGE), list_to_integer(binary_to_list(Skip)) );
		"text_us_economy" ->
			%Category = "US",
			string:concat("http://api.contentapi.ws/news?channel=us_economy&limit=10&format=short&skip=",binary_to_list(Skip));
			% cs247_util:news_top_text_news_by_category_with_limit_and_skip("text_us_economy.","by_id_title_desc_thumb_date",integer_to_list(?NEWS_PER_PAGE), list_to_integer(binary_to_list(Skip)));
			
		"text_us_stocks" ->
			%Category = "Politics",
			string:concat("http://api.contentapi.ws/news?channel=us_stocks&limit=10&format=short&skip=",binary_to_list(Skip));
			% cs247_util:news_top_text_news_by_category_with_limit_and_skip("text_us_stocks","by_id_title_desc_thumb_date",integer_to_list(?NEWS_PER_PAGE), list_to_integer(binary_to_list(Skip)));
			
		"text_us_money" ->
			%Category = "Entertainment",
			string:concat("http://api.contentapi.ws/news?channel=us_money&limit=10&format=short&skip=",binary_to_list(Skip));
			% cs247_util:news_top_text_news_by_category_with_limit_and_skip("text_us_money","by_id_title_desc_thumb_date",integer_to_list(?NEWS_PER_PAGE), list_to_integer(binary_to_list(Skip)));	
		_ ->

			%Category = "None",
			lager:info("#########################None")

	end,
	% io:format("url --> ~p ~n",[Url_all_news]),
	% Url = cs247_util:news_top_text_news_by_category_with_limit_and_skip(binary_to_list(Category),binary_to_list(Count), binary_to_list(Skip)),
	% io:format("design ~p ~n",[Url]),
	% {ok, "200", _, Response} = ibrowse:send_req(Url,[],get,[],[]),
	% Res = string:sub_string(Response, 1, string:len(Response) -1 ),
	% Body = list_to_binary(Res),
	% {Body, Req, State}.

	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	Body = list_to_binary(Response_mlb),
	{Body, Req, State}.

