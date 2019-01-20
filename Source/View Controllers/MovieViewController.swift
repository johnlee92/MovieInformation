//
//  MovieViewController.swift
//  MovieInformation
//
//  Created by Apple on 2018. 12. 16..
//  Copyright © 2018년 Nowstring. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var currentMovie: Movie!
    var currentImage: UIImage!
    var currentMovieDetail: MovieDetail?
    var currentMovieComments: MovieComments?
    
    struct Const {
        static let infoTableViewCellIndentifier: String = "infoTableViewCell"
        static let storyTableViewCellIndentifier: String = "storyTableViewCell"
        static let makerTableViewCellIndentifier: String = "makerTableViewCell"
        static let commentTableViewHeaderCellIndentifier: String = "commentHeaderTableViewCell"
        static let commentTableViewCellIndentifier: String = "commentTableViewCell"
        
        static let tableViewFooterHeight: CGFloat = 16.0
        
        static let showPosterImageSegue: String = "showPosterImage"
    }
    
    enum Section: Int, CaseIterable {
        case info
        case story
        case maker
        case comment
    }
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationItem.title = self.currentMovie.title
        
    }
    
    private func getServerURL(connectWith subURL: String) -> URL? {
        let baseURL = "https://connect-boxoffice.run.goorm.io/"
        let finalURL = URL(string: baseURL + subURL)
        return finalURL
    }
    
    func loadMovieDetail(){
        
        guard let url = self.getServerURL(connectWith: "movie?id=\(self.currentMovie.id)") else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {
            (data: Data?, response: URLResponse?
            , error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do{
                let movieDetail: MovieDetail = try JSONDecoder().decode(MovieDetail.self , from: data)
                
                self.currentMovieDetail = movieDetail
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch(let err) {
                print(err.localizedDescription)
            }
            
        }
        dataTask.resume()
        
    }
    
    func loadMovieComments(){
        
        guard let url = self.getServerURL(connectWith: "comments?movie_id=\(self.currentMovie.id)") else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) {
            (data: Data?, response: URLResponse?
            , error: Error?) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do{
                let movieComments: MovieComments = try JSONDecoder().decode(MovieComments.self , from: data)
                
                self.currentMovieComments = movieComments
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            } catch(let err) {
                print(err.localizedDescription)
            }
            
        }
        dataTask.resume()
        
    }
    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Const.tableViewFooterHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 1 }
        
        switch section {
        case .info,
             .story,
             .maker:
            return 1
        case .comment:
            if let commentsCount = self.currentMovieComments?.comments.count {
               return 1 + commentsCount
            }
            else {
               return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            
        // Information
        case .info:
            let cell: MovieInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: Const.infoTableViewCellIndentifier, for: indexPath) as! MovieInfoTableViewCell
            
            // Movie Information Cell Configuration
            
            cell.thumbImage = self.currentImage
            cell.currentMovie = self.currentMovie
            
            // Movie Detail Information Configuration
            
            guard let movieDetail: MovieDetail = self.currentMovieDetail else {
                return cell
            }
            cell.movieDetail = movieDetail
            
            
            // Star Visualizing
            
            cell.userRating = movieDetail.userRating
            
            return cell
        
        // Synopsis
        case .story:
            let cell: MovieStoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: Const.storyTableViewCellIndentifier, for: indexPath) as! MovieStoryTableViewCell
            
            guard let movieDetail: MovieDetail = self.currentMovieDetail else {
                return cell
            }
            
            cell.movieDetail = movieDetail
            
            return cell
        
        // Makers
        case .maker:
            let cell: MovieMakerTableViewCell = tableView.dequeueReusableCell(withIdentifier: Const.makerTableViewCellIndentifier, for: indexPath) as! MovieMakerTableViewCell
            guard let movieDetail: MovieDetail = self.currentMovieDetail else {
                return cell
            }
            
            cell.movieDetail = movieDetail
            
            return cell

        // Comments
        case .comment:
            if indexPath.row == 0 {
                
            let cell: MovieCommentHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: Const.commentTableViewHeaderCellIndentifier, for: indexPath) as! MovieCommentHeaderTableViewCell
            return cell
            }
            else {
                
            let cell: MovieCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: Const.commentTableViewCellIndentifier, for: indexPath) as! MovieCommentTableViewCell
            
            guard let movieComment: MovieComment = self.currentMovieComments?.comments[indexPath.row-1] else {
                return cell
            }
                
            cell.movieComment = movieComment
                
            //Star Initializing
            cell.starNumber1.image = UIImage(named: "ic_star_large")
            cell.starNumber2.image = UIImage(named: "ic_star_large")
            cell.starNumber3.image = UIImage(named: "ic_star_large")
            cell.starNumber4.image = UIImage(named: "ic_star_large")
            cell.starNumber5.image = UIImage(named: "ic_star_large")
                
            //Star Visualizing
            cell.userRating = movieComment.rating
                
            return cell
            }
        }
        
    }
    
    //화면 전환
    @IBAction func touchUpPosterImage(_ sender: UIButton) {
        performSegue(withIdentifier: Const.showPosterImageSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let sourceImage = self.currentImage
        
        if segue.identifier == Const.showPosterImageSegue {
            if let destViewController = segue.destination as? PosterViewController {
                destViewController.posterImage = sourceImage
                destViewController.currentMovie = self.currentMovie
            }
        }
    }
  

}
