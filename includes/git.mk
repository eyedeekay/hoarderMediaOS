garbage-collect:
	export DEV_MESSAGE="garbage-collected repository" ; \
		git commit -am "$(DEV_MESSAGE)"
	git filter-branch --tag-name-filter cat --index-filter 'git rm -r --cached --ignore-unmatch binary' --prune-empty -f -- --all
	rm -rf .git/refs/original/
	git reflog expire --all --expire=now
	git gc --prune=now
	git gc --aggressive --prune=now
	git repack -Ad
	export DEV_MESSAGE="garbage-collected repository" ; \
		gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
			README.md; \
		git commit -am "$(DEV_MESSAGE)"
	git push github --force --all
	git push github --force --tags
	yes | docker system prune

push:
	git add .
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		README.md
	git commit -am "$(DEV_MESSAGE)"
	git push github master
