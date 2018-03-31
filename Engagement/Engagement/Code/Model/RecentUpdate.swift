//
//  RecentUpdate.swift
//  Engagement
//
//  Created by Microsoft on 12/02/2016.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation
import SWXMLHash

extension Data {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options:[NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}


/// Recent Update model
class RecentUpdate {
    
    var title: String?
    var description: String?
    var pubDate: String?
    var link: String?
    var category: String?
    
    /**
     Parse a XML element to create a RecentUpdate Object
     
     - parameter element: XMLIndexer element
     
     - returns: RecentUpdate object
     */
    static func parseFromXMLElements(_ element: XMLIndexer) -> RecentUpdate
    {
        let recentUpdate = RecentUpdate()
        recentUpdate.title = element["title"].element?.text
        recentUpdate.pubDate = element["pubDate"].element?.text
        
        if let text = element["description"].element?.text
        {
            //decode text
            let encodedData = text.data(using: String.Encoding.utf8)!
            
            let textAttributed = encodedData.attributedString
            
            let cleanedText = textAttributed?.string.replacingOccurrences(of: "<[^>]+>", with: "")
            recentUpdate.description = cleanedText
        }
        
        recentUpdate.link = element["link"].element?.text
        recentUpdate.category = element["category"].element?.text
        return recentUpdate
    }
}
