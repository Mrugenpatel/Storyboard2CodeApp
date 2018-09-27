//  Created by dasdom on 04/01/2017.
//  Copyright © 2017 dasdom. All rights reserved.
//

import XCTest
@testable import Storyboard2Code

class StoryboardXMLParserDelegateTests: XCTestCase {
  
  var sut: StoryboardXMLParserDelegate!
  
  override func setUp() {
    super.setUp()
    
    sut = StoryboardXMLParserDelegate()
  }
  
  override func tearDown() {
    sut = nil
    
    super.tearDown()
  }
  
  func test_ParsesButton() {
    let xmlString = """
      <subviews>\n
        <button id="42" userLabel="foo">\n
        </button>\n
      </subviews>
      """
    
    parseAndCheckArrays(for: xmlString)
    XCTAssertTrue(sut.viewDict.values.first is Button)
  }
  
  func test_ParsesImageView() {
    let xmlString = """
      <subviews>\n
        <imageView id="42" userLabel="foo">\n
        </imageView>\n
      </subviews>
      """
    
    parseAndCheckArrays(for: xmlString)
    XCTAssertTrue(sut.viewDict.values.first is ImageView)
  }
  
  func test_ParsesLabel() {
    let xmlString = """
      <subviews>\n
        <label id="42" userLabel="foo">\n
        </label>\n
      </subviews>
      """
    
    parseAndCheckArrays(for: xmlString)
    XCTAssertTrue(sut.viewDict.values.first is Label)
  }
  
  func test_ParsesScrollView() {
    let xmlString = """
      <subviews>\n
        <scrollView id="42" userLabel="foo">\n
        </scrollView>\n
      </subviews>
      """
    
    parseAndCheckArrays(for: xmlString)
    XCTAssertTrue(sut.viewDict.values.first is ScrollView)
  }
  
  func test_ParsesSegmentedControl() {
    let xmlString = """
      <subviews>\n
        <segmentedControl id="42" userLabel="foo">\n
        </segmentedControl>\n
      </subviews>
      """
    
    parseAndCheckArrays(for: xmlString)
    XCTAssertTrue(sut.viewDict.values.first is SegmentedControl)
  }
  
  func test_ParsesSlider() {
    let xmlString = """
      <subviews>\n
        <slider id="42" userLabel="foo">\n
        </slider>\n
      </subviews>
      """
    
    parseAndCheckArrays(for: xmlString)
    XCTAssertTrue(sut.viewDict.values.first is Slider)
  }
  
  func test_ParsesTableView() {
    let xmlString = """
      <subviews>\n
        <tableView id="42" userLabel="foo">\n
        </tableView>\n
      </subviews>
      """
    
    parseAndCheckArrays(for: xmlString)
    XCTAssertTrue(sut.viewDict.values.first is TableView)
  }
  
  func test_ParsesTableViewCell() {
    let xmlString = """
      <tableViewController id="23" customClass="bar">\n
        <tableViewCell id="42" userLabel="foo">\n
        </tableViewCell>\n
      </tableViewController>
      """
    let xmlData = xmlString.data(using: .utf8)!
    
    let parser = XMLParser(data: xmlData)
    parser.delegate = sut
    parser.parse()
    
    XCTAssertEqual(sut.fileRepresentations.count, 1)
  }
  
  func test_ParsesTextField() {
    let xmlString = """
      <subviews>\n
        <textField id="42" userLabel="foo">\n
        </textField>\n
      </subviews>
      """
    
    parseAndCheckArrays(for: xmlString)
    XCTAssertTrue(sut.viewDict.values.first is TextField)
  }
  
  func test_ParsesView() {
    let xmlString = """
      <subviews>\n
        <view id="42" userLabel="foo">\n
        </view>\n
      </subviews>
      """
    
    parseAndCheckArrays(for: xmlString)
  }
  
