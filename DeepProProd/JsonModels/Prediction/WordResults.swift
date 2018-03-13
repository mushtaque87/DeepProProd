/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct WordResults : Codable {
	let word : String?
	let actual : String?
	let notMatched : [NotMatched]?
	let predicted : String?
	let score : Float?
	let matched : [Matched]?

	enum CodingKeys: String, CodingKey {

		case word = "word"
		case actual = "actual"
		case notMatched = "notMatched"
		case predicted = "predicted"
		case score = "score"
		case matched = "matched"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		word = try values.decodeIfPresent(String.self, forKey: .word)
		actual = try values.decodeIfPresent(String.self, forKey: .actual)
		notMatched = try values.decodeIfPresent([NotMatched].self, forKey: .notMatched)
		predicted = try values.decodeIfPresent(String.self, forKey: .predicted)
		score = try values.decodeIfPresent(Float.self, forKey: .score)
		matched = try values.decodeIfPresent([Matched].self, forKey: .matched)
	}

}
