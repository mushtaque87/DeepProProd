/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct User_attributes : Codable {
	var address : String?
	var school_code : String?
	var gender : String?
	var phone : String?
	var dob : String?
	var class_code : String?

	enum CodingKeys: String, CodingKey {

		case address = "address"
		case school_code = "school_code"
		case gender = "gender"
		case phone = "phone"
		case dob = "dob"
		case class_code = "class_code"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		school_code = try values.decodeIfPresent(String.self, forKey: .school_code)
		gender = try values.decodeIfPresent(String.self, forKey: .gender)
		phone = try values.decodeIfPresent(String.self, forKey: .phone)
		dob = try values.decodeIfPresent(String.self, forKey: .dob)
		class_code = try values.decodeIfPresent(String.self, forKey: .class_code)
	}

    init(address: String?, class_code: String? ,gender: String?, phone: String? ,dob : String? ) {
        self.address = address
        self.class_code = class_code
        self.gender = gender
        self.phone = phone
        self.dob = dob
    }
    
}
