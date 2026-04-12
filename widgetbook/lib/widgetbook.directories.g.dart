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
import 'package:flux_card_widgetbook/usecases/flux_content.dart'
    as _flux_card_widgetbook_usecases_flux_content;
import 'package:flux_card_widgetbook/usecases/flux_loading.dart'
    as _flux_card_widgetbook_usecases_flux_loading;
import 'package:flux_card_widgetbook/usecases/flux_media.dart'
    as _flux_card_widgetbook_usecases_flux_media;
import 'package:flux_card_widgetbook/usecases/flux_overlay.dart'
    as _flux_card_widgetbook_usecases_flux_overlay;
import 'package:flux_card_widgetbook/usecases/flux_section.dart'
    as _flux_card_widgetbook_usecases_flux_section;
import 'package:flux_card_widgetbook/usecases/flux_theme.dart'
    as _flux_card_widgetbook_usecases_flux_theme;
import 'package:flux_card_widgetbook/usecases/flux_ticket.dart'
    as _flux_card_widgetbook_usecases_flux_ticket;
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
                name: 'Gradient',
                builder: _flux_card_widgetbook_usecases_flux_background
                    .buildBackgroundGradientUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Slot-targeted',
                builder: _flux_card_widgetbook_usecases_flux_background
                    .buildBackgroundSlotTargetedUseCase,
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
                name: 'Column',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildColumnLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Empty shell',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildEmptyShellUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'InColumn',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildInColumnLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildInteractiveCardUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Responsive',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildResponsiveLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Row',
                builder: _flux_card_widgetbook_usecases_flux_card
                    .buildRowLayoutUseCase,
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
                name: 'Event ticket',
                builder: _flux_card_widgetbook_usecases_flux_composition
                    .buildEventTicketUseCase,
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
        name: 'Content',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxContent',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Min / max height',
                builder: _flux_card_widgetbook_usecases_flux_content
                    .buildContentConstraintsUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Scrollable body',
                builder: _flux_card_widgetbook_usecases_flux_content
                    .buildContentScrollableUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With decoration',
                builder: _flux_card_widgetbook_usecases_flux_content
                    .buildContentDecorationUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Loading',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxCardSkeleton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Built-in skeleton',
                builder: _flux_card_widgetbook_usecases_flux_loading
                    .buildLoadingSkeletonUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'External shimmer bridge',
                builder: _flux_card_widgetbook_usecases_flux_loading
                    .buildLoadingExternalShimmerUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Toggle loaded / loading',
                builder: _flux_card_widgetbook_usecases_flux_loading
                    .buildLoadingToggleUseCase,
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
                name: 'Aspect ratio',
                builder: _flux_card_widgetbook_usecases_flux_media
                    .buildMediaAspectRatioUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Custom widget',
                builder: _flux_card_widgetbook_usecases_flux_media
                    .buildMediaCustomWidgetUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Fixed size',
                builder: _flux_card_widgetbook_usecases_flux_media
                    .buildMediaFixedSizeUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Rounded corners',
                builder: _flux_card_widgetbook_usecases_flux_media
                    .buildMediaRoundedUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Overlays',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxOverlay',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive badges',
                builder: _flux_card_widgetbook_usecases_flux_overlay
                    .buildOverlayInteractiveUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Offset nudge',
                builder: _flux_card_widgetbook_usecases_flux_overlay
                    .buildOverlayOffsetUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Slot targeting',
                builder: _flux_card_widgetbook_usecases_flux_overlay
                    .buildOverlaySlotTargetingUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'zIndex ordering',
                builder: _flux_card_widgetbook_usecases_flux_overlay
                    .buildOverlayZIndexUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Sections',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxSection',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'As standalone',
                builder: _flux_card_widgetbook_usecases_flux_section
                    .buildSectionStandaloneUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Full anatomy',
                builder: _flux_card_widgetbook_usecases_flux_section
                    .buildSectionAnatomyUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With decoration',
                builder: _flux_card_widgetbook_usecases_flux_section
                    .buildSectionDecorationUseCase,
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
                name: 'Outlined',
                builder: _flux_card_widgetbook_usecases_flux_theme
                    .buildThemeOutlinedUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Standard',
                builder: _flux_card_widgetbook_usecases_flux_theme
                    .buildThemeStandardUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'ThemeExtension',
                builder: _flux_card_widgetbook_usecases_flux_theme
                    .buildThemeExtensionUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Ticket Shape',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxTicketShape',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Basic ticket',
                builder: _flux_card_widgetbook_usecases_flux_ticket
                    .buildTicketBasicUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Horizontal ticket',
                builder: _flux_card_widgetbook_usecases_flux_ticket
                    .buildTicketHorizontalUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Outlined ticket',
                builder: _flux_card_widgetbook_usecases_flux_ticket
                    .buildTicketOutlinedUseCase,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
