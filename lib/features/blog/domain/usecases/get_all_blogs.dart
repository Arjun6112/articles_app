import 'package:articles_app/core/error/failures.dart';
import 'package:articles_app/core/usecase/usecase.dart';
import 'package:articles_app/features/blog/domain/entities/blog.dart';
import 'package:articles_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';

class GetAllBlogs implements Usecase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;
  GetAllBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
