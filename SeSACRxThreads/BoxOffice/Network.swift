//
//  Network.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

class BoxOfficeNetwork {

	static let baseURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt="

	static func fetchBoxOfficeData(date: String) -> Observable<Movie> {

		return Observable.create { observer in
			guard let url = URL(string: "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt=\(date)") else {

				observer.onError(APIError.invalidURL)
				return Disposables.create()
			}

			URLSession.shared.dataTask(with: url) { data, response, error in

				print("DataTask Succeed")

				if let _ = error {
					print("Error")
					observer.onError(APIError.unknownResponse)
					return
				}

				guard let response = response as? HTTPURLResponse,
					  (200...299).contains(response.statusCode) else {
					print("Response Error")
					observer.onError(APIError.statusError)
					return
				}

				if let data = data,
				   let appData = try? JSONDecoder().decode(Movie.self, from: data) {
					print(appData)
					observer.onNext(appData)
				} else {
					observer.onError(APIError.unknownResponse)
				}
			}.resume()

			return Disposables.create()
		}
	}

	static func fetchBoxOfficeDataWithSingle(date: String) -> Single<Movie> {

		return Single.create { single -> Disposable in


			AF.request(URL(string: (baseURL + date))!)
				.validate(statusCode: 200..<300)
				.responseDecodable(of: Movie.self) { response in
					switch response.result {
					case .success(let success):
						single(.success(success))

					case.failure(let failure):
						single(.failure(failure))
					}
				}
			return Disposables.create()
		}.debug()
	}
}
