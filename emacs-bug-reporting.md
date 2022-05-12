# Some guidelines for reporting bugs in GNU Emacs

The following guidelines for reporting bugs in GNU Emacs (`M-x report-emacs-bug`) are based on observations of the bug-gnu-emacs mailing list over an extended period.

Ideally, you should carefully read [the "Reporting bugs" chapter of the GNU Emacs manual](https://www.gnu.org/software/emacs/manual/html_node/emacs/Bugs.html#Bugs)[1]; a lot of thought and work has gone into it, to assist people in creating high-quality bug reports that are more likely to be helpful to Emacs devs. However, the following summarises some of the key points:

* To begin, narrow down where the problem is, or might be. Does the problem appear when you run Emacs with the `-Q` option? If not, then the cause of the problem is likely to be either in your configuration, or in a package you've installed:

  * Firstly, check whether the problem is in your configuration. If you temporarily move your `.emacs`/`init.el`/whatever out of the path Emacs searches for configuration files, start Emacs, and the problem seems to disappear, then your configuration is likely to be the cause:

    * Try running Emacs with the `--debug-init` option. That might quickly help pinpoint the specific line causing issues.

    * If that doesn't help, you'll need to bisect your configuration file. Remove or comment out half of it, and check if the problem is still present; if it is, the problem is probably in the remaining half, and if you don't, the problem is probably in the removed or commented-out half. Then repeat the process with the relevant halves.

    * The bisection process might narrow down the issue as being something to do with a package you've installed. Unless it's a package you've installed from GNU ELPA, you need to report the issue to the maintainer(s) of that package, not via `report-emacs-bug`. Note, too, that issues with Org should be first reported to the Org maintainers, even though Org is part of Emacs. If you've installed the package from GNU ELPA, then that package is considered part of Emacs, and the issue can be reported via `report-emacs-bug`.

* If you can reproduce the problem when running Emacs with the `-Q` option:

  * If possible, try to check if the problem still occurs in a more recent version of Emacs, if one exists:

    * The most recent source release is available [here](https://www.gnu.org/software/emacs/). A binary package might have been released for your specific operating system; check in the location from which you last downloaded Emacs.

    * For those running a development version of Emacs, make sure you're at the latest commit on `master`, then run `make bootstrap`, which removes all existing compiled files and forces a new bootstrap from a clean slate.

Still experiencing the issue even in the most recent release, or at the most recent commit? Check whether the issue has already been reported, either by visiting [the GNU Emacs bug tracker on the Web](https://debbugs.gnu.org/cgi/pkgreport.cgi?package=emacs;max-bugs=100;base-order=1;bug-rev=1), or by installing [the `debbugs` package from GNU ELPA](http://elpa.gnu.org/packages/debbugs.html) and searching for existing issues via its Emacs interface. If the issue has already been reported, consider adding to that report any details not already described.

Assuming there's no existing report of the issue on the bug tracker, you can now `report-emacs-bug`:

* Regardless of where you send the report, it should include the following information:

  * Which version of Emacs you're running, on what operating system. If you're running a version of Emacs built directly from source control, refer to the commit you've built from. Otherwise, report the version number (e.g. "25.1"), and where you installed Emacs from: did you compile it from source, did you get it from your Linux distribution's package manager, did you get it using Homebrew on macOS[2], did you get a prebuilt binary for Windows? Finally, report the version of your OS - sometimes something that works fine in Emacs running on one OS version, doesn't work properly on a different version of that same OS.

  * An overview of you did, what you *expected* to happen, and what *actually* happened.

  * A *minimal example* to reproduce the problem. The more effort you require someone to go to in order to reproduce your bug, the more difficult it makes things for them, the more difficult it is to narrow down the issue, and the less likely the problem will be solved. So this:

      "You need to install Bazinga Linux 2005. Then run this script to fetch data from this Web site. Then install my 5000-line `init.el`. Then load up this 10M file into Emacs. Then do `M-x a-useful-command`. See the problem?"

    is .... not helpful. Especially compared to e.g. this:

      "Run Emacs -Q. Evaluate `(setq a-variable "value")`. Type 'wtf', press space, then do `M-x a-useful-command`. I expected 'wtf' to get capitalised in this context, but instead it always gets replaced with 'doh'."

* Note that your report should be *entirely self-contained* - all the essential information should be within your report, and links to Web sites should only be provided to e.g. provide some background information, demonstrate that other people are facing the same or similar problems, etc.

--

[1] Which can also be accessed from within Emacs itself either by selecting the "How to Report a Bug" entry from the "Help" menu, or by doing <kbd>C-h r m bugs <RET></kbd>.

[2] Or, indeed, are you using the version that comes pre-installed with macOS, which was current around the time the first iPhone was released?
