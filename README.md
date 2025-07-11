# CreditScoreView

`CreditScoreView` is a fully customizable, animated credit score arc view for iOS. Built using UIKit, this view helps you beautifully visualize a credit score with smooth animation and flexible UI styling.

![CreditScoreView Demo](https://user-images.githubusercontent.com/your-gif-here.gif)

---

## 📦 Installation

### Swift Package Manager (SPM)

1. Open Xcode
2. Go to **File → Add Packages...**
3. Paste this URL:

```
https://github.com/Rakesh0918/CreditScoreView.git
```

4. Select version `1.0.0` or `Up to Next Major`

---

## ✨ Features

- Animated credit score arc using `CAShapeLayer`
- Customize segment colors, ranges, and labels (e.g., Poor, Fair, Good)
- Marker animation to represent the score
- Show/hide and style:
  - Score label (center)
  - Min/Max labels (start and end)
- Fully configurable from outside the component

---

## 🧑‍💻 Usage

```swift
import CreditScoreView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let creditScoreView = CreditScoreView(
            frame: CGRect(x: 40, y: 150, width: 300, height: 200)
        )

        // Customize labels
        creditScoreView.isScoreLabelVisible = true
        creditScoreView.isMinLabelVisible = true
        creditScoreView.isMaxLabelVisible = true

        creditScoreView.scoreLabelFont = .systemFont(ofSize: 30, weight: .bold)
        creditScoreView.minLabelTextColor = .gray
        creditScoreView.maxLabelFont = .italicSystemFont(ofSize: 12)

        // Set a score
        creditScoreView.setScore(765)

        view.addSubview(creditScoreView)
    }
}
```

---

## 🎨 Customization Options

| Property                 | Description                      |
|--------------------------|----------------------------------|
| `segments`               | Define score ranges & colors     |
| `segmentWidth`           | Width of arc segments            |
| `segmentSpacing`         | Spacing between segments         |
| `markerSize`             | Size of animated score marker    |
| `isScoreLabelVisible`    | Show/hide central score          |
| `isMinLabelVisible`      | Show/hide min score label        |
| `isMaxLabelVisible`      | Show/hide max score label        |
| `scoreLabelFont`         | Font of central score            |
| `minLabelFont`           | Font of min label                |
| `maxLabelFont`           | Font of max label                |
| `scoreLabelTextColor`    | Text color for score             |
| `minLabelTextColor`      | Text color for min               |
| `maxLabelTextColor`      | Text color for max               |

---

![CreditScoreView Demo](./demo.gif)

## ✅ Example Segments

```swift
creditScoreView.segments = [
    (300, 580, .red, "Poor"),
    (580, 670, .orange, "Fair"),
    (670, 740, .yellow, "Good"),
    (740, 800, .systemGreen.withAlphaComponent(0.6), "Very Good"),
    (800, 850, .systemGreen, "Excellent")
]
```

---

## 🔖 License

MIT License

---

## 💬 Feedback or Contributions?

Feel free to open issues or pull requests.  
Maintained by [@Rakesh0918](https://github.com/Rakesh0918)
