import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../cubits/settings.dart';
import '../../widgets/exact_slider.dart';

class PenBehaviorSettings extends StatelessWidget {
  const PenBehaviorSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.pen),
        ),
        body: BlocBuilder<SettingsCubit, ButterflySettings>(
          builder: (context, state) => ListView(
            children: [
              ExactSlider(
                  min: 0,
                  max: 100,
                  value: state.penSensitivity,
                  header: Row(children: [
                    const Icon(PhosphorIcons.lightningLight),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.sensitivity),
                  ]),
                  onChanged: (value) {
                    final cubit = context.read<SettingsCubit>();
                    cubit.changePenSensitivity(value);
                  }),
            ],
          ),
        ));
  }
}
