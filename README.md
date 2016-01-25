# EE16A/B Automatic Submitter

This script combines multiple images together into a compressed PDF and then
submits that PDF and any IPython notebook files to be graded. It also handles
self-grade text files by simply uploading them. However, to do all of this,
this script expects a specific structure of your files:

- Main directory name: Same as the assignment being submitted (`hw#`,
    `hw#_grades`, etc.)
- Homework PDF name is the same as the directory name (`hw#`)
- Homework IPython notebook is the same as the PDF name
- Self-grades are named the same as the homework but with `_grades`
    appended to the name. (Same as the assignment being submitted)

If you already have a PDF to submit, this script will just submit that instead
of trying to create a new one out of images it finds. So if you make your PDFs
by using some scanner app or similar, then that works fine too, there's just
one less step to do!

