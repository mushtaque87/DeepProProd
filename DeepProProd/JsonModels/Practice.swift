/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


*/

import Foundation
struct Practice : Codable {
	let id : Int?
	let short_name : String?
	let description : String?
	let creation_date : Double?
	let category_id : Int?
	let task_type : String?
    let due_date : Double?
    let status : String?
    
	enum CodingKeys: String, CodingKey {

		case id = "id"
		case short_name = "short_name"
		case description = "description"
		case creation_date = "creation_date"
		case category_id = "category_id"
		case task_type = "task_type"
        case due_date = "due_date"
        case status = "status"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		short_name = try values.decodeIfPresent(String.self, forKey: .short_name)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		creation_date = try values.decodeIfPresent(Double.self, forKey: .creation_date)
        due_date = try values.decodeIfPresent(Double.self, forKey: .due_date)
		category_id = try values.decodeIfPresent(Int.self, forKey: .category_id)
		task_type = try values.decodeIfPresent(String.self, forKey: .task_type)
        status = try values.decodeIfPresent(String.self, forKey: .status)
	}

}
