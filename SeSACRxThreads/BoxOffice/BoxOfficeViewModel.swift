//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {

	var recent: [String] = []

	let bag = DisposeBag()

    struct Input {
		let searchText: ControlProperty<String>
		let searchButtonTap: ControlEvent<Void>

		let recentMovie: PublishSubject<String>
    }
    
    struct Output {
		let recentList: BehaviorRelay<[String]>
		let movieList: PublishSubject<[DailyBoxOfficeList]>
		let wrongMessage: PublishRelay<Void>
		
    }
    
    
    func transform(input: Input) -> Output {

		let recentList = BehaviorRelay(value: recent)
		let movieList = PublishSubject<[DailyBoxOfficeList]>()
		let wrongMessage = PublishRelay<Void>()

		input.searchButtonTap
			.throttle(.seconds(1), scheduler: MainScheduler.instance)
			.withLatestFrom(input.searchText)
			.map { guard let result = Int($0) else { return 20240401 }
			return result }
			.map { String($0) }
			.flatMap { BoxOfficeNetwork.fetchBoxOfficeDataWithSingle(date: $0)
					.catch { error in
						wrongMessage.accept(())
						return Single<Movie>.never()
					}
			}
			.subscribe(with: self) { owner, value in
				let data = value.boxOfficeResult.dailyBoxOfficeList
				movieList.onNext(data)
			}
			.disposed(by: bag)

		input.recentMovie
			.subscribe(with: self) { owner, value in
				owner.recent.append(value)
				recentList.accept(owner.recent)
			}
			.disposed(by: bag)

		return Output(recentList: recentList,
					  movieList: movieList,
		wrongMessage: wrongMessage)
    }
    
    
}




