# tsc Check GitHub Action

This GitHub Action runs a TypeScript compilation check (`tsc`) and integrates with [ReviewDog](https://github.com/reviewdog/reviewdog) to provide feedback on pull requests by reporting TypeScript errors. It is designed to help teams incrementally improve type safety in projects with a high water mark for existing errors. The action fails if new errors are introduced in modified files, or if the total number of errors exceeds this threshold.

The high water mark can be set manually, or updated from an external process as your project improves. This enables teams to gradually reduce technical debt while still maintaining forward momentum.

## Features

- Runs `tsc` to check for TypeScript compilation errors.
- Reports issues using ReviewDog with customizable levels and reporters.
- Allows configuration of `tsc` flags, working directory, and error thresholds.

## Inputs

| Name                | Description                                                                 | Default                  | Required |
|---------------------|-----------------------------------------------------------------------------|--------------------------|----------|
| `reviewdog-version` | Version of ReviewDog to use.                                               | `latest`                 | No       |
| `workdir`           | Working directory relative to the root directory.                         | `.`                      | No       |
| `high-water-mark`   | Maximum number of errors allowed before failing the action.               | `0`                      | No       |
| `level`             | Report level for ReviewDog (`info`, `warning`, `error`).                  | `error`                  | No       |
| `reporter`          | Reporter for ReviewDog (`github-check`, `github-pr-check`, `github-pr-review`). | `github-pr-check`        | No       |
| `filter-mode`       | Filtering mode for ReviewDog (`added`, `diff_context`, `file`, `nofilter`). | `added`                  | No       |
| `fail-on-error`     | Whether to fail the action if errors are found (`true`, `false`).          | `false`                  | No       |
| `reviewdog-flags`   | Additional flags for ReviewDog.                                            | `""`                     | No       |
| `tool-name`         | Tool name to use for ReviewDog reporter.                                   | `tsc`                    | No       |
| `tsc-flags`         | Flags and arguments to pass to `tsc`.                                      | `--noEmit --skipLibCheck`| No       |

## Usage

Below is an example of how to use this action in your workflow:

```yaml
name: TypeScript Check

on:
  pull_request:
    paths:
      - '**/*.ts'
      - '**/*.tsx'

jobs:
  tsc-check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Run tsc Check
        uses: ./ # Path to your action
        with:
          reviewdog-version: "latest"
          workdir: "."
          high-water-mark: "10"
          level: "error"
          reporter: "github-pr-check"
          filter-mode: "added"
          fail-on-error: "true"
          tsc-flags: "--noEmit --skipLibCheck"
```

## License

This project is licensed under the [MIT License](LICENSE).
