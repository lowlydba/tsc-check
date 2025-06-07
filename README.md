# tsc Check GitHub Action <!-- omit in toc -->

- [Introduction](#introduction)
- [How-to Guides](#how-to-guides)
  - [Basic Usage](#basic-usage)
  - [Detecting New TypeScript Errors](#detecting-new-typescript-errors)
- [Reference](#reference)
  - [Inputs](#inputs)
- [Explanation](#explanation)
  - [How It Works](#how-it-works)
  - [When to Use](#when-to-use)


## Introduction

**tsc Check** is a GitHub Action that runs a TypeScript compilation check (`tsc`) and integrates with [ReviewDog](https://github.com/reviewdog/reviewdog) to provide feedback on pull requests by reporting TypeScript errors.
It is designed to help teams incrementally improve type safety in projects with a high water mark for existing errors. The action fails if new errors are introduced in modified files, or if the total number of errors exceeds a configurable threshold.

The high water mark can be set manually or updated from an external process as your project improves, enabling teams to gradually reduce technical debt while maintaining momentum.

---

## How-to Guides

### Basic Usage

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
        uses: lowlydba/tsc-check@v1.0.0
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

### Detecting New TypeScript Errors

For a step-by-step guide on detecting new TypeScript errors between branches, see [Detecting New TypeScript Transpile Errors](find-tsc-regressions.md).

## Reference

### Inputs

| Name                | Description                                                                 | Default                  | Required |
|---------------------|-----------------------------------------------------------------------------|--------------------------|----------|
| `reviewdog-version` | Version of ReviewDog to use.                                               | `latest`                 | No       |
| `typescript-version`| Version of the TypeScript npm package to use.                              | `latest`                 | No       |
| `workdir`           | Working directory relative to the root directory.                          | `.`                      | No       |
| `high-water-mark`   | Maximum number of errors allowed before failing the action.                | `0`                      | No       |
| `help-doc-url`      | URL to help documentation for this action.                                 | See action.yml           | No       |
| `level`             | Report level for ReviewDog (`info`, `warning`, `error`).                   | `error`                  | No       |
| `reporter`          | Reporter for ReviewDog (`github-check`, `github-pr-check`, `github-pr-review`). | `github-pr-check`        | No       |
| `filter-mode`       | Filtering mode for ReviewDog (`added`, `diff_context`, `file`, `nofilter`).| `added`                  | No       |
| `fail-on-error`     | Whether to fail the action if errors are found (`true`, `false`).          | `false`                  | No       |
| `reviewdog-flags`   | Additional flags for ReviewDog.                                            | `""`                    | No       |
| `tool-name`         | Tool name to use for ReviewDog reporter.                                   | `tsc`                    | No       |
| `tsc-flags`         | Flags and arguments to pass to `tsc`.                                      | `--noEmit --skipLibCheck`| No       |

## Explanation

### How It Works

- **TypeScript Compilation**: The action runs `tsc` in the specified working directory with configurable flags.
- **Error Threshold**: If the number of errors exceeds the `high-water-mark`, the action fails and provides a link to help documentation.
- **ReviewDog Integration**: All `tsc` output is piped to ReviewDog, which annotates pull requests with errors and warnings according to your configuration.
- **Incremental Adoption**: By setting a high water mark, teams can prevent new errors from being introduced while gradually reducing existing errors.

### When to Use

Use this action if you want to:

- Prevent new TypeScript errors from entering your codebase.
- Incrementally improve type safety in large or legacy projects.
- Provide clear, actionable feedback to contributors via GitHub PR annotations.
