import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../design_sys/colors.dart';
import '../../design_sys/sizes.dart';
import '../../services/category_repository.dart';
import '../../shared/views/error_view.dart';
import '../../shared/views/loading_view.dart';
import 'my_categories_controller.dart';
import 'my_categories_states.dart';

class MyCategoriesPage extends StatelessWidget {
  const MyCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        MyCategoriesController.instance(CategoryFirebaseRepository());
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/category-edit'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: BlocBuilder<MyCategoriesController, MyCategoriesState>(
        bloc: controller,
        builder: (context, state) {
          if (state is ErrorMyCategoriesState) {
            return ErrorView(
              icon: Icons.cloud_off_rounded,
              text: state.message,
            );
          }
          if (state is SuccessMyCategoriesState) {
            return ListView.separated(
              itemCount: state.list.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (_, index) => PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    onTap: () => Future( //Fixes the navigation problem (stackoverflow)
                      () => Navigator.of(context).pushNamed(
                        '/category-edit',
                        arguments: state.list[index],
                      ),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.edit_rounded),
                        SizedBox(width: Sizes.mediumSpace),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () => controller.deleteCategory(state.list[index]),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.expense,
                        ),
                        SizedBox(width: Sizes.mediumSpace),
                        Text(
                          'Excluir',
                          style: TextStyle(color: AppColors.expense),
                        ),
                      ],
                    ),
                  ),
                ],
                child: ListTile(
                  leading: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      CircleAvatar(backgroundColor: state.list[index].color),
                      Icon(
                        state.list[index].icon,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ],
                  ),
                  title: Text(state.list[index].name),
                ),
              ),
            );
          }
          return const LoadingView();
        },
      ),
    );
  }
}
