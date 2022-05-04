# The Salesforce Character Counting Component
<p align="center">
<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
<br/>
<a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4R000001hhzaQAA">
<img alt="Deploy Unlocked Package to Prod" src="https://github.com/Coding-With-The-Force/Salesforce_Character_Counting_Component/blob/master/images/btn-install-unlocked-package-sandbox.png?raw=true">
</a>
<a style="padding-left: 10px" href="https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4R000001hhzaQAA">
<img alt="Deploy Unlocked Package to Prod" src="https://github.com/Coding-With-The-Force/Salesforce_Character_Counting_Component/blob/master/images/btn-install-unlocked-package-production.png?raw=true">
</a>
</p>


Ever wished you could see how many characters were left when entering text into a 
text field in Salesforce?? Well this is the answer! It works on every field in every 
field combination and it's completely driven by field sets! No custom code ever again!

Click the images below to check out what this component can look and feel like! Remember though, there are tons of config options, so you can change this up quite a bit!

<b>The Character Counter's View Two-Column Layout Example</b>
![Character Counting View Display](https://github.com/Coding-With-The-Force/Salesforce_Character_Counting_Component/blob/master/images/CharacterCounterView.JPG?raw=true)

<b>The Character Counter's Edit Two-Column Layout Example</b>
![Character Counting View Display](https://github.com/Coding-With-The-Force/Salesforce_Character_Counting_Component/blob/master/images/CharacterCounterEdit.JPG?raw=true)

---
# Features
1. An abstract 100% configuration based component that is driven by field sets.
2. It can work in virtually any situation! Embed it in your lightning record pages, use it in a custom new record page, put it in a flow or merge it into another custom component of yours. It can adapt to any situation.
3. It can be used on literally any object with any combination of fields!
4. Supports character counting on all text based fields! Even rich text!
5. Has the ability to display in a single column or a double column layout.
6. Has the ability to present itself as a stand-alone component or to present itself as a field section in a page layout to integrate smooth into page layouts.
7. You can set your own header title and optionally your own icon for the header
8. Can be used on lightning record pages
9. Can be used in flows
10. Can be used in custom new record pages
11. Can be merged into larger lwc, aura or vf components seamlessly

---
# Installation

You can currently install the component via any of the three links below. I would personally suggest leveraging the unlocked packaging options as it will allow you to easily keep up with updates for the component and keep it self-contained.

However if you are adverse to unlocked packaging (for some crazy reason) you can use the "Deploy to Salesforce" button which will deploy the code, without the packaging, to your organization. 


<p><b><i>Deploy to your org without packaging using the link below:</i></b></p>
<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
<br/>

<p><b><i>Deploy to your org with packaging using one of the links below (HIGHLY SUGGESTED!!):</i></b></p>
<a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4R000001hhzaQAA">
<img alt="Deploy Unlocked Package to Prod" src="https://github.com/Coding-With-The-Force/Salesforce_Character_Counting_Component/blob/master/images/btn-install-unlocked-package-sandbox.png?raw=true">
</a>
<a style="padding-left: 10px" href="https://test.salesforce.com/packaging/installPackage.apexp?p0=04t4R000001hhzaQAA">
<img alt="Deploy Unlocked Package to Prod" src="https://github.com/Coding-With-The-Force/Salesforce_Character_Counting_Component/blob/master/images/btn-install-unlocked-package-production.png?raw=true">
</a>

---

# Setup and Installation Tutorial Video

---

# Setting Up The Component on Record Edit Pages


---

# Setting Up The Component on New Record Pages

---

# Setting Up The Component in Flows


---

# How to Embed The Component in Other LWC's

---

# Suggestions For Developers Setting Up This Component

While this component has fairly robust exception catching it does not have logging and it also does not leverage selectors. I chose to do this because I didn't want to load this project with dependencies that you may not want to use yourself and creating a logger or a selector layer solution is not the point of this repo/component. I would suggest that you add error logging and a selector layer that you are comfortable with to this code prior to leveraging it.