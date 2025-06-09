#!/bin/bash
cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

# Store the output of tsc in a variable
# shellcheck disable=SC2086
tsc_output=$(tsc $INPUT_TSC_FLAGS 2>&1)
tsc_rc=$?

# Check if tsc failed due to out-of-memory
if [ $tsc_rc -eq 134 ]; then
  echo "::error::TypeScript compilation failed with out of memory error: $tsc_rc"
  echo "$tsc_output"
  exit 1
fi

# Extract the error count
# Because the "summary" output with the total error count is a wrapper and not pipeable
error_count=$(echo "$tsc_output" | wc -l)

# If no errors were found, the count is 0
if [ -z "$error_count" ]; then
  error_count=0
fi

# Output raw results
echo ::group::"🧾 tsc raw output"
echo "$tsc_output"
echo ::endgroup::

# Human readable output
echo "🔎 Found $error_count tsc errors"
if [ "$error_count" -gt "$INPUT_HIGH_WATER_MARK" ]; then
  echo "::error::High water mark is $INPUT_HIGH_WATER_MARK, but there are $error_count errors. Did you introduce regressions in files that were not changed in this PR? For help, see $INPUT_HELP_DOC_URL"
  exit 1
fi
echo "✅ Error count is at or below high water mark of $INPUT_HIGH_WATER_MARK, continuing with reviewdog ..."

# Run check
echo "::group::📝 Running tsc with reviewdog 🐶"
echo "$tsc_output" |
    reviewdog -f=tsc \
      -name="${INPUT_TOOL_NAME}" \
      -reporter="${INPUT_REPORTER}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      "${INPUT_REVIEWDOG_FLAGS}"

reviewdog_rc=$?
echo "::endgroup::"
exit $reviewdog_rc