import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../design_sys/sizes.dart';
import '../index_controller.dart';
import '../statistics_controller.dart';
import '../statistics_states.dart';

class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final state = context.read<StatisticsController>().state as SuccessStatisticsState;
    final touchedIndex = IndexController();

    return ListView.builder(
      itemCount: state.sections.length,
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: touchedIndex,
        builder: (context, child) {
          return ListTile(
            onTap: () =>
                touchedIndex.value = touchedIndex.value == index ? -1 : index,
            leading: SizedBox(
              width: width * Sizes.tenPercent,
              child: Center(
                child: CircleAvatar(
                    radius: touchedIndex.value == index ? 12 : 8,
                    backgroundColor: state.sections[index].color),
              ),
            ),
            title: Text(state.sections[index].description),
            trailing: Text(
                'R\$ ${state.sections[index].value.toStringAsFixed(2).replaceFirst('.', ',')}'),
          );
        },
      ),
    );
  }
}
