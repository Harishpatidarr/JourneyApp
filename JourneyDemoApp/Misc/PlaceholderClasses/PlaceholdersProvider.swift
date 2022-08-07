//
//  PlaceholdersProvider.swift
//  HGPlaceholders
//
//  Created by Hamza Ghazouani on 20/07/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import HGPlaceholders

extension PlaceholdersProvider {
    static var appCustom: PlaceholdersProvider {
        var commonStyle = PlaceholderStyle()
        commonStyle.backgroundColor = #colorLiteral(red: 0.97299999, green: 0.97299999, blue: 0.97299999, alpha: 1)
        commonStyle.actionBackgroundColor = #colorLiteral(red: 0.02400000021, green: 0.1059999987, blue: 0.2899999917, alpha: 1)
        commonStyle.actionTitleColor = .white
        commonStyle.titleColor = #colorLiteral(red: 0.02400000021, green: 0.1059999987, blue: 0.2899999917, alpha: 1)
        commonStyle.isAnimated = true
        
        commonStyle.titleFont = UIFont.systemFont(ofSize: 19) //Font.Poppins.bold.ofSize(19)!
        commonStyle.subtitleFont = UIFont.systemFont(ofSize: 19) //Font.Poppins.medium.ofSize(19)!
        commonStyle.actionTitleFont = UIFont.systemFont(ofSize: 19) //Font.Poppins.medium.ofSize(19)!
        
        var loadingStyle = commonStyle
        loadingStyle.actionBackgroundColor = .clear
        loadingStyle.actionTitleColor = .gray
        
        var loadingData: PlaceholderData = .loading
        loadingData.image = nil
        loadingData.action = nil
        loadingData.title = nil
        loadingData.subtitle = nil
        let loading = Placeholder(data: loadingData, style: loadingStyle, key: .loadingKey)
        
        var errorData: PlaceholderData = .error
        //errorData.image = #imageLiteral(resourceName: "splash_img2")
        let error = Placeholder(data: errorData, style: commonStyle, key: .errorKey)
        
        var noResultsData: PlaceholderData = .noResults
     //   noResultsData.image = #imageLiteral(resourceName: "splash_img3")
        noResultsData.action = nil
//        noResultsData.title = LocalizedKey.noDataFound.value
        noResultsData.subtitle = ""
        let noResults = Placeholder(data: noResultsData, style: commonStyle, key: .noResultsKey)
        
        var noConnectionData: PlaceholderData = .noConnection
    //    noConnectionData.image = #imageLiteral(resourceName: "splash_img2")
        let noConnection = Placeholder(data: noConnectionData, style: commonStyle, key: .noConnectionKey)
        
        let placeholdersProvider = PlaceholdersProvider(loading: loading, error: error, noResults: noResults, noConnection: noConnection)
        return placeholdersProvider
    }
    

}
