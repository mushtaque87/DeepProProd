/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



*/

import Foundation
struct HTTPError : Codable {
	let error_code : String?
	let description : String?
	let correlation_id : String?
	let external_error_code : String?

	enum CodingKeys: String, CodingKey {

		case error_code = "error_code"
		case description = "description"
		case correlation_id = "correlation_id"
		case external_error_code = "external_error_code"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		error_code = try values.decodeIfPresent(String.self, forKey: .error_code)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		correlation_id = try values.decodeIfPresent(String.self, forKey: .correlation_id)
		external_error_code = try values.decodeIfPresent(String.self, forKey: .external_error_code)
	}

}
