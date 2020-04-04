# Review Notes

## First impressions

 - Good outlook of project
    - You have your files nicely grouped in a clear way View, ViewModels, etc. Makes it also clear that you're using an architecture that makes use of ViewModels, I like that too
    - You seem to have tests, that's a good start too. The Unit Test target [does not compile though](https://github.com/bertadevant/UnsplashAPIApp/commit/b7b8e59f06ca91196afccf42cbe5eea0644b2b94), and once I fix it to make it compile, I have 3 tests failing
 - [README](https://github.com/bertadevant/UnsplashAPIApp/commit/89ead7af925b4f87d8fbe419d6e557ff59231218): I know it's just a private project for now, but for demo projects intended for interviews I suggest you to add some notes in the future, like:
    - What does this demo shows: That's already part of your README so, great
    - What architecture choices did you make and why. There's no silver bullets in architecture, the most important thing, as least to my PoV, is that you are able to explain your choices and why you went with one solution rather than another. Is it to make it testable? To make it flexible? Easy to reason about? Be SOLID? etc
 - You had (easy to fix) warnings when opening the project: not a great look for reviewer opening your code
    - some warnings about code [commit](https://github.com/bertadevant/UnsplashAPIApp/commit/98eeded041080b085ff152032ca6470ad882a971)
    - some warnings about assets [commit](https://github.com/bertadevant/UnsplashAPIApp/commit/7c95db452f68b8021b26a4ee9a5fe4ba42889b77)
 - You don't have any dependencies in that project. That great.
    - I mean, if that was a sign that you instead reinvented every complex thing yourself instead of using an existing lib (NIH syndrome) that wouldn't be a good sign
    - Or if it was because you instead copy/pasted lib code into your project reather than using a dep manager, that wouldn't be good either
    - But in your case at least I can see that since you didn't need any dependency, you didn't feel the urge to have a `Podfile` or `Cartfile` like some other
      people that I see including well-known pods in their demo project "just because it's a pod I see everywhere and add no questions asked" like AFNetworks or similar,
      while they actually don't need it. In that sense that's a good sign that your project is clean and simple without any useless deps!

### UX

When running the app in the simulator (usually the first thing I do on a interviewee project, also to see if it compiles and works out of the box), UI felt nice and
    enjoyable.
But the time it took for the images to load felt quite long, and I only got a solid-fill rectangle in the ImageView while waiting for the actual image to load.

Maybe at least add a spinner or something while loading the image to let the user know that it's loading instead of feeling like it's a bug.
[commit](https://github.com/bertadevant/UnsplashAPIApp/commit/5991ec7ac10c3f993b23d5c52be87a6f3f2937d8) – though that won't help with the recycling bug (see below)

Ideally starting by loading lower resolutions of the image first, and only load full-res when you click to show the image full-screen would also probably improve the UX a lot (idk if the Unsplash API provides those lower-res images?).

That's also probably a feature you just didn't have time to develop just yet, but in that case it would still be worth mentioning that in the README for the recruiter as "Future Improvements" to let them know that you thought about it.

### Cell recycling bug

Because you use `UIImageView` method that asynchronously sets its own image after an async network request, there is an issue with cell recycling.
Because if the user scrolls while the image is loading, your CollectionView will recycling the views that are going offscreen even if they were loading, and reuse them for a different image.

So basically:
 - if you have set an image `urlA` on an `UIImageView` in cell X by calling your method that set the image from URL
 - then the user scrolls down in the `UICollectionView`, so cell X goes offscreen, and is recycled and reused for a later `IndexPath` down the road, this time corresponding to `urlB`
 - so you call your method to set the image of that cell  to `urlB` (same cell, since it's recycled from previous cell X you used for `urlA`)
 - at that stage there are two network requests in the air, one for `urlA` and one for `urlB`, that will ultimately update the `self.image` of the same `UIImageView` instance
 - so if `urlA` 's response arrives before `urlB`'s response, you'll see image of `urlA` in a cell that has since been recycled and is supposed to contain image of `urlB`… and only a bit later once `urlB`'s response arrives will you see that `UIImageView` be updated with the expected image (that is, if the user didn't continue scrolling yet another `IndexPath`that started to load `urlC`… and so on)
 - if `urlB`'s response arrives before `urlA`'s response, then you'll see the expected image in your cell… but then later the old and unexpected one

⚠️ So overall it's best to handle that loading logic at the level of your `ImageListViewModel` instead. Instead of holding a list of images (your `typealias ImageList` in your VM), your VM could for example hold a list of `[ImageState]` with `ImageState` could be an `enum ImageState { case loading(URL); case loaded(Image) }`.

It's then the responsability of your ViewModel to decide if it needs to provide the cell with a loading view with placeholder, or with a loaded view with image. This responsability should not be owned by the view layer (your `UIImageView` extension in your case)


## Project Notes

 - Some files have names that don't match the class they containing an implementation for. This makes it hard to find back where each class is defined.
   - For example `URLSessionExtension+Load` contains `protocol Session` and `class NetworkSession` (but no `extension URLSession`).
   - I figure that's legacy from a former impl, but it's still nice to tidy things up
 - Some classes are declared in places that seems unlikely or unrelated. For example you declare your color constants in `Global/Colors.swift` (👍) but you declare your Font constants in… `CellStyle.swift`? [commit](https://github.com/bertadevant/UnsplashAPIApp/commit/2b7c4f93e1886a67f16c929817e46b1997fa5653)


## Code Notes

### `CellSize.swift`

[commit](https://github.com/bertadevant/UnsplashAPIApp/commit/2b9250901187c510e70bfef1891df18da59df596)

I don't really like the use of `UIApplication.shared.keyWindow` here for multiple reasons:

1. the `keyWindow` can change during the lifecycle of the app, so depending on when those static var are (lazily) created, this will affect the default size
2. this relies on using a shared singleton instance, `UIApplication` even. Not good for testability

But actually I didn't even see that `defaultSize` property used anywhere anyway, so ended up deleting it – not a good idea to keep dead code in a demo project 😅 – but still wanted to note those suggestions here.

### Creating viewModels from Models

I'm not sure if I can really justify why, as it's more like a feel and convention, but it feels strange to provide extensions on your models to build ViewModels from it, rather than provide an init to your ViewModels to create them from your Models.

I think the intuition I get from this is that ViewModels should be build from models, like there's a sense of hierarchy in the architecture layers here. A ViewController has/is constructed from a ViewModel which is constructed from a Model. So you pass the ViewModel to the Controller to build it, so also makes sense that you pass the Model to the `ViewModel.init` to build it


You also seem to use `ViewModel` and `ViewState` interchangeably or at least confuse the two sometimes, e.g. `func viewModel() -> AuthorViewState` on `extension Author` in `ImageViewState.swift`

Also, your type `struct Colors` has a name that is a little too close from your `struct Color` you use in … `Colors.swift` to declare your color constants.
And since it's only used as an inside type for your `ImageViewState`, best solution is to just declare it as a subtype of `ImageViewState`, both to scope it and avoid any confusion.

[commit](https://github.com/bertadevant/UnsplashAPIApp/commit/2c383d1bb099618f871198f3b7a3abe96d29058c)

### `UIButton+LoadingIndicator`

It's quite bad practice to use `UIView.tag`. It's a hack in UIKit that should never have existed, and it's generally viewed poorly when seen in code.

I highly suggest that you create a subclass `class LoadingButton: UIButton` which adds the loadingIndicator as subview on its `init`, store that in a private property of your `LoadingButton`, recenters it on `layoutSubviews`, and provide a public API to toggle the loadingIndicator instead.

## NetworkLayer

### `LoadAPIRequest`

It's a bit confusing that you build a LoadAPIRequest from a full URL string, then delete the https://{host} from that String, only to later re-inject it via the components… and rebuild the URL on your Network Layer…

Besides repeating the scheme and host twice (in `var components` and in the `init` when you remove it), this is not super testable either…

[commit](https://github.com/bertadevant/UnsplashAPIApp/commit/05ab305eec99b72bb601776b8a96e1eaebaf29c1)

### `APIRequest`

Not a good look to have your API key hardcoded here, not only for security reasons but also because keys like that should not be defined deep inside the network layer code, as they would be hard to find later and don't make your layer independant. 

This is also because your `NetworkLayer` should be agnostic of who is using it. It should be a client that works for anyone willing to use the Unspalsh API. Hard-coding a Client-ID inside the NetworkLayer itself is not a good separation of concern there. The best solution is to inject that key when instantiating your `NetworkSession`

As for the security part of things, that's less trivial to fix: ideally you should not commit your API keys to GitHub. You could for example have your keys in some `plist` file that you include in your project and read at runtime, but never commit that `plist` and document in the README that the user is supposed to create it with their own APIKey.

It would still be ok to provide the plist with your own Key to a recruiter as part of a ZIP containing your project so that they are able to run the project immediately after unzipping, but at least you'd have shown that you didn't hardcode the APIKey.

Other solutions exists (the best probably being CocoaPods-Keys, but since you don't use CocoaPods in this project, probably not worth the effort for a simple toy project like that)

BTW this is typically the kind of things that you could document in your README for a recruiter btw (e.g. "I hardcoded the API Key in this config file that I provided here, to make it simple for reviewers to be able to run the project out of the box, but in a real project I'd have used X or Y instead")

[commit](https://github.com/bertadevant/UnsplashAPIApp/commit/844c93bef1acbc10bd99c37e87f59d9197f44e5b)

Another note: why the need for the `APIRequest` protocol to have both a `URLComponent` and a `queryItems`, while you always include the queryItems as part of the `URLComponents` anyway? Also, you repeat the `https` and `api.unsplash.com` multiple times… [commit](https://github.com/bertadevant/UnsplashAPIApp/commit/79dc9ee2a6bdacab315afc13e09c27969a0580fe)

### `Resource.swift`

I liked that very much! The concept of bundling `APIRequest` + `parse` method and making it monadic by providing a `map` on it is a very good choice.

Only thing I would change is to not discard the potential error there. i.e. change `parse` to a `(Data) throws -> A` and throw the error instead of returning `nil`

### `URLSessionExtension+Load.swift` (now `NetworkSession.swift`)

I like the idea of having a `Session` protocol, makes things testable

I'd not make `NetworkSession` inherit from `URLSession` though. There is no need for that, and it introduces the risk of allowing you to write methods taking `URLSession` (instead of `Sessions`) parameters and still compile when you pass a `NetworkSession` without warning you that you used the wrong parameter type (as expecting a `URLSession` parameter instead of using your `Session` abstraction won't make it testable).

[commit](https://github.com/bertadevant/UnsplashAPIApp/commit/76607870a8de2f4dc2ac777af47d85d40c5362ab)

## Other

I liked that you use `struct SearchCategory` with and `extension SearchCategory` containing `static` constants. Those should be `let` not `var` though.

But otherwise it's a nice solution to use rather than an `enum`. Some people would have used an `enum` instead but an `enum` is supposed to be closed (a finite set of values that have no intention to grow or change) and something for which using a `switch` on would make sense, which is not the case here. So using a `struct` + `extension with static let` was a good choice, because it makes it clear that those are some suggested values but that it's also valid to add more, and to also allow other devs using your code to create their own `SearchCategory` rather than being limited on using only a fixed/closed set of the ones provided. 👍

---

Speaking of `enum` vs `struct`, when declaring types that only serve as namespaces, like `Color` or `Fonts` (oh, inconsistent naming here, singular vs plural…), it's common practice to:

 - Either declare `private init(){}` on your struct serving as namespace, because that type is only containing `static` properties and is not intended to be instantiated
 - Or more commonly, use `enum` (even if it's a `case`-less enum and kind of working around the original purpose of `enum`), which ultimately provides the same behavior (declaring a type just for the sake of being used as a namespace containing only `static` properties) but doesn't require you to declare a `private init(){}` explicitly, since an `enum` with no case (known in the jargon as an "inhabited type") already can't be instanciated.
 - Use `let` instead of `var` for those `static` constants. They are constants, after all!

 A use case where you can use `struct` instead of `enum` is if you _do_ intend to (or that it _does_ makes sense to) let a developer using your code to create other things of that type.
   - For `enum Fonts` and `enum Colors` those are namespaces returning objects of a different type (those enum are an inhabited type anyway so you couldn't create an instance of those), namely `UIColor` and `UIFont` here. You don't intend other devs to do `let f = Fonts()`
   - But for `struct SearchCategory` you provide a type, then provide default common values for it via `static let` properties returning `SearchCategories` too, so that's a bit different. You don't want to forbid other devs to create theyr own if they need/want to (why would you prevent others to call `SearchCategory(…, …)` init after all) so for this one it makes sense to keep it as a `struct`

[commit](https://github.com/bertadevant/UnsplashAPIApp/commit/7a427175dc1101f83815127bfe352a9fc8bcef3c)

## TODO

For me as a reviewer:

- [ ] Review the code of the Tests, I haven't taken the time yet to go thru them
- [ ] Review the `ViewController`, I kinda skipped them as I focused on architecture and the Models/ViewModels/Network layers

For you, things that I didn't provide a commit/fix for:

- [ ] Image Loading: move loading logic (network request) to ViewModel layer, + see if we can't load low-res first
- [ ] UIButton subclass with loader instead of `extensions` + `view.tag`
- [ ] Fix your Unit Tests
