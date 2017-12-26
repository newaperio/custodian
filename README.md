# Custodian

Custodian is an opinionated GitHub bot to automate routine development tasks. It was built by [NewAperio](https://newaperio.com) and is designed to follow our conventions.

Currently, Custodian performs the following functions:

* When a new pull request is **opened**, adds `needs-review` label
* When a pull request is **closed**, removes all labels and deletes branch
* When a pull request is **reopened**, removes all labels
* When a pull request review is **approved**, removes `needs-review` and `in-progress` labels and adds `ready-to-merge`; merges changes from base branch to keep head updated
* When a pull request review is **changes requested**, removes `needs-review` and `ready-to-merge` labels and adds `in-progress`

The labels Custodian applies are a part of the NewAperio [spec](https://github.com/newaperio/github-labels).

## Installation

Custodian can be installed from its [GitHub app](https://github.com/apps/custodian) page. Click the "Install" button and select which repositories to run on. Custodian will then run on any new pull requests.

## Development

### Getting Started

Before you begin, make sure you have the following installed and configured:

* BEAM, the Erlang VM
* Elixir
* Hex
* Mix
* PostgreSQL

After you've cloned this repo, install the dependencies with Mix:

    % mix deps.get

Next, initialize the database (make sure PostgreSQL is running):

    % mix ecto.create
    % mix ecto.migrate

To start the app, run the server command:

    % mix phoenix.server

The server runs by default on [`localhost:4000`](http://localhost:4000).

### Documentation

The codebase is documented where appropriate. The docs are available on GitHub in HTML form. To view the docs, click [here](https://newaperio.github.io/custodian/readme.html).

To view the docs in development, run ExDoc:

    % mix docs

This generates an HTML version available in the `doc/` folder. Open to view:

    % open docs/index.html

To publish changes to the docs hosted on GitHub Pages, run the update script from master:

    % git checkout master
    % ./bin/update-docs

### Testing

This project uses Test-Driven Development. For any new feature, tests should be written to verify appropriate behavior. We prefer to avoid testing framework, project, or library behavior and instead focus on testing the business logic of the app.

Tests should be terse and focus on a single component, in order to avoid coupling features. This will ensure tests accurately describe a feature's behavior.

Pull requests should not be accepted without appropriate tests covering any new behavior. Those PRs that fix bugs should include tests verifying the fixed issue.

All tests can be found in the `test` directory. To run the entire test suite, use Mix:

    % mix test

### Code Style

This repo includes [Credo](https://github.com/rrrene/credo), a linting tool for Elixir. You can run it via Mix:

    % mix credo

This repo also includes [Sobelow](https://github.com/nccgroup/sobelow), a static analysis tool for security issues. You can run it via Mix:

    % mix sobelow

This repo also includes full Elixir [typespecs](https://hexdocs.pm/elixir/typespecs.html) which can be verified by [Dialyzer](https://github.com/jeremyjh/dialyxir). You can run it via Mix:

    % mix dialyzer

### Github Labels

Every issue on GitHub should be labeled appropriately with its status, area of focus, and type of implementation. We follow a [standardized list](https://github.com/newaperio/github-labels) of labels.

Every PR on GitHub should be labeled appropriately with its status.

Here are the labels we use in this repo:

| Name             | Color      | Category | Description                                                        |
| ---------------- | ---------- | -------- | ------------------------------------------------------------------ |
| `api`            | black      | focus    | Issues related to the API                                          |
| `blocked`        | orange     | status   | Signals an issue is blocked by extenuating circumstances           |
| `bug`            | red        | type     | Denotes an issue related to an existing bug                        |
| `database`       | black      | focus    | Issues related to data storage                                     |
| `documentation`  | black      | focus    | Issues related to documenting the code or API                      |
| `enhancement`    | light blue | type     | Denotes an issue that is an enhancement of existing functionality  |
| `feature`        | blue       | type     | Denotes a new feature that is planned for the app                  |
| `in-progress`    | purple     | status   | Denotes an issue actively being worked on                          |
| `infra`          | black      | focus    | Issues related to infrastructure, external services, or deployment |
| `needs-review`   | yellow     | status   | Denotes a PR that is finished and is awaiting peer review          |
| `question`       | magenta    | status   | Signals a stalled issue because of outstanding question(s)         |
| `ready-to-merge` | green      | status   | Denotes a PR that has been reviewed and approved                   |
| `testing`        | black      | focus    | Issues related to testing the app                                  |

### Contributing

Always create a feature branch for any new code. Use the following naming scheme: `github-user-name-feature-name` (so who owns the branch and what purpose it serves can quickly be determined). Start with a branch based on master.

    % git checkout master
    % git pull
    % git checkout -b github-user-name-feature-name

Pull in new changes on master frequently to avoid major conflicts.

    % git fetch origin
    % git rebase origin/master

When the feature is complete, make sure the tests pass.

    % mix test

It's also a good idea to run any [code style checks](#code-style).

Make a pull request when the feature is complete. Write a [good commit message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).

    % git add -A
    % git status
    % git commit -v

Push to Github and create a pull request.

    % git push origin github-user-name-feature-name

Open a PR with a descriptive name and full description. Explain the nature of the change, the motivation for the change, and the thinking behind the implementation. Add links to supporting material and/or reference related issues. Tag the PR with the `needs-review` label and await peer review.

After CI passes and you get an approved PR review, merge the changes into master.

First, rebase. Pick only commits that are necessary. Squash others.

    % git fetch origin
    % git rebase -i origin/master

View the changelog, merge and push.

    % git log origin/master..github-user-name-feature-name
    % git diff --stat origin/master
    % git checkout master
    % git merge github-user-name-feature-name --ff-only
    % git push

Clean up remote and local branches.

    % git push origin --delete github-user-name-feature-name
    % git branch -d github-user-name-feature-name

### Deploying

Custodian is hosted on Heroku. Currently only a productio instance is available. Deploying is a simple git push:

    % git push production

### External Services

* Performance metrics and error tracking via [AppSignal](https://appsignal.com)

### Architecture Notes

* Runs on Erlang 20.2
* Runs on Elixir 1.5.3
* Runs on Phoenix 1.3
* Uses PostgreSQL as a relational data store
* Uses ExUnit for testing
* Deployed to Heroku

## License

Custodian is copyright (c) 2017 NewAperio, LLC. It is licensed under the terms in the [LICENSE](/LICENSE.md) file.

## About NewAperio

Custodian is built by [NewAperio, LLC](https://newaperio.com).

NewAperio is a web and mobile design and development studio with offices in Baton Rouge, LA and Denver, CO.
