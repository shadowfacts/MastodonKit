//
//  Payload.swift
//  MastodonKit
//
//  Created by Ornithologist Coder on 4/28/17.
//  Copyright © 2017 MastodonKit. All rights reserved.
//

import Foundation

enum Payload {
    case parameters([Parameter]?)
    case formData(MediaAttachment?, [Parameter]?)
    case empty
}

extension Payload {
    private static let boundary = "MastodonKitBoundary"
    
    var items: [URLQueryItem]? {
        switch self {
        case .parameters(let parameters): return parameters?.compactMap(toQueryItem)
        case .formData: return nil
        case .empty: return nil
        }
    }

    var data: Data? {
        switch self {
        case .parameters(let parameters): return parameters?.compactMap(toString).joined(separator: "&").data(using: .utf8)
        case .formData(let mediaAttachment, let parameters):
            var data = Data()
            if let parameters = parameters {
                for param in parameters {
                    guard let value = param.value else { continue }
                    data.append("--\(Payload.boundary)\r\n")
                    data.append("Content-Disposition: form-data; name=\"\(param.name)\"\r\n\r\n")
                    data.append("\(value)\r\n")
                }
            }
            
            if let mediaAttachment = mediaAttachment,
                let attachmentData = mediaAttachment.data {
                data.append("--\(Payload.boundary)\r\n")
                data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(mediaAttachment.fileName)\"\r\n")
                data.append("Content-Type: \(mediaAttachment.mimeType)\r\n\r\n")
                data.append(attachmentData)
                data.append("\r\n")
            }
            
            data.append("--\(Payload.boundary)--\r\n")
            return data
        case .empty: return nil
        }
    }

    var type: String? {
        switch self {
        case .parameters(let parameters): return parameters.flatMap { _ in "application/x-www-form-urlencoded; charset=utf-8" }
        case .formData(let mediaAttachment, let parameters):
            if mediaAttachment != nil || parameters != nil {
                return "multipart/form-data; boundary=\(Payload.boundary)"
            } else {
                return nil
            }
        case .empty: return nil
        }
    }
}
