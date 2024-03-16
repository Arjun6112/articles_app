import 'dart:io';

import 'package:articles_app/core/error/exceptions.dart';
import 'package:articles_app/core/error/failures.dart';
import 'package:articles_app/core/network/connection_checker.dart';
import 'package:articles_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:articles_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:articles_app/features/blog/data/models/blog_model.dart';
import 'package:articles_app/features/blog/domain/entities/blog.dart';
import 'package:articles_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(this.blogRemoteDataSource, this.blogLocalDataSource,
      this.connectionChecker);
  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String userId,
      required List<String> topics}) async {
    try {
      if (!await (connectionChecker.hasConnection)) {
        return Left(Failure('No internet connection'));
      }
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        userId: userId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
          image: image, blogModel: blogModel);
      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return Right(uploadedBlog);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.hasConnection)) {
        final localBlogs = blogLocalDataSource.loadBlogs();
        return Right(localBlogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
      return Right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
