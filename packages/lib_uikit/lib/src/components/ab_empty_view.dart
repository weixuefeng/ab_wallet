
import 'package:flutter/material.dart';
import 'package:lib_uikit/generated/l10n.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:lib_uikit/src/utils/image_utils.dart';
import 'package:lib_uikit/src/utils/theme/colors_utils.dart';

// 空组件图标枚举类，用于区分不同的空页面选用不同的icon
enum ABEmptyIconType { data, search, wallet, connection }


class ABEmptyView extends StatelessWidget {
  // icon参数，如果传了icon则下面三个icon参数不生效
  final Widget? icon;
  final String? iconAssetPath; // iconPath和iconType二选一
  final ABEmptyIconType? iconType; // iconPath和iconType二选一
  final double? iconWidth;
  final double? iconHeight;

  // icon下方的文案参数，如果传了titleView，则下面的title相关参数不生效
  final Widget? titleView;
  final String? title;
  final TextStyle? titleStyle;
  final double? titleSize;
  final Color? titleColor;
  final FontWeight? titleFontWeight;

  //底部按钮文案
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  // icon和text间的间距
  final double? iconTextSpace;

  final EdgeInsetsGeometry? padding;

  ///true小尺寸（图片72大小）
  final bool? isSmall;

  final Widget? bottomWidget;

  ///用在外层用Expanded包裹，需要设置上边距的情况，传false；默认true
  final bool? isCenter;

  const ABEmptyView(
      {super.key,
        this.icon,
        this.iconAssetPath,
        this.iconType,
        this.iconWidth = 96,
        this.iconHeight = 96,
        this.titleView,
        this.title,
        this.titleStyle,
        this.titleSize = 14,
        this.titleColor,
        this.titleFontWeight = FontWeight.w400,
        this.iconTextSpace = 16,
        this.padding,
        this.buttonText,
        this.onButtonPressed,
        this.isSmall,
        this.bottomWidget,
        this.isCenter});

  @override
  Widget build(BuildContext context) {
    double _iconWidth = iconWidth ?? 96;
    double _iconHeight = iconHeight ?? 96;
    double _iconTextSpace = iconTextSpace ?? 16;
    double _titleSize = titleSize ?? 14;
    Theme.of(context);
    String? iconAssetPathReal = iconAssetPath;
    if (null == iconAssetPathReal && null != iconType) {
      switch (iconType!) {
        case ABEmptyIconType.data:
          iconAssetPathReal = ABImageRes.noDataImg;
          break;
        case ABEmptyIconType.search:
          iconAssetPathReal = ABImageRes.noDataSearchImg;
          break;
        case ABEmptyIconType.wallet:
          iconAssetPathReal = ABImageRes.noDataWalletImg;
          break;
        case ABEmptyIconType.connection:
          iconAssetPathReal = ABImageRes.noDataConnectImg;
          break;
        default:
          iconAssetPathReal = ABImageRes.noDataImg;
          break;
      }
    }
    if (isSmall ?? false) {
      _iconWidth = 72;
      _iconHeight = 72;
      _iconTextSpace = 8;
      _titleSize = 12;
    }

    Widget _container() {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon ??
                Image.asset(iconAssetPath ?? (iconAssetPathReal ?? ABImageRes.noDataImg),
                    height: _iconHeight, width: _iconWidth),
            SizedBox(height: _iconTextSpace),
            titleView ??
                Text(
                  title ?? LibUIKitS.of(context).no_data,
                  style: titleStyle ??
                      TextStyle(
                          color: titleColor ?? ABColors.text1.color,
                          fontSize: _titleSize,
                          fontWeight: titleFontWeight),
                  textAlign: TextAlign.center,
                ),
            if (buttonText != null) ...[
              const SizedBox(height: 24),
              ABPrimaryButton(
                text: buttonText ?? "",
                onPressed: onButtonPressed ?? (){

                },
              )
            ],
            if (bottomWidget != null) ...[const SizedBox(height: 24), bottomWidget!],
          ],
        ),
      );
    }

    if (isCenter ?? true) {
      return Center(child: _container());
    } else {
      return _container();
    }
  }
}
