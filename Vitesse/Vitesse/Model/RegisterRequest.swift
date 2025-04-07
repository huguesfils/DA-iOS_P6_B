import Foundation

struct RegisterRequestParams: Encodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
}
