//
//  FeedViewController.swift
//  InstagramDemo
//
//  Created by Viacheslav Tolstopianteko on 15.11.2022.
//

import Foundation
import UIKit
import RxSwift

private struct Strings {
	@Localizable static var APP_NAME		= "APP_NAME"
}

class FeedViewController: UIViewController, BaseViewProtocol {
	
	let disposeBag = DisposeBag()
	var viewModel: FeedViewModelDataSource!
	
	lazy var tableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setupUI()
		self.setupViewModel()
	}

	private func setupUI() {
		self.view.backgroundColor = .white
		
		let title = UILabel()
		title.font = Fonts.Siry(size: 28)
		title.text = Strings.$APP_NAME
		self.navigationItem.titleView = title
		
		view.addSubview(tableView)
		
		tableView.snp.makeConstraints {
			$0.leading.equalToSuperview()
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			$0.trailing.equalToSuperview()
			$0.bottom.equalToSuperview()
		}
		
		configureTableView()
	}
	
	private func setupViewModel() {
		viewModel.updateInfo
			.asDriver(onErrorJustReturn: false)
			.drive(onNext: { [weak self] _ in
				self?.tableView.reloadData()
			}).disposed(by: disposeBag)
		
		viewModel.isLoadingMore
			.asDriver(onErrorJustReturn: false)
			.drive(onNext: { [weak self] _ in
				self?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
			}).disposed(by: disposeBag)
		
		viewModel.isLoading.bind(to: isAnimating).disposed(by: disposeBag)
		
		viewModel.errorResult
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] error in
				self?.showErrorAlert(message: error.localizedDescription)
			}).disposed(by: disposeBag)
		
		viewModel.viewDidLoad()
	}
	
	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UnsplashPhotoTableCell.self, forCellReuseIdentifier: UnsplashPhotoTableCell.id)
		tableView.register(LoadingTableCell.self, forCellReuseIdentifier: LoadingTableCell.id)
		tableView.showsVerticalScrollIndicator = false
		
		tableView.separatorStyle = .none
	}
}


extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		viewModel.numberOfSections
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.numberOfRowsInSection(section)
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Loading Cell
		if indexPath.section == 1 {
			guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableCell.id)
				  as? LoadingTableCell else { return UITableViewCell() }
			
			cell.activityIndicator.startAnimating()
			
			return cell
		}
		// Data Cell
		guard let cell = tableView.dequeueReusableCell(withIdentifier: UnsplashPhotoTableCell.id)
			  as? UnsplashPhotoTableCell else { return UITableViewCell() }
		
		let item = viewModel.infoForRowAt(indexPath.row)

		cell.setup(autorName: item.autor.name, autorUrl: item.autor.avatarUrl,
				   photoDescription: item.description, photoUrl: item.imageUrl,
				   likes: item.likes)
		
		return cell
	}
	
	// Did Scroll to the bottom of ScrollView
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		if offsetY > contentHeight - scrollView.frame.height {
			viewModel.tryLoadMoreData()
		}
	}
}
