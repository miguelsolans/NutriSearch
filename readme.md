# NutriSearch

The here-in code serves as coding challenge for Nutrium company. 

There are number of improvements I could do, but unfortunetly time is a problem. To name a few: 

- Saving offline data in CoreData or SwiftData. I decided to maintain in NSUserDefaults since no pagination has been implemented at this point. Offline and cache mechanism can be easily improved by implementing at BaseApiClient **Offline** extension.

- Extract navigation from UIViewControllers by using a Coordinator pattern. This would no only improve navigation definition as also allow dependency ibjection by using the Coordinator layer to:
  1. Inject ApiClient interactor in the ViewModel
  2. Inject ViewModel in the UIViewController
