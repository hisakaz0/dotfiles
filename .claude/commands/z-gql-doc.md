graphql description を修正する: $ARGUMENTS

次のコマンドを実行し、エラーがなくなるまで修正してください。ultrathink

```sh
make description_admin | grep $ARGUMENTS
```

## ルールと優先順位
1. 定型なオブジェクトは他のファイルを参考にするのではなく、次のパターンを優先してください。
2. 型やオブジェクトの命名は既存の description を参考にしてください。
3. 上記以外は他の.graphql や .graphql に対応する `domain/*.go` を参考にしてください。

- XXXConnection
    * XXXの配列とページング情報を含むオブジェクトです
- XXXConnection.PageInfo
    * ページング情報
- XXXConnection.Nodes
    * オブジェクトの配列
- XXX.ID
    * オブジェクトのID
- XXX.CreatedAt
    * 作成日時
- XXX.UpdatedAt
    * 更新日時
- XXXSortKeys
    * XXXの並び順を表現するオブジェクト
- XXXSortKeys.YYY
    * YYY順


