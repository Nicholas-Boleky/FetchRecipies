### Steps to Run the App
After cloning into a folder of your choice, navigate to that folder, enter the top level folder, and click on the `FetchRecipes.xcodeproj` file. This project uses SPM for third party libraries so you do not have to worry about installing cocopods. Simply choose a device to run from and push the play/run button.
In XCode default scheme is run in debug so on the recipe landing page you will see a picker for the three data sources provided in the project instructions. If you would like to see the release version of this project:
1. **Open Scheme Editor**:
   - In Xcode’s top toolbar, click the app’s name > **Edit Scheme...**.

2. **Set Build Configuration**:
   - In the left panel, make sure **Run** is selected.
   - Under **Build Configuration**, choose **Debug** (for development) or **Release** (for production).

3. **Save**:
   - Click **Close** to apply the changes.
  
     
### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

- Architecture: I emphasized a clean MVVM architecture for separation of concerns, testability, and scalability.
- Performance: I focused on optimized rendering for large datasets (e.g., lazy loading of RecipeRow and on-screen recipe visibility).
- Reusability: Created modular components (ShareButton, RecipeSearchBar, etc.) to maximize reusability and flexibility across different screens that might exist in an otherwise production app.
- User Experience:
  - Prioritized user-friendly features like a search bar and tabs to filter cuisine.
  - iPads will see the rows always expanded which blends better on their larger format screen.
  - Users will see youtube players embedded for watching the recipe if a video url is available.
  - Errors are handled in a way that communicates the problem to users clearly

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I didnt time anything exactly but I worked on this intermittently over two days. I think overall I spent about 6ish hours on the project. (Just writing this readme took almost an hour)
  - Setting Up Architecture and Project Structure: ~20%
  - Implementing Core Features (MVVM setup, UI components): ~30%
  - Ironing out kinks: ~15%
  - Writing Unit Tests: ~25% (longer than typical but I had to refresh myself on unit testing)
  - Refactoring and Code Cleanup: ~10%

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

Using Lazy Loading: 
- Chose lazy loading for recipe rows to improve memory efficiency but slightly increased initial load time.
  
Reusable Components: 
- Opted to make UI components highly reusable, which added upfront complexity but ensured a scalable design for future features.

One Screen App:
 - The directions for this project explicitly stated that this app should only really have one screen so I wasnt able to implement a webView to navigate to the source_url provided by most recipes. I made up for this by simply adding a share sheet to make it easy for users to copy the url and explore on their own.

Time:
- I spent more time than typical on this project in order to implement some features that added to user experience and make things easier for the devs who test the endpoints

### Weakest Part of the Project: What do you think is the weakest part of your project?

UI would be the weakest part of my project. I think I provide a good UX by embedding the youtube player and animating some actions however I spent so much time on the features in this project that I didnt really take time to make pretty colors or modern sleek shadows/corners on views like buttons and tiles

### External Code and Dependencies: Did you use any external code, libraries, or dependencies?

I used two libraries for this project. For the image caching I used `SDWebImageSwiftUI` which is built on `SDWebImage` but more optimized for swiftUI. This handled the image caching for me. For the youtube player I added `YouTubePlayerKit` which I found to be a really great library for embedding youtube videos. Its already swiftUI ready. You pretty much just supply a link and its good to go. The player has 3 states for idle, ready, and error. Even if it throws error the player displays a helpful message about the video not being available anymore however I chose to overlay a picture that looked slightly more user friendly.
Some external code I used included leveraging chatGPT for some tasks like UI code generation to help save time where I could. It also generated an image I used when there was no youtube link or it took us to a video that didnt exist. My cats face makes a guest appearance when you pull down an empty recipe array.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

I had a great time on this project. I have never embedded a youtube player into an app before so this was a cool opportunity to explore that and think about how to handle cases where links were broken. I cant take all the credit because the library used makes that pretty easy. 

One thing that might be helpful for developers testing this project is I added a segmented controller that will only appear in debug mode. You can use this to change the data source between the typical recipe list, malformed data, and the empty array. This will show by default because XCode typically runs schemes in debug but if you would like to see release I put directions for how to change that at the top of this readme.

I feel like, to leave room for artistic interpretation, the directions were intentionally vague on what to do with the extra information provided for the recipes so I hope you will enjoy my decision to use expandable views to play the video and share the source page.
