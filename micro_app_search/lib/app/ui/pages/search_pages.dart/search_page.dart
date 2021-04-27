import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:micro_app_search/app/domain/models/github_repository_model.dart';

import 'search_controller.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ModularState<SearchPage, SearchController> {
  @override
  void initState() {
    controller.getGitHubList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          'A GitHub Search',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildList(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () => controller.navigateToAboutPage(),
                  child: const Text('About the app'),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildList() => Center(
        child: Observer(builder: (_) {
          if (controller.gitHubIsLoading) {
            return const CircularProgressIndicator();
          }

          final List<GitHubRepositoryModel> gitHubRepos = controller.gitHubObservable?.value ?? [];

          return ListView.builder(
            itemCount: gitHubRepos.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => _buildItemBuilder(gitHubRepos[index]),
          );
        }),
      );

  Widget _buildItemBuilder(GitHubRepositoryModel gitHubRepositoryModel) => Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.bookmark,
              color: Colors.grey,
            ),
            Text(
              gitHubRepositoryModel.name.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            const Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            Text(
              gitHubRepositoryModel.stargazersCount.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
}
