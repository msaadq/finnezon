# Finnezon

## Description
Finnezon allows you to see ads related to real estate and goods. You are able to see information about the category of the ad along with the price, an image, location and a short description. It also lets you favourite ads and filter by favourites. 

## Review
I am proud of the fact that I am able to write this app while maintaining good testability. All the UI is decoupled from the navigation which lets me mock the view models and response for better testing in the future. One of the shortcoming of the app is that despite using the coorinator pattern, the app does not take much advantage of it because all the functionality is constrained to a single page

## If I had more time...
The next items to implement as part of the project (in decreasing order of priority):
* Offline Data for favourites
* Details page for each ad
* Apple Maps implementation for the details page to let the user navigate to location
* Utilize the Mock Services to setup unit testing
* Reduce min API version to introduce 14.0+ Support and a fallback implementation for AsyncImages and other List-related features
* Allow users to filter by price
* Allow users to filter by location using neaby location