  func test_ParsesSubView() {
    let xmlString = """
      <view id="mainId" userLabel="mainLabel">\n
        <subviews>\n
          <view id="subViewId" userLabel="subViewLabel">\n
            <subviews>\n
              <view id="firstSubSubViewId" userLabel="firstSubSubViewLabel">\n
              </view>\n
              <view id="secondSubSubViewId" userLabel="secondSubSubViewLabel">\n
              </view>\n
            </subviews>\n
          </view>\n
        </subviews>\n
      </view>"]
      """
    
    let xmlData = xmlString.data(using: .utf8)!
    
    let parser = XMLParser(data: xmlData)
    parser.delegate = sut
    parser.parse()
    
    let subView = sut.viewDict["subViewId"]
    XCTAssertEqual(subView?.addToSuperString, "addSubview(subViewLabel)")
    let firstSubSubView = sut.viewDict["firstSubSubViewId"]
    XCTAssertEqual(firstSubSubView?.addToSuperString, "subViewLabel.addSubview(firstSubSubViewLabel)")
    let secondSubSubView = sut.viewDict["secondSubSubViewId"]
    XCTAssertEqual(secondSubSubView?.addToSuperString, "subViewLabel.addSubview(secondSubSubViewLabel)")
  }
  
  func test_ParsesTableViewCellSubViews() {
    let xmlString = """
      <tableViewController id="tableViewControllerId" customClass="TableViewControllerClass">\n
        <tableView id="tableViewId" userLabel="tableViewLabel">\n
          <prototypes>\n
            <tableViewCell id="firstTableViewCellId" userLabel="firstTableViewCellLabel">\n
              <tableViewCellContentView id="firstTableViewCellContentViewId">\n
                <subviews>\n
                  <imageView id="imageViewId" userLabel="imageViewLabel">\n
                  </imageView>\n
                </subviews>\n
              </tableViewCellContentView>\n
            </tableViewCell>\n
            <tableViewCell id="secondTableViewCellId" userLabel="SecondTableViewCellLabel">\n
              <tableViewCellContentView id="secondTableViewCellContentViewId">\n
                <subviews>\n
                  <label id="labelId" userLabel="labelLabel">\n
                  </label>\n
                </subviews>\n
              </tableViewCellContentView>\n
            </tableViewCell>\n
          </prototypes>\n
        </tableView>\n
      </tableViewController>
      """
    let xmlData = xmlString.data(using: .utf8)!
    
    let parser = XMLParser(data: xmlData)
    parser.delegate = sut
    parser.parse()
    
    let subView = sut.viewDict["imageViewId"]
    XCTAssertEqual(subView?.addToSuperString, "contentView.addSubview(imageViewLabel)")
    
    // The table view is not in fileRepresentations becaust the xml does not
    // containt the tag <scene>.
    let firstFileRepresentation = sut.fileRepresentations.first!
    XCTAssertTrue(firstFileRepresentation.mainView is TableViewCell)
    XCTAssertEqual(firstFileRepresentation.viewDict.count, 1)
    
    let lastFileRepresentation = sut.fileRepresentations.last!
    XCTAssertTrue(lastFileRepresentation.mainView is TableViewCell)
    XCTAssertEqual(lastFileRepresentation.viewDict.count, 1)
  }
  
  func test_ParsingTableView_DoesNotAddCellsAsSubview() {
    let xmlString = """
      <scene>\n
        <tableViewController id="tableViewControllerId" customClass="TableViewControllerClass">\n
          <tableView id="tableViewId" userLabel="tableViewLabel">\n
            <prototypes>\n
              <tableViewCell id="firstTableViewCellId" userLabel="firstTableViewCellLabel">\n
                <tableViewCellContentView id="firstTableViewCellContentViewId">\n
                </tableViewCellContentView>\n
              </tableViewCell>\n
            </prototypes>\n
          </tableView>\n
        </tableViewController>\n
      </scene>
      """
    
    let xmlData = xmlString.data(using: .utf8)!
    
    let parser = XMLParser(data: xmlData)
    parser.delegate = sut
    parser.parse()
    
    let lastFileRepresentation = sut.fileRepresentations.last!
    XCTAssertTrue(lastFileRepresentation.mainView is TableView)
    XCTAssertNil(lastFileRepresentation.viewDict["firstTableViewCellId"])
  }
  
