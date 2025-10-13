
GitHub の Pull Request のコメントを取得してそれらを対応してください。
以下のコマンドから未解決なPull Requestのコメントを取得してください。

```bash
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
      }
    }
  }" \
  -F owner="$(gh repo view --json owner --jq .owner.login)" \
  -F repo="$(gh repo view --json name --jq .name)" \
  -F pr="$(gh pr view --json number --jq .number)" \
  --jq ".data.repository.pullRequest.reviewThreads.nodes \| map\(select\(.isResolved | not\)\)"
```
議論中の場合は一度確認を挟んでください。
