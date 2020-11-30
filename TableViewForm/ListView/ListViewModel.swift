//
//  ListViewModel.swift
//  TableViewForm
//
//  Created by 윤병진 on 2020/11/30.
//

import Foundation

struct ListViewModel: Codable {
    
    var responseCode : Int = 0
    var information : [ListViewModelInformations]?
   
    enum CodingKeys : String, CodingKey {
        case responseCode = "rt_code"
        case information = "information"
    }
    
    init(from decoder: Decoder) throws {
        let unkeyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        responseCode = try unkeyedContainer.decode(Int.self, forKey : .responseCode)
        information = (try? unkeyedContainer.decode([ListViewModelInformations].self, forKey : .information)) ?? []
    }
}

struct ListViewModelInformations: Codable {
    
    var reqNum : String = ""
    var reqDateReg : String = ""
    var reqFDrName : String = ""
    var reqFDrCName : String = ""
    var reqFDrTel : String = ""
    var reqDateDoc1 : String = ""
    var reqDateDoc2 : String = ""
    var reqDateDoc3 : String = ""
    var reqTerm : String = ""
    var reqStatus : String = ""

    enum CodingKeys : String, CodingKey {
        case reqNum = "req_num"
        case reqDateReg = "req_date_reg"
        case reqDateDoc1 = "req_date_doc1"
        case reqDateDoc2 = "req_date_doc2"
        case reqDateDoc3 = "req_date_doc3"
        case reqFDrName = "req_f_dr_name"
        case reqFDrCName = "req_f_dr_c_name"
        case reqFDrTel = "req_f_dr_tel"
        case reqTerm = "req_term"
        case reqStatus = "req_status"
    }
}
