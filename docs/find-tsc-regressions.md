# 🔍 Detecting New TypeScript Transpile Errors

> [!NOTE]
> This guide for use in tandem with the [tsc-check][tsc-check] GitHub Action. Its advice is **not** generalizable to all TypeScript projects, but is specifically tailored for those using the action to incrementally decrease TypeScript errors.

When you edit one file in your branch, you may inadvertently introduce errors elsewhere. This guide shows you how to:

1. Run `tsc` on the **default/main** branch
2. Run `tsc` on your **feature** branch
3. Diff the two error outputs to spot new issues

## 📋 Prerequisites

- Node.js & npm/Yarn installed
- A `tsconfig.json` at the repo root that reflects your “build” configuration
- Git CLI

### 🛠️ Step 1: Get base errors on `main`

```bash
# Make sure you're on main (or default branch)
git checkout main

# Ensure it's up-to-date
git pull origin main

# Run tsc and save errors
tsc --noEmit 2>&1 | sort > /tmp/ts-errors-main.txt
```

### 🔨 Step 2: Get errors on your feature branch

```bash
# Switch back to your working branch
git checkout <your-branch>

# Make sure it’s up-to-date with main, if desired
git rebase main

# Run tsc and save errors
tsc --noEmit 2>&1 | sort > /tmp/ts-errors-feature.txt
```

### ⚖️ Step 3: Diff the results

```bash
diff --unified /tmp/ts-errors-main.txt /tmp/ts-errors-feature.txt \
  | grep '^[+-]' \
  | sed \
      -e 's/^+[^+]/➕ &/' \
      -e 's/^-[^-]/➖ &/'
```

### 🎯 Interpreting the Diff

- **➕ New Errors** — errors present in your branch but *not* in `main`.
- **➖ Removed Errors** — errors present in `main` but *not* in your branch.

Only pay attention to the `➕` lines—those are regressions you need to fix.

## ✅ Summary

By comparing sorted `tsc` outputs from `main` vs. your branch, you can:

- **Automatically catch** regressions
- **Prevent** new compile errors sneaking into CI
- **Maintain** a green build

Keep this pattern in your toolbox to ensure code quality and developer confidence! 🚀

**Feel free to adjust** file paths, branch names (`main` vs. `master`), or script locations to match your repo’s conventions.

[tsc-check]: https://github.com/lowlydba/tsc-check