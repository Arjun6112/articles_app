import 'dart:io';

import 'package:articles_app/core/error/failures.dart';
import 'package:articles_app/core/usecase/usecase.dart';
import 'package:articles_app/features/blog/domain/entities/blog.dart';
import 'package:articles_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  UploadBlog(this.blogRepository);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
        image: params.image,
        title: params.title,
        content: params.content,
        userId: params.userId,
        topics: params.topics);
  }
}

class UploadBlogParams {
  final String title;
  final String content;
  final String userId;
  final List<String> topics;
  final File image;

  UploadBlogParams(
      {required this.title,
      required this.content,
      required this.userId,
      required this.topics,
      required this.image});
}
