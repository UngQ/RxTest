//
//  ShoppingListViewModel.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/2/24.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class ShoppingListViewModel {

	let repository = ShoppingListRepository()

	var shoppingList: Results<ShoppingListRealmModel>!
	var observationToken: NotificationToken?

	let disposeBag = DisposeBag()

	struct Input {
		let title: ControlProperty<String?>
		let addButtonTap: ControlEvent<Void>
		let deleteButtonTap: ControlEvent<IndexPath>

	}

	struct Output {
		let shoppingList: BehaviorSubject<[ShoppingList]>
	}

	init() {
		shoppingList = repository.fetchList()


	}

	func transform(input: Input) -> Output {
		var list: [ShoppingList] = []
		let outputList = BehaviorSubject<[ShoppingList]>(value: list)


		observationToken = self.shoppingList.observe { changes in
			switch changes {
			case .initial:
				print("initial")
				list = Array(self.shoppingList).map { $0.toStruct() }
				outputList.onNext(list)
			case .update:
				print("update")
				list = Array(self.shoppingList).map { $0.toStruct() }
				outputList.onNext(list)
			case .error:
				print("error")
			}
		}

		input.title
			.orEmpty
			.subscribe(with: self) { owner, value in
				let result = value.isEmpty ? list : list.filter { $0.title.contains(value) }
				outputList.onNext(result)
			}
			.disposed(by: disposeBag)

		input.addButtonTap
			.withLatestFrom(input.title.orEmpty)
			.distinctUntilChanged()
			.subscribe(with: self) { owner, title in
				owner.repository.createShoppingItem(title)
				input.title.onNext("")
			}
			.disposed(by: disposeBag)

		input.deleteButtonTap
			.map { $0.row }
			.subscribe(with: self) { owner, value in
				print(value)
				owner.repository.deleteShoppingItem(list[value].id)
			}
			.disposed(by: disposeBag)


		return Output(shoppingList: outputList)
	}
}
