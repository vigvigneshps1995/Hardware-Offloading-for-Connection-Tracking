# Contributing to the project

## Quicklinks

* [Project Website](https://canvas.kth.se/groups/165813/wiki)
* [Getting Started](#getting-started)
    * [Issues](#issues)
    * [Pull Requests](#pull-requests)

## Getting Started

Contributions are made to this repo via Issues and Pull Requests (PRs). A few general guidelines that cover both:
- Search for existing Issues and PRs before creating your own.

Never commit directly to the master branch. Any commits should be performed via Issues and Pull Requests.  
Any PR will require a minimum of 4 accepted reviews before being merged (and hopefully pass on integration tests).

### Issues
Issues should be used to report problems with the library, request a new feature, or to discuss potential changes before a PR is created. When you create a new Issue, a template will be loaded that will guide you through collecting and providing the information needed to investigate.

If you find an Issue that addresses the problem you're having, please add your own reproduction information to the existing issue rather than creating a new one.

### Pull Requests

In general, PRs should:
- Only fix/add the functionality in question **OR** address wide-spread whitespace/style issues, not both.
- Add unit or integration tests for fixed or changed functionality (if a test suite already exists).
- Address a single concern in the least number of changed lines as possible.
- Include documentation in the repo.
- Be accompanied by a complete Pull Request template (loaded automatically when a PR is created).

For changes that address core functionality or would require breaking changes (e.g. a major release), it's best to open an Issue to discuss your proposal first. This is not required but can save time creating and reviewing changes.

In general, try to follow this format when making changes,

1. Clone the project to your machine
2. Create a branch locally with a succinct but descriptive name,  
   such as `[feature/bug/hotfix]/name-of-branch` e.g. `feature/amazing-feature`  
3. Commit changes to the branch
4. Following any formatting and testing guidelines specific to this repo
5. Push changes to your branch
6. Open a PR in the repository and follow the PR template.
