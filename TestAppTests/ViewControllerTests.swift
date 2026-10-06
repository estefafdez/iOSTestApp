import XCTest
@testable import TestApp

final class ViewControllerTests: XCTestCase {

    private var sut: ViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: ViewController.self))
        sut = storyboard.instantiateInitialViewController() as? ViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testViewDidLoadConfiguresTextAndSlider() {
        XCTAssertEqual(sut.textToIncrease.text, "Hey There")
        XCTAssertEqual(sut.sliderButton.minimumValue, 10)
        XCTAssertEqual(sut.sliderButton.value, 20)
        XCTAssertEqual(sut.sliderButton.maximumValue, 50)
    }

    func testSwitchButtonUpdatesLabel() {
        sut.switchButton.isOn = true
        sut.switchButtonAction(sut.switchButton as Any)
        XCTAssertEqual(sut.switchLabel.text, "ON")

        sut.switchButton.isOn = false
        sut.switchButtonAction(sut.switchButton as Any)
        XCTAssertEqual(sut.switchLabel.text, "OFF")
    }

    func testClickActionGreetsTheEnteredName() {
        sut.nameInput.text = "Estefania"
        sut.clickAction(sut.nameInput as Any)
        XCTAssertEqual(sut.enterYourName.text, "Hello: Estefania")
    }

    func testClickActionWithEmptyNameKeepsTheLabel() {
        let before = sut.enterYourName.text
        sut.nameInput.text = ""
        sut.clickAction(sut.nameInput as Any)
        XCTAssertEqual(sut.enterYourName.text, before)
    }

    func testSliderChangesTheFontSize() {
        sut.sliderButton.value = 30
        sut.increaseTextAction(sut.sliderButton)
        XCTAssertEqual(sut.textToIncrease.font?.pointSize, 30)
        XCTAssertFalse(sut.textToIncrease.isEditable)
    }
}
