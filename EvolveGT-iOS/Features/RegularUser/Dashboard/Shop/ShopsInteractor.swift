//
//  ShopsInteractor.swift
//  EvolveGT-iOS
//
//  Created by Subair Ariyil on 21/05/20.
//  Copyright © 2020 YaraTech. All rights reserved.
//

import Foundation


protocol CategoryViewDelegate{
    func didFetchCategories(categories : [ProductCategory])
}

protocol ProductListDelegate{
    func didFetchProducts(products : [Product])
}

protocol ProductDetailsDelegate{
    func didFetchProductDetails(productDetails : ProductDetails)
}

class ShopsInteractor : BaseInteractor{
    
    var viewDelegate : BaseViewDelegate?
    var categoryDelegate : CategoryViewDelegate?
    var productListDelegate : ProductListDelegate?
    var productDetailsDelegate : ProductDetailsDelegate?
    
    func fetchCategoryList(){
        self.viewDelegate?.showProgressIndicator(message: "")
        
        let shopsApi = ShopsApi()
        shopsApi.setCompletionHandler(){ data, error in
            self.viewDelegate?.hideProgressIndicator()
            
            if error == nil{
                if let categoryList = self.decodeFromJson(data!, modelType: CategoryListResponse.self){
                    if categoryList.category?.count ?? 0 == 0{
                        self.viewDelegate?.showEmptyPageError(message: ErrorMessages.genericError)
                    }else{
                        self.categoryDelegate?.didFetchCategories(categories: categoryList.category!)
                    }
                }else{
                    self.viewDelegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
            }else{
                self.viewDelegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        shopsApi.fetchCategoryList()
    }
    
    func fetchProductList(category : ProductCategory, source: String){
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingProducts)
           
           let shopsApi = ShopsApi()
           shopsApi.setCompletionHandler(){ data, error in
               self.viewDelegate?.hideProgressIndicator()
               self.viewDelegate?.hideEmptyPageError()
            
               if error == nil{
                   if let productListResponse = self.decodeFromJson(data!, modelType: ProductListResponse.self){
                       if productListResponse.products?.count ?? 0 == 0{
                           self.viewDelegate?.showEmptyPageError(message: ErrorMessages.emptyProducts)
                       }else{
                        self.productListDelegate?.didFetchProducts(products: productListResponse.products!)
                       }
                   }else{
                       self.viewDelegate?.showEmptyPageError(message: ErrorMessages.genericError)
                   }
               }else{
                   self.viewDelegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
               }
           }
           shopsApi.fetchProductList(category: category, source: source)
       }
    
    func fetchProductDetails(slug: String){
     self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.loadingProductDetails)
        
        let shopsApi = ShopsApi()
        shopsApi.setCompletionHandler(){ data, error in
            self.viewDelegate?.hideProgressIndicator()
            self.viewDelegate?.hideEmptyPageError()
         
            if error == nil{
                if let productDetails = self.decodeFromJson(data!, modelType: ProductDetails.self){
                   
                    self.productDetailsDelegate?.didFetchProductDetails(productDetails: productDetails)
                    
                }else{
                    self.viewDelegate?.showEmptyPageError(message: ErrorMessages.genericError)
                }
            }else{
                self.viewDelegate?.showEmptyPageError(message: error?.errorMessage ?? ErrorMessages.genericError)
            }
        }
        shopsApi.fetchProductDetails(slug: slug)
    }
    
    func getProductDetailsSections(details : ProductDetails) -> [ProductDetailSections]{
        var sections = [ProductDetailSections]()
        sections.append(.info)
        sections.append(.quantity)
        if details.variations?.count ?? 0 > 0{
            sections.append(.variations)
        }
        if details.isOutOfStock{
             sections.append(.outofstock)
        }
        return sections
    }
    func addProductToCart(productDetails: ProductDetails){
        self.viewDelegate?.showProgressIndicator(message: LoadingIndicatorMessages.addingProductToCart)
        let cartApi = CartApi()
        
        
        var request = ProductCartRequest()
        request.price = productDetails.productVariantPrice
        request.quantity = productDetails.quantity
        request.serial = AppEngine.sharedInstance.userID
        request.slug = productDetails.slug
        request.selectedAttributes = [ProductCartAttribute]()
        if let variations = productDetails.variations{
            for variation in variations{
                var attribute = ProductCartAttribute()
                attribute.name = variation.variantName
                attribute.value = variation.selectedVariant.value
                request.selectedAttributes?.append(attribute)
            }
        }
        
        cartApi.setCompletionHandler(){ data, error in
                   self.viewDelegate?.hideProgressIndicator()
                   self.viewDelegate?.hideEmptyPageError()
                
                   if error == nil{
                    self.viewDelegate?.showSuccessToastMessage(message: SuccessMessages.productAddedToCart)
                   }else{
                       self.viewDelegate?.showErrorToastMessage(message: error?.errorMessage ?? ErrorMessages.genericError)
                   }
               }
        cartApi.addProductToCart(request: request)
        
    }
}
enum ProductDetailSections : Int{
    case info
    case quantity
    case variations
    case outofstock
}
