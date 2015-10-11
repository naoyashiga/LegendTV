# 伝説のTV
![](https://raw.githubusercontent.com/naoyashiga/LegendTV/master/demo.gif)

お笑い番組「ガキの使い」の企画が見られるアプリです。

# 使い方
## Youtube apiの設定
Config.swiftというファイルを作りましょう。
```swift
import Foundation

struct Config {
    static let API_KEY = "YOUR_API_KEY"
    static let REQUEST_BASE_URL = "https://www.googleapis.com/youtube/v3/"
    static let REQUEST_SEARCH_URL = REQUEST_BASE_URL + "search?key=\(API_KEY)&type=video&"
    static let REQUEST_CONTENT_DETAILS_URL = REQUEST_BASE_URL + "videos?key=\(API_KEY)&part=contentDetails&"
    static let REQUEST_STATISTICS_URL = REQUEST_BASE_URL + "videos?key=\(API_KEY)&part=statistics&"
}
```

## 企画の設定
kikaku.jsonで設定しています。以下のように、シリーズ名、企画名をjsonに追加することができます。

```
{
  "seriesName": "松本vs浜田・対決シリーズ / 罰ゲーム",
  "desc": "松本人志と浜田雅功が日本シリーズや紅白歌合戦の勝敗予想、スポーツ、ゲームなどで対決（1998年のゴルフ対決からは山崎・ココリコも参加している）、敗者は厳しい罰ゲームを受ける。",
  "kikakuList": [
     {
     "name": "ガララニョロロでズームイン!!（1990年正月）松本人志",//企画名
     "query": "ガキの使い ガララニョロロ"//検索クエリ
     },
     {
     "name": "SM亀甲縛りアルタ画面で番組宣伝（1990年春）松本人志",
     "query": ""//検索しても出てこない時は空欄
     }
}
```
