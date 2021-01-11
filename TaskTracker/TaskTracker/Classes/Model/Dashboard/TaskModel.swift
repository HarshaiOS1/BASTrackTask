//
//  TaskModel.swift
//  TaskTracker
//
//  Created by Harsha on 12/01/21.
//

import Foundation

// MARK: - TaskData
struct TaskData: Codable {
    let count: Int?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let completed: Bool?
    let id, datumDescription: String?
    let owner: Owner?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case completed
        case id = "_id"
        case datumDescription = "description"
        case owner, createdAt, updatedAt
        case v = "__v"
    }
}

enum Owner: String, Codable {
    case the5Fcf496Fac58B00017C8106F = "5fcf496fac58b00017c8106f"
}
