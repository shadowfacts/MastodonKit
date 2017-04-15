import XCTest
@testable import MastodonKit

class AttachmentTests: XCTestCase {
    static var allTests = [
        ("testAttachmentFromJSON", testAttachmentFromJSON),
        ("testeAttachmentType", testeAttachmentType)
    ]

    var attachmentFixture: Any!

    override func setUp() {
        super.setUp()
        attachmentFixture = try? Fixture.load(fileName: "Fixtures/Attachment.json")
    }

    func testAttachmentFromJSON() {
        let dictionary = attachmentFixture as! JSONDictionary
        let attachment = Attachment(json: dictionary)

        XCTAssertEqual(attachment?.id, 42)
        XCTAssertEqual(attachment?.type, AttachmentType.image)
        XCTAssertEqual(attachment?.url, "http://lorempixel.com/200/200/cats/3/")
        XCTAssertEqual(attachment?.previewURL, "http://lorempixel.com/200/200/cats/4/")
        XCTAssertEqual(attachment?.textURL, "https://mastodon.technology/@ornithocoder")
    }

    func testeAttachmentType() {
        XCTAssertEqual(AttachmentType(string: "image"), AttachmentType.image)
        XCTAssertEqual(AttachmentType(string: "video"), AttachmentType.video)
        XCTAssertEqual(AttachmentType(string: "gifv"), AttachmentType.gifv)
        XCTAssertEqual(AttachmentType(string: "foobar"), AttachmentType.unknown)
    }
}