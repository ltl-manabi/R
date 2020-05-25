# TokyoR replay - 2018-03-03 68th "RからfastTextを使ってみた"

<div style="text-align:right; margin-bottom:2em">
フリーランス　研修・人材育成サービス<br />
<a href="https://mana.bi/">タナカ ケンタ</a>
</div>

[fastText](https://github.com/facebookresearch/fastText)は、2016年にFacebookが公開した、テキスト表現と文書分類のためのライブラリです。 → https://fasttext.cc/

word2vecなどの先行研究を踏まえて、高速で効率的な学習ができることが利点 (よく「10億語を数分で」と表現される) です。

ライブラリ自身が教師あり学習をサポートしており、テキスト中の形態素の出現パターン (頻度) を特徴量として、ラベルとの関係性をモデル化、予測できます。

Pythonのgensimパッケージから利用することが多いようですが、R用のパッケージも開発、公開されています。

2018年3月3日に開催された[第68回Tokyo.R](https://atnd.org/events/94785)では、Rから[fastrtextパッケージ](https://pommedeterresautee.github.io/fastrtext/)を使ってfastTextを呼び出し、テキストの分類モデルを作成した経緯を発表しました。