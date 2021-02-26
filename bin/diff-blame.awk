/^diff --git / {
  prefilename = $3
  postfilename = $4
}
/^new file/ {
  prefilename = "/dev/null"
}
/^deleted file/ {
  postfilename = "/dev/null"
}
/^@@ / {
  preIdx = 0
  postIdx = 0
  split("", preBlameLines)
  split("", postBlameLines)
  if (prefilename != "/dev/null") {
    blame($2, oldrev, "." substr(prefilename, 2), preBlameLines)
  }
  if (postfilename != "/dev/null") {
    blame($3, newrev, "." substr(postfilename, 2), postBlameLines)
  }
  line = colorize($0, 36, color)
}
/^-/ {
  if ($0 != ("--- " prefilename)) {
    preIdx++
    line = colorize("-"preBlameLines[preIdx], 31, color)
  }
}
/^\+/ {
  if ($0 != ("+++ " postfilename)) {
    postIdx++
    line = colorize("+"postBlameLines[postIdx], 32, color)
  }
}
/^ / {
  preIdx++
  postIdx++
  line = " " postBlameLines[postIdx]
}
{
  if (line == "") {
    line = $0
  }
  print line
  line = ""
}

function debug(msg) {
  # https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
  print colorize(msg, 35)
}

function colorize(msg, code, needColor) {
  if (needColor != "0") {
    return "\033[0;" code "m" msg "\033[0m"
  }
  return msg
}

function blame(range, rev, filename, lines) {
  # https://stackoverflow.com/questions/2529441/how-to-read-the-output-from-git-diff
  range = substr(range, 2)
  mid = index(range, ",")
  if (mid == 0) {
    first = substr(range, 1)
    nol = 0
  } else {
    first = substr(range, 1, mid - 1)
    nol = substr(range, mid + 1)
  }
  last = first + nol - 1
  if (last >= first) {
    # https://stackoverflow.com/questions/1960895/assigning-system-commands-output-to-variable
    cmd = "git blame -L " first "," last " " rev " -- " filename
    # debug(cmd)
    i = 1
    while ( ( cmd | getline result ) > 0 ) {
      lines[i] = result
      i++
    }
    close(cmd)
  }
}
