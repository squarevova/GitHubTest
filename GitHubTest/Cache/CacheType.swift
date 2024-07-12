//
//  CacheType.swift
//  GitHubTest
//
//  Created by Volodymyr Milichenko on 24/01/2024.
//

protocol CacheType<CacheObject> {
    associatedtype CacheObject
    
    func loadObjects() -> [CacheObject]?
    func saveObjects(_ objects: [CacheObject])
}
