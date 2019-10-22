# Flutter To Do App

This is an example to do app built in Flutter.

The app uses an external REST API (built with Laravel) that can be accessed at [laravelreact.com](http://laravelreact.com). The source code for the API and React front-end is available at [laravel-react-bootstrap](https://github.com/devinsays/laravel-react-bootstrap).

The app handles:

* Login
* Registration
* Password reset
* Displays "Open" and "Closed" tasks
* Lazy loads tasks from a paginated API
* Toggles to do status (opened/closed)
* Adds new to dos
* Log out

The Provider package is used to manage app state.