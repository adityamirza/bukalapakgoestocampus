# Contribution Guideline
Read this before you start contribute on bukalapak_web_automation

### Indentation
For Ruby(.rb) and Gherkin(.feature) files we use 2 spaces for indentation. Don't use Tab!

Ruby Example:
```
When(/^Admin want to add new campaign$/) do
  homePage_visit
  homePage_login(username, password)
  paymentCampaignsPage_visit
  paymentCampaignsPage_click_create_new_campaign
end
```

Gherkin Example:

```
@dgt @register
Feature: DGT-Register New User
  As a new user of Bukalapak, user want to create a new account to be used for login
  in Bukalapak

Scenario: User register a new account
  Given user have valid E-Mail Address
  When user register by email on bukalapak
  Then user can login with new account

```

### Finding Element
When finding element from page use these in order:

1. css
2. xpath

### Sleep
Use sleep when it needed. Not because you assume it need to. We need to keep scenario to run as fast as possible. Use wait_for or wait_until instead of sleep.

### Tag & Feature
For each squad please use squad prefix for feature name and tag for each scenario or parent scenario.

Feature Example:

```
Feature: DGT-Register New User

```
Tag Example:

parent tag:
```
@dgt @register
Feature: DGT-Register New User
  As a new user of Bukalapak, user want to create a new account to be used for login
  in Bukalapak

Scenario: User register a new account
  Given user have valid E-Mail Address
  When user register by email on bukalapak
  Then user can login with new account
```

each scenario:tag

```
Feature: DTB-Popular Product
  Admin should able to create, delete, edit or view popular product

  @dtb @popular-product
  Scenario: Admin create new popular product
    When Admin create new popular product
    Then popular product is created

  @dtb @popular-product
  Scenario: Admin delete popular product
    When Admin delete popular product
    Then popular product is deleted
```


# PageObject
We use [siteprism](https://github.com/natritmeyer/site_prism) for pageObject. Please read the [documentation](http://rdoc.info/gems/site_prism/frames) before you start contribute.

# API Steps

See [API Steps Guideline](https://github.com/bukalapak/bukalapak_web_automation/blob/master/API-Steps.md)

# Git
This part explain to you how to contribute to bukalapak_web_automation with git

### Clone
First you need to clone bukalapak_web_automation into your laptop/PC (you probably had done this before read this manual)

### branch
If you want to develop new scenario or add something to bukalapak_web_automation checkout into new branch using -b parameter:

```
git checkout -b fix_login_scenario
```

### commit
After you add/change something to the code then use this command to commit your change
WARNING! Make sure your code running on your local machine.

```
git commit -m "fix login scenario"
```

### push
After commiting your work into local git, you need to push it into repository

```
git push origin fix_login_scenario
```

### merge
After you push your work create pull request. Then merge it to master using **Merge Pull Request** button on the pull request page.

WARNING! Make sure your code running and passed on [jenkins!](http://www.qa-jenkins.vm:8080) before merge your branch into master
