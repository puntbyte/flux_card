// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flux_card_widgetbook/usecases/flux_advanced_cards.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_advanced_cards_usecase;
import 'package:flux_card_widgetbook/usecases/flux_card.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_card_usecase;
import 'package:flux_card_widgetbook/usecases/flux_composition.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_composition_usecase;
import 'package:flux_card_widgetbook/usecases/flux_content.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_content_usecase;
import 'package:flux_card_widgetbook/usecases/flux_loading.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_loading_usecase;
import 'package:flux_card_widgetbook/usecases/flux_media.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_media_usecase;
import 'package:flux_card_widgetbook/usecases/flux_overlay.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_overlay_usecase;
import 'package:flux_card_widgetbook/usecases/flux_section.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_section_usecase;
import 'package:flux_card_widgetbook/usecases/flux_theme.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_theme_usecase;
import 'package:flux_card_widgetbook/usecases/flux_ticket.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_ticket_usecase;
import 'package:flux_card_widgetbook/usecases/flux_underlay.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_underlay_usecase;
import 'package:flux_card_widgetbook/usecases/flux_view.usecase.dart'
    as _flux_card_widgetbook_usecases_flux_view_usecase;
import 'package:widgetbook/widgetbook.dart' as _widgetbook;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Flux Card',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'Backgrounds',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'FluxUnderlay',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Color & Decoration',
                builder: _flux_card_widgetbook_usecases_flux_underlay_usecase
                    .buildBackgroundColorUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Extruding & Overlapping',
                builder: _flux_card_widgetbook_usecases_flux_underlay_usecase
                    .buildBackgroundOverlappingUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Multi-Target Image',
                builder: _flux_card_widgetbook_usecases_flux_underlay_usecase
                    .buildBackgroundImageUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'zIndex ordering',
                builder: _flux_card_widgetbook_usecases_flux_underlay_usecase
                    .buildBackgroundZIndexUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Cards',
        children: [
          _widgetbook.WidgetbookFolder(
            name: 'Advanced',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'FluxCard',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Commerce Hero',
                    builder:
                        _flux_card_widgetbook_usecases_flux_advanced_cards_usecase
                            .buildAdvancedCommerceHeroUseCase,
                  ),
                ],
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'FluxCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Column',
                builder: _flux_card_widgetbook_usecases_flux_card_usecase
                    .buildColumnLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Hero Animation',
                builder: _flux_card_widgetbook_usecases_flux_card_usecase
                    .buildHeroAnimationUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Inline',
                builder: _flux_card_widgetbook_usecases_flux_card_usecase
                    .buildInlineLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _flux_card_widgetbook_usecases_flux_card_usecase
                    .buildInteractiveCardUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Responsive',
                builder: _flux_card_widgetbook_usecases_flux_card_usecase
                    .buildResponsiveLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Ripple over media',
                builder: _flux_card_widgetbook_usecases_flux_card_usecase
                    .buildRippleOverMediaUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Row',
                builder: _flux_card_widgetbook_usecases_flux_card_usecase
                    .buildRowLayoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Row Spanning',
                builder: _flux_card_widgetbook_usecases_flux_card_usecase
                    .buildRowSpanningUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Surface decoration',
                builder: _flux_card_widgetbook_usecases_flux_card_usecase
                    .buildDecorationUseCase,
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
                name: 'Creator profile',
                builder: _flux_card_widgetbook_usecases_flux_composition_usecase
                    .buildCreatorProfileUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Event ticket',
                builder: _flux_card_widgetbook_usecases_flux_composition_usecase
                    .buildEventTicketUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Freelancer profile',
                builder: _flux_card_widgetbook_usecases_flux_composition_usecase
                    .buildFreelancerProfileUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Pricing card',
                builder: _flux_card_widgetbook_usecases_flux_composition_usecase
                    .buildPricingCardUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Product card (full bleed)',
                builder: _flux_card_widgetbook_usecases_flux_composition_usecase
                    .buildFullBleedProductUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Property listing',
                builder: _flux_card_widgetbook_usecases_flux_composition_usecase
                    .buildPropertyListingUseCase,
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
                name: '.column (Auto-spacing)',
                builder: _flux_card_widgetbook_usecases_flux_content_usecase
                    .buildContentColumnUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: '.row (Auto-spacing)',
                builder: _flux_card_widgetbook_usecases_flux_content_usecase
                    .buildContentRowUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: '.wrap (Tags & Chips)',
                builder: _flux_card_widgetbook_usecases_flux_content_usecase
                    .buildContentWrapUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Min / max height',
                builder: _flux_card_widgetbook_usecases_flux_content_usecase
                    .buildContentConstraintsUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Scrollable body',
                builder: _flux_card_widgetbook_usecases_flux_content_usecase
                    .buildContentScrollableUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With decoration',
                builder: _flux_card_widgetbook_usecases_flux_content_usecase
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
                builder: _flux_card_widgetbook_usecases_flux_loading_usecase
                    .buildLoadingSkeletonUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'External shimmer bridge',
                builder: _flux_card_widgetbook_usecases_flux_loading_usecase
                    .buildLoadingExternalShimmerUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Toggle loaded / loading',
                builder: _flux_card_widgetbook_usecases_flux_loading_usecase
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
                builder: _flux_card_widgetbook_usecases_flux_media_usecase
                    .buildMediaAspectRatioUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Custom widget',
                builder: _flux_card_widgetbook_usecases_flux_media_usecase
                    .buildMediaCustomWidgetUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Fixed size',
                builder: _flux_card_widgetbook_usecases_flux_media_usecase
                    .buildMediaFixedSizeUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Gradients & Scrims',
                builder: _flux_card_widgetbook_usecases_flux_media_usecase
                    .buildMediaGradientsUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Rounded corners',
                builder: _flux_card_widgetbook_usecases_flux_media_usecase
                    .buildMediaRoundedUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Row — BoxFit fills slot',
                builder: _flux_card_widgetbook_usecases_flux_media_usecase
                    .buildMediaRowBoxFitUseCase,
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
                name: 'Breakout Overlays',
                builder: _flux_card_widgetbook_usecases_flux_overlay_usecase
                    .buildOverlayBreakoutUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive badges',
                builder: _flux_card_widgetbook_usecases_flux_overlay_usecase
                    .buildOverlayInteractiveUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Offset nudge',
                builder: _flux_card_widgetbook_usecases_flux_overlay_usecase
                    .buildOverlayOffsetUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Slot targeting',
                builder: _flux_card_widgetbook_usecases_flux_overlay_usecase
                    .buildOverlaySlotTargetingUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'zIndex ordering',
                builder: _flux_card_widgetbook_usecases_flux_overlay_usecase
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
                name: 'Agnostic (Omni-tool)',
                builder: _flux_card_widgetbook_usecases_flux_section_usecase
                    .buildSectionAnatomyUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Full Bleed Override',
                builder: _flux_card_widgetbook_usecases_flux_section_usecase
                    .buildSectionFullBleedUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Semantic .footer',
                builder: _flux_card_widgetbook_usecases_flux_section_usecase
                    .buildSectionFooterUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Semantic .header',
                builder: _flux_card_widgetbook_usecases_flux_section_usecase
                    .buildSectionHeaderUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Text & Row Alignments',
                builder: _flux_card_widgetbook_usecases_flux_section_usecase
                    .buildSectionAlignmentUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With decoration',
                builder: _flux_card_widgetbook_usecases_flux_section_usecase
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
                builder: _flux_card_widgetbook_usecases_flux_theme_usecase
                    .buildThemeCompactUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Custom',
                builder: _flux_card_widgetbook_usecases_flux_theme_usecase
                    .buildThemeCustomUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Elevated',
                builder: _flux_card_widgetbook_usecases_flux_theme_usecase
                    .buildThemeElevatedUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Outlined',
                builder: _flux_card_widgetbook_usecases_flux_theme_usecase
                    .buildThemeOutlinedUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Standard',
                builder: _flux_card_widgetbook_usecases_flux_theme_usecase
                    .buildThemeStandardUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'ThemeExtension',
                builder: _flux_card_widgetbook_usecases_flux_theme_usecase
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
            name: 'FluxNotchShape',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Basic ticket',
                builder: _flux_card_widgetbook_usecases_flux_ticket_usecase
                    .buildTicketBasicUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Horizontal ticket',
                builder: _flux_card_widgetbook_usecases_flux_ticket_usecase
                    .buildTicketHorizontalUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Outlined ticket',
                builder: _flux_card_widgetbook_usecases_flux_ticket_usecase
                    .buildTicketOutlinedUseCase,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'Views (Scrollables)',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'CustomScrollView',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'SliverGrid',
                builder: _flux_card_widgetbook_usecases_flux_view_usecase
                    .buildSliverGridUseCase,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'SliverList',
                builder: _flux_card_widgetbook_usecases_flux_view_usecase
                    .buildSliverListUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'GridView',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'GridView',
                builder: _flux_card_widgetbook_usecases_flux_view_usecase
                    .buildGridViewUseCase,
              ),
            ],
          ),
          _widgetbook.WidgetbookComponent(
            name: 'ListView',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'ListView',
                builder: _flux_card_widgetbook_usecases_flux_view_usecase
                    .buildListViewUseCase,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
