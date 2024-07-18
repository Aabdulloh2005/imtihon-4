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
        bloc: context.read<TadbirBloc>()..add(FetchTadbirEvent()),
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
            return ListView.builder(
              itemCount: data.events.length,
              itemBuilder: (context, index) {
                final event = data.events[index];
                return CustomEvent(
                  image: event.imageUrl,
                  location: event.geoPoint,
                  onPressed: () {},
                  time: event.time.toDate(),
                  title: event.name,
                );
              },
            );
          }
        },
      ),
    );
  }
}
