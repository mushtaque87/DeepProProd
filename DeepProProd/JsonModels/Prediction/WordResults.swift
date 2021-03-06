/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



*/

import Foundation
struct WordResults : Codable {
	let score : Float?
	let word : String?
	var matched : [Matched]?
	let wordPhonemes : [String]?
	let predictedPhonemes : [String]?

	enum CodingKeys: String, CodingKey {

		case score = "score"
		case word = "word"
		case matched = "matched"
		case wordPhonemes = "wordPhonemes"
		case predictedPhonemes = "predictedPhonemes"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		score = try values.decodeIfPresent(Float.self, forKey: .score)
		word = try values.decodeIfPresent(String.self, forKey: .word)
		matched = try values.decodeIfPresent([Matched].self, forKey: .matched)
		wordPhonemes = try values.decodeIfPresent([String].self, forKey: .wordPhonemes)
		predictedPhonemes = try values.decodeIfPresent([String].self, forKey: .predictedPhonemes)
	}
    
    init(score:Float ,word:String , wordPhonemes:[String] , predictedPhonemes:[String])
    {
        self.score = score
        self.word = word
        self.wordPhonemes = wordPhonemes
        self.predictedPhonemes = predictedPhonemes
        
    }

}
