# 4Good

Your event for the day was cancelled?
You have time every thursday after your university classes?
You want to help?

Become a volunteer!

4Good is an app that makes volunteering simple.
It collects volunteering opportunities from all over the web, be it your local animal shelter, refugee organizations or youth centers. View both events created on 4Good as well as links to projects on external volunteering web archives.

## What good is 4Good?

### Want to help, spontaneously and easily?

Find a project that inspires you, join with one button tap.

### You want to help near your home? You want something suited to your skills? You want to help in a specific field?

Our tool helps you find the projects that fit your wishes. We can filter events by your preferred location, so that you are only presented projects where you really can make a difference. You can also filter for projects that allow you to use your skill sets to help others.

### Don't want to volunteer alone?

Invite your friends to 4Good events using your favourite messenger. More help, more engagement, more fun.

### Want to help, but your local volunteering opportunities are scattered all over the web?

4Good also displays projects from external sites, so you don't have to search every site separately.

### Want to volunteer at an external event, but still keep track of it?

To communicate with externally hosted projects you will have to visit their external website, but you can add the project to your 4Good project overview to never miss anything.

## What and how we built it

We used the Flutter framework in Android Studio. Our backend database is Firebase. All information displayed is updated live if the Firebase data is updated.

Our main screen is the project overview. The projects are sorted by timestamp and display when they will happen,  When filters are applied, this view is updated to only show the filtered events.

If you tap on a project, a project view is opened with all details like description, time, location, etc. If it is an external project, you can save it and visit the matching external website. If it is a direct 4Good project, volunteering will directly notify the project organisers.

One of the other main parts is the profile screen with your own information (e.g. your location and skills) and the projects you volunteered for.

## Challenges

A lot of volunteering websites and apps exist, yet many people don't know any of them. Why are many so unknown? Can we make it easier for people wanting to volunteer (so they don't have to find and search every site individually) and event organizers (so they can choose the site they like best instead of creating ten entries in ten different tools)?

Many volunteering sites are for long term commitments with interviews and other processes. Can we make an app that also allows very informal, spontaneous volunteering?

# HackHPI

This was a submission for HackHPI 2019, more details can be found on our [devpost post](https://devpost.com/software/four_good).
