# PoCCryptoTracker

This is a toy project meant to learn SwiftUI, Combine and Core Data.
It is based on [this](https://www.youtube.com/playlist?list=PLwvDm4Vfkdphbc3bgy_LpLRQ9DDfFGcFu) _YouTube_ course by [Swiftful Thinking](https://www.youtube.com/@SwiftfulThinking/featured).

This project uses _MVVM_ (Model-View-ViewModel) design pattern to separate business login to UI logic. To get UI responsive to business login is used _Combine_ framework.

## Code architecture

The application architecture is based on _MVVM_architecture pattern.

This means that _User Interface_ (_UI_) objects are separated from _Login Components_.
The main views are:

- Coin details
- Home
- Settings

### Coin details

This view shows more information on a particular crypto coin.
It has one more subview, _ChartView_, representing a line chart object.
As every view, all the data that this view shows are managed by a _ViewModel_ class: downloading data for the selected coin, transform downloaded data and pass them to the view.

### Home

_Home_ is the first view and it shows the 250 coins with the greatest capitalization.

This view could show user's portfolio, where user can see its portfolio and make operations on it (e.g. add, sell partially o completely a coin).

In this two views is present a _Search bar_ where user can search a coin on the list.

Lists can be sorted by every column that are present.

### Settings

_Settings_ view shows some application and _API_ information, without edit it.

## Combine

All data is downloaded using _Publisher-Subscriber_ pattern (built in _Combine_ framework). This means that the application responds immediately on every data change.

## Lint

All code is linted during a build process using _SwiftLint_.