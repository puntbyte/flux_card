// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flux_card_widgetbook/usecases/flux_background.dart'
    as _flux_card_widgetbook_usecases_flux_background;
import 'package:flux_card_widgetbook/usecases/flux_card.dart'
    as _flux_card_widgetbook_usecases_flux_card;
import 'package:flux_card_widgetbook/usecases/flux_composition.dart'
    as _flux_card_widgetbook_usecases_flux_composition;
import 'package:flux_card_widgetbook/usecases/flux_footer.dart'
    as _flux_card_widgetbook_usecases_flux_footer;
import 'package:flux_card_widgetbook/usecases/flux_header.dart'
    as _flux_card_widgetbook_usecases_flux_header;
import 'package:flux_card_widgetbook/usecases/flux_media.dart'
    as _flux_card_widgetbook_usecases_flux_media;
import 'package:flux_card_widgetbook/usecases/flux_overlay.dart'
    as _flux_card_widgetbook_usecases_flux_overlay;
import 'package:flux_card_widgetbook/usecases/flux_theme.dart'
    as _flux_card_widgetbook_usecases_flux_theme;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Flux Card',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'Backgrounds',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxBackground',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Color',
                builder: _flux_card_widgetbook_usecases_flux_background
                    .buildBackgroundColorUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Custom decoration',
                builder: _flux_card_widgetbook_usecases_flux_background
                    .buildBackgroundCustomUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Gradient',
                builder: _flux_card_widgetbook_usecases_flux_background
                    .buildBackgroundGradientUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Cards',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Column layout',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildColumnLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Empty shell',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildEmptyShellUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive card',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildInteractiveCardUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Responsive card',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildResponsiveLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Row layout',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildRowLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Stack layout',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildStackLayoutUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Compositions',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Blog card',
                builder: _flux_card_widgetbook_usecases_flux_composition
                    .buildBlogCardUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Product card',
                builder: _flux_card_widgetbook_usecases_flux_composition
                    .buildProductCardUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Travel card',
                builder: _flux_card_widgetbook_usecases_flux_composition
                    .buildTravelCardUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Footer',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxFooter',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Horizontal actions',
                builder: _flux_card_widgetbook_usecases_flux_footer
                    .buildFooterHorizontalUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Stacked actions',
                builder: _flux_card_widgetbook_usecases_flux_footer
                    .buildFooterStackedUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Wrapped actions',
                builder: _flux_card_widgetbook_usecases_flux_footer
                    .buildFooterWrappedUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Header',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxHeader',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Leading and trailing',
                builder: _flux_card_widgetbook_usecases_flux_header
                    .buildHeaderRichUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Long text',
                builder: _flux_card_widgetbook_usecases_flux_header
                    .buildHeaderLongTextUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Simple',
                builder: _flux_card_widgetbook_usecases_flux_header
                    .buildHeaderSimpleUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Media',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxMedia',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Center',
                builder: _flux_card_widgetbook_usecases_flux_media
                    .buildMediaCenterUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Contain',
                builder: _flux_card_widgetbook_usecases_flux_media
                    .buildMediaContainUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Cover',
                builder: _flux_card_widgetbook_usecases_flux_media
                    .buildMediaCoverUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Fill',
                builder: _flux_card_widgetbook_usecases_flux_media
                    .buildMediaFillUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Product media',
                builder: _flux_card_widgetbook_usecases_flux_media
                    .buildMediaProductUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Overlay',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxOverlay',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Badges',
                builder: _flux_card_widgetbook_usecases_flux_overlay
                    .buildOverlayBadgesUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Rating chip',
                builder: _flux_card_widgetbook_usecases_flux_overlay
                    .buildOverlayRatingUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Themes',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxCardThemeData',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Compact',
                builder: _flux_card_widgetbook_usecases_flux_theme
                    .buildThemeCompactUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Custom',
                builder: _flux_card_widgetbook_usecases_flux_theme
                    .buildThemeCustomUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Elevated',
                builder: _flux_card_widgetbook_usecases_flux_theme
                    .buildThemeElevatedUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Standard',
                builder: _flux_card_widgetbook_usecases_flux_theme
                    .buildThemeStandardUseCase,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
