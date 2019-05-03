//
//  SeriesController.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/27/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShowsController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let showDetailSegue = "ShowDetail"
    
    var viewModel = ShowsViewModel(showsTVMazeOperations: ShowsTVMazeOperations(api: TVMazeCommunications(environment: Environment())))
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        self.setupBindings()
        viewModel.fetchShows(at: 0)
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
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            viewModel.loadNextPage()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDetailSegue {
            let showDetailController = segue.destination as! ShowDetailController
            showDetailController.viewModel = ShowDetailViewModel(show: sender as! Show, showEpisodesTVMazeOperations: ShowEpisodesTVMazeOperations(api: TVMazeCommunications(environment: Environment())))
        }
    }
}
