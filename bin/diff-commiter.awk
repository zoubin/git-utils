/^diff --git / {
  prefilename = $3
  postfilename = $4
}
/^-/ {
  if ($0 != ("--- " prefilename)) {
    name = author()
    deletions[name] += 1
    additions[name] += 0
  }
}
/^\+/ {
  if ($0 != ("+++ " postfilename)) {
    name = author()
    deletions[name] += 0
    additions[name] += 1
  }
}
END {
  for (name in additions) {
    print "+"additions[name] "\t-"deletions[name] "\t" name
  }
}

function author() {
  name = $2
  for ( i = 3; i <= NF; i++ ) {
    # git blame -f
    # Show the filename in the original commit. By default the filename is shown if there is any line that came from a file with a different name, due to rename detection.
    if (match($i, /^\(/) > 0) {
      name = $i
    } else {
      if (match($i, /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/) > 0) {
        break
      }
      name = name " " $i
    }
  }
  return substr(name, 2)
}
