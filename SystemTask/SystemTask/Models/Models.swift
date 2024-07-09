//
//  Models.swift
//  SystemTask
//
//  Created by Kanchireddy sreelatha on 08/07/24.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
}

struct User: Codable {
    let name: String
    let email: String
    let phoneNumber: String
}

struct Product: Codable {
    let notes: String
    let description: String
    let attachments: [String]
}


// MARK: - UserModel
struct UserModel: Codable {
    let message: String
    let status: Int
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int = 0
    let firstName, lastName, email, name: String?
    let rating, countryCode, phone, profileImage: String?
    let companyLogo, city, state, address: String?
    let country, postalCode, gender, dateOfBirth: String?
    let firebaseToken, nickName, storeName, storeUserName: String?
    let reviewsCount: Int?
    let totalLikes, accountType: String?
    let isVerified: Bool?
    let organization: Organization?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email, name, rating
        case countryCode = "country_code"
        case phone
        case profileImage = "profile_image"
        case companyLogo = "company_logo"
        case city, state, address, country
        case postalCode = "postal_code"
        case gender
        case dateOfBirth = "date_of_birth"
        case firebaseToken = "firebase_token"
        case nickName = "nick_name"
        case storeName = "store_name"
        case storeUserName = "store_user_name"
        case reviewsCount = "reviews_count"
        case totalLikes = "total_likes"
        case accountType = "account_type"
        case isVerified = "is_verified"
        case organization
    }
}

// MARK: - Organization
struct Organization: Codable {
    let id: Int
    let name: String
}

// MARK: - SalesModel
struct SalesModel : Codable{
    let message: String?
    let status: Int?
    let data: SaleDataClass?
}

// MARK: - DataClass
struct SaleDataClass : Codable {
    let posts: [Post]?
    let pagination: Pagination?
   
    enum CodingKeys: String, CodingKey {
           case posts, pagination
          
       }
}

// MARK: - Pagination
struct Pagination : Codable{
    let total, perPage, currentPage, lastPage: Int?
    
    enum CodingKeys: String, CodingKey {
           case total
           case perPage = "per_page"
           case currentPage = "current_page"
           case lastPage = "last_page"
           
       }
}



// MARK: - Post
struct Post : Codable{
    let notes: String?
    let description: String?
    let videoImage: String?
    let attachments: [Attachment]?
   
    enum CodingKeys: String, CodingKey {
            
        case videoImage = "video_image"
        case  attachments
        case notes
        case description
        }
}

// MARK: - Attachment
struct Attachment : Codable{
    let id: Int?
    let url: String?
    let attachmentType, serialNo: String?
    
    enum CodingKeys: String, CodingKey {
            case id, url
            case attachmentType = "attachment_type"
            case serialNo = "serial_no"
            
        }
}








