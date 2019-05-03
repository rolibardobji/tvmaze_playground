//
//  SearchViewModel.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 5/1/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import RxSwift

class SearchViewModel: NSObject {
    var showsViewModels: PublishSubject<[ShowCellViewModel]> = PublishSubject()
    var loading: PublishSubject<Bool> = PublishSubject()
    var error: PublishSubject<String> = PublishSubject()
    private var shows: BehaviorSubject<[Show]> = BehaviorSubject(value: [])
    
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
    
    func search(show: String) {
        showsTVMazeOperations.search(show: show) { (response) in
            switch response {
            case let .success(shows):
                self.shows.onNext(shows)
            case let .error(error):
                self.error.onNext(error)
            }
        }
    }
    
    func show(at index: Int) -> Show? {
        do {
            return try shows.value()[index]
        } catch {
            return nil
        }
    }
}
