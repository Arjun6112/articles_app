import 'dart:io';

import 'package:articles_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:articles_app/core/common/widgets/loader.dart';
import 'package:articles_app/core/theme/app_pallete.dart';
import 'package:articles_app/core/utils/pick_image.dart';
import 'package:articles_app/core/utils/show_snackbar.dart';
import 'package:articles_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:articles_app/features/blog/domain/entities/blog.dart';
import 'package:articles_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:articles_app/features/blog/presentation/pages/blog_pages.dart';
import 'package:articles_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<String> selectedTopics = [];
  File? image;

  final _formKey = GlobalKey<FormState>();

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void uploadBlog() {
    if (_formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      BlocProvider.of<BlogBloc>(context).add(BlogUpload(
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          userId: userId,
          topics: selectedTopics,
          image: image!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Blog'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: uploadBlog, icon: const Icon(Icons.upload))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<BlogBloc, BlogState>(
            listener: (context, state) {
              if (state is BlogFailure) {
                showSnackbar(context, state.error);
              } else if (state is BlogUploadSuccess) {
                Navigator.pushAndRemoveUntil(
                    context, BlogPage.route(), (route) => false);
              }
            },
            builder: (context, state) {
              if (state is BlogLoading) {
                return const Loader();
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      image != null
                          ? GestureDetector(
                              onTap: selectImage,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: FileImage(image!),
                                        fit: BoxFit.cover)),
                              ),
                            )
                          : GestureDetector(
                              onTap: selectImage,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image, size: 60),
                                      SizedBox(height: 10),
                                      Text(
                                        'Add Image',
                                        style: TextStyle(fontSize: 22),
                                      )
                                    ]),
                              ),
                            ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              ["Technology", "Lifestyle", "Health", "Business"]
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () => setState(() {
                                            if (selectedTopics.contains(e)) {
                                              selectedTopics.remove(e);
                                            } else {
                                              selectedTopics.add(e);
                                            }
                                            print(selectedTopics);
                                          }),
                                          child: Chip(
                                            color: selectedTopics.contains(e)
                                                ? const MaterialStatePropertyAll(
                                                    AppPallete.gradient1)
                                                : null,
                                            label: Text(e),
                                            side: const BorderSide(
                                                color: AppPallete.borderColor),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                        ),
                      ),
                      BlogEditor(
                          controller: _titleController, hintText: "Title"),
                      const SizedBox(height: 10),
                      BlogEditor(
                          controller: _contentController, hintText: "Content"),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}

class MaterialStylePropertyAll {}
