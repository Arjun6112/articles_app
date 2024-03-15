import 'dart:io';

import 'package:articles_app/features/blog/domain/entities/blog.dart';
import 'package:articles_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;
  BlogBloc(this.uploadBlog) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final result = await uploadBlog(UploadBlogParams(
        title: event.title,
        content: event.content,
        userId: event.userId,
        topics: event.topics,
        image: event.image));
    result.fold((failure) => emit(BlogFailure(failure.message)),
        (blog) => emit(BlogSuccess()));
  }
}
