#!/usr/bin/env bash

PR_NUMBER="${1:-$(gh pr view --json number --jq .number)}"
OWNER="$(gh repo view --json owner --jq .owner.login)"
REPO="$(gh repo view --json name --jq .name)"

gh api graphql -f query="
  query(\$owner:String!, \$repo:String!, \$pr:Int!) {
    repository(owner:\$owner, name:\$repo) {
      pullRequest(number:\$pr) {
        reviewThreads(first:100) {
          nodes {
            isResolved
            comments(first:10) {
              nodes {
                author { login }
                body
                createdAt
                path
                startLine
                line
              }
            }
          }
        }
        reviews(first:100) {
          nodes {
            author { login }
            body
            state
            createdAt
          }
        }
      }
    }
  }" \
  -F owner="$OWNER" \
  -F repo="$REPO" \
  -F pr="$PR_NUMBER" \
  --jq '{
    reviewThreads: (.data.repository.pullRequest.reviewThreads.nodes | map(select(.isResolved | not))),
    reviews: (.data.repository.pullRequest.reviews.nodes | map(select(.body != null and .body != "")))
  }'
