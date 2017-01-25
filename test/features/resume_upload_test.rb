require 'open-uri'
require 'test_helper'

feature 'Upload a resume' do

  scenario 'an application can upload a PDF', js: true do
    Capybara.using_session('bad contact info') do
      # we can fast-forward to the available_times step

      digest= Digest::SHA256.file "test/fixtures/resume.pdf"

      fixture = prospects(:all_valid)
      all_valid = fixture.attributes
      all_valid[:enumeration_ids] = fixture.enumerations.map(&:id)
      all_valid.reject! { |a| %w(id created_at updated_at).include? a }

      all_valid['addresses_attributes'] = [addresses(:all_valid_springfield).attributes.reject { |a| a == 'id' }]
      all_valid['phone_numbers_attributes'] = [phone_numbers(:all_valid_dummy).attributes.reject { |a| a == 'id' }]
      all_valid['available_times_attributes'] = [available_times(:all_valid_sunday).attributes.reject { |a| a == 'id' }]
      page.set_rack_session("prospect_params": all_valid)

      visit new_prospect_path

      10.times do
        click_button 'Continue'
        break if page.has_content?('Resume')
      end

      assert page.has_content?('Resume')
      page.attach_file('resume_file', 'test/fixtures/resume.pdf', visible: false)

      find("input[name='uploadResume']").click

      assert_selector "input[value='Success!']"

      click_button 'Continue'
      assert page.has_content?("Confirmation")

      # let's download it andmake sure its the same
      assert_selector ".download-resume"

      href = find('.download-resume')['href']

      page.evaluate_script("window.downloadCSVXHR = function(){ var url = '#{href}'\; return getFile(url)\; }")
      page.evaluate_script("window.getFile = function(url) { var xhr = new XMLHttpRequest()\;  xhr.open('GET', url, false)\;  xhr.send(null)\; return xhr.status }")
      assert_equal 200, page.evaluate_script( "downloadCSVXHR()")

      # and now for fools trying to get in the backdoor
      err = ->{ open(href) }.must_raise OpenURI::HTTPError
      err.message.must_match /403 Forbidden/

    end
  end

  scenario 'an applicant cannot upload a none pdf', js: true do
    # we can fast-forward to the available_times step

    fixture = prospects(:all_valid)
    all_valid = fixture.attributes
    all_valid[:enumeration_ids] = fixture.enumerations.map(&:id)
    all_valid.reject! { |a| %w(id created_at updated_at).include? a }

    all_valid['addresses_attributes'] = [addresses(:all_valid_springfield).attributes.reject { |a| a == 'id' }]
    all_valid['phone_numbers_attributes'] = [phone_numbers(:all_valid_dummy).attributes.reject { |a| a == 'id' }]
    all_valid['available_times_attributes'] = [available_times(:all_valid_sunday).attributes.reject { |a| a == 'id' }]
    page.set_rack_session("prospect_params": all_valid)

    visit new_prospect_path

    10.times do
      click_button 'Continue'
      break if page.has_content?('Resume')
    end
    assert page.has_content?('Resume')
    page.attach_file('resume_file', 'test/fixtures/resume.notpdf', visible: false)

    find("input[name='uploadResume']").click

    refute_selector "input[value='Success!']"

    click_button 'Continue'
    assert page.has_content?("Confirmation")

    # let's download it andmake sure its the same
    refute_selector ".download-resume"

  end
end
