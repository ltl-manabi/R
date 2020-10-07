tutorial.js <- system.file("lib", "tutorial", "tutorial.js", package = "learnr")
tutorial_format.js <- system.file("rmarkdown", "templates", "tutorial", "resources", "tutorial-format.js", package = "learnr")


changes <- list(
  run_code = list(
    text = "実行",
    file = tutorial.js,
    pattern = 'var run_button = add_submit_button("fa-play", "btn-success",',
    code = 'var run_button = add_submit_button("fa-play", "btn-success", "{text}", false)'
  ),
  submit_answer = list(
    text = "回答",
    file = tutorial.js,
    pattern = 'add_submit_button("fa-check-square-o", "btn-primary",',
    code = 'add_submit_button("fa-check-square-o", "btn-primary", "{text}", true);'
  ),
  start_over = list(
    text = "リセット",
    file = tutorial.js,
    pattern =  'var startOverButton = addHelperButton("fa-refresh",',
    code = 'var startOverButton = addHelperButton("fa-refresh", "{text}");'
  ),
  next_topic = list(
    text = "次のトピック",
    file = tutorial_format.js,
    pattern =  'var nextButton = $(\'<button class="btn btn-primary">',
    code = 'var nextButton = $(\'<button class="btn btn-primary">{text}</button>\');'
  ),
  continue = list(
    text = "続ける",
    file = tutorial_format.js,
    pattern = 'var continueButton = ',
    code = 'var continueButton = $(\'<button class="btn btn-default skip" data-section-id="\' + sectionElement.id + \'">{text}</button>\');'
  ),
  
  hint = list(
    text = "ヒント",
    file = tutorial.js, 
    pattern = 'var button = addHintButton("',
    code = 'var button = addHintButton("{text}");'
  ),
  clipboard = list(
    text = "クリップボードにコピー",
    file = tutorial.js, 
    pattern = 'copyButton.append("',
    code = 'copyButton.append(" {text}");'
  )
)
  

make_changes <- function(change) {
  file <- change$file
  lines <- readLines(file)
  code <- glue::glue_data(change, change$code)
  where <- grepl(change$pattern, lines, fixed = TRUE)

  lines[where] <- code
  writeLines(lines, file)

  return(which(where))
}

lapply(changes, make_changes)


