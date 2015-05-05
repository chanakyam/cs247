var app = angular.module('cs247App', ['ui.bootstrap']);

app.factory('cs247HomePageService', function ($http) {
	return {
		
		getTopEntertainmentNews: function (count, skip) {
			return $http.get('/api/news/topnews?c=Entertainment&n=' + count + '&s=' + skip).then(function (result) {
				return result.data.rows;
			});
		},
		getTopNewsWithImages: function (count) {
			return $http.get('/api/news/topnews_with_images?n=' + count).then(function (result) {
				return result.data.rows;
			});
		},

		getMoreTopNewsWithImages: function (count, skip) {
			return $http.get('/api/news/topnews_with_images_count_and_skip?n=' + count + '&s=' + skip).then(function (result) {
				return result.data.rows;
			});
		},

	};
});
app.controller('Cs247Home', function ($scope, cs247HomePageService) {
	$scope.currentYear = (new Date).getFullYear();	
});

