/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Prediction_result_json : Codable {
	var score : Int?
	var actual : String?
	var predicted : String?
	var alignment : Alignment?
	let wordResults : [WordResults]?
	var topPredictions : [TopPredictions]?

	enum CodingKeys: String, CodingKey {

		case score = "score"
		case actual = "actual"
		case predicted = "predicted"
		case alignment = "alignment"
		case wordResults = "wordResults"
		case topPredictions = "topPredictions"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		score = try values.decodeIfPresent(Int.self, forKey: .score)
		actual = try values.decodeIfPresent(String.self, forKey: .actual)
		predicted = try values.decodeIfPresent(String.self, forKey: .predicted)
		alignment = try values.decodeIfPresent(Alignment.self, forKey: .alignment)
		wordResults = try values.decodeIfPresent([WordResults].self, forKey: .wordResults)
		topPredictions = try values.decodeIfPresent([TopPredictions].self, forKey: .topPredictions)
	}

    init(wordResults:[WordResults])
    {
        self.wordResults = wordResults
    }
}
