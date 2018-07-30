/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import UIKit
struct Profile : Codable {
	var email : String?
	var first_name : String?
	var last_name : String?
    var profile_image : UIImage?
	var user_attributes : User_attributes?

    var gender : String?
    var standard : String?
    var section : String?
    var contact : String?
    
	enum CodingKeys: String, CodingKey {

		case email = "email"
		case first_name = "first_name"
		case last_name = "last_name"
		case user_attributes = "user_attributes"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
		last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
		user_attributes = try values.decodeIfPresent(User_attributes.self, forKey: .user_attributes)
	}
    
   

    init(first_name: String?, last_name: String? ,email: String?, user_attributes: User_attributes?) {
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.user_attributes = user_attributes
    }

}
