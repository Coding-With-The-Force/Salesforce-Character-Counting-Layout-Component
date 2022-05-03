# The Salesforce Character Counting Component

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

Ever wished you could see how many characters were left when entering text into a 
text field in Salesforce?? Well this is the answer! It works on every field in every 
field combination and it's completely driven by field sets! No custom code ever again!

Click the images below to check out what this component can look and feel like! Remember though, there are tons of config options, so you can change this up quite a bit!

![Character Counting View Display](https://github.com/Coding-With-The-Force/Salesforce_Character_Counting_Component/blob/master/images/CharacterCounterView.JPG?raw=true)
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

You can currently install the component either by using the installation link at the top of this page, or the one below! I plan to eventually add an unlocked package link as well.
Click the button, connect to your org, deploy the code and you're off to the races!

<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
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