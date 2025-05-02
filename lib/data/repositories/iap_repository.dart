import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/failure.dart';

abstract interface class IapRepository {
  Stream<List<PurchaseDetails>> get subscription;

  Future<Either<Failure, List<ProductDetails>>> getProducts();

  Future<Either<Failure, void>> restorePurchases();

  Future<Either<Failure, void>> purchaseProduct(ProductDetails product);

  void completePurchase(PurchaseDetails purchase);
}

class IapRepositoryImpl implements IapRepository {
  final InAppPurchase _iap = InAppPurchase.instance;

  @override
  Stream<List<PurchaseDetails>> get subscription => _iap.purchaseStream;

  @override
  Future<Either<Failure, List<ProductDetails>>> getProducts() async {
    try {
      final bool isAvailable = await _iap.isAvailable();
      if (isAvailable) {
        final primaryId = const String.fromEnvironment("PRIMARY_PRODUCT_ID");
        final secondaryId = const String.fromEnvironment("SECONDARY_PRODUCT_ID");
        final productIds = {primaryId, secondaryId};
        debugPrint('productIds: $productIds');
        final response = await _iap.queryProductDetails(productIds);
        if (response.notFoundIDs.isNotEmpty) {
          return Left(Failure(message: 'Product not found'));
        }
        return Right(response.productDetails);
      } else {
        return Left(Failure(message: 'In-app purchases are not available'));
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, void>> restorePurchases() async {
    try {
      await _iap.restorePurchases();
      return Right(null);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, void>> purchaseProduct(ProductDetails product) async {
    try {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
      if (product.id == const String.fromEnvironment("PRIMARY_PRODUCT_ID")) {
        await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        await _iap.buyConsumable(purchaseParam: purchaseParam);
      }
      return Right(null);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  void completePurchase(PurchaseDetails purchase) {
    _iap.completePurchase(purchase);
  }
}
