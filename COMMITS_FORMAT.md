### Commit Guide for Scriptus Maximus

This commit guide aims to establish a clear and consistent structure for commit messages in the Scriptus Maximus project. By following the guidelines below, we can ensure that our commit history is easy to read, understand, and maintain. The structure we'll use is based on the **Conventional Commits** format, which is widely adopted and helps in generating changelogs, semantic versioning, and communicating the nature of changes more effectively.

## Conventional Commits Format

Each commit message should consist of a **type**, an optional **scope**, and a **subject**:

```
<type>(<scope>): <subject>
```

### Types

The following types should be used to categorize commits:

- **core**: A core functionality
- **feat**: A new feature for the user.
- **fix**: A bug fix for the user.
- **docs**: Documentation-only changes.
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing semicolons, etc.).
- **refactor**: A code change that neither fixes a bug nor adds a feature.
- **test**: Adding missing tests or correcting existing tests.
- **chore**: Changes to the build process or auxiliary tools and libraries, such as documentation generation.
- **ci**: Changes to our CI configuration files and scripts.
- **perf**: A code change that improves performance.
- **revert**: Reverts a previous commit.

### Scopes

The **scope** is optional, but it helps identify which part of the project is affected by the commit. Some possible scopes for the Scriptus Maximus project are:

- **general**
- **header**
- **menu**
- **utils**
- **setup**
- **backup**
- **docker**
- **zsh**
- **auth**
- **config**

### Subjects

The **subject** should be a brief summary of the change, written in the imperative mood and not exceeding 50 characters.

### Detailed Commit Message Format

Each commit message should have the following format:

1. **Type**: The type of the commit (e.g., feat, fix, docs).
2. **Scope**: The scope of the change (e.g., header, menu).
3. **Subject**: A short description of the change.
4. **Body** (optional): A more detailed description of the change.
5. **Footer** (optional): Information about breaking changes or issues fixed.

```text
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Example Commit Messages

#### Adding a New Feature

```text
feat(menu): add submenu support

- Added support for nested menus
- Adjusted the menu rendering logic

Closes #42
```

#### Fixing a Bug

```text
fix(header): resolve issue with title alignment

- Fixed the issue where the header title was misaligned
- Improved overall header styling
```

#### Updating Documentation

```text
docs(setup): update setup instructions for Docker

- Updated the README to reflect the latest Docker setup process
```

#### Refactoring Code

```text
refactor(utils): streamline input validation

- Simplified the input validation logic
- Improved error handling
```

#### Adding Tests

```text
test(auth): add tests for authentication endpoints

- Added unit tests for login and logout functionality
- Improved test coverage for error cases
```

#### Other Useful Examples

```text
chore(ci): update CI configuration for GitHub Actions

- Updated the CI configuration to run tests on pull requests
```

```text
perf(menu): improve menu rendering performance

- Optimized the menu rendering logic for better performance
```

```text
style(header): format code

- Applied code formatting to header.js
```

```text
revert(menu): revert "feat(menu): add submenu support"

- Reverted the previous commit that added submenu support
```

## Best Practices

1. **Use the imperative mood**: Write your subject line as if you're instructing someone to make the change, e.g., "Fix bug" instead of "Fixed bug" or "Fixes bug."
2. **Keep it concise**: Limit the subject line to 50 characters or less.
3. **Use the body for more detail**: If necessary, use the body to explain what and why you're changing.
4. **Use closing keywords**: If a commit closes an issue, use keywords like "Closes #<issue_number>" to automatically close the issue.
5. **Test thoroughly**: Always test your changes before committing to avoid breaking the project.