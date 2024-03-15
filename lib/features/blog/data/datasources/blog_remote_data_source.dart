import 'dart:io';

import 'package:articles_app/core/error/exceptions.dart';
import 'package:articles_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blogModel);
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blogModel});
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blogModel) async {
    try {
      final blogData = await supabaseClient
          .from('articles')
          .insert(blogModel.toJson())
          .select();
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blogModel}) async {
    try {
      await supabaseClient.storage
          .from('article_images')
          .upload(blogModel.id, image);

      return supabaseClient.storage
          .from('article_images')
          .getPublicUrl('blogModel.id');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
