//Copyright (C) 2012 Sergey Akopkokhyants. All Rights Reserved.
//Author: akserg

part of monomer_test;

/**
 * Button Tests.
 */
class ButtonTestGroup extends TestGroup {

  registerTests() {
    this.testGroupName = "Button";

    // Static methods
    this.testList["isVisible"] = isVisibleTest;
  }

  /**
   * Check static method [UiObject.isVisible].
   * 
   * Returns whether the given element is visible.
   */
  void isVisibleTest() {
/*    dart_html.Element element = new dart_html.DivElement();
    // By default element always visible
    expect(ui.UiObject.isVisible(element), isTrue);
    // Set element invisible
    element.style.display = "none";
    // Check does element invisible
    expect(ui.UiObject.isVisible(element), isFalse);
    // Set element visible
    element.style.display = "";
    // Check does element visible
    expect(ui.UiObject.isVisible(element), isTrue);*/
  }
}