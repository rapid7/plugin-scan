class HelpController < ApplicationController
  include ApplicationHelper

  def index
    @help_nav = "active"

    @faqs = [
[
  "Does #{product_name} track personal information?",
  "No, #{product_name} only enumerates browser vulnerabilities."
],
  [
"Does #{product_name} abide by Do Not Track (DNT)?",
"#{product_name} does not track any personal data."
],
[
"How does the tracking work?",
"#{product_name} uses JavaScript to collect plugin information from visitor\'s web browser and inspect the version numbers in order to do vulnerability enumeration."
],
[
"What is transparent tracking mode?",
"Transparent tracking mode enumerates vulnerabilities when a webpage is loaded. This mode is ideal for administrators who wish to track vulnerabilities without altering corporate and intranet website design."
],
[
"What is badge tracking mode?",
"Badge tracking mode enumerates vulnerabilities and produces an image that gives the end user a vulnerability finding alert."
],
[
"What is redirect tracking mode?",
"Redirect tracking mode enumerates vulnerabilities and redirects the user\'s browser to a URL designated by the administrator if vulnerabilities are discovered."
],
[
"What is overlay tracking mode.",
"Overlay tracking mode enumerates vulnerabilities and produces a full browser window translucent overlay with information designated by the administrator if vulnerabilities are discovered."
],
[
"How do I view my website statistics?",
"Once have created a #{product_name} account and successfully deploy your tracking code on your site you will be able to see your website statistics on the Dashboard page."
],
["Can I delete my data?",
'Yes, you can delete your data via <a href="/settings">Account Settings</a> page.'
],
[
"Can I get more than one tracking code?",
"Currently you are only able to sign up for one tracking code per account."
],
[
"How can I tell if my tracking code is working?",
"Once you have deployed your tracking code on your site, open a browser to the page where it is deployed. Go to the Dashboard > Referers and you should see your site."
],
[
"Why do I see duplicate source IP addresses?",
"If you deploy your tracking code behind a network address translation (NAT) device you probably will only see one IP address for multiple hosts. Even though it is one address, #{product_name} enumerates by host which will still give you excellent insight on how vulnerable your organization is to attacks."
]

            ]

  end
end
