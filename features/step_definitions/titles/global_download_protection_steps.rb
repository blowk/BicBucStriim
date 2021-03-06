# encoding: utf-8
# 
Given /^I choose no download protection$/ do
  visit "/admin/"
  choose 'No, not necessary'
  click_button 'Save'
end

Given /^I choose (admin|separate) download protection, using password "(.+)"$/ do |arg1, arg2|
  visit "/admin/"
  if (page.has_selector?('form#adminpwform', :visible => true))
    fill_in 'admin_pwin', :with => 'admin'
    click_button 'Submit Password'
  end
  if arg1 == 'admin'
		fill_in 'admin_pw', :with => arg2
		choose 'Yes, use admin password'
	else
		fill_in 'glob_dl_password', :with => arg2
		choose 'Yes, use a separate password (enter below)'
	end
  click_button 'Save'
  page.has_no_selector?('p.error')
end

When /^a user navigates to book page "(\d+)"$/ do |arg1|
  visit "/titles/#{arg1}"
  page.has_content?('Book Details')
  page.has_content?('Die Glücksritter')
end

Then /^the download is protected$/ do
  page.has_selector?('div.dl_access')
  page.has_css?('div.dl_access', :visible => true)
  page.has_css?('div.dl_download', :visible => false)
end

Then /^the page shows the download options$/ do
  page.has_selector?('div.dl_download')
  page.has_css?('div.dl_access', :visible => false)
  page.has_css?('div.dl_download', :visible => true)
end

Then /^the cookie "(.+)" is set$/ do |arg1|
  pending # webkit doesn't recognoze our cookies?
end

Then /^enters the password "(.+)"$/ do |arg1|
  click_on 'Download'
  click_on 'Submit Password'
  fill_in 'password', :with => arg1
  click_on 'Submit Password'
end

Then /^the page shows an error$/ do
  page.has_content?('Invalid Password')
end

When /^a user downloads a boook directly$/ do
  visit 'titles/3/file/Der+seltzame+Springinsfeld+-+Hans+Jakob+Christoffel+von+Grimmelshausen.epub' 
end

Then /^the app sends reponse code "(\d+)"$/ do |arg1|
  x = page.driver.status_code
  x.should == arg1.to_i
end
