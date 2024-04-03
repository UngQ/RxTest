//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa


class BirthdayViewModel {

	let inputBirthday: PublishSubject<Date> = PublishSubject()

	let todayComponent = Calendar.current.dateComponents([.year, .month, .day], from: Date())

	lazy var year = BehaviorRelay<Int>(value: todayComponent.year!)
	lazy var month = BehaviorRelay<Int>(value: todayComponent.month!)
	lazy var day = BehaviorRelay<Int>(value: todayComponent.day!)

	let bag = DisposeBag()


	init() {

		inputBirthday.subscribe(with: self) { owner, date in
			let component = Calendar.current.dateComponents([.year, .month, .day], from: date)

			guard let year = component.year, let month = component.month, let day = component.day else { return }

			owner.year.accept(year)
			owner.month.accept(month)
			owner.day.accept(day)
		}
		.disposed(by: bag)



	}

}
