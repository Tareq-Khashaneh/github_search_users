import 'package:dartz/dartz.dart';

import '../../../../core/utils/error/failures.dart';
import '../entites/user.dart';

abstract class GithubRepository {
  Future<Either<Failure,List<User>>> searchUsers(String query);
}
