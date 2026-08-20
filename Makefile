.PHONY: install push

Q=@

install:
	${Q}./shell-scripts-install

push:
	git push ssh+git://dimka@brainbox:443/opt/git/shell-scripts.git master
