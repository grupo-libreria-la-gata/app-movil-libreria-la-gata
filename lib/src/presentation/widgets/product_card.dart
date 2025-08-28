import 'package:flutter/material.dart';
import '../../core/design/design_tokens.dart';
import '../../core/utils/responsive_helper.dart';

/// Widget para mostrar un producto en la lista
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final stock = product['stock'] as int;
    final minStock = product['minStock'] as int;
    final isLowStock = stock <= minStock;
    final isOutOfStock = stock == 0;
    final responsiveHelper = ResponsiveHelper.instance;
    final isSmallMobile = responsiveHelper.isSmallMobile(context);

    return Card(
      elevation: DesignTokens.elevationSm,
      color: DesignTokens.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
        child: Padding(
          padding: EdgeInsets.all(responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingMd)),
          child: isSmallMobile 
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildProductImage(context),
                      SizedBox(width: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingMd)),
                      Expanded(child: _buildProductInfo(context)),
                    ],
                  ),
                  SizedBox(height: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingSm)),
                  _buildProductActions(context, isLowStock, isOutOfStock),
                ],
              )
            : Row(
                children: [
                  // Imagen del producto
                  _buildProductImage(context),
                  
                  SizedBox(width: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingMd)),
                  
                  // Información del producto
                  Expanded(
                    child: _buildProductInfo(context),
                  ),
                  
                  // Acciones y estado
                  _buildProductActions(context, isLowStock, isOutOfStock),
                ],
              ),
        ),
      ),
    );
  }

  /// Construye la imagen del producto
  Widget _buildProductImage(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;
    
    return Container(
      width: responsiveHelper.getResponsiveIconSize(context, 60),
      height: responsiveHelper.getResponsiveIconSize(context, 60),
      decoration: BoxDecoration(
        color: DesignTokens.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
      ),
      child: product['imageUrl'] != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.borderRadiusMd),
              child: Image.network(
                product['imageUrl'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultIcon();
                },
              ),
            )
          : _buildDefaultIcon(),
    );
  }

  /// Construye el icono por defecto
  Widget _buildDefaultIcon() {
    return Icon(
      Icons.local_bar,
      color: DesignTokens.primaryColor,
      size: 30,
    );
  }

  /// Construye la información del producto
  Widget _buildProductInfo(BuildContext context) {
    final responsiveHelper = ResponsiveHelper.instance;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nombre del producto
        Text(
          product['name'],
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(context, DesignTokens.fontSizeLg),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.textPrimaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        SizedBox(height: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingXs)),
        
        // Marca
        Text(
          product['brand'],
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(context, DesignTokens.fontSizeMd),
            color: DesignTokens.textSecondaryColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        SizedBox(height: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingXs)),
        
        // Categoría
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingSm),
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: DesignTokens.accentColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
          ),
          child: Text(
            product['category'],
            style: TextStyle(
              fontSize: responsiveHelper.getResponsiveFontSize(context, DesignTokens.fontSizeXs),
              color: DesignTokens.accentColor,
              fontWeight: DesignTokens.fontWeightMedium,
            ),
          ),
        ),
        
        SizedBox(height: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingSm)),
        
        // Precio
        Text(
          '₡${product['price'].toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: responsiveHelper.getResponsiveFontSize(context, DesignTokens.fontSizeLg),
            fontWeight: DesignTokens.fontWeightBold,
            color: DesignTokens.primaryColor,
          ),
        ),
      ],
    );
  }

  /// Construye las acciones y estado del producto
  Widget _buildProductActions(BuildContext context, bool isLowStock, bool isOutOfStock) {
    final responsiveHelper = ResponsiveHelper.instance;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón de editar
        if (onEdit != null)
          IconButton(
            icon: Icon(
              Icons.edit,
              color: DesignTokens.textSecondaryColor,
              size: responsiveHelper.getResponsiveIconSize(context, 20),
            ),
            onPressed: onEdit,
          ),
        
        const Spacer(),
        
        // Estado del stock
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsiveHelper.getResponsiveSpacing(context, DesignTokens.spacingSm),
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: _getStockColor(isLowStock, isOutOfStock).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(DesignTokens.borderRadiusSm),
          ),
          child: Text(
            'Stock: ${product['stock']}',
            style: TextStyle(
              fontSize: responsiveHelper.getResponsiveFontSize(context, DesignTokens.fontSizeXs),
              color: _getStockColor(isLowStock, isOutOfStock),
              fontWeight: DesignTokens.fontWeightMedium,
            ),
          ),
        ),
      ],
    );
  }

  /// Obtiene el color del estado del stock
  Color _getStockColor(bool isLowStock, bool isOutOfStock) {
    if (isOutOfStock) return DesignTokens.errorColor;
    if (isLowStock) return DesignTokens.warningColor;
    return DesignTokens.successColor;
  }
}
