//
//  BoxOfficeViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout() )
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
   
    let viewModel = BoxOfficeViewModel()
    
    func bind() {

		let recentMovie = PublishSubject<String>()

		let input = BoxOfficeViewModel.Input(
			searchText: searchBar.rx.text.orEmpty,
			searchButtonTap: searchBar.rx.searchButtonClicked,
			recentMovie: recentMovie)

		let output = viewModel.transform(input: input)


		output.movieList
            .bind(
                to: tableView.rx.items(
                    cellIdentifier: SearchTableViewCell.identifier,
                    cellType: SearchTableViewCell.self)
            ) { (row, element, cell) in
				cell.appNameLabel.text = element.movieNm
            }
            .disposed(by: disposeBag)

		output.recentList
            .bind(
                to: collectionView.rx.items(
                    cellIdentifier: MovieCollectionViewCell.identifier,
                    cellType: MovieCollectionViewCell.self)
            ) { (row, element, cell) in
                cell.label.text = "\(element)\(row)"
            }
            .disposed(by: disposeBag)
         
        Observable.zip(
            tableView.rx.modelSelected(DailyBoxOfficeList.self),
            tableView.rx.itemSelected
        )
		.map { $0.0 }
            .subscribe(with: self) { owner, value in
                print(value, "Selected")
				recentMovie.onNext(value.movieNm)
            }
            .disposed(by: disposeBag)
         
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        configure()
        bind()
    }

    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.backgroundColor = .green
        tableView.rowHeight = 100
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.backgroundColor = .red
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
     
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
   
}
