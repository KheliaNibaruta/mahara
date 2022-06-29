@javascript @core
Feature:

Background:
  Given the following "institutions" exist:
    | name | displayname | registerallowed | registerconfirm |
    | pcnz | Institution One | ON | OFF |

  And the following "users" exist:
  | username | password | email | firstname | lastname | institution | authname | role |
  | UserA | Kupuh1pa! | UserA@example.org | Angela | User | mahara | internal | member |

  And the following "pages" exist:
  | title | description | ownertype | ownername |
  | Page UserA_01 | Page 01 | user | UserA |

Scenario:
  Given I log in as "UserA" with password "Kupuh1pa!"
  When I choose "Files" in "Create" from main menu
  And I fill in "Folder1" for "files_filebrowser_createfolder_name"
  And I press "Create folder"
  And I follow "Folder1"
  And I attach the file "Image1.jpg" to "File"
  And I attach the file "Image2.png" to "File"
  And I attach the file "Image3.png" to "File"
  # check that folder size is displayed after uploading 3 images
  And I reload the page
  And I should see "1.5M" in the "Folder1" row
  # Creating folder 1
  Given I choose "Pages and collections" in "Create" from main menu
  And I click on "Page UserA_01"
  Then I press "Edit"
  When I click on the add block button
  And I press "Add"
  And I click on blocktype "Image gallery"
  And I set the field "Block title" to "Image gallery"
  And I select the radio "Image selection: Display all images from a folder including images uploaded later"
  And I click on the "Select" "Files" property
  And I select the radio "Style: Thumbnails (square)"
  And I press "Save"
  And I display the page
  Then I should see images within the block "Image gallery"
