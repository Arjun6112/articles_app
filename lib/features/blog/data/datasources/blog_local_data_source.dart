import 'package:articles_app/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box blogBox;
  BlogLocalDataSourceImpl(this.blogBox);
  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];

    blogBox.read(() {
      for (int i = 0; i < blogs.length; i++) {
        blogs.add(BlogModel.fromJson(blogBox.get(i.toString())));
      }
    });
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    blogBox.clear();
    blogBox.write(() {
      for (int i = 0; i < blogs.length; i++) {
        blogBox.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
