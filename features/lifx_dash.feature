Feature: Show help information
  In order to show command line help

  Scenario: Show general command line help
    When I get help for "lifx_dash"
    Then the output should contain "    lifx_dash - Toggle LIFX lights with an Amazon Dash button"
    Then the output should match /   config  - (.*)/
    Then the output should match /   help    - (.*)/
    Then the output should match /   monitor - (.*)/
    Then the output should match /   snoop   - (.*)/
    And the exit status should be 0

  Scenario: Show config help
    When I run `lifx_dash help config`
    Then the output should contain "    config - Set (and persist) default options for commands"
    Then the output should contain "   -s, --[no-]show - Show the config file"
    And the exit status should be 0
