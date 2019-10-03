# ----
library(RMeCab)
library(fastText)
library(data.table)
library(tidyverse)

# ----
parse_text <- function(file) {
    # 形態素解析を行う
    t <- RMeCabText(file, etc = "--unk-feature=未知語 -b 81920")
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
#    Sys.sleep(1)
    return(t.sub)
}

# ----
# ファイル一覧の読み込み
filelist <- dir("./ldcc-20140209/", pattern = ".*txt", recursive = TRUE)

# ファイルの読み込み
text.all <- NULL
for (i in 1:length(filelist)){
#for (i in 1:3){ # for debug
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

#eval_text <- readLines("./eval_text.txt") # モデルのチューニングだけ行いたい場合はここから

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

# ----
# 学習
params <- list(command = "supervised", lr = 0.1, dim = 200,
              input = file.path(".", "ldcc_train_data.txt"),
              output = file.path(".", "ldcc_train_model2"), 
              epoch = 50, wordNgrams = 2, verbose = 2, thread = 6)

res <- fasttext_interface(params, path_output = file.path(".", "sup_logs.txt"),
              MilliSecs = 5, remove_previous_file = TRUE,
              print_process_time = TRUE)

# ----
# 予測
params <- list(command = "predict",
              model = file.path(".", "ldcc_train_model2.bin"),
              test_data = file.path(".", "ldcc_test_data.txt"), 
              k = 1,
              th = 0.0)

res <- fasttext_interface(params, 
                         path_output = file.path(".", "predict_result.txt"))
pred.ft <- readLines("predict_result.txt")

# ----
# 評価
# fastTextパッケージでは返り値のラベルに "__label__" が付くので、そのままtest_data$labelを使う
result.prob <- mean(pred.ft == test_data$label)
print(result.prob)
