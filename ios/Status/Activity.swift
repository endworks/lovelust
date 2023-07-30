//
//  Activity.swift
//  Runner
//
//  Created by ender on 29/7/23.
//

import Foundation

struct Activity: Decodable, Hashable {
    let id: String
    let partner: String?
    let birthControl: String?
    let partnerBirthControl: String?
    let date: Date
    let location: String?
    let notes: String?
    let duration: Int
    let orgasms: Int
    let partnerOrgasms: Int
    let place: String?
    let initiator: String?
    let rating: Int
    let type: String?
    let mood: String?
    let practices: [IdName]
}

struct IdName: Hashable, Codable {
    let id: String
    let name: String
}
