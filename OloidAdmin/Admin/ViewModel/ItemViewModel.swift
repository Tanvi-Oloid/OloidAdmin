//
//  ItemViewModel.swift
//  CICOApp
//
//  Created by Tanvi Mittal on 21/05/20.
//  Copyright © 2020 Proxce Inc. All rights reserved.
//

import Foundation

// MARK: ItemDelegate Protocol
protocol ItemDelegate: AnyObject {
    /**
     Method called on ItemViewModel content update.
     
     - Parameter viewModel: active instance of ItemViewModel.
     */
    func contentUpdated(viewModel: ItemViewModel) -> Void
    
    /**
     Method called on error detection while content update.
     
     - Parameters:
     - viewModel: active instance of ItemViewModel.
     - error: type of NetworkError
     - message: custom error message as per error state.
     */
    func viewModel(viewModel: ItemViewModel, errorDetected error:NetworkError, withMessage message: String) -> Void
}

// MARK: ItemViewModel Struct
class ItemViewModel  {
    
    var listArray: AppListArray?
    // delegation to create binding with ViewModel
    weak var delegate: ItemDelegate?
    
    // custom initilazation of class
    init(delegate: ItemDelegate?) {
        self.delegate = delegate
    }
}

// MARK: Data fetch methods
extension ItemViewModel {
    
    /**
     Methods to fetch Item by using API.
    */
    func fetchItem() -> Void {
       
        // cancel all active downloads if any

        let url = ServerPath.listApplications.url
        var request = Request<AppListArray>(url: url)
        
        request.headerFields["Authorization"] = ""
        WebService().load(request: request) { response in
            DispatchQueue.main.async {
                switch response {
                case .success (let data):

                    // update item
                    self.listArray = data // TODO:
                    self.delegate?.contentUpdated(viewModel: self)
                case .failure (let error):

                    // error handling
                    switch error {
                    case .decodingError:
                        self.delegate?.viewModel(viewModel: self, errorDetected:error , withMessage: "Invalid response. Not able to parse data")
                    case .networkError: fallthrough
                    case .serviceError:
                        self.delegate?.viewModel(viewModel: self, errorDetected:error , withMessage: "Invalid response from server. Try again later.")
                    }
                }
            }
        }
    }

}
