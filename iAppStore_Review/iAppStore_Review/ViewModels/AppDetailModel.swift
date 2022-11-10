//
//  AppDetailModel.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import Foundation

class AppDetailModel: ObservableObject {
    
    @Published var app: AppDetail? = nil
    @Published var results: [AppDetail] = []
    
    func searchAppData(_ appId: String?, _ keyWord: String?, _ regionName: String) {
        
        let regionId = TSMGConstants.regionTypeListIds[regionName] ?? "cn"
        var endpoint: APIService.Endpoint = APIService.Endpoint.lookupApp(appid: "", country: "")
        if let appid = appId {
            endpoint = APIService.Endpoint.lookupApp(appid: appid, country: regionId)
        }
        if let word = keyWord, let encodeword = word.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            endpoint = APIService.Endpoint.searchApp(word: encodeword, country: regionId, limit: 200)
        }
        
        APIService.shared.POST(endpoint: endpoint, params: nil) { (result: Result<AppDetailM, APIService.APIError>) in
            switch result {
            case let .success(response):
                self.results = response.results
                if appId != nil {
                    self.app = response.results.first
                }
            case .failure(_):
                break
            }
        }
    }
}
