# data reads existing infrastructure; resource manages its lifecycle
data "github_repository" "arro" {
  name = "arro"
}

resource "github_repository_ruleset" "arro_grr" {
  name        = "arro_grr"
  repository  = data.github_repository.arro.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      # As a result, the ruleset applies only to main.
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    required_status_checks {
      required_check {
        context = "build"
      }
    }

    pull_request {
      # Changes must not be pushed directly to `main`; instead, they must be submitted via a pull request.
      required_approving_review_count = 0
    }
  }
}
