import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiro_app/bloc/tadbir_bloc/tadbir_bloc.dart';
import 'package:tadbiro_app/ui/widgets/custom_event.dart';

class MyEvents extends StatelessWidget {
  const MyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: BlocBuilder<TadbirBloc, TadbirState>(
        bloc: context.read<TadbirBloc>()..add(FetchMyTadbirEvent()),
        builder: (context, state) {
          if (state is TadbirInitial) {
            return const Center(
              child: Text("Initial"),
            );
          }

          if (state is TadbirLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TadbirError) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else {
            final data = (state as TadbirLoaded);
            print('Ishlash kere');
            print(data.events.length);
            return ListView.builder(
              itemCount: data.events.length,
              itemBuilder: (context, index) {
                final event = data.events[index];

                return CustomEvent(
                  onPressed: () {},
                  event: event,
                );
              },
            );
          }
        },
      ),
    );
  }
}
