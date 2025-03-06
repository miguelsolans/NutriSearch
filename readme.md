# NutriSearch

The code here-in serves as a solution for a coding challenge for Nutrium company by Miguel Solans.
It consumes an API to fetch professionals in nutritium and display's their profile.


There are number of improvements that could be done, but unfortunetely I am lacking on more time. To name two improvements I would do: 

- Saving offline data in CoreData or SwiftData. I decided to maintain in NSUserDefaults since no pagination has been implemented at this point. Offline and cache mechanism can be easily improved by implementing at BaseApiClient *Offline* extension.

- Extract navigation from UIViewControllers by using a Coordinator pattern. The Coordinator pattern would include depedency injection for the ViewController and ViewModel. The ViewController would have the ViewModel injected from the Coordinator, while the ViewModel would have its Api Client interactor also injected from the Coordinator. 
