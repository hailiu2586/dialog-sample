@echo on
setlocal

IF NOT DEFINED ARTIFACTS (
    SET ARTIFACTS=%~dp0%..\artifacts
)

IF NOT DEFINED DEPLOYMENT_SOURCE (
  SET DEPLOYMENT_SOURCE=%~dp0%.
)

SET DEPLOYMENT_TARGET=%ARTIFACTS%\bot

rem check if git remote is set to fetch all branches
FOR /F "tokens=* usebackq" %%f in (`git config --get-regexp remote.*.fetch`) do (
    set GIT_FETCH=%%~f
)

if not "x%GIT_FETCH:+refs/heads/*:refs/remotes/git/*=%x"=="x%GIT_FETCH%x" goto :worktree

rem get the remote origin
FOR /F "tokens=* usebackq" %%k in (`git remote get-url origin`) do (
    set REMOTE_GIT=%%~k
)

rem config remote to fetch all branches
git remote add git %REMOTE_GIT%
git remote remove origin

:worktree
rem fetch all branches and prune all missing worktree
git fetch --all
git worktree prune

rem create work tree for  all branches
FOR /F "tokens=* usebackq" %%b in (`git branch -r`) do (
    call :prep_worktree %%b
)

goto :eof

:prep_worktree
set bn=%1
set sbn=%bn:~4%
IF EXIST %DEPLOYMENT_TARGET%/%sbn% (
    call :pull_worktree %bn%
) else (
    call :add_worktree %bn%
    call :pull_worktree %bn%
)

exit /b

:add_worktree
set bn=%1
set sbn=%bn:~4%
if %sbn%==master exit /b
echo add worktree for branch %sbn%
git worktree add %DEPLOYMENT_TARGET%/%sbn% %sbn%

exit /b

:pull_worktree
set bn=%1
set sbn=%bn:~4%
if %sbn%==master exit /b
echo pull worktree branch %sbn%
pushd %DEPLOYMENT_TARGET%\%sbn:/=\%
git pull --rebase
popd

exit /b


:eof
endlocal