  func test_parsingTableViewCells_whenCellStyleIsSet_doesNotAddSubviews() {
    let xmlString = """
      <tableViewController id="tableViewControllerId" customClass="TableViewControllerClass">
        <tableView id="tableViewId" userLabel="tableViewLabel">
          <prototypes>
            <tableViewCell style="IBUITableViewCellStyleDefault" id="24q-Hh-TrU" userLabel="defaultCell">
              <tableViewCellContentView id="lAt-7Y-nOG">
                <subviews>
                  <label id="MeK-Ua-LQL">
                  </label>
                </subviews>
              </tableViewCellContentView>
            </tableViewCell>
          </prototypes>
        </tableView>
      </tableViewController>
      """
    
    let xmlData = xmlString.data(using: .utf8)!
    
    let parser = XMLParser(data: xmlData)
    parser.delegate = sut
    parser.parse()

    let lastFileRepresentation = sut.fileRepresentations.last!
    XCTAssertTrue(lastFileRepresentation.mainView is TableViewCell)
    XCTAssertEqual(lastFileRepresentation.viewDict.count, 0)
  }
  
  func test_constraints_whenItemIsNotMainUserLabel_setsFirstItemName() {
    let input = [constraintWithFirstItem1234()]
    
    let output = sut.constraintsWithReplacedItemName(from: input, mainUserLabel: "bla", viewNameForId: { _ in "bar" })
    
    XCTAssertEqual(output.first?.firstItemName, "bar")
  }
  
  func test_constraints_whenItemIsMainUserLabel_setsFirstItemName() {
    let input = [constraintWithFirstItem1234()]
    
    let output = sut.constraintsWithReplacedItemName(from: input, mainUserLabel: "bar", viewNameForId: { _ in "bar" })

    XCTAssertEqual(output.first?.firstItemName, "")
  }
  
  func test_constraints_whenItemAttributeHasSuffixMargin_setsFirstItemName() {
    let input = [constraintWithFirstAttributeFooMargin()]
    
    let output = sut.constraintsWithReplacedItemName(from: input, mainUserLabel: "bla", viewNameForId: { _ in "bar" })
    
    XCTAssertEqual(output.first?.firstItemName, "barMargins")
    XCTAssertEqual(output.first?.firstAttribute, "foo")
  }
  
  func test_constraints_whenItemIsNotMainUserLabel_setsSecondItemName() {
    let input = [constraintWithSecondItem1234()]
    
    let output = sut.constraintsWithReplacedItemName(from: input, mainUserLabel: "bla", viewNameForId: { _ in "bar" })

    XCTAssertEqual(output.first?.secondItemName, "bar")
  }
  
  func test_constraints_whenItemIsMainUserLabel_setsSecondItemName() {
    let input = [constraintWithSecondItem1234()]
    
    let output = sut.constraintsWithReplacedItemName(from: input, mainUserLabel: "bar", viewNameForId: { _ in "bar" })

    XCTAssertEqual(output.first?.secondItemName, "")
  }
  
  func test_constraints_whenItemAttributeHasSuffixMargin_setsSecondItemName() {
    let input = [constraintWithSecondAttributeFooMargin()]
    
    let output = sut.constraintsWithReplacedItemName(from: input, mainUserLabel: "bla", viewNameForId: { _ in "bar" })
    
    XCTAssertEqual(output.first?.secondItemName, "barMargins")
    XCTAssertEqual(output.first?.secondAttribute, "foo")
  }
  
  func test_viewMargins_whenFirstItemAttributeHasSuffixMargin_returnsMarginStrings() {
    var constraint = constraintWithFirstAttributeFooMargin()
    constraint.firstItemName = "foobar"

    let margins = sut.viewMargins(from: [constraint], mainUserLabel: "bar")

    XCTAssertEqual(margins.first, "let foobarMargins = foobar.layoutMarginsGuide\n")
  }
  
