/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ContentGroup : Codable {
	let id : Int?
	let name : String?
    var has_units : Bool?
	var creation_date : Int?
	var created_by : String?
	var parent_id : Int?
	var description : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
		case has_units = "has_units"
		case creation_date = "creation_date"
		case created_by = "created_by"
		case parent_id = "parent_id"
		case description = "description"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		has_units = try values.decodeIfPresent(Bool.self, forKey: .has_units)
		creation_date = try values.decodeIfPresent(Int.self, forKey: .creation_date)
		created_by = try values.decodeIfPresent(String.self, forKey: .created_by)
		parent_id = try values.decodeIfPresent(Int.self, forKey: .parent_id)
		description = try values.decodeIfPresent(String.self, forKey: .description)
	}

    
    init(id:Int , name:String)
    {
        self.id = id
        self.name = name    
    }

}