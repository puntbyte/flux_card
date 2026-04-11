import 'package:flutter/material.dart';
import 'package:flux_card/flux_card.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../shared/preview_surface.dart';

Text _title(BuildContext context, {String? text}) =>
    Text(context.knobs.string(label: 'Title', initialValue: text ?? 'Simple header', maxLines: 1));

Text _subtitle(BuildContext context, {String? text}) => Text(
  context.knobs.string(label: 'Subtitle', initialValue: text ?? 'Simple subtitle', maxLines: 3),
);

@widgetbook.UseCase(name: 'Simple', type: FluxHeader, path: '[Flux Card]/Header')
Widget buildHeaderSimpleUseCase(BuildContext context) => PreviewSurface(
  child: FluxCard(
    header: FluxHeader(title: _title(context), subtitle: _subtitle(context)),
    theme: FluxCardThemeData.elevated,
  ),
);

@widgetbook.UseCase(name: 'Leading and trailing', type: FluxHeader, path: '[Flux Card]/Header')
Widget buildHeaderRichUseCase(BuildContext context) => PreviewSurface(
  child: FluxCard(
    header: FluxHeader(
      leading: CircleAvatar(child: Icon(Icons.person)),
      title: _title(context, text: 'Leading and trailing'),
      subtitle: _subtitle(context, text: 'Header with actions and avatar.'),
      trailing: [Icon(Icons.more_horiz)],
    ),

    theme: FluxCardThemeData.elevated,
  ),
);

@widgetbook.UseCase(name: 'Long text', type: FluxHeader, path: '[Flux Card]/Header')
Widget buildHeaderLongTextUseCase(BuildContext context) => PreviewSurface(
  child: FluxCard(
    header: FluxHeader(
      leading: const CircleAvatar(child: Icon(Icons.article_outlined)),
      title: _title(context, text: 'A very long title that wraps across lines gracefully'),
      subtitle: _subtitle(context, text: 'Subtitles can also wrap when needed.'),
    ),
    theme: FluxCardThemeData.elevated,
  ),
);
