//
//  SnapshotExtension.swift
//  bublePop
//
//  Created by Nguyễn Ngọc Anh on 5/5/18.
//  Copyright © 2018 Nguyễn Ngọc Anh. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot {
    
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws  -> T {
        
        var documentJson = data()
        if includingId {
            documentJson["id"] = documentID
        }
        
        let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
        let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
        
        return decodedObject
    }
    
}
