//
//  ShoppingListViewController.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingListViewController: UIViewController {

	let viewModel = ShoppingListViewModel()

	let searchView = UIView()
	let textField = UITextField()
	let addButton = {
		let button = UIButton()
		button.setTitle("추가", for: .normal)
		return button
	}()

	let shoppingListTableView = {
		let tableView = UITableView()
		tableView.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.identifier)
		tableView.backgroundColor = .systemBlue
		return tableView
	}()


	let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()


		configureLayout()
		bind()
    }

	func configureLayout() {

		view.addSubview(searchView)
		searchView.addSubview(textField)
		searchView.addSubview(addButton)
		view.addSubview(shoppingListTableView)

		searchView.snp.makeConstraints { make in
			make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
			make.height.equalTo(60)
		}

		addButton.snp.makeConstraints { make in
			make.trailing.verticalEdges.equalToSuperview().inset(12)
			make.width.equalTo(44)
		}

		textField.snp.makeConstraints { make in
			make.leading.verticalEdges.equalToSuperview().inset(12)
			make.trailing.equalTo(addButton.snp.leading).offset(-8)
		}

		shoppingListTableView.snp.makeConstraints { make in
			make.top.equalTo(searchView.snp.bottom).offset(8)
			make.horizontalEdges.equalToSuperview().inset(8)
			make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
		}



		searchView.backgroundColor = .darkGray
		textField.backgroundColor = .lightGray
		addButton.backgroundColor = .blue

	}

	func bind() {

		textField.rx.text.orEmpty
			.bind(to: viewModel.searchText)
			.disposed(by: disposeBag)

		addButton.rx
			.tap
			.withLatestFrom(textField.rx.text.orEmpty)
			.distinctUntilChanged()
			.subscribe(with: self) { owner, value in
				owner.viewModel.addShoppingItem(title: value)
			}
			.disposed(by: disposeBag)

		var curretnFilteredData: [ShoppingList] = []

		viewModel.filteredData
			.do(onNext: { data in curretnFilteredData = data
			print(data)})
			.bind(to: shoppingListTableView.rx.items(cellIdentifier: ShoppingListTableViewCell.identifier, cellType: ShoppingListTableViewCell.self)) {
				row, element, cell in
				
				cell.appNameLabel.rx.text
					.onNext(element.title)

				let checkButtonImage = element.isCheck ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
				cell.checkButton.setImage(checkButtonImage, for: .normal)
				cell.checkButton.rx.tap
					.bind(with: self) { owner, _ in
						owner.viewModel.repository.toggleCheck(element.id)
						owner.viewModel.loadRealmData()
					}
					.disposed(by: cell.disposeBag)

				let bookmarkButtonImage = element.isBookmark ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
				cell.bookmarkButton.setImage(bookmarkButtonImage, for: .normal)
				cell.bookmarkButton.rx.tap
					.bind(with: self) { owner, _ in
						owner.viewModel.repository.toggleBookmark(element.id)
						owner.viewModel.loadRealmData()
					}
					.disposed(by: cell.disposeBag)



			}
			.disposed(by: disposeBag)

		shoppingListTableView.rx.itemDeleted.bind(with: self) { owner, indexPath in
			let data = curretnFilteredData[indexPath.row].id
			owner.viewModel.deleteShoppingItem(by: data)
//			owner.viewModel.repository.deleteShoppingItem(owner.viewModel.data.value()[indexPath.row].id)
//			owner.textField.rx.text.onNext(nil)
//			owner.viewModel.loadRealmData()
		}
		.disposed(by: disposeBag)
	}



}
