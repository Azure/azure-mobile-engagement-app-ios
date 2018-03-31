//
// Created by Jocelyn Girard on 09/02/2016.
// Copyright (c) 2016 Microsoft. All rights reserved.
//

import UIKit

struct MenuItem {

  var icon: UIImage
  var title = ""
  var initViewController: () -> UIViewController?

  init(title: String, icon: UIImage, initViewController: () -> UIViewController?) {
    self.title = title
    self.icon = icon
    self.initViewController = initViewController
  }

}

