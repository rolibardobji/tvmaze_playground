//
//  ShowsViewModel.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import RxSwift

class ShowsViewModel: NSObject {
    var showsViewModels: PublishSubject<[ShowCellViewModel]> = PublishSubject()
    var loading: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<String> = PublishSubject()
    private var shows: BehaviorSubject<[Show]> = BehaviorSubject(value: [])
    private var page = 0
    private var showsTVMazeOperations: ShowsTVMazeOperations
    private var disposeBag: DisposeBag = DisposeBag()
    
    init(showsTVMazeOperations: ShowsTVMazeOperations) {
        self.showsTVMazeOperations = showsTVMazeOperations
        super.init()
        shows
            .map() {
                $0.map { ShowCellViewModel(cover: URL(string: $0.cover), coverPlaceholder: "plchldr_show", name: $0.name) } }
            .bind(onNext: {
                self.showsViewModels.onNext($0) })
            .disposed(by: disposeBag)
    }
    
    func fetchShows(at page: Int) {
        showsTVMazeOperations.tvShows(at: page) { (response) in
            switch response {
            case let .success(shows):
                do {
                    let currentShows = try self.shows.value()
                    let newShows = currentShows + shows
                    
                    self.shows.onNext(newShows)
                } catch {
                }
                
            case let .error(error):
                self.error.onNext(error)
            }
        }
    }
    
    func loadNextPage() {
        page += 1
        fetchShows(at: page)
    }
    
    func show(at index: Int) -> Show? {
        do {
            return try shows.value()[index]
        } catch {
            return nil
        }
    }
}

struct ShowCellViewModel {
    var cover: URL?
    var coverPlaceholder: String
    var name: String
}
