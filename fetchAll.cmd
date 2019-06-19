setlocal

rem get the remote origin
FOR /F "tokens=* usebackq" %k in (`git remote get-url origin`) do (
    set REMOTE_GIT=%~k
)

rem config remote to fetch all branches
git remote add git %REMOTE_GIT%
git remote remove origin

rem fetch all branches
git fetch --all

rem list all remote branches
git branch -r --format=^%(refname:lstrip=3) > branches.txt
FOR /F %b in (branches.txt) do (
    git --work-tree=\scrach\dump\fetchAll\%b checkout %b
)
endlocal
