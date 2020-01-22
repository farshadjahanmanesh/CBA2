# CBA2
it's a simple library app so i chose MVVM as Arcitecture and CoreData as Storage and has a main app coordinator that helps viewModels to navigate through rutes. every view controller has a view model protocol that helps it do its jobs and each view model protocol has a default implementation. `CoreData` has its own classes we call them  `remote models`, so to hide the implementation and use our own local models, i decided to use a protocol as a bridge between our `remode models` (CoreData classes) and `local models` (Struct). all features uses the `Book` protocol as their model and only in the destination where the data would save to the disk, we convert it to the `CDBook (core data book model)`.

there was two feature that i did'nt implement(lack of time to put on): 1. deleting a book and bookmark page, i think they were duplicate because i edit a book when it's reading status changes and deleting it was  a simple CD query that they are multiple query like that in our application.

and also in the last assignement i wrote some tests to show that i now how to write tests for my application either sync or aync. in last assignment i put all my time on the infrastructre like service, caching, mocking and reactive components to show my swift skills so in this assignment i did'nt do it again. 
here is some of my libraries that can prove that i know how to build complex UI design
https://github.com/farshadjahanmanesh/loady

https://github.com/farshadjahanmanesh/TipSee


and about giflow:
https://virgool.io/@farshadjahanmanesh/%D8%B1%D8%A7%D9%87-%D9%87%D8%A7%DB%8C-%D8%B1%D8%B3%DB%8C%D8%AF%D9%86-%D8%A8%D9%87-gitflow-my2yaqt0d6dh
