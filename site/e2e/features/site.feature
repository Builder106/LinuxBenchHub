Feature: LinuxBenchHub dashboard

  Scenario: Home page shows all three distro tiles
    Given I am on the home page
    Then the Ubuntu distro tile links to its benchmarks page
    And the Fedora distro tile links to its benchmarks page
    And the Debian distro tile links to its benchmarks page

  Scenario: Sample benchmark data panel renders on home page
    Given I am on the home page
    Then the benchmark data panel shows 4 rows
    And the C-Ray row shows the mean value "1,088"

  Scenario: Ubuntu distro detail page renders
    Given I navigate to the Ubuntu benchmarks page
    Then the back link to overview is present
    And the section navigation is visible
