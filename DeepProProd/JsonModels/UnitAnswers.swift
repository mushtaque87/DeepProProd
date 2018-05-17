/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 

*/

import Foundation
struct UnitAnswers : Codable {
	var id : Int?
	var submission_date : Double?
	var audio_url : String? 
	let prediction_result_json : Prediction_result_json?
	let score : Double?
	var unit_id : Int?
	var student_id : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case submission_date = "submission_date"
		case audio_url = "audio_url"
		case prediction_result_json = "prediction_result_json"
		case score = "score"
		case unit_id = "unit_id"
		case student_id = "student_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		submission_date = try values.decodeIfPresent(Double.self, forKey: .submission_date)
		audio_url = try values.decodeIfPresent(String.self, forKey: .audio_url)
		prediction_result_json = try values.decodeIfPresent(Prediction_result_json.self, forKey: .prediction_result_json)
        //try Prediction_result_json(from: decoder)
		score = try values.decodeIfPresent(Double.self, forKey: .score)
		unit_id = try values.decodeIfPresent(Int.self, forKey: .unit_id)
		student_id = try values.decodeIfPresent(String.self, forKey: .student_id)
	}
    
    init(score: Double, predictJson: Prediction_result_json , audio_url: String, submission_date:Double) {
        self.score = score
        self.prediction_result_json = predictJson
        self.audio_url = audio_url
        self.submission_date = submission_date
    }

}
