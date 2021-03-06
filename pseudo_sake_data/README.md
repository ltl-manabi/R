# 全国市販酒類調査の結果をもとにした疑似日本酒データセット
by タナカケンタ (https://mana.bi)

国税庁の[「全国市販酒類調査の結果について（平成28年度調査分）」](https://www.nta.go.jp/taxes/sake/shiori-gaikyo/seibun/2017/01.htm) ページで公開されているデータをもとに、架空の日本酒データを生成するRスクリプトを作成しました。また、それによって生成したデータも公開します。

なお、日本酒の種別 (一般酒、吟醸酒、純米酒、本醸造酒) の構成比率については、[純米吟醸酒の出荷量、初めて本醸造酒を上回る/17年の日本酒動向｜食品産業新聞社](https://www.ssnp.co.jp/news/liquor/2018/02/2018-0207-1109-14.html) を参考にしました。

このスクリプトでは、都道府県ごとの日本酒作りの特徴は加味していませんので、「全国の日本酒作りの方法・方針が均一であったときに、こんなデータが得られる」というものです。

スクリプトおよびデータは、ひとつ上の "R" レポジトリまるごとMITライセンスに設定していますので、それに準じます。
