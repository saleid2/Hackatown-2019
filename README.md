# polseinzer

A Flutter app to help you find parking

## Inspiration
Street signage keeps changing, and it's hard to keep track. We couldn't find any tools to provide us with accurate information about parking restrictions around Montreal, so we decided to build one.

## What it does
Using some of Montreal's open data, after filtering out the more cryptic information, we're left with the restrictions and permitted hours/days/months! We proudly display these in a radius of 200m of the users current location, or destination (accessible through search) as long as that destination is within Montreal

## How We built it
We processed the data using Python, dropping rows and columns containing unnecessary information. Using Flutter, we built a UI (User Interface) to display the different signs around Montreal.
The data access layer uses the repository pattern where everything is abstracted from the rest of the application, so it's easy to switch from local storage, to a dedicated server for these kind of information.

## Challenges I ran into
Flutter is a fairly recent framework. Dart is a weird language that does things differently. Documentation isn't always as accessible in comparison to more mature languages and frameworks.

## Accomplishments that We're proud of
We built a *native* cross-platform application requirement minimal effort to deploy on Android (no effort really, just download and build) and iOS (missing some plist data and obviously testing) using a framework no one was familiar with in a language we'd never used before.

## What We learned
Although Flutter and Dart are a good concept, the road is still rocky while they mature.

## What's next for Polseinzer
We will probably polish the application some more, and more the data to a more accessible backend. Some features we'd like to see is a more visible indicator of available parking through coloured lines on the side of the street! (similar to how Google does for traffic... but for parking!) Eventually, it would be possible to integrate sensors that determine if a spot is available or not. Integrating with the city's parking payment infrastructure would be a huge step in improving the city's tech presence (I dare you to look at the Android App without Tech PTSD from the early Android days)
