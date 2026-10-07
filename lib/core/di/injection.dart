import 'package:flutter_application_1/features/country/data/country_repo.dart';
import 'package:flutter_application_1/features/country/logic/country_cubit.dart';
import 'package:flutter_application_1/features/edit_profile/logic/edit_profile_cubit.dart';
import 'package:flutter_application_1/features/language/data/language_repo.dart';
import 'package:flutter_application_1/features/language/logic/language_cubit.dart';
import 'package:flutter_application_1/features/notifications/data/notifications_repo.dart';
import 'package:flutter_application_1/features/notifications/logic/notifications_cubit.dart';
import 'package:flutter_application_1/features/profile/data/model/profile_model.dart';
import 'package:flutter_application_1/features/profile/data/repo/profile_repo.dart';
import 'package:flutter_application_1/features/profile/logic/profile_cubit.dart';
import 'package:flutter_application_1/features/search/data/repo/Searchrepo.dart';
import 'package:flutter_application_1/features/search/logic/search_cubit.dart';
import 'package:flutter_application_1/features/wishlist/data/repos/wishlist_repo.dart';
import 'package:flutter_application_1/features/wishlist/logic/wishlist_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_application_1/core/networking/api_service.dart';

import '../../features/home/data/repos/home_repo.dart';
import '../../features/home/logic/home_cubit.dart';
import '../../features/most_popular/logic/most_popular_cubit.dart';
import '../../features/movie_detail/data/repos/movie_detail_repo.dart';
import '../../features/movie_detail/logic/movie_detail_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDI() async {
  _core();
  _home();
  _mostPopular();
  _movieDetail();
  _search();
  _wishlist();
  _profile();
  _editProfile();
  _notifications();
  _language();
  _country();

}

void _core() {
  sl.registerLazySingleton<ApiService>(() => ApiService());
}

void _home() {
  sl.registerLazySingleton<HomeRepo>(() => HomeRepo(sl()));
  sl.registerFactory<HomeCubit>(() => HomeCubit(sl()));
}

void _mostPopular() {
  sl.registerFactory<MostPopularCubit>(() => MostPopularCubit(sl()));
}

void _movieDetail() {
  sl.registerLazySingleton<MovieDetailRepo>(() => MovieDetailRepo(sl()));
  sl.registerFactory<MovieDetailCubit>(() => MovieDetailCubit(sl()));
}

void _search() {
  sl.registerLazySingleton<SearchRepo>(() => SearchRepo(sl()));
  sl.registerFactory<SearchCubit>(() => SearchCubit(sl()));
}

void _wishlist() {
  sl.registerLazySingleton<WishlistRepo>(() => WishlistRepo());
  sl.registerLazySingleton<WishlistCubit>(() => WishlistCubit(sl())..load());
}

void _profile() {
  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepo(sl()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));
}
 
void _editProfile() {
  sl.registerFactoryParam<EditProfileCubit, ProfileModel, void>(
    (profile, _) => EditProfileCubit(sl(), profile),
  );
}
 
void _notifications() {
  sl.registerLazySingleton<NotificationsRepo>(() => NotificationsRepo());
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit(sl()));
}
 
void _language() {
  sl.registerLazySingleton<LanguageRepo>(() => LanguageRepo(sl()));
  sl.registerFactory<LanguageCubit>(() => LanguageCubit(sl()));
}

void _country() {
  sl.registerLazySingleton<CountryRepo>(() => CountryRepo(sl()));
  sl.registerFactory<CountryCubit>(() => CountryCubit(sl()));
}
