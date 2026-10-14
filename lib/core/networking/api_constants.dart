class ApiConstants {
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const imageBase = 'https://image.tmdb.org/t/p';

  static const accessToken = String.fromEnvironment('TMDB_TOKEN');
  static const accountId = String.fromEnvironment('TMDB_ACCOUNT_ID');

  // Home
  static const account = '/account/$accountId';
  static const upcoming = '/movie/upcoming';
  static const popular = '/movie/popular';
  static const genres = '/genre/movie/list';
  static const discover = '/discover/movie';

  // Search
  static const trendingToday = '/trending/movie/day';
  static const topRated = '/movie/top_rated';
  static const searchMovie = '/search/movie';
  static const searchPerson = '/search/person';

  // Movie detail
  static String movieDetails(int id) => '/movie/$id';
  static String movieCredits(int id) => '/movie/$id/credits';

  static const languages = '/configuration/languages';
  static const countries = '/configuration/countries';
}
