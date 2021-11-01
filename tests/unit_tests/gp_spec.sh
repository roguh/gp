Describe 'gp'
  gp_with_enter() {
    printf '\n' | ./gp
  }

  gp_with_more_than_enter() {
    printf 'nope\n' | ./gp
  }

  It 'shows help with -h'
    When call ./gp -h
    The status should be success
    The output should include "--help"
  End

  It 'shows help with --help'
    When call ./gp --help
    The status should be success
    The output should include "--help"
  End

  Mock git
    python3 ./tests/git_mock.py \
      --local-branch-name test-branch \
      --local-branch 5678 --remote-branch 1234 --base-branch 5678 \
      "$@"
  End

  It 'pulls'
    When call ./gp
    The status should be success
    The error should include "git remote update"
    The error should include "git pull"
    The error should not include "git push"
  End

  Mock git
    python3 ./tests/git_mock.py \
      --local-branch-name test-branch \
      --local-branch 1234 --remote-branch 5678 --base-branch 5678 \
      "$@"
  End

  It 'pushes'
    When call ./gp
    The status should be success
    The error should include "git remote update"
    The error should include "git push"
    The error should not include "git pull"
  End

  Mock git
    python3 ./tests/git_mock.py \
      --local-branch-name test-branch \
      --local-branch 1234 --remote-branch '' --base-branch 5678 \
      "$@"
  End

  It 'pushes new with -f'
    When call ./gp -f
    The status should be success
    The error should include "git push --set-upstream origin test-branch"
    The error should not include "git pull"
  End

  It 'pushes new when typing ENTER'
    When call gp_with_enter
    The status should be success
    The output should include "Press ENTER"
    The error should include "git push --set-upstream origin test-branch"
    The error should not include "git pull"
  End

  It 'does not push new when anything except ENTER is typed'
    When call gp_with_more_than_enter
    The status should be failure
    The output should include "Press ENTER"
    The error should not include "git push"
    The error should not include "git pull"
  End

  Mock git
    python3 ./tests/git_mock.py \
      --local-branch-name test-branch \
      --local-branch 1234 --remote-branch 5678 --base-branch 9101 \
      "$@"
  End

  It 'force pushes with -f'
    When call ./gp -f
    The status should be success
    The error should include "git remote update"
    The error should include "git push --force"
    The error should not include "git pull"
  End

  It 'avoids force pushing'
    When call ./gp
    The status should be success
    The error should include "git remote update"
    The error should include "Diverged"
    The error should not include "git push"
    The error should not include "git pull"
  End
End
