# NKDropdownMenu

 ![Verision](https://img.shields.io/badge/pod-v0.1.0-blue.svg)
 ![License](https://img.shields.io/badge/license-MIT-blue.svg)

A drop down menu inspired by https://dribbble.com/shots/2286361-Hamburger-Menu-Animation.  It's not exactly the same as the original design because i don't figure out some details. Please pull request if you can make it better.

 ![gif](https://db.tt/H0ZclkeB)

##Examples##

```Swift

    let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]

    let hamburgerMenu: NKDropdownMenu = NKDropdownMenu(items: items)

    hamburgerMenu.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
        print("Did select item at index: \(indexPath)")

    }

    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: hamburgerMenu)

```

##TODO##
* more testing
* make details better

##License##
This code is distributed under the terms and conditions of the MIT license.

##Thanks##
Awesome design by [Gal Shir](https://dribbble.com/galshir)
