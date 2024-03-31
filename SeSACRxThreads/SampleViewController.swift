//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by ungQ on 4/1/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {


	let textField = UITextField()
	let addButton = UIButton()
	let tableView = UITableView()


	var items = BehaviorSubject<[String]>(value: ["Jack", "Hue", "Den", "Bran"])

	let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

		view.backgroundColor = .white

		configureLayout()
		bind()
    }

	func configureLayout() {
		view.addSubview(textField)
		view.addSubview(addButton)
		view.addSubview(tableView)

		textField.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.leading.equalTo(view.safeAreaLayoutGuide)
			make.trailing.equalTo(addButton.snp.leading)
			make.height.equalTo(40)
		}

		textField.backgroundColor = .gray

		addButton.snp.makeConstraints { make in
			make.top.trailing.equalTo(view.safeAreaLayoutGuide)
			make.width.height.equalTo(40)
		}

		addButton.backgroundColor = .green


		tableView.snp.makeConstraints { make in
			make.top.equalTo(textField.snp.bottom)
			make.horizontalEdges.bottom.equalToSuperview()
		}

		tableView.backgroundColor = .brown
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

	}

	func bind() {
		items
			.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) {
				row, element, cell in
				cell.textLabel?.text = element
			}
			.disposed(by: bag)

		addButton.rx
			.tap
			.subscribe(with: self) { owner, _ in
				do {
					var list = try self.items.value()
					list.append(owner.textField.text!)
					owner.items.onNext(list)
					owner.textField.text = ""
				}
				catch {

				}
			}
			.disposed(by: bag)

		tableView.rx
			.itemSelected
			.subscribe(with: self) { owner, indexPath in
				do {
					var list = try self.items.value()
					list.remove(at: indexPath.row)
					owner.items.onNext(list)
				}
				catch {

				}
			}
			.disposed(by: bag)

		


	}



}
