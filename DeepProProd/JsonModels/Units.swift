/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



*/

import Foundation
struct Units : Codable {
	let unit_id : Int?
	let creation_date : Int?
	let description : String?
	let question_text : String?
    let unit_status : String?
    

	enum CodingKeys: String, CodingKey {

		case unit_id = "unit_id"
		case creation_date = "creation_date"
		case description = "description"
		case question_text = "question_text"
        case unit_status = "unit_status"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		unit_id = try values.decodeIfPresent(Int.self, forKey: .unit_id)
		creation_date = try values.decodeIfPresent(Int.self, forKey: .creation_date)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		question_text = try values.decodeIfPresent(String.self, forKey: .question_text)
        unit_status = try values.decodeIfPresent(String.self, forKey: .unit_status)
	}

}
