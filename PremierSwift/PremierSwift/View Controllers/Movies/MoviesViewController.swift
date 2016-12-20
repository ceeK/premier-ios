import UIKit

final class MoviesViewController: UITableViewController {
    
    private enum Row {
        case loading
        case error(String)
        case movie(Movie)
    }
    
    private var rows: [Row] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let cellImageLoader = CellImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Top Movies"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(MovieTableViewCell.self)
        tableView.register(LoadingTableViewCell.self)
        tableView.register(ErrorTableViewCell.self)

        loadContent()
    }
    
    private func loadContent() {
        rows = [.loading]
        
        let topMoviesOperation = ResourceOperation(resource: Movie.topMovies, completion: handleNetworkResponse)
        OperationQueue.main.addOperation(topMoviesOperation)
    }
    
    private func handleNetworkResponse(response: NetworkResponse<[Movie]>) {
        switch response {
        case .success(let movies):
            self.rows = movies.map { .movie($0) }
        case .failure(_):
            self.rows = [.error("Oops! Something went wrong.")]
        }
    }
    
    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rows[indexPath.row]
        
        switch row {
        case .loading:
            return tableView.dequeue(forIndexPath: indexPath) as LoadingTableViewCell
            
        case .error(let errorText):
            let cell: ErrorTableViewCell = tableView.dequeue(forIndexPath: indexPath)
            cell.configure(errorDescription: errorText, retryHandler: { [weak self] in
                self?.loadContent()
            })
            return cell
            
        case .movie(let movie) :
            let cell: MovieTableViewCell = tableView.dequeue(forIndexPath: indexPath)
            cell.configure(title: movie.title, synopsis: movie.synopsis)
            
            guard let posterURL = movie.posterURL else { return cell }
            
            cellImageLoader.loadImage(imageURL: posterURL, cell: cell) { image in
                cell.posterImage = image
            }
            
            return cell
        }

    }
    
}
