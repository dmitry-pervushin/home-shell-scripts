.PHONY: install push

Q=@

install:
	${Q}./shell-scripts-install

push:
	git push origin master
