-module(all_news_paginated_handler).
-author("tapanp@koderoom.com").

-export([init/3]).
-export([content_types_provided/2]).
-export([welcome/2]).
-export([terminate/3]).
-include("includes.hrl").
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
	{PageBinary, PageNumber} = cowboy_req:qs_val(<<"p">>, Req),
	PageNum = list_to_integer(binary_to_list(PageBinary)),
	SkipItems = (PageNum-1) * ?NEWS_PER_PAGE,

	{CategoryBinary, _} = cowboy_req:qs_val(<<"c">>, Req),
	Category = binary_to_list(CategoryBinary),

	Url_all_news = case Category of 
		"text_us_business" ->
			%Category = "US",
			string:concat("http://api.contentapi.ws/news?channel=us_business&limit=40&format=short&skip=",integer_to_list(SkipItems));
			% cs247_util:news_top_text_news_by_category_with_limit_and_skip("text_us_business","by_id_title_desc_thumb_date",integer_to_list(?NEWS_PER_PAGE), list_to_integer(binary_to_list(SkipItems)) );
		"text_us_economy" ->
			%Category = "US",
			string:concat("http://api.contentapi.ws/news?channel=us_economy&limit=40&format=short&skip=",integer_to_list(SkipItems));
			% cs247_util:news_top_text_news_by_category_with_limit_and_skip("text_us_economy.","by_id_title_desc_thumb_date",integer_to_list(?NEWS_PER_PAGE), list_to_integer(binary_to_list(SkipItems)));
			
		"text_us_stocks" ->
			%Category = "Politics",
			string:concat("http://api.contentapi.ws/news?channel=us_stocks&limit=40&format=short&skip=",integer_to_list(SkipItems));
			% cs247_util:news_top_text_news_by_category_with_limit_and_skip("text_us_stocks","by_id_title_desc_thumb_date",integer_to_list(?NEWS_PER_PAGE), list_to_integer(binary_to_list(SkipItems)));
			
		"text_us_money" ->
			%Category = "Entertainment",
			string:concat("http://api.contentapi.ws/news?channel=us_money&limit=40&format=short&skip=",integer_to_list(SkipItems));
			% cs247_util:news_top_text_news_by_category_with_limit_and_skip("text_us_money","by_id_title_desc_thumb_date",integer_to_list(?NEWS_PER_PAGE), list_to_integer(binary_to_list(SkipItems)));	
		_ ->

			%Category = "None",
			lager:info("#########################None")

	end,

	% for videos

	Url = case Category of 
		"text_us_business" ->
			%Category = "US",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=1&format=long";
		"text_us_economy" ->
			%Category = "US",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=2&format=long";
			
		"text_us_stocks" ->
			%Category = "Politics",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=3&format=long";
			
		"text_us_money" ->
			%Category = "Entertainment",
			"http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=4&format=long";	
		_ ->

			%Category = "None",
			lager:info("#########################None")

	end,

	% io:format("all news--> ~p ~n",[Url_all_news]),

	% Url = "http://api.contentapi.ws/videos?channel=world_news&limit=1&skip=1&format=long",
	{ok, "200", _, Response_mlb} = ibrowse:send_req(Url,[],get,[],[]),
	ResponseParams_mlb = jsx:decode(list_to_binary(Response_mlb)),	
	[Params] = proplists:get_value(<<"articles">>, ResponseParams_mlb),

	{ok, "200", _, ResponseAllNews} = ibrowse:send_req(Url_all_news,[],get,[],[]),
	ResponseParams = jsx:decode(list_to_binary(ResponseAllNews)),
	ResAllNews = proplists:get_value(<<"articles">>, ResponseParams),	

    %%io:format("params ~p ~n ",[Params]),
	{ok, Body} = all_news_paginated_dtl:render([{"videoParam",Params},{<<"news_category">>,Category},{<<"allnews">>,ResAllNews}]),
    {Body, Req, State}
.