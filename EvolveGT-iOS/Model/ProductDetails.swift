//
//  ProductDetails.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 23/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation
class ProductDetails: Codable {
    var title, slug: String?
    var image: String?
    var price: String?
    var variations: [ProductVariation]?
    var itemStatusList: [ProductItemStatus]?
    var priceRange: String?
    var stockStatus: String?
    var quantity = 1
    var productID, categoryID, isVariant: Int?
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case title, slug, image, price
        case isVariant = "is_variant"
        case categoryID = "category_id"
        case variations
        case itemStatusList = "pricings"
        case priceRange = "price_range"
        case stockStatus = "stock_status"
    }
    
    var selectedVariants: [String]{
        var selectedVariants = [String]()
        if let allVariations = variations{
            for productVariation in allVariations{
                selectedVariants.append(productVariation.selectedVariant.variantID ?? "")
            }
        }
        return selectedVariants.filter({$0.isEmpty() == false})
    }
    func getItemStatus() -> ProductItemStatus?{
        if let allItemStatusList = itemStatusList{
            let selectedVariantSet = Set(selectedVariants)
            for itemStatus in allItemStatusList where itemStatus.variants?.count ?? 0 > 0{
                let listVariantSet = Set(itemStatus.variants!)
                if selectedVariantSet.isSubset(of: listVariantSet){
                    return itemStatus
                }
            }
        }
        return nil
    }
    var isOutOfStock : Bool{
        if let itemStatus = getItemStatus(){
            return  itemStatus.stockStatus?.isOutOfStock() ?? false
        }
        return stockStatus?.isOutOfStock() ?? false
    }
    
    var productVariantPrice: String{
        if let itemStatus = getItemStatus(){
            return itemStatus.price ?? ""
        }
        return price ?? ""
    }
    
    func preselectDefaultVariant(){
        
        if let allVariations = variations{
            for productVariation in allVariations{
                if productVariation.variants?.count ?? 0 > 0{
                    productVariation.selectedVariant = productVariation.variants![0]
                }
            }
        }
        
        
    }
}

// MARK: - Pricing
class ProductItemStatus: Codable {
    var price: String?
    var stockStatus: String?
    var variants: [String]?
    
    enum CodingKeys: String, CodingKey {
        case price
        case stockStatus = "stock_status"
        case variants
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? container.decode(Int.self, forKey: .price) {
            price = String(value)
        } else {
            price = try container.decode(String.self, forKey: .price)
        }
        
        if let valueStockStatus = try? container.decode(String.self, forKey: .stockStatus) {
            stockStatus = valueStockStatus
        }
        
        if let variantsValue = try? container.decode([String].self, forKey: .variants) {
            variants = variantsValue
        }
    }
}



// MARK: - Variation
class ProductVariation: Codable {
    var variantName: String?
    var variants: [ProductVariant]?
    
    var selectedVariant = ProductVariant()
    enum CodingKeys: String, CodingKey {
        case variantName
        case variants = "data"
    }
    
    var options: [String]{
        var optionsList = [String]()
        if let allVariants = variants{
            for variant in allVariants where variant.value?.isEmpty() ?? true == false{
                optionsList.append(variant.value!)
            }
        }
        return optionsList
    }
}

// MARK: - Datum
class ProductVariant: Codable {
    var variantID, value: String?
    
    enum CodingKeys: String, CodingKey {
        case variantID = "variantId"
        case value
    }
}
