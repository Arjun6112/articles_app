import 'dart:io';

import 'package:articles_app/core/usecase/usecase.dart';
import 'package:articles_app/features/blog/domain/entities/blog.dart';
import 'package:articles_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:articles_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
      : _getAllBlogs = getAllBlogs,
        _uploadBlog = uploadBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogGetAllBlogs>(_onGetAllBlogs);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final result = await _uploadBlog(UploadBlogParams(
        title: event.title,
        content: event.content,
        userId: event.userId,
        topics: event.topics,
        image: event.image));
    result.fold((failure) => emit(BlogFailure(failure.message)),
        (blog) => emit(BlogUploadSuccess()));
  }

  void _onGetAllBlogs(BlogGetAllBlogs event, Emitter<BlogState> emit) async {
    final result = await _getAllBlogs(NoParams());
    result.fold((failure) => emit(BlogFailure(failure.message)),
        (blogs) => emit(BlogsDisplaySuccess(blogs)));
  }
}
