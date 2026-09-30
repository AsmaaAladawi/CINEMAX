class ApiConstants {
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const imageBase = 'https://image.tmdb.org/t/p';

static const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjliNjE2YzRmY2FmZjI0MjllZDhlZTBlOWNkNmQxMyIsIm5iZiI6MTc5MDYwODI1OS43MzMsInN1YiI6IjZhYmE4MzgzYmQ0NDFkMmE5NmRkYzNiNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4DnhJeF4uTaXtsnoRG6WPacXKRDF7pDKVRRUN_LUxL0';
static const accountId = 'b29b616c4fcaff2429ed8ee0e9cd6d13';

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
}


  //static const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjliNjE2YzRmY2FmZjI0MjllZDhlZTBlOWNkNmQxMyIsIm5iZiI6MTc5MDYwODI1OS43MzMsInN1YiI6IjZhYmE4MzgzYmQ0NDFkMmE5NmRkYzNiNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4DnhJeF4uTaXtsnoRG6WPacXKRDF7pDKVRRUN_LUxL0';
  //static const accountId = 'b29b616c4fcaff2429ed8ee0e9cd6d13';