  func test_viewMargins_whenSecondItemAttributeHasSuffixMargin_returnsMarginStrings() {
    var constraint = constraintWithSecondAttributeFooMargin()
    constraint.secondItemName = "foobar"
    
    let margins = sut.viewMargins(from: [constraint], mainUserLabel: "bar")
    
    XCTAssertEqual(margins.first, "let foobarMargins = foobar.layoutMarginsGuide\n")
  }
  
  func test_configureConstraints_fillsControllerConstraints_1() {
    sut.constraints = [constraintWithFirstItem1234()]
    sut.layoutGuides = [LayoutGuide(dict: ["type": "top", "id": "1234"])]
    
    sut.configureConstraints()
    
    XCTAssertEqual(sut.controllerConstraints.first?.id, "42")
    XCTAssertEqual(sut.constraints.count, 0)
  }
  
  func test_configureConstraints_fillsControllerConstraints_2() {
    sut.constraints = [constraintWithSecondItem1234()]
    sut.layoutGuides = [LayoutGuide(dict: ["type": "top", "id": "1234"])]
    
    sut.configureConstraints()
    
    XCTAssertEqual(sut.controllerConstraints.first?.id, "42")
    XCTAssertEqual(sut.constraints.count, 0)
  }
  
  func test_configureConstraints_setsNamesOfControllerConstraints_1() {
    sut.constraints = [constraintWithFirstItem1234()]
    sut.layoutGuides = [LayoutGuide(dict: ["type": "top", "id": "1234"])]
    
    sut.configureConstraints()
    
    XCTAssertEqual(sut.controllerConstraints.first?.firstItemName, "topLayoutGuide")
  }
  
  func test_configureConstraints_setsNamesOfControllerConstraints_2() {
    sut.constraints = [constraintWithSecondItem1234()]
    sut.layoutGuides = [LayoutGuide(dict: ["type": "top", "id": "1234"])]
    
    sut.configureConstraints()
    
    XCTAssertEqual(sut.controllerConstraints.first?.secondItemName, "topLayoutGuide")
  }
}

// MARK: - Constraints test data
extension StoryboardXMLParserDelegateTests {
  func constraintWithFirstItem1234() -> Constraint {
    return Constraint(dict: [
      Constraint.Key.firstItem.rawValue: "1234",
      Constraint.Key.firstAttribute.rawValue: "bla",
      Constraint.Key.id.rawValue: "42",
      ])
  }
  
  func constraintWithFirstAttributeFooMargin() -> Constraint {
    return Constraint(dict: [
      Constraint.Key.firstItem.rawValue: "1234",
      Constraint.Key.firstAttribute.rawValue: "fooMargin",
      Constraint.Key.id.rawValue: "42",
      ])
  }
  
  func constraintWithSecondItem1234() -> Constraint {
    return Constraint(dict: [
      Constraint.Key.secondItem.rawValue: "1234",
      Constraint.Key.firstAttribute.rawValue: "fooMargin",
      Constraint.Key.id.rawValue: "42",
      ])
  }
  
  func constraintWithSecondAttributeFooMargin() -> Constraint {
    return Constraint(dict: [
      Constraint.Key.secondItem.rawValue: "foo",
      Constraint.Key.firstAttribute.rawValue: "bar",
      Constraint.Key.secondAttribute.rawValue: "fooMargin",
      Constraint.Key.id.rawValue: "42",
      ])
  }
}

extension StoryboardXMLParserDelegateTests {
  func parseAndCheckArrays(for string: String, file: StaticString = #file, line: UInt = #line) {
    guard let xmlData = string.data(using: .utf8)
      else {
        
        return XCTFail()
    }
    
    let parser = XMLParser(data: xmlData)
    parser.delegate = sut
    parser.parse()
    
    XCTAssertEqual(sut.viewDict.count, 1, file: file, line: line)
    XCTAssertEqual(sut.tempViews.count, 0, file: file, line: line)
  }
}
