<<<<<<< HEAD
setlocal

rem get the remote origin
FOR /F "tokens=* usebackq" %k in (`git remote get-url origin`) do (
    set REMOTE_GIT=%~k
=======
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
>>>>>>> fetch all branches as part of deploy
)

rem config remote to fetch all branches
git remote add git %REMOTE_GIT%
git remote remove origin

<<<<<<< HEAD
rem fetch all branches
git fetch --all

rem list all remote branches
git branch -r --format=^%(refname:lstrip=3) > branches.txt
FOR /F %b in (branches.txt) do (
    git --work-tree=\scrach\dump\fetchAll\%b checkout %b
)
=======
:worktree
rem fetch all branches
git fetch --all

rem create work tree for  all branches
FOR /F "tokens=* usebackq" %%b in (`git branch -r`) do (
    call :add_worktree %%b
)

goto :eof


:add_worktree
set bn=%1
set sbn=%bn:~4%
echo add worktree for branch %sbn%
git worktree add %DEPLOYMENT_TARGET%/%bn:~4% %bn:~4%
exit /b

:eof
>>>>>>> fetch all branches as part of deploy
endlocal
