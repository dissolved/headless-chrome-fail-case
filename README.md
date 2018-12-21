# headless-chrome-fail-case

An MWE to show the limitations of headless chrome when downloading a PDF from a new tab link. The options and preferences used to configure chrome were taken from [this chromium thread](https://bugs.chromium.org/p/chromium/issues/detail?id=696481#c89). These comments are old, but it's the only one to seem to have gotten things working with capybara.

### Installation

Install the required gems and drivers.

### Running the example

#### Start an http server in this directory
I'm a python person, so I use:
- `python3 -m http.server`

Visit [http://localhost:8000](http://localhost:8000) and try out both links. Both should point to our [sample PDF](http://www.pdf995.com/samples/pdf.pdf), one in a new tab and one not.

#### Test download with headless chrome

Run the ruby code that uses headless chrome / selenium to download this:
- `ruby download_pdf.rb`

By default this will attempt to download the new tab PDF. It won't fail, but there won't be any files listed in the DOWNLOAD_PATH at the end of the script.

#### Test normal (no new tab) download

Edit `download_pdf.rb` to find `id: "normal_link"` on line 9, then run `ruby download_pdf.rb` again. This time the DOWNLOAD_PATH should have a PDF file in it, which you can go in and open.

#### Test new tab download with headed chrome
Restore `download_pdf.rb` to its original state, so it's looking for `id: "newtab_link"`. Then open scrapppy.rb and comment out line 18, where we're specifying that chrome run in `--headless` mode. Save and then run `ruby download_pdf.rb` again. Chrome will start in headed mode, then successfully download the new tab PDF.

### System info and versions
- capybara (2.18.0)
- selenium-webdriver (3.141.0)
- ChromeDriver 2.44.609545



