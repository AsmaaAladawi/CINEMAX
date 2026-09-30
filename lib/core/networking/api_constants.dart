class ApiConstants {
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const imageBase = 'https://image.tmdb.org/t/p';

  // الـ "API Read Access Token" من TMDB (Settings > API) - مش الـ API Key القصير
  static const accessToken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjliNjE2YzRmY2FmZjI0MjllZDhlZTBlOWNkNmQxMyIsIm5iZiI6MTc5MDYwODI1OS43MzMsInN1YiI6IjZhYmE4MzgzYmQ0NDFkMmE5NmRkYzNiNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4DnhJeF4uTaXtsnoRG6WPacXKRDF7pDKVRRUN_LUxL0';
  static const accountId = 'b29b616c4fcaff2429ed8ee0e9cd6d13';

  // Endpoints
  static const account = '/account/$accountId';
  static const upcoming = '/movie/upcoming';
  static const popular = '/movie/popular';
  static const genres = '/genre/movie/list';
  static const discover = '/discover/movie';
}