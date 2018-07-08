library(yaml)
library(glue)

## Alter these templates to change the output.
##
## Template notes:
##   If the value of the template variable foo is bar then
##   {foo} will be render as bar
##   {{foo}} will render as {foo}
##   {{{foo}}} will render as {bar}

cmd_question <- "
\\item {latex_escape(Output)}
\\if1\\solutions
\\newline\\newline \\noindent\\textbf{{Solution:}}
<<eval=FALSE>>=
{CorrectAnswer}
@
\\fi
"
mult_question <- "
\\item {latex_escape(Output)}
{enumerate_and_escape(AnswerChoices)}
\\if1\\solutions
\\newline\\newline \\noindent\\textbf{{Solution:}}
\\begin{{verbatim}}
{CorrectAnswer}
\\end{{verbatim}}
\\fi
"
rnw_template <- "
\\section{{Swirl Review Questions}}
\\subsection{{{Lesson}}}
\\begin{{enumerate}}
{Questions}
\\end{{enumerate}}
"

latex_escape <- function(s){
  # Adjusted from Simon Penel's stresc function in the seqinr package
  s2c <- function(x){ unlist(strsplit(x, "")) }
  fromchar <- c("\\", "{", "}", "$", "^", "_", "%", "#", "&", "~", "[", "]", "|")
  tochar <- c("$\\backslash$", "\\{", "\\}", "\\$", "\\^{}", "\\_", "\\%",
              "\\#", "\\&", "\\~{}", "\\lbrack{}", "\\rbrack{}","\\textbar{}")
  translate <- function(x)
    ifelse(x %in% fromchar, tochar[which(x == fromchar)], x)
  val <- paste0(sapply(s2c(s), translate), collapse = "")
  val <- gsub('"(.+?)"', "\\\\rexpr{\\1}", val, perl = TRUE)
  val <- gsub('" R "', "\\\\R{}", val, fixed = TRUE)
  val
}

enumerate_and_escape <- function(options){
  opts <- lapply(trimws(unlist(strsplit(options, ";"))), latex_escape)
  paste0("\\begin{enumerate}\n", paste("\\item", opts, collapse = "\n"),
         "\n\\end{enumerate}")
}

process_question <- function(x){
  switch(x$Class,
         cmd_question = glue(cmd_question,
                             Output = x$Output,
                             CorrectAnswer = x$CorrectAnswer),
         mult_question = glue(mult_question, Output = x$Output,
                              CorrectAnswer = x$CorrectAnswer,
                              AnswerChoices = x$AnswerChoices),
         stop("Unrecognized question type", x$Class))
}

# bundle questions from multiple yaml files together and write a rnw fragment
process_yaml_files <- function(yaml_files, rnw_filename, subsection){

  yamls <- lapply(yaml_files, read_yaml)
  bundle <- function(yaml){
    qs <- Map(process_question,
              Filter(function(x) grepl("question", x$Class), yaml))
    paste(qs, collapse = "\n")
  }
  questions <- paste(sapply(yamls, bundle), collapse = "\n")
  # meta <- Filter(function(x) x$Class == "meta", yamls[[1]])[[1]]
  rnw <- glue(rnw_template, Lesson = subsection, Questions = questions)
  writeLines(rnw, con = rnw_filename)
}

yamls <- dir(recursive = TRUE, full.names = TRUE, pattern = ".yaml")
chapters <- c("PROBABILITY", "INTRO", "CAUSALITY", "PREDICTION", "DISCOVERY",
              "UNCERTAINTY", "MEASUREMENT")
for (ch in chapters)
  process_yaml_files(yamls[grepl(ch, yamls)],
                     rnw_filename = paste0(tolower(ch), "-swirl.rnw"),
                     tools::toTitleCase(tolower(ch)))

