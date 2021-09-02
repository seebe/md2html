# Markdown to HTML Converter

This script uses the standard 'markdown' application, but then makes additional changes to make the HTML look better.


# Installation
* Install the markdown application
<pre>
$ sudo apt install markdown
</pre>

* Clone this repository
<pre>
$ git clone https://github.com/seebe/md2html
</pre>

* Add an alias to your login script to make it easier to run.
<pre>
$ cd md2html
$ echo "alias md2html='$PWD/md2html.sh'" >> ~/.bashrc
</pre>
* Note that after you add this alias, you will need to open a new terminal window for this to start working (because that is when .bashrc is read). This also means for any terminal window that currently open, this alias will not work yet. However, you can simply enter "source ~/.bashrc" in any open terminal window to re-read in your update bashrc file with your new alias.


# Usage
* Enter the filename of the .md file you would like to convert.
* The output file .html will be created.
* If no filename is passed, "README.md" will be assumed (since that file is common in github repositories)
<pre> 
$ md2html README.md
</pre>

# Notes

* ★ Alwasy check your html file in the broswer to make sure it looks OK.
* Note that the way github displays .md files online is different than how the markdown app converts them. Below are some tips:
    * Always use < pre> for code blocks (not a leading space)
