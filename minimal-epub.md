# Creating a minimal EPUB

The EPUB format for e-books is relatively simple. However, it's not so simple to determine the essential components of an EPUB file. This guide introduces the core of the format, and describes how the `create-epub` shell script can be used to quickly generate a minimal EPUB from a small collection of files

An EPUB file is a [ZIP](https://en.wikipedia.org/wiki/ZIP_(file_format)) file, with the following constraints:

* The first file in the archive must be named `mimetype`, and contain
  *only* the text `application/epub+zip`, without even a newline.

* The archive must contain, at the top level, a directory named `META-INF`, in which there must be a file named `container.xml`, with the following contents:

```
<?xml version="1.0"?>
<container version="1.0"
           xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
    <rootfiles>
        <rootfile full-path="EPUB/opf.opf"
            media-type="application/oebps-package+xml"/>
    </rootfiles>
</container>
```

The `.opf` file referenced in the `full-path` attribute does not have to be named `opf.opf`; it can be any valid filename.

* The archive must contain, at the top level, a directory named `EPUB`.

* The `EPUB` directory must contain the OPF file referenced in the `full-path` attribute in `container.xml`, with the following contents:

```
<?xml version="1.0"?>
<package version="3.0"
         xml:lang="en"
         xmlns="http://www.idpf.org/2007/opf"
         unique-identifier="pub-id">
    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
        <dc:identifier id="pub-id">[pub-id]</dc:identifier>
        <dc:title>[title]</dc:title>
        <dc:creator id="creator">[authors]</dc:creator>
        <meta property="dcterms:modified">[date]</meta>
        <dc:language>[language]</dc:language>
    </metadata>
    <manifest>
        <item id="nav"
              href="nav.xhtml"
              media-type="application/xhtml+xml"
              properties="nav"/>
        [additional item elements, one for each XHTML file in package]
    </manifest>
    <spine>
        <itemref idref="[idref]"/>
        [additional itemref elements, one for each item element specified]
    </spine>
</package>
```

where `[pub-id]`, `[title]`, `[authors]`, `[date]`, `[language]`, `[additional item elements ...]`, and `[additional itemref elements ...]` should be substituted with the appropriate values. The order of `<itemref>` elements is the 'spine' specifying the intended reading order.

* The `EPUB` directory must contain the file `nav.xhtml`, with the following contents:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:epub="http://www.idpf.org/2007/ops"
      xml:lang="[language]"
      lang="[language]">
  <head>
    <title>[page title, e.g. "Table of Contents"]</title>
  </head>
  <body>
    <nav epub:type="toc">
      <h1>[document title]</h1>
      <ol>
        <li>
          <a href="[first part].xhtml">[title of first part]</a>
        </li>
        [additional li-and-a elements, one for each part of the document]
      </ol>
    </nav>
  </body>
</html>
```

where `[language]`, `[page title ...]`, `[document title]`, `[first part]`, `[title of first part]`, and `[additional li-and-a elements ...]` should be substituted with the appropriate values.

To summarise the essential contents of the ZIP archive:

```
mimetype
META-INF/container.xml
EPUB/opf.opf
EPUB/nav.xhtml
EPUB/[first part].xhtml
EPUB/[additional XHTML parts]
```

As mentioned earlier, `mimetype` must be the first file in the archive. Additionally, files in the archive must not save 'extra' file attributes, such as file times; this necessitates the use of zip(1)'s `-X`/`--no-extra` option. Therefore, assuming the current directory contains the `mimetype` file and the `META-INF` and `EPUB` directories, one could create an EPUB called `document.epub` in one's home directory by doing:

```
$ zip -X ~/document.epub mimetype
$ zip -urX ~/document.epub *
```
where the `-u` option updates an existing archive, and the `-r` option requests recursive directory traversal.

## epub-create

[epub-create](https://github.com/flexibeast/epub-create) is a simple, self-contained POSIX shell script to automate the above process. When supplied with the name of a directory with a collection of (non-binary) files, the script:

* prompts the user for the document title, author(s), language and publication ID, supplying default values when the user doesn't supply any;
* opens a file in the user's `EDITOR` containing a list of the files it found in the supplied directory, which the user can reorder as appropriate to provide the 'spine';
* opens each of those files in turn for the user to edit, wrapping the file contents in the approximate XHTML, so the user can do any necessary tidying (e.g. ensuring the file is valid XHTML);
* opens the `nav.xhtml` file to allow the user to finalise the EPUB's table of contents.

It then creates an EPUB with the name `[directory].epub`.

The script is not intended for more complex EPUB creation and editing requirements. In such cases, one option is Sigil, based on QtWebEngine:

https://sigil-ebook.com/

Additionally, for simply creating an EPUB from e.g. a PDF or OOXML file, one can use Pandoc:

https://pandoc.org

# References

* [EPUB 3 Overview](https://www.w3.org/publishing/epub32/epub-overview.html)

* [EPUB Open Container Format (OCF) 3.2](https://www.w3.org/publishing/epub/epub-ocf.html)

* [EPUB Packages 3.2](https://www.w3.org/publishing/epub32/epub-packages.html)

* [EPUBCheck](https://www.w3.org/publishing/epubcheck/)
