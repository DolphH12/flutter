// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'framework.dart';

/// Applies an [ImageFilter] to its child.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=7Lftorq4i2o}
///
/// See also:
///
/// * [BackdropFilter], which applies an [ImageFilter] to everything
///   beneath its child.
/// * [ColorFiltered], which applies a [ColorFilter] to its child.
@immutable
class ImageFiltered extends SingleChildRenderObjectWidget {
  /// Creates a widget that applies an [ImageFilter] to its child.
  ///
  /// The [imageFilter] must not be null.
  const ImageFiltered({
    super.key,
    required this.imageFilter,
    super.child,
  }) : assert(imageFilter != null);

  /// The image filter to apply to the child of this widget.
  final ImageFilter imageFilter;

  @override
  RenderObject createRenderObject(BuildContext context) => _ImageFilterRenderObject(imageFilter);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _ImageFilterRenderObject).imageFilter = imageFilter;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ImageFilter>('imageFilter', imageFilter));
  }
}

class _ImageFilterRenderObject extends RenderProxyBox {
  _ImageFilterRenderObject(this._imageFilter);

  ImageFilter get imageFilter => _imageFilter;
  ImageFilter _imageFilter;
  set imageFilter(ImageFilter value) {
    assert(value != null);
    if (value != _imageFilter) {
      _imageFilter = value;
      markNeedsPaint();
    }
  }

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    assert(imageFilter != null);
    if (layer == null) {
      layer = ImageFilterLayer(imageFilter: imageFilter);
    } else {
      final ImageFilterLayer filterLayer = layer! as ImageFilterLayer;
      filterLayer.imageFilter = imageFilter;
    }
    context.pushLayer(layer!, super.paint, offset);
    assert(layer != null);
  }
}
