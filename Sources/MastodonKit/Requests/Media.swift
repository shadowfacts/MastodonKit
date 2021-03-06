//
//  Media.swift
//  MastodonKit
//
//  Created by Ornithologist Coder on 5/9/17.
//  Copyright © 2017 MastodonKit. All rights reserved.
//

import Foundation

public struct Media {
    /// Uploads a media attachment.
    ///
    /// - Parameter mediaAttachment: The media attachment to upload.
    /// - Parameter description: A plain-text description of the media, for accessibility (420 chars, max)
    /// - Returns: Request for `Attachment`.
    public static func upload(media mediaAttachment: MediaAttachment, description: String? = nil) -> Request<Attachment> {
        let parameters = [
            Parameter(name: "description", value: description)
        ]
        let method = HTTPMethod.post(.formData(mediaAttachment, parameters))
        return Request<Attachment>(path: "/api/v1/media", method: method)
    }
}
