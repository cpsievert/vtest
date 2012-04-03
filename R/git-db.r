# Functions that interact with both the git repo and the test result database


#' Returns a data frame of recent commits and their associated resultset_hash.
#'
#' For commits without a resultset, the resultset_hash is \code{NA}.
#'
#' @param start  The commit to start searching backward from
#' @param n  Maximum number of commits to search
#' @export
recent_vtest <- function(start = "", n = 20) {
  prev <- git_prev_commits(dir = get_vtest_pkg()$path, n = n, start = start)
  prev_commits <- data.frame(idx = seq_along(prev), commit = prev)

  c_results <- load_commits_table()
  prev_commits <- merge(prev_commits, c_results, all.x = TRUE)
  prev_commits <- prev_commits[order(prev_commits$idx), ]
  prev_commits$idx <- NULL
  rownames(prev_commits) <- NULL
  prev_commits$commit <- substr(prev_commits$commit, 1, 6)  # Short git hash

  prev_commits
}
