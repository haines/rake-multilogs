# frozen_string_literal: true

require_relative "test_helper"

class AssertLabelledOutputTest < Minitest::Test
  include AssertLabelledOutput

  def test_matches_succeeds_with_matching_output
    output = <<~OUTPUT
      kore
      \e[38;5;123mone |\e[0m tahi
      \e[38;5;123mone |\e[0m un
      zéro
      \e[38;5;45mtwo |\e[0m rua
      \e[38;5;123mone |\e[0m uno
      \e[38;5;45mtwo |\e[0m deux
      \e[38;5;45mtwo |\e[0m dos
      cero
    OUTPUT

    assert_labelled_output_matches(
      {
        nil => [
          "kore",
          "zéro",
          "cero"
        ],
        "one" => [
          "tahi",
          "un",
          "uno"
        ],
        "two" => [
          "rua",
          "deux",
          "dos"
        ]
      },
      output
    )
  end

  def test_matches_fails_with_mismatched_lines
    output = <<~OUTPUT
      \e[38;5;123mone |\e[0m tahi
      \e[38;5;45mtwo |\e[0m rua
      \e[38;5;123mone |\e[0m ein
      \e[38;5;123mone |\e[0m uno
      \e[38;5;45mtwo |\e[0m dos
      \e[38;5;45mtwo |\e[0m zwei
    OUTPUT

    failure = assert_raises(Minitest::Assertion) {
      assert_labelled_output_matches(
        {
          "one" => [
            "tahi",
            "un",
            "uno"
          ],
          "two" => [
            "rua",
            "deux",
            "dos"
          ]
        },
        output
      )
    }

    assert_equal <<~MESSAGE, failure.message
        one | tahi
      \e[31m- one | un\e[0m
      \e[33m+ one | ein\e[0m
        one | uno
        two | rua
      \e[31m- two | deux\e[0m
        two | dos
      \e[33m+ two | zwei\e[0m
    MESSAGE
  end

  def test_contains_succeeds_with_subset_of_output
    output = <<~OUTPUT
      kore
      \e[38;5;123mone |\e[0m tahi
      \e[38;5;123mone |\e[0m un
      zéro
      \e[38;5;45mtwo |\e[0m rua
      \e[38;5;123mone |\e[0m uno
      \e[38;5;45mtwo |\e[0m deux
      \e[38;5;45mtwo |\e[0m dos
      cero
    OUTPUT

    assert_labelled_output_contains(
      {
        nil => [
          "kore",
          "cero"
        ],
        "one" => [
          "tahi",
          "uno"
        ],
        "two" => [
          "rua",
          "dos"
        ]
      },
      output
    )
  end

  def test_contains_fails_with_missing_lines
    output = <<~OUTPUT
      \e[38;5;123mone |\e[0m tahi
      \e[38;5;45mtwo |\e[0m rua
      \e[38;5;123mone |\e[0m ein
      \e[38;5;123mone |\e[0m uno
      \e[38;5;45mtwo |\e[0m dos
      \e[38;5;45mtwo |\e[0m zwei
    OUTPUT

    failure = assert_raises(Minitest::Assertion) {
      assert_labelled_output_contains(
        {
          "one" => [
            "tahi",
            "un",
            "uno"
          ],
          "two" => [
            "rua",
            "deux",
            "dos"
          ]
        },
        output
      )
    }

    assert_equal <<~MESSAGE, failure.message
        one | tahi
      \e[31m- one | un\e[0m
      \e[33m+ one | ein\e[0m
        one | uno
        two | rua
      \e[31m- two | deux\e[0m
        two | dos
      \e[33m+ two | zwei\e[0m
    MESSAGE
  end
end
