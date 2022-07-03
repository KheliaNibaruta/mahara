@javascript @core @portfolio
Feature: Creating a page with stuff in it
   In order to have a portfolio
   As a user I need navigate to a portfolio
   So I can create a page and add content to it

Background:
    Given the following "institutions" exist:
    | name | displayname | registerallowed | registerconfirm |
    | pcnz | Institution One | ON | OFF |

    And the following "users" exist:
    | username | password  | email             | firstname | lastname | institution | authname | role   |
    | UserA    | Kupuh1pa! | UserA@example.org | Angela    | User     | mahara      | internal | member |

    And the following "blocks" exist:
    | title                     | type     | page                   | retractable | updateonly | data                                                |
    | Portfolios shared with me | newviews | Dashboard page: UserA  | no          | yes        | limit=5;user=1;friend=1;group=1;loggedin=1;public=1 |

Scenario: Creating a page with content in it (Bug 1426983)
    # Log in as "Admin" user
    Given I log in as "admin" with password "Kupuh1pa!"
    And I choose "Files" in "Create" from main menu
    # Navigating to Portfolio to create a page
    # This is the test for manually creating a page
    And I choose "Pages and collections" in "Create" from main menu
    And I should see "Pages and collections" in the "H1 heading" "Common" property
    # PCNZ customisation: 'Add' button is hidden
    Then I go to "/view/editlayout.php?new=1"
    And I fill in the following:
    | Page title       | Test view         |
    | Page description | First description |
    # Open the 'Advanced' accordion and check for the instructions field and 'Prevent removing of blocks' toggle
    # (Bug 1891265)
    When I press "Advanced"
    Then I should see "Instructions"
    And I should see "Prevent removing of blocks"
    # (Bug 1891265 end)
    And I press "Save"
    # Editing the pages
    And I press "Settings" in the "Toolbar buttons" "Nav" property
    #Change the Page title
    And I fill in the following:
    | Page title       | This is the edited page title |
    | Page description | This is the edited description |
    And I press "Save"
    # Adding media block
    When I click on the add block button
    And I press "Add"
    And I click on blocktype "File(s) to download"
    And I press "Save"
    # Adding Journal block
    When I click on the add block button
    And I press "Add"
    And I click on blocktype "Recent journal entries"
    And I press "Save"
    # Adding profile info block
    When I click on the add block button
    And I press "Add"
    And I click on blocktype "Profile information"
    And I press "Save"
    # Adding external media block - but remove it instead
    When I click on the add block button
    And I press "Add"
    And I click on blocktype "External media"
    And I press "Remove"

    And I display the page
    # Show last updated date and time when seeing a portfolio page (Bug 1634591)
    And I should see "Updated on" in the "Last updated" "Views" property
    # actual date format displayed is 31 May 2018, 13:29
    And I should see the date "today" in the "Last updated" "Views" property with the format "d F Y"
    # Verifying the page title and description changed
    Then I should see "This is the edited page title"
    And I should not see "This is the edited description"
    # Create a timeline version
    And I press "More options"
    And I follow "Save to timeline"
    # Check that the image is displayed on page and ensure the link is correct
    #Then I should see image "Image2.png" on the page
    # The "..." button should only have the option to print and delete the page
    And I should see "More options"
    And I press "More options"
    Then I should see "Print"
    And I should see "Delete this page"
    # User share page with public and enable copy page functionality
    And I choose "Pages and collections" in "Create" from main menu
    And I click on "Manage access" in "This is the edited page title" card access menu
    # And I press "Advanced options"
    # And I enable the switch "Allow copying"
    And I select "Public" from "General" in shared with select2 box
    And I press "Save"
    And I log out

    # Log in as UserA and copy the page
    # PCNZ customisation - advanced sharing is disabled
    # Given I log in as "UserA" with password "Kupuh1pa!"
    # And I wait "1" seconds
    # Then I should see "This is the edited page title"
    # When I follow "This is the edited page title"
    # And I press "More options"
    # And I follow "Copy"
    # And I fill in the following:
    # | Page title | This is my page now |
    # And I press "Save"
    # And I press "Display page"
    # And I should not see "This is the edited description"
    # And I log out

    # check page can be deleted (Bug 1755682)
    Given I log in as "admin" with password "Kupuh1pa!"
    # Go to version page
    And I choose "Pages and collections" in "Create" from main menu
    And I follow "This is the edited page title"
    And I press "More options"
    And I follow "Timeline"

    Then I should see "Timeline"
    # check page can be deleted (Bug 1755682)
    And I choose "Pages and collections" in "Create" from main menu
    And I click on "Delete" in "This is the edited page" card menu
    And I should see "Do you really want to delete this page?"
    And I press "Yes"
    Then I should see "Page deleted"
    And I should not see "This is the edited page"
