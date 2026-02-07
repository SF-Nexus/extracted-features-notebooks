# Guide to OCR in Abbyy
## Introduction
[ABBYY Fine Reader](https://pdf.abbyy.com/) can take jpgs, tiffs, and pdfs and translate them into computer readable text through a process called Optical Character Recognition (OCR). [Here's a brief introduction to OCR.](https://www.youtube.com/watch?v=jO-1rztr4O0)

[In this project,](https://lcdssgeo.com/omeka-s/s/scifi/page/digitizing-science-fiction) Abbyy Fine Reader was used to perform OCR on a corpus of science fiction books. The books were  scanned and saved to a server as TIFF files, and the OCR process was tracked through a master worklog.

## Open Files in Abbyy OCR Editor
* Navigate to the server where files are stored (ex. Novel Database server -> Digitized Books -> Round # -> Batch #)
* Open the folder corresponding to the file you want to review (ex. SSFCBZ201710000### -> TIFFs to OCR) 
* Select all TIFF files in folder, right click, and select "Open in OCR Editor Abbyy Fine Reader." Abbyy will now open with selected files ready for cleaning. 

Additional notes for file wrangling: 
* If uploading a long book (260+ pages) you may encounter the error “the filename or extension is too long.” To circumvent, select the first 100 files and open in Abbyy using the steps above. Then, with the new project open in Abbyy, go to File -> Open Image and select the next batch of files. Do this until all files have been loaded into single OCR project. 
* If the book is an ACE DOUBLE (two books in one), create two OCR projects (for the files corresponding to each book).

## Review and Clean Files in Abbyy OCR Editor
Perform the following steps to review and clean files in Abbyy. Track all progress in OCR worklog. 

1. **Check for blank pages** by scrolling through the page viewing pane on the left side of the screen. Right-click on the image of any blank page in the viewing pane and click Delete. This will remove the whole page from the project. 

![delete_blank](https://user-images.githubusercontent.com/64552353/178784501-dd9bbca0-d0ea-46b8-9e7b-c45c73ce5261.png)

2. **Review pages with unrecognized elements.** Red boxes indicate that parts of text are unrecognized; recognized text will show up in green boxes. To edit, determine which category the pages with unrecognized elements fall under: 
    * If the page has **unrecognized elements AND recognized text,** right-click on the red boxes around the unrecognized elements and click “Delete.” 
    * If the page has **unrecognized text you want to keep,** use the editing panel on the right-hand side of the screen to add text to the page. If the unrecognized text you want to keep is more than a few words or paragraphs (i.e. a page or multiple pages), make a note in the worklog spreadsheet so the corresponding book can be reviewed or re-scanned.
    * If the page **ONLY has unrecognized elements you do not want to keep (e.g. images or icons),** delete the whole page as instructed for blank pages. As you delete them, make a note of any **maps or meaningful illustrations** in the worklog for possible future preservation.

3. **Skim pages to see if any are significantly ripped, blurred, or otherwise cut off.** These pages may be recognized, but OCR may not be accurate. Manually correct and/or make a note in the worklog when physical book is needed for review. 

![close_cuts](https://user-images.githubusercontent.com/64552353/178785392-eaf270f8-bfb3-42b1-b5bc-3ea17574b912.png)

4. If not already present, **add the book’s title and author name** to the first page of the OCR project. This is necessary when the title page with title and author name is an image/unrecognized. See example below:

*Before: First page unrecognized, title/author not listed* 

![Before_Title](https://user-images.githubusercontent.com/64552353/178783306-98b5cc3a-f271-4506-a4e3-6f02806c6321.png)


*After: Image box removed, title/author manually added* 

![After_Title](https://user-images.githubusercontent.com/64552353/178783334-b6c13d78-614f-409a-b4bc-7ef1f9568d32.png)


5. **Add START OF BOOK and END OF BOOK tags** using the text editor. Both tags should be in all caps; hit enter after typing. 
    * Type START OF BOOK **at the top of the page where the first chapter starts** (after title, copyright info, preface, dedication). Prologues ARE considered chapters.     
    * Type END OF BOOK **at the end of the last page of the last chapter.**

6. **Add CHAPTER headings** before the start of each chapter using the following format: CHAPTER # (ex. CHAPTER 2). Hit enter after chapter heading. A few caveats: 
    * If the book has its own chapter headings, remove/edit them to match format above
    * If the book has chapter titles, list them on separate line following CHAPTER #
    * If the book is a short-story collection, still divide each short story with a CHAPTER heading. On the line below CHAPTER, keep the title of the chapter, short story, etc.
    * If the book is divided into parts, note the part, the part title (if applicable), the chapter, and the chapter title  (if applicable), as in the following example: ![Chapter_Header](https://user-images.githubusercontent.com/64552353/178782938-e60eac75-b41c-4876-a3d1-a05542521fce.png)
    * If there are no chapter headings, determine how the book is split into sections–e.g. noticeable line breaks, asterisks or other characters separating substantial parts–and add CHAPTER # headings each time a new section begins. 

7. **Automate header/footer recognition** so these elements (such as page numbers) can be removed from files. To automate recognition, go to Tools -> Options -> OCR -> Check box next to “Headers and Footers” under section “Detection of Structural Elements.” Re-run recognition (Recognition -> Recognize All Pages) and header and footer bars should appear on right-hand side text editor. 

    *Example of header with title and page number recognized:* ![Picture1](https://user-images.githubusercontent.com/64552353/178782579-23af51fe-eb41-450e-b452-af9bb710945d.png)

    This way, when you’re ready to export to plain text files, the headers/footers can easily be removed by going to Tools -> Options -> Format Settings -> TXT and uncheck the box next to “Keep Headers and Footers.”

8. **Manually remove unrecognized headers/footers.** Skim pages to catch page numbers and other headers/footers that are included in the body of text instead of being recognized as a header or footer. Manually delete these from the right-hand side text editor. 
      * The manual removal process can be supported by creating a set “area” that approximates the position of the text WITHOUT the header/footer and applying it to all pages. To do this, highlight the area of text to recognize and save it as a template by going to Area -> Save Area Template. To recognize that same area across all pages of the project, go to Area -> Load Area Template, select the template and choose "Apply to All Pages," and re-recognize all pages. However, since each page will have slightly different margins, you will still need to skim pages to make sure area has not caught header/footer (and still includes all other text). 

## Save Files in Abbyy As OCR Project
1. With file open in Abbyy, go to File -> Save OCR Project 
2. Choose the location in which you want to save the project (ex. Novel Database server -> Digitized Books -> Round # -> Batch #) as file path and create new folder named OCR Files.
3. Save your OCR project in new OCR Files folder with chosen title (ex. SSFCBZ201710000###_[first few chars of author/book title])

## Export OCR Project as Text File
1. With file open in Abbyy, go to File -> Save As -> TXT Document
2. Choose the location in which you want to save the project (ex. Novel Database server -> Exported Datasets -> Sci Fi Corpus Txt Files -> Round X Clean Txt Files) as file path. 
3. Save your text file using this format: PublicationDate_AUTHORLASTNAME_TITLE (ex. 1954_POHL_STAR)