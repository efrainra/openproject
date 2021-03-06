#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2014 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

Feature: Copying a work package
  Background:
    Given there is 1 project with the following:
      | identifier | project_1 |
      | name       | project_1 |
    Given there is 1 project with the following:
      | identifier | project_2 |
      | name       | project_2 |

    And I am working in project "project_2"
    And there are the following issue status:
      | name        | is_closed  | is_default  |
      | New         | false      | true        |
    And the project "project_2" has the following types:
      | name    | position |
      | Bug     |     1    |
      | Feature |     2    |
    And there is a default issuepriority with:
      | name   | Normal |
    And there is a issuepriority with:
      | name   | High |
    And there is a issuepriority with:
      | name   | Immediate |

    And I am working in project "project_1"
    And there are the following issue status:
      | name        | is_closed  | is_default  |
      | New         | false      | true        |
    And the project "project_1" has the following types:
      | name    | position |
      | Bug     |     1    |
    And there is a default issuepriority with:
      | name   | Normal |
    And there is a issuepriority with:
      | name   | High |
    And there is a issuepriority with:
      | name   | Immediate |

    And there is a role "member"
    And the role "member" may have the following rights:
      | view_work_packages |
      | move_work_packages |
    And there is 1 user with the following:
      | login | bob |
    And the user "bob" is a "member" in the project "project_1"
    And the user "bob" is a "member" in the project "project_2"

    And there are the following issues in project "project_1":
      | subject | type |
      | issue1  | Bug  |
      | issue2  | Bug  |

    And there are the following issues in project "project_2":
      | subject | type    |
      | issue3  | Feature |

    And the work package "issue1" has the following children:
      | issue2 |

    And I am already logged in as "bob"

  Scenario: Copy an issue
    When I go to the move new page of the work package "issue1"
     And I select "project_2" from "Project"

    When I click "Copy and follow"

    Then I should see "Successful creation."
     And I should see "project_2" within ".breadcrumb"

  Scenario: Move an issue
    When I go to the move page of the work package "issue1"
     And I select "project_2" from "Project"

    When I click "Move and follow"

    Then I should see "Successful update."
     And I should see "project_2" within ".breadcrumb"

  Scenario: Issue children are moved
    When I go to the move page of the work package "issue1"
     And I select "project_2" from "Project"

    When I click "Move and follow"
    When I go to the page of the work package "issue2"

     And I should see "project_2" within ".breadcrumb"

  Scenario: Move an issue to project with missing type
    When I go to the move page of the work package "issue3"
     And I select "project_1" from "Project"

    When I click "Move and follow"

    Then I should see "Failed to save 1 work package(s) on 1 selected:"

  @javascript
  Scenario: Going to the Copy Page of 2 Work Packages via bulk edit
    When I go to the work package index page of the project called "project_1"
     And  I open the context menu on the work packages:
       | issue1 |
       | issue2 |
     And I follow "Copy" within "#work-package-context-menu"
     Then I should see "Copy" within "#content"
      And I should not see "Move" within "#content"

#  FIXME: Please check this: is this the same issue as reported in #1868
#  Scenario: Move an planning element to project with missing type
#    When I go to the move page of the work package "pe3"
#     And I select "project_1" from "Project"
#
#    When I click "Move and follow"
#
#    Then I should see "Successful update."
#     And I should see "project_1" within ".breadcrumb"
