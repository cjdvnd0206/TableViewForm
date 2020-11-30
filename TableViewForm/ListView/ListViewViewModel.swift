//
//  ListViewViewModel.swift
//  TableViewForm
//
//  Created by 윤병진 on 2020/11/30.
//

import Foundation
import RxSwift
import RxCocoa

class ListViewViewModel {
    
    var model : BehaviorRelay<ListViewModel?> = BehaviorRelay<ListViewModel?>(value: nil)
    var step : BehaviorRelay<String> = BehaviorRelay(value: "")
    var responseError : BehaviorRelay<String> = BehaviorRelay(value: "")
    
    func requestSubList() {
        let parameters : [String : String] = ["mem_id" : UserDefaults().string(forKey: Constants.memId)!,
                                              "step" : step.value]
        
        Api.hospitalSubListDocRequest(parameters, completionHandler: { responseData in
            if responseData is Data {
                let responseData : Data = responseData as! Data
                let json : ListViewModel? = try? JSONDecoder().decode(ListViewModel.self, from: responseData)
                self.model.accept(json)
                
            } else {
                let responseError = responseData as? Error
                self.responseError.accept(responseError.debugDescription)
            }
        })
    }
}
