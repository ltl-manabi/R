# ----
library(RMeCab)
library(fastrtext)
library(data.table)
library(tidyverse)

# ----
parse_text <- function(file) {
    # 形態素解析を行う
    t<-RMeCabText(file, etc = "--unk-feature=未知語 -b 81920")
    # 結果のlistから不要な品詞を除くための、要素番号の取得
    t.condition <- sapply(t, function(x) {(x[2] == "名詞" & !x[3] %in% c("数", "接尾", "代名詞", "非自立", "副詞可能")) | (x[2] == "動詞" & x[3] == "自立") | (x[2] == "形容詞" & x[3] == "自立")})
    # 必要な品詞のみ抽出する
    t.sub <- t[t.condition]
    # 頻出する数詞を除去する
    t.sub <- subset(t.sub, !grepl("[0-9][円年月日時分秒回人名個冊巻頭台着枚]", t.sub))
    # リストをベクトル化する
    t.sub <- do.call("rbind", lapply(t.sub, "[[", 1))
    # ベクトルをスカラに結合する
    t.sub <- paste(t.sub, collapse = " ")
    return(t.sub)
}

# ----
# ファイル一覧の読み込み
filelist <- dir("./ldcc-20140209/", pattern = ".*txt", recursive = TRUE)

# ファイルの読み込み
text.all <- NULL
for (i in 1:length(filelist)){
    text.tmp <- parse_text(paste0("./ldcc-20140209/", filelist[i]))
    text.all[i] <- text.tmp
}

# ----
# カテゴリ情報の作成
category <- str_replace_all(filelist, "/.*$", "")

# カテゴリとテキストを結合
eval_text <- cbind.data.frame(category, text.all, stringsAsFactors = FALSE)
eval_text$category <- as.factor(eval_text$category)
eval_text$label <- paste0("__label__", as.numeric(eval_text$category))
eval_text <- select(eval_text, label, text.all)

write.table(eval_text, "./ldcc_eval.txt", row.names = FALSE, col.names = FALSE, quote = FALSE, fileEncoding = "UTF-8")

#eval_text <- readLines("./ldcc_eval.txt") # モデルのチューニングだけ行いたい場合はここから

# ----
# データの書き出し
## 学習用データ (全体の80%)
train_idx <- sample_frac(data.frame(1:nrow(eval_text)), size = 0.8)
train_data <- eval_text %>%
    filter(row_number() %in% train_idx[, 1]) %>%
    select(label, text.all)
write.table(train_data, "ldcc_train_data.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)

## テスト用データ (全体の20%)
test_data <- eval_text %>%
    filter(!row_number() %in% train_idx[, 1]) %>%
    select(label, text.all)
write.table(test_data, "ldcc_test_data.txt", col.names = FALSE, row.names = FALSE, quote = FALSE)
test_data.vec <- readLines("ldcc_test_data.txt")

# ----
# 学習
t <- Sys.time()
execute(commands = c("supervised", "-input", "ldcc_train_data.txt", "-output", "ldcc_train_model", "-dim", 200, "-lr", 0.1, "-epoch", 50, "-wordNgrams", 2, "-verbose", 2))
difftime(Sys.time(), t, tz = "Asia/Tokyo", units = "secs")
Sys.sleep(10) # モデルの書き込み終了まで待つ

# ----
# 予測
model.ft <- load_model("./ldcc_train_model.bin")
pred.ft <- predict(model.ft, sentences = test_data.vec, simplify = TRUE)

# ----
# 評価
# 返り値のラベルに "__label__" が付かないので、除去
result.prob <- mean(names(pred.ft) == str_replace_all(str_replace_all(test_data$label, " .*$", ""), "__label__", ""))
print(result.prob)
