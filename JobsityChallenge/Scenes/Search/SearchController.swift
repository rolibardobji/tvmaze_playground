//
//  SearchController.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 5/1/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import RxSwift

class SearchController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let showDetailSegue = "ShowDetail"
    
    var viewModel = SearchViewModel(showsTVMazeOperations: ShowsTVMazeOperations(api: TVMazeCommunications(environment: Environment())))
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    func setupBindings() {
        viewModel.showsViewModels
            .bind(to: tableView.rx
                .items(cellIdentifier: ShowCell.identifier, cellType: ShowCell.self)) { row, model, cell in
                    cell.configure(with: model) }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map {
                self.viewModel.show(at: $0.row) }
            .subscribe(onNext: {
                self.performSegue(withIdentifier: self.showDetailSegue, sender: $0) })
            .disposed(by: disposeBag)
        
        searchBar.rx.text
        .throttle(4, scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .bind { self.viewModel.search(show: $0 ?? "") }
        .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegue {
            let showDetailController = segue.destination as! ShowDetailController
            showDetailController.viewModel = ShowDetailViewModel(show: sender as! Show, showEpisodesTVMazeOperations: ShowEpisodesTVMazeOperations(api: TVMazeCommunications(environment: Environment())))
        }
    }

}
