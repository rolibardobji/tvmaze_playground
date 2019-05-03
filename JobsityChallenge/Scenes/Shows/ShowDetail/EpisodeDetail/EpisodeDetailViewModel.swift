//
//  EpisodeDetailViewModel.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 5/1/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import RxSwift

class EpisodeDetailViewModel: NSObject {
    var name: PublishSubject<String> = PublishSubject()
    var coverURL: PublishSubject<URL?> = PublishSubject()
    var summary: PublishSubject<String> = PublishSubject()
    var episodeAndSeason: PublishSubject<String> = PublishSubject()
    let coverPlaceholder = "plchldr_show"
    
    private var showEpisode: ShowEpisode
    
    init(showEpisode: ShowEpisode) {
        self.showEpisode = showEpisode
        super.init()
    }
    
    func start() {
        name.onNext(showEpisode.name)
        coverURL.onNext(URL(string: showEpisode.cover))
        summary.onNext(showEpisode.summary.removeHTMLTags() ?? "")
        episodeAndSeason.onNext("Episode \(showEpisode.number) of season \(showEpisode.season)")
    }
}
