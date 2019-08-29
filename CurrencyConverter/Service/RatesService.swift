//
//  RatesService.swift
//  CurrencyConverter
//
//  Created by Jag Stang on 22/01/2019.
//  Copyright © 2019 JagStang. All rights reserved.
//

import Foundation

protocol RatesServiceProtocol {
    func getRates(for baseCurrencyName: String, completion: @escaping ([String: Float]) -> ())
}

fileprivate struct RateResponse: Decodable {
    var base: String
    var rates: [String: Float]
    
    func getRatesWithBase() -> [String: Float] {
        var rates = self.rates
        rates[base] = 1.0
        
        return rates
    }
}

class RatesService: RatesServiceProtocol {
    
    private let urlPrefix = "http://jagstang.ru/currency.php?base="
    private let requestTimeout = 5.0
    
    public func getRates(for baseCurrencyName: String, completion: @escaping ([String: Float]) -> ()) {
        let session = URLSession.shared
        let request = prepareGetRequest(for: baseCurrencyName)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            if err == nil {
                do {
                    let response = try JSONDecoder().decode(RateResponse.self, from: data!)
                    completion(response.getRatesWithBase())
                    return
                } catch {
                }
            }
            completion([:])
        })
        
        task.resume()
    }
    
    private func prepareGetRequest(for baseCurrencyName: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: getUrl(with: baseCurrencyName))! as URL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.cachePolicy = .reloadIgnoringCacheData
        request.timeoutInterval = requestTimeout
        
        return request
    }
    
    private func getUrl(with baseCurrencyName: String) -> String {
        return urlPrefix + baseCurrencyName
    }
}
