# WebsiteSpeedTest
Tool to test response speed of a website

Windows Binary is available in the release folder of this repo.

Parameters to use:

1. Required. URL to test (A GET call).
2. Required. Number of seconds to test for. Must be greater than 0 and less than 120. Fractions are allowed.
3. Optional. A folder to place get responce body.
4. Optional. Text used a prefix to file named created in the folder specified by parameter 3.

Example: WebsiteSpeedTest.exe "https://www.google.com" 5 "C:\WebsiteSpeedTestResponses" "GoogleHomePage_"

You may omit the double quotes from parameters, if no blank spaces are included.

The following example will place in a folder C:\WebsiteSpeedTestResponses\ files named like:
  GoogleHomePage_1.html
  GoogleHomePage_2.html
  GoogleHomePage_3.html
  GoogleHomePage_4.html
  ....
