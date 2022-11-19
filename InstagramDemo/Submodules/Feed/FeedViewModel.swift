//
//  FeedViewModel.swift
//  InstagramDemo
//
//  Created by Viacheslav Tolstopianteko on 15.11.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol FeedViewModelDataSource: BaseViewModelDataSource {
	 var numberOfSections: Int { get }
	func numberOfRowsInSection(_ section: Int) -> Int
	func infoForRowAt(_ index: Int) -> UnsplashPhotoItem
	func loadData()
	func tryLoadMoreData()
	 var isLoadingMore: Observable<Bool> { get }
}


final class FeedViewModel: FeedViewModelDataSource {
	
	var numberOfSections: Int { 2 }
	var updateInfo: Observable<Bool>
	var errorResult: Observable<Error>
	var isLoading: Observable<Bool>
	var isLoadingMore: Observable<Bool>
	
	private let disposeBag = DisposeBag()
	private var updateInfoSubject = PublishSubject<Bool>()
	private var errorResultSubject = PublishSubject<Error>()
	private var loadingSubject = BehaviorSubject<Bool>(value: true)
	private var loadingMoreSubject = BehaviorSubject<Bool>(value: false)
	
	private var unsplashPhotosList = [UnsplashPhotoItem]()
	private var pageNumber: Int = 1
	private var _isLoadingMore: Bool {
		guard let value = try? loadingMoreSubject.value() else { return false }
		return value
	}
	
	var unsplashPhotosNetworkHandler: UnsplashPhotoNetworkHandling!
	
	init() {
		self.updateInfo = updateInfoSubject.asObservable()
		self.errorResult = errorResultSubject.asObservable()
		self.isLoading = loadingSubject.asObservable()
		self.isLoadingMore = loadingMoreSubject.asObservable()
	}
	
	func numberOfRowsInSection(_ section: Int) -> Int {
		if section == 0 { return self.unsplashPhotosList.count } else if section == 1, self._isLoadingMore { return 1 }
		return 0
	}
	
	func infoForRowAt(_ index: Int) -> UnsplashPhotoItem { unsplashPhotosList[index] }
	
	func viewDidLoad() {
		loadData()
	}
	
	func loadData() {
		fetchData()
	}
	
	func tryLoadMoreData() {
		if !_isLoadingMore, numberOfRowsInSection(0) > 0 {
			fetchMoreData()
		}
	}
	
	private func fetchData() {
		loadingSubject.onNext(true)
		unsplashPhotosNetworkHandler.loadUnsplashPhotos(page: 1)
			.subscribe { [weak self] unsplashPhotos in
				self?.unsplashPhotosList = unsplashPhotos.compactMap({UnsplashPhotoItem.tryMapToItem(json: $0)})
				self?.updateInfoSubject.onNext(true)
				self?.loadingSubject.onNext(false)
			} onFailure: { [weak self] error in
				self?.errorResultSubject.onNext(error)
				self?.loadingSubject.onNext(false)
			}.disposed(by: disposeBag)
	}
	
	private func fetchMoreData() {
		loadingMoreSubject.onNext(true)
		unsplashPhotosNetworkHandler.loadUnsplashPhotos(page: pageNumber + 1)
			.delay(.milliseconds(700), scheduler: MainScheduler.instance) // more loading delay
			.subscribe { [weak self] unsplashPhotos in
				self?.unsplashPhotosList += unsplashPhotos.compactMap({UnsplashPhotoItem.tryMapToItem(json: $0)})
				self?.pageNumber += 1
				self?.updateInfoSubject.onNext(true)
				self?.loadingMoreSubject.onNext(false)
			} onFailure: { [weak self] error in
				self?.errorResultSubject.onNext(error)
				self?.loadingMoreSubject.onNext(false)
			}.disposed(by: disposeBag)
	}
}








