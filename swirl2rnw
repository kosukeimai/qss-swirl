#!/bin/bash
# Script for extracting swirl questions and writing to .rnw file

# Function for reading .yaml and writing to .rnw
read_yaml ()
{
	# Constants
	FILE_IN=$1
	DIR_IN=$(dirname "$FILE_IN")
	CHAPTER=$(basename "$DIR_IN" | tr -d '[:digit:]')
	LESSON="Lesson "${DIR_IN: -1}""
	FILE_OUT="${DIR_IN}/../$(echo "$CHAPTER" | tr '[:upper:]' '[:lower:]')-swirl.rnw"

        # Check if output file already exists and delete if so
	if [ -e $FILE_OUT -a ${LESSON: -1} == 1 ]; then
	   rm -f $FILE_OUT
	fi
	
	# Write beginning part of formatting
	if [ ${LESSON: -1} == 1 ]; then
	    cat >$FILE_OUT <<- EOF
\section{Swirl Review Questions}
  \subsection{$LESSON}
  \begin{enumerate}             
EOF
	else
	    cat >>$FILE_OUT <<- EOF
  \subsection{$LESSON}
  \begin{enumerate}
EOF
	fi
	
	# Write questions and answers to .rnw file
	awk '$0 ~ "cmd_question" {getline; print; getline; print "cmd"; print; print "end_c"}; $0 ~ "mult_question" {getline; print; getline; print; getline; print "mlt"; print; print "end_m"}; $0 ~ "exact_question" {getline; print; getline; print "exct"; print; print "end_e"}' $FILE_IN | awk '$0 ~ "AnswerChoices" {gsub(";","'\\n'      \\item")}; {print}' | sed -e "s/CorrectAnswer: /  /" -e "s/AnswerChoices:/  \\\begin{enumerate}\\"$'\n'"\      \\\item/" -e $"s/Output:/  \\\item/" | sed -e $"s/cmd/    \\\if1\\\solutions\\"$'\n'"\    \\\newline\\\newline \\\noindent{\\\bf Solution:}\\"$'\n'"\    <<eval=FALSE>>=/" -e "s/end_c/    @\\"$'\n'"\    \\\fi/" -e $"s/exct/    \\\if1\\\solutions\\"$'\n'"\    \\\newline\\\newline \\\noindent{\\\bf Solution:}\\"$'\n'"\    <<eval=FALSE>>=/" -e "s/end_e/    @\\"$'\n'"\    \\\fi/" -e "s/mlt/    \\\end{enumerate}\\"$'\n'"\    \\\if1\\\solutions\\"$'\n'"\    \\\noindent{\\\bf Solution:}\\"$'\n'"\    <<eval=FALSE>>=/" -e "s/end_m/    @\\"$'\n'"\    \\\fi/" | awk '$0 ~ "\\item" {gsub("#","\\#"); gsub("%","\\%"); gsub("_","\\_"); gsub("\\{","\\{"); gsub("\\}","\\}") gsub("\\$","\\rexpr{\\$}"); gsub("\\&","\\&"); gsub("\\^","\\textasciicircum{}"); gsub("[a-zA-Z\\.]*\\(\\)","\\rfun{&}"); gsub("\"([^\"])*\"","\\rexpr{&}"); gsub("R[?\\.\47].","\\tbr&"); gsub(" R "," \\tbr&{}"); gsub("\"","")}; {print}' | awk '$0 ~ "\\item" {sub("\47",""); gsub("\47$","")}; {print}' | sed -e "s/''/\'/g;s/\&/\\\&/g;s/tbr//g;s/R {}/R{} /g" | sed -e "s/'\\\n'/'\\\textbackslash{}n'/g" >>$FILE_OUT

	# Write ending part of formatting
	cat >>$FILE_OUT <<- EOF 
  \end{enumerate}
EOF
}

# Find all files name lesson.yaml, parse, and create .rnw files
export -f read_yaml
find . -name "lesson.yaml" -exec bash -c 'read_yaml "$0"' {} \;